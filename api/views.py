from rest_framework.decorators import api_view,permission_classes
from rest_framework.response import Response
from .models import Vendor,PurchaseOrder,HistoricalPerformance
from .serializers import VendorSerializer,PurchaseOrderSerializer,HistoricalPerformanceSerializer
from rest_framework import status
from rest_framework_simplejwt.tokens import AccessToken
from django.contrib import auth
from rest_framework.permissions import IsAuthenticated
from django.db.models import F
from datetime import date


@api_view(['POST'])
def custom_token_obtain(request):
    username = request.data.get('username')
    password = request.data.get('password')
    user = auth.authenticate(username=username, password=password)
    if user is not None:
        token = generate_access_token_for_user(user)
        response = {
            "status": status.HTTP_200_OK,
            "message": "Success",
            "response": token
        }
        return Response(response, status=status.HTTP_200_OK)
    return Response({'detail': 'Invalid credentials'}, status=status.HTTP_401_UNAUTHORIZED)

def generate_access_token_for_user(user):
    access = AccessToken.for_user(user)
    return {
        'access': str(access),
    }

@api_view(['POST'])
@permission_classes([IsAuthenticated])
def create_vendor(request):
    item = VendorSerializer(data=request.data)
    if item.is_valid():
        item.save()
        reponse = {
            "status": status.HTTP_200_OK,
            "message": "Success"
        }
        return Response(reponse,status=status.HTTP_200_OK)    
    return Response(item.errors, status=status.HTTP_400_BAD_REQUEST)
   
@api_view(['GET'])
@permission_classes([IsAuthenticated])
def getVendor(request):    
    vendors = Vendor.objects.all()
    serializer = VendorSerializer(vendors, many=True)
    reponse = {
        "status": status.HTTP_200_OK,
        "message": "Success",
        "response": {
            "vendorsData":serializer.data
        }
    }
    return Response(reponse,status=status.HTTP_200_OK)

@api_view(['GET'])
@permission_classes([IsAuthenticated])
def getVendorId(request, vendor_id):
    try:
        vendor = Vendor.objects.get(id=vendor_id)
        serializer = VendorSerializer(vendor)
        response = {
            "status": status.HTTP_200_OK,
            "message": "Success",
            "response": {
                "vendorsData": serializer.data
            }
        }
        return Response(response,status=status.HTTP_200_OK)
    except Vendor.DoesNotExist:
        response = {
            "status": status.HTTP_404_NOT_FOUND,
            "message": "Not Found"
        }
        return Response(response,status=status.HTTP_404_NOT_FOUND)

@api_view(['PUT'])
@permission_classes([IsAuthenticated])
def updateVendor(request, vendor_id):
    try:
        vendor = Vendor.objects.get(id=vendor_id)
    except Vendor.DoesNotExist:
        response = {
            "status": status.HTTP_404_NOT_FOUND,
            "message": "Not Found"
        }
        return Response(response,status=status.HTTP_404_NOT_FOUND)
    
    serializer = VendorSerializer(vendor, data=request.data)
    if serializer.is_valid():
        serializer.save()
        response = {
            "status": status.HTTP_200_OK,
            "message": "Success"
        }
        return Response(response, status=status.HTTP_200_OK)
    return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

@api_view(['DELETE'])
@permission_classes([IsAuthenticated])
def deletVendor(request, vendor_id):
    try:
        vendor = Vendor.objects.get(id=vendor_id)
    except Vendor.DoesNotExist:
        response = {
            "status": status.HTTP_404_NOT_FOUND,
            "message": "Not Found"
        }
        return Response(response, status=status.HTTP_404_NOT_FOUND)

    vendor.delete()
    response = {
            "status": status.HTTP_200_OK,
            "message": "Success"
        }
    return Response(response, status=status.HTTP_200_OK)

@api_view(['POST'])
@permission_classes([IsAuthenticated])
def create_purchase_order(request):
    item = PurchaseOrderSerializer(data=request.data)
    vendorId = request.data.get('vendor')
    if item.is_valid():        
        item.save()
        calculate_performance_metrics(vendorId)
        return Response(item.data,status=status.HTTP_200_OK)    
    return Response(item.errors, status=status.HTTP_400_BAD_REQUEST)

@api_view(['GET'])
@permission_classes([IsAuthenticated])
def get_purchase_order_filter(request,vendor_id):    
    purchseOrdr = PurchaseOrder.objects.filter(vendor_id=vendor_id)
    serializer = PurchaseOrderSerializer(purchseOrdr, many=True)
    reponse = {
        "status": status.HTTP_200_OK,
        "message": "Success",
        "response": {
            "purchaseData":serializer.data
        }
    }
    return Response(reponse,status=status.HTTP_200_OK)


