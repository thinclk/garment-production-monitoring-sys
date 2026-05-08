-- --------------------------------------------------------
-- Host:                         127.0.0.1
-- Server version:               8.0.46 - MySQL Community Server - GPL
-- Server OS:                    Win64
-- HeidiSQL Version:             12.15.0.7171
-- --------------------------------------------------------

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8 */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;


-- Dumping database structure for garment-db
CREATE DATABASE IF NOT EXISTS `garment-db` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;
USE `garment-db`;

-- Dumping structure for table garment-db.employees
CREATE TABLE IF NOT EXISTS `employees` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `rfid_uid` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `status` enum('active','inactive') COLLATE utf8mb4_unicode_ci DEFAULT 'active',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `rfid_uid` (`rfid_uid`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Dumping data for table garment-db.employees: ~0 rows (approximately)
INSERT INTO `employees` (`id`, `name`, `rfid_uid`, `status`, `created_at`) VALUES
	(3, 'Aaliya', 'DD 2A F 5', 'active', '2026-04-28 07:58:50'),
	(4, 'Nabeel', '79 C2 13 5', 'active', '2026-04-28 07:58:50'),
	(5, 'Amar', 'A1 43 AB 2', 'active', '2026-04-28 07:58:50'),
	(6, 'Aadhil', '1C 61 AB 0', 'active', '2026-04-28 07:58:50');

-- Dumping structure for table garment-db.logs
CREATE TABLE IF NOT EXISTS `logs` (
  `id` int NOT NULL AUTO_INCREMENT,
  `esp_id` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `employee_id` int DEFAULT NULL,
  `employee_name` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `rfid_uid` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `column_no` int DEFAULT NULL,
  `machine_no` int DEFAULT NULL,
  `time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `employee_id` (`employee_id`),
  CONSTRAINT `logs_ibfk_1` FOREIGN KEY (`employee_id`) REFERENCES `employees` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=46 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Dumping data for table garment-db.logs: ~14 rows (approximately)
INSERT INTO `logs` (`id`, `esp_id`, `employee_id`, `employee_name`, `rfid_uid`, `column_no`, `machine_no`, `time`) VALUES
	(31, 'ESP32_1', 6, 'Aadhil', '1C 61 AB 0', 1, 7, '2026-04-28 13:26:16'),
	(32, 'ESP32_1', 5, 'Amar', 'A1 43 AB 2', 1, 6, '2026-04-28 13:26:42'),
	(33, 'ESP32_1', 5, 'Amar', 'A1 43 AB 2', 1, 5, '2026-04-28 13:26:47'),
	(34, 'ESP32_1', 5, 'Amar', 'A1 43 AB 2', 1, 1, '2026-04-28 13:27:20'),
	(36, 'ESP32_1', 5, 'Amar', 'A1 43 AB 2', 1, 3, '2026-04-28 13:27:40'),
	(37, 'ESP32_1', 5, 'Amar', 'A1 43 AB 2', 1, 4, '2026-04-28 13:27:51'),
	(38, 'ESP32_1', 5, 'Amar', 'A1 43 AB 2', 1, 5, '2026-04-28 13:28:02'),
	(39, 'ESP32_1', 4, 'Nabeel', '79 C2 13 5', 1, 6, '2026-04-28 13:28:17'),
	(40, 'ESP32_1', 4, 'Nabeel', '79 C2 13 5', 1, 7, '2026-04-28 13:28:25'),
	(41, 'ESP32_1', 4, 'Nabeel', '79 C2 13 5', 1, 1, '2026-04-28 13:28:34'),
	(42, 'ESP32_1', 5, 'Amar', 'A1 43 AB 2', 1, 7, '2026-05-05 07:59:38'),
	(43, 'ESP32_1', 5, 'Amar', 'A1 43 AB 2', 1, 7, '2026-05-05 07:59:51'),
	(44, 'ESP32_1', 5, 'Amar', 'A1 43 AB 2', 1, 7, '2026-05-05 08:00:38'),
	(45, 'ESP32_1', 5, 'Amar', 'A1 43 AB 2', 1, 7, '2026-05-05 08:00:44');

/*!40103 SET TIME_ZONE=IFNULL(@OLD_TIME_ZONE, 'system') */;
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IFNULL(@OLD_FOREIGN_KEY_CHECKS, 1) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40111 SET SQL_NOTES=IFNULL(@OLD_SQL_NOTES, 1) */;
