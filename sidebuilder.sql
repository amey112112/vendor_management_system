-- Adminer 4.8.1 MySQL 10.4.24-MariaDB dump

SET NAMES utf8;
SET time_zone = '+00:00';
SET foreign_key_checks = 0;
SET sql_mode = 'NO_AUTO_VALUE_ON_ZERO';

SET NAMES utf8mb4;

DROP TABLE IF EXISTS `api_customuser`;
CREATE TABLE `api_customuser` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `password` varchar(128) NOT NULL,
  `last_login` datetime(6) DEFAULT NULL,
  `is_superuser` tinyint(1) NOT NULL,
  `username` varchar(150) NOT NULL,
  `first_name` varchar(150) NOT NULL,
  `last_name` varchar(150) NOT NULL,
  `email` varchar(254) NOT NULL,
  `is_staff` tinyint(1) NOT NULL,
  `is_active` tinyint(1) NOT NULL,
  `date_joined` datetime(6) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `username` (`username`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

INSERT INTO `api_customuser` (`id`, `password`, `last_login`, `is_superuser`, `username`, `first_name`, `last_name`, `email`, `is_staff`, `is_active`, `date_joined`) VALUES
(1,	'pbkdf2_sha256$720000$waiieFFGXQBansR7yE7zGI$A8qda0C1+Vodtpqw+1ndSXFEJs2pVX4X2AjMT2/Wikc=',	NULL,	1,	'admin',	'',	'',	'admin@gmail.com',	1,	1,	'2024-07-17 04:46:54.417153');

DROP TABLE IF EXISTS `api_historicalperformance`;
CREATE TABLE `api_historicalperformance` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `date` datetime NOT NULL,
  `vendor_id` bigint(20) NOT NULL,
  `on_time_delivery_rate` float NOT NULL DEFAULT 0,
  `quality_rating_avg` float NOT NULL DEFAULT 0,
  `average_response_time` float NOT NULL DEFAULT 0,
  `fulfillment_rate` float NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  KEY `vendor_id` (`vendor_id`),
  CONSTRAINT `api_historicalperformance_ibfk_1` FOREIGN KEY (`vendor_id`) REFERENCES `api_vendor` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;


DROP TABLE IF EXISTS `api_purchaseorder`;
CREATE TABLE `api_purchaseorder` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `po_number` varchar(100) NOT NULL,
  `order_date` datetime(6) NOT NULL,
  `delivery_date` datetime(6) NOT NULL,
  `items` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL CHECK (json_valid(`items`)),
  `quantity` int(11) NOT NULL,
  `status` varchar(10) NOT NULL,
  `quality_rating` float NOT NULL DEFAULT 0,
  `issue_date` datetime(6) NOT NULL,
  `acknowledgment_date` datetime(6) DEFAULT NULL,
  `vendor_id` bigint(20) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `po_number` (`po_number`),
  KEY `api_purchaseorder_vendor_id_3dfc4286_fk_api_vendor_id` (`vendor_id`),
  CONSTRAINT `api_purchaseorder_vendor_id_3dfc4286_fk_api_vendor_id` FOREIGN KEY (`vendor_id`) REFERENCES `api_vendor` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;


DROP TABLE IF EXISTS `api_vendor`;
CREATE TABLE `api_vendor` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `contact_details` longtext NOT NULL,
  `address` longtext NOT NULL,
  `vendor_code` varchar(100) NOT NULL,
  `on_time_delivery_rate` float NOT NULL DEFAULT 0,
  `quality_rating_avg` float NOT NULL DEFAULT 0,
  `average_response_time` float NOT NULL DEFAULT 0,
  `fulfillment_rate` float NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  UNIQUE KEY `vendor_code` (`vendor_code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;


DROP TABLE IF EXISTS `auth_group`;
CREATE TABLE `auth_group` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(150) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;


DROP TABLE IF EXISTS `auth_group_permissions`;
CREATE TABLE `auth_group_permissions` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `group_id` int(11) NOT NULL,
  `permission_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `auth_group_permissions_group_id_permission_id_0cd325b0_uniq` (`group_id`,`permission_id`),
  KEY `auth_group_permissio_permission_id_84c5c92e_fk_auth_perm` (`permission_id`),
  CONSTRAINT `auth_group_permissio_permission_id_84c5c92e_fk_auth_perm` FOREIGN KEY (`permission_id`) REFERENCES `auth_permission` (`id`),
  CONSTRAINT `auth_group_permissions_group_id_b120cbf9_fk_auth_group_id` FOREIGN KEY (`group_id`) REFERENCES `auth_group` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;


DROP TABLE IF EXISTS `auth_permission`;
CREATE TABLE `auth_permission` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `content_type_id` int(11) NOT NULL,
  `codename` varchar(100) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `auth_permission_content_type_id_codename_01ab375a_uniq` (`content_type_id`,`codename`),
  CONSTRAINT `auth_permission_content_type_id_2f476e4b_fk_django_co` FOREIGN KEY (`content_type_id`) REFERENCES `django_content_type` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

INSERT INTO `auth_permission` (`id`, `name`, `content_type_id`, `codename`) VALUES
(1,	'Can add log entry',	1,	'add_logentry'),
(2,	'Can change log entry',	1,	'change_logentry'),
(3,	'Can delete log entry',	1,	'delete_logentry'),
(4,	'Can view log entry',	1,	'view_logentry'),
(5,	'Can add permission',	2,	'add_permission'),
(6,	'Can change permission',	2,	'change_permission'),
(7,	'Can delete permission',	2,	'delete_permission'),
(8,	'Can view permission',	2,	'view_permission'),
(9,	'Can add group',	3,	'add_group'),
(10,	'Can change group',	3,	'change_group'),
(11,	'Can delete group',	3,	'delete_group'),
(12,	'Can view group',	3,	'view_group'),
(13,	'Can add user',	4,	'add_user'),
(14,	'Can change user',	4,	'change_user'),
(15,	'Can delete user',	4,	'delete_user'),
(16,	'Can view user',	4,	'view_user'),
(17,	'Can add content type',	5,	'add_contenttype'),
(18,	'Can change content type',	5,	'change_contenttype'),
(19,	'Can delete content type',	5,	'delete_contenttype'),
(20,	'Can view content type',	5,	'view_contenttype'),
(21,	'Can add session',	6,	'add_session'),
(22,	'Can change session',	6,	'change_session'),
(23,	'Can delete session',	6,	'delete_session'),
(24,	'Can view session',	6,	'view_session'),
(25,	'Can add vendor',	7,	'add_vendor'),
(26,	'Can change vendor',	7,	'change_vendor'),
(27,	'Can delete vendor',	7,	'delete_vendor'),
(28,	'Can view vendor',	7,	'view_vendor'),
(29,	'Can add purchase order',	8,	'add_purchaseorder'),
(30,	'Can change purchase order',	8,	'change_purchaseorder'),
(31,	'Can delete purchase order',	8,	'delete_purchaseorder'),
(32,	'Can view purchase order',	8,	'view_purchaseorder');

DROP TABLE IF EXISTS `auth_user_groups`;
CREATE TABLE `auth_user_groups` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `group_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `auth_user_groups_user_id_group_id_94350c0c_uniq` (`user_id`,`group_id`),
  KEY `auth_user_groups_group_id_97559544_fk_auth_group_id` (`group_id`),
  CONSTRAINT `auth_user_groups_group_id_97559544_fk_auth_group_id` FOREIGN KEY (`group_id`) REFERENCES `auth_group` (`id`),
  CONSTRAINT `auth_user_groups_user_id_6a12ed8b_fk_auth_user_id` FOREIGN KEY (`user_id`) REFERENCES `api_customuser` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;


DROP TABLE IF EXISTS `auth_user_user_permissions`;
CREATE TABLE `auth_user_user_permissions` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `permission_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `auth_user_user_permissions_user_id_permission_id_14a6b632_uniq` (`user_id`,`permission_id`),
  KEY `auth_user_user_permi_permission_id_1fbb5f2c_fk_auth_perm` (`permission_id`),
  CONSTRAINT `auth_user_user_permi_permission_id_1fbb5f2c_fk_auth_perm` FOREIGN KEY (`permission_id`) REFERENCES `auth_permission` (`id`),
  CONSTRAINT `auth_user_user_permissions_user_id_a95ead1b_fk_auth_user_id` FOREIGN KEY (`user_id`) REFERENCES `api_customuser` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;


DROP TABLE IF EXISTS `django_admin_log`;
CREATE TABLE `django_admin_log` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `action_time` datetime(6) NOT NULL,
  `object_id` longtext DEFAULT NULL,
  `object_repr` varchar(200) NOT NULL,
  `action_flag` smallint(5) unsigned NOT NULL CHECK (`action_flag` >= 0),
  `change_message` longtext NOT NULL,
  `content_type_id` int(11) DEFAULT NULL,
  `user_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `django_admin_log_content_type_id_c4bce8eb_fk_django_co` (`content_type_id`),
  KEY `django_admin_log_user_id_c564eba6_fk_auth_user_id` (`user_id`),
  CONSTRAINT `django_admin_log_content_type_id_c4bce8eb_fk_django_co` FOREIGN KEY (`content_type_id`) REFERENCES `django_content_type` (`id`),
  CONSTRAINT `django_admin_log_user_id_c564eba6_fk_auth_user_id` FOREIGN KEY (`user_id`) REFERENCES `api_customuser` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;


DROP TABLE IF EXISTS `django_content_type`;
CREATE TABLE `django_content_type` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `app_label` varchar(100) NOT NULL,
  `model` varchar(100) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `django_content_type_app_label_model_76bd3d3b_uniq` (`app_label`,`model`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

INSERT INTO `django_content_type` (`id`, `app_label`, `model`) VALUES
(1,	'admin',	'logentry'),
(8,	'api',	'purchaseorder'),
(7,	'api',	'vendor'),
(3,	'auth',	'group'),
(2,	'auth',	'permission'),
(4,	'auth',	'user'),
(5,	'contenttypes',	'contenttype'),
(6,	'sessions',	'session');

DROP TABLE IF EXISTS `django_migrations`;
CREATE TABLE `django_migrations` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `app` varchar(255) NOT NULL,
  `name` varchar(255) NOT NULL,
  `applied` datetime(6) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

INSERT INTO `django_migrations` (`id`, `app`, `name`, `applied`) VALUES
(1,	'contenttypes',	'0001_initial',	'2024-07-16 13:20:26.410619'),
(2,	'auth',	'0001_initial',	'2024-07-16 13:20:26.949689'),
(3,	'admin',	'0001_initial',	'2024-07-16 13:20:27.081204'),
(4,	'admin',	'0002_logentry_remove_auto_add',	'2024-07-16 13:20:27.096829'),
(5,	'admin',	'0003_logentry_add_action_flag_choices',	'2024-07-16 13:20:27.096829'),
(6,	'api',	'0001_initial',	'2024-07-16 13:20:27.212714'),
(7,	'contenttypes',	'0002_remove_content_type_name',	'2024-07-16 13:20:27.281726'),
(8,	'auth',	'0002_alter_permission_name_max_length',	'2024-07-16 13:20:27.328603'),
(9,	'auth',	'0003_alter_user_email_max_length',	'2024-07-16 13:20:27.350732'),
(10,	'auth',	'0004_alter_user_username_opts',	'2024-07-16 13:20:27.350732'),
(11,	'auth',	'0005_alter_user_last_login_null',	'2024-07-16 13:20:27.428861'),
(12,	'auth',	'0006_require_contenttypes_0002',	'2024-07-16 13:20:27.444486'),
(13,	'auth',	'0007_alter_validators_add_error_messages',	'2024-07-16 13:20:27.450993'),
(14,	'auth',	'0008_alter_user_username_max_length',	'2024-07-16 13:20:27.450993'),
(15,	'auth',	'0009_alter_user_last_name_max_length',	'2024-07-16 13:20:27.466624'),
(16,	'auth',	'0010_alter_group_name_max_length',	'2024-07-16 13:20:27.482248'),
(17,	'auth',	'0011_update_proxy_permissions',	'2024-07-16 13:20:27.497873'),
(18,	'auth',	'0012_alter_user_first_name_max_length',	'2024-07-16 13:20:27.513500'),
(19,	'sessions',	'0001_initial',	'2024-07-16 13:20:27.551254');

DROP TABLE IF EXISTS `django_session`;
CREATE TABLE `django_session` (
  `session_key` varchar(40) NOT NULL,
  `session_data` longtext NOT NULL,
  `expire_date` datetime(6) NOT NULL,
  PRIMARY KEY (`session_key`),
  KEY `django_session_expire_date_a5c62663` (`expire_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;


-- 2024-07-17 11:20:51
