from django.urls import path
from . import views

urlpatterns = [
    path('custom_token_obtain', views.custom_token_obtain, name='custom_token_obtain'),
    
	# ---------------- vendors apis url ----------------
    path('vendors/create_vendor', views.create_vendor, name='create_vendor'),
	path('vendors/getVendor', views.getVendor, name='getVendor'),	
    path('vendors/getVendorId/<int:vendor_id>', views.getVendorId, name='getVendorId'),
    path('vendors/updateVendor/<int:vendor_id>', views.updateVendor, name='updateVendor'),
    path('vendors/deletVendor/<int:vendor_id>', views.deletVendor, name='deletVendor'),
    

	# ---------------- purchaseorders apis url ----------------
    
	path('purchase_orders/create_purchase_order', views.create_purchase_order, name='create_purchase_order'),
	path('purchase_orders/get_purchase_order_filter/<int:vendor_id>', views.get_purchase_order_filter, name='get_purchase_order_filter'),
	path('purchase_orders/get_purchase_order/<int:po_id>', views.get_purchase_order, name='get_purchase_order'),
	path('purchase_orders/update_purchase_order/<int:po_id>', views.update_purchase_order, name='update_purchase_order'),
	path('purchase_orders/delete_purchase_order/<int:po_id>', views.delete_purchase_order, name='delete_purchase_order'),
    
	# ---------------- performance apis url ----------------

	path('vendors/getVendorPerformance/<int:vendor_id>', views.getVendorPerformance, name='getVendorPerformance'),
]