@api_view(['GET'])
@permission_classes([IsAuthenticated])
def get_purchase_order(request, po_id):
    try:
        purchseOrdr = PurchaseOrder.objects.get(id=po_id)
        serializer = PurchaseOrderSerializer(purchseOrdr)
        response = {
            "status": status.HTTP_200_OK,
            "message": "Success",
            "response": {
                "purchseOrdrsData": serializer.data
            }
        }
        return Response(response,status=status.HTTP_200_OK)
    except PurchaseOrder.DoesNotExist:
        response = {
            "status": status.HTTP_404_NOT_FOUND,
            "message": "Not Found"
        }
        return Response(response,status=status.HTTP_404_NOT_FOUND)
    

@api_view(['PUT'])
@permission_classes([IsAuthenticated])
def update_purchase_order(request, po_id):
    try:
        purchseOrdr = PurchaseOrder.objects.get(id=po_id)
    except PurchaseOrder.DoesNotExist:
        response = {
            "status": status.HTTP_404_NOT_FOUND,
            "message": "Not Found"
        }
        return Response(response,status=status.HTTP_404_NOT_FOUND)
    
    serializer = PurchaseOrderSerializer(purchseOrdr, data=request.data)
    vendorId = request.data.get('vendor')
    if serializer.is_valid():
        serializer.save()
        calculate_performance_metrics(vendorId)
        response = {
            "status": status.HTTP_200_OK,
            "message": "Success"
        }
        return Response(response, status=status.HTTP_200_OK)
    return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

@api_view(['DELETE'])
@permission_classes([IsAuthenticated])
def delete_purchase_order(request, po_id):
    try:
        purchseOrdr = PurchaseOrder.objects.get(id=po_id)
    except PurchaseOrder.DoesNotExist:
        response = {
            "status": status.HTTP_404_NOT_FOUND,
            "message": "Not Found"
        }
        return Response(response, status=status.HTTP_404_NOT_FOUND)

    purchseOrdr.delete()
    response = {
            "status": status.HTTP_200_OK,
            "message": "Success"
        }
    return Response(response, status=status.HTTP_200_OK)


def calculate_performance_metrics(vendor_id):

    completed_pos = PurchaseOrder.objects.filter(vendor_id=vendor_id,status='completed')
    on_time_deliveries = completed_pos.filter(order_date__lte=F('delivery_date')).count()
    total_completed_pos = completed_pos.count()
    if total_completed_pos > 0:
        on_time_delivery_rate = (on_time_deliveries / total_completed_pos) * 100
    else:
        on_time_delivery_rate = 0.0

    quality_ratings = PurchaseOrder.objects.filter(vendor_id=vendor_id,quality_rating__isnull=False).values_list('quality_rating', flat=True)
    quality_rating_avg = sum(quality_ratings) / len(quality_ratings) if quality_ratings else 0

    total_pos = PurchaseOrder.objects.filter(vendor_id=vendor_id).count()
    fulfilled_pos = PurchaseOrder.objects.filter(vendor_id=vendor_id, status='completed').count()
    if total_pos > 0:
        fulfillment_rate = (fulfilled_pos / total_pos) * 100
    else:
        fulfillment_rate = 0.0

    vendorData = Vendor.objects.get(id=vendor_id)
    vendorData.on_time_delivery_rate = on_time_delivery_rate
    vendorData.quality_rating_avg = quality_rating_avg
    vendorData.average_response_time = 0.0
    vendorData.fulfillment_rate = fulfillment_rate
    vendorData.save()

    vendorDataCheck = HistoricalPerformance.objects.filter(vendor_id=vendor_id).exists()
    if vendorDataCheck == False:
        new_data = HistoricalPerformance(
        vendor_id=vendor_id,
        date=str(date.today()),  # Set to current date
        on_time_delivery_rate=on_time_delivery_rate,
        quality_rating_avg=quality_rating_avg,
        average_response_time=0.0,
        fulfillment_rate=fulfillment_rate
        )
        new_data.save()
        print("----11---",vendorDataCheck)
    else:
        dataUpdate = HistoricalPerformance.objects.get(vendor_id=vendor_id)
        dataUpdate.date = str(date.today())  # Update to current date
        dataUpdate.on_time_delivery_rate = on_time_delivery_rate
        dataUpdate.quality_rating_avg = quality_rating_avg
        dataUpdate.average_response_time = 0.0
        dataUpdate.fulfillment_rate = fulfillment_rate
        dataUpdate.save()

@api_view(['GET'])
@permission_classes([IsAuthenticated])
def getVendorPerformance(request,vendor_id):    
    perform = HistoricalPerformance.objects.get(vendor_id=vendor_id)
    serializer = HistoricalPerformanceSerializer(perform)
    reponse = {
        "status": status.HTTP_200_OK,
        "message": "Success",
        "response": {
            "performanceData":serializer.data
        }
    }
    return Response(reponse,status=status.HTTP_200_OK)

