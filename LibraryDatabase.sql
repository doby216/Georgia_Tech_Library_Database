-- MySQL dump 10.13  Distrib 8.0.33, for macos13 (arm64)
--
-- Host: localhost    Database: library
-- ------------------------------------------------------
-- Server version	8.0.32

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `Book`
--

DROP TABLE IF EXISTS `Book`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Book` (
  `ISBN` varchar(17) NOT NULL,
  `Volume_Number` int NOT NULL,
  `Book_Status` varchar(40) DEFAULT NULL,
  PRIMARY KEY (`ISBN`,`Volume_Number`),
  CONSTRAINT `book_ibfk_1` FOREIGN KEY (`ISBN`) REFERENCES `Catalog_Of_Book` (`ISBN`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Book`
--

LOCK TABLES `Book` WRITE;
/*!40000 ALTER TABLE `Book` DISABLE KEYS */;
INSERT INTO `Book` VALUES ('978-0-060-83987-1',1,'borrowed'),('978-0-060-83987-1',2,'available'),('978-0-060-83987-1',3,'available'),('978-0-060-83987-1',4,'available'),('978-0-060-83987-1',5,'available'),('978-0-060-83987-1',6,'available'),('978-0-060-83987-1',7,'available'),('978-0-060-83987-1',8,'available'),('978-0-060-83987-1',9,'available'),('978-0-060-83987-1',10,'available'),('978-0-316-76917-4',1,'borrowed'),('978-0-316-76917-4',2,'available'),('978-0-316-76917-4',3,'available'),('978-0-316-76917-4',4,'available'),('978-0-316-76917-4',5,'available'),('978-0-316-76917-4',6,'available'),('978-0-316-76917-4',7,'available'),('978-0-316-76917-4',8,'available'),('978-0-316-76917-4',9,'available'),('978-0-316-76917-4',10,'available'),('978-0-385-46878-4',1,'borrowed'),('978-0-385-46878-4',2,'borrowed'),('978-0-385-46878-4',3,'available'),('979-8-745-27482-4',1,'borrowed'),('979-8-745-27482-4',2,'available'),('979-8-745-27482-4',3,'available'),('979-8-745-27482-4',4,'available'),('979-8-745-27482-4',5,'available'),('979-8-745-27482-4',6,'available'),('979-8-745-27482-4',7,'available'),('979-8-745-27482-4',8,'available'),('979-8-745-27482-4',9,'available'),('979-8-745-27482-4',10,'available');
/*!40000 ALTER TABLE `Book` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Borrowing_Activity`
--

DROP TABLE IF EXISTS `Borrowing_Activity`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Borrowing_Activity` (
  `Receipt_Number` varchar(255) NOT NULL,
  `Duration` int DEFAULT NULL,
  `Check_Out_Date` date DEFAULT NULL,
  `Return_Status` varchar(40) DEFAULT NULL,
  `Return_Date` date DEFAULT NULL,
  `Amount_Due` double DEFAULT NULL,
  `ISBN` varchar(17) DEFAULT NULL,
  `Volume_Number` int DEFAULT NULL,
  `Card_Number` int DEFAULT NULL,
  `Staff_SSN` int DEFAULT NULL,
  PRIMARY KEY (`Receipt_Number`),
  KEY `ISBN` (`ISBN`,`Volume_Number`),
  KEY `Card_Number` (`Card_Number`),
  KEY `Staff_SSN` (`Staff_SSN`),
  CONSTRAINT `borrowing_activity_ibfk_1` FOREIGN KEY (`ISBN`, `Volume_Number`) REFERENCES `Book` (`ISBN`, `Volume_Number`),
  CONSTRAINT `borrowing_activity_ibfk_2` FOREIGN KEY (`Card_Number`) REFERENCES `Membership_Card` (`Card_Number`),
  CONSTRAINT `borrowing_activity_ibfk_3` FOREIGN KEY (`Staff_SSN`) REFERENCES `Staff` (`SSN`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Borrowing_Activity`
--

LOCK TABLES `Borrowing_Activity` WRITE;
/*!40000 ALTER TABLE `Borrowing_Activity` DISABLE KEYS */;
INSERT INTO `Borrowing_Activity` VALUES ('20230506211730',21,'2023-05-06','Returned','2023-05-06',0,'978-0-385-46878-4',1,1,444444444),('20230506212520',21,'2023-05-06','Returned','2023-05-06',0,'978-0-385-46878-4',2,2,444444444),('20230507131637',21,'2023-05-07','Not Returned',NULL,0,'978-0-060-83987-1',1,1,444444444),('20230507131654',21,'2023-05-07','Not Returned',NULL,0,'978-0-316-76917-4',1,1,444444444),('20230507131710',21,'2023-05-07','Not Returned',NULL,0,'978-0-385-46878-4',1,1,444444444),('20230507131728',21,'2023-05-07','Not Returned',NULL,0,'979-8-745-27482-4',1,1,444444444),('20230507131900',21,'2023-05-07','Not Returned',NULL,0,'978-0-385-46878-4',2,1,444444444);
/*!40000 ALTER TABLE `Borrowing_Activity` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Catalog_Of_Book`
--

DROP TABLE IF EXISTS `Catalog_Of_Book`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Catalog_Of_Book` (
  `ISBN` varchar(17) NOT NULL,
  `Title` varchar(255) DEFAULT NULL,
  `Author` varchar(255) DEFAULT NULL,
  `Subject_Area` varchar(255) DEFAULT NULL,
  `Description` varchar(255) DEFAULT NULL,
  `Book_Type` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`ISBN`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Catalog_Of_Book`
--

LOCK TABLES `Catalog_Of_Book` WRITE;
/*!40000 ALTER TABLE `Catalog_Of_Book` DISABLE KEYS */;
INSERT INTO `Catalog_Of_Book` VALUES ('978-0-060-83987-1','Zen and the Art of Motorcycle Maintenance: An Inquiry Into Values','Pirsig, Robert M','Non-Fiction','','Paperback'),('978-0-316-76917-4','The Catcher in the Rye','J. D. Salinger','Fiction','','Paperback'),('978-0-385-46878-4','To Kill a Mockingbird','Harper Lee','Fiction','','Paperback'),('979-8-745-27482-4','The Great Gatsby','Fitzgerald, F. Scott','Fiction','','Paperback');
/*!40000 ALTER TABLE `Catalog_Of_Book` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Member`
--

DROP TABLE IF EXISTS `Member`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Member` (
  `SSN` int NOT NULL,
  `Member_Type` varchar(40) DEFAULT NULL,
  `Check_Out_Day_Allowed` int DEFAULT NULL,
  `Grace_Period` int DEFAULT NULL,
  PRIMARY KEY (`SSN`),
  CONSTRAINT `member_ibfk_1` FOREIGN KEY (`SSN`) REFERENCES `Person` (`SSN`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Member`
--

LOCK TABLES `Member` WRITE;
/*!40000 ALTER TABLE `Member` DISABLE KEYS */;
INSERT INTO `Member` VALUES (111111111,'student',21,7),(222222222,'student',21,7),(333333333,'professor',90,14),(555555555,'professor',90,14),(666666666,'professor',90,14),(777777777,'student',21,7);
/*!40000 ALTER TABLE `Member` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Membership_Card`
--

DROP TABLE IF EXISTS `Membership_Card`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Membership_Card` (
  `Card_Number` int NOT NULL,
  `Member_SSN` int DEFAULT NULL,
  `Date_Issued` date DEFAULT NULL,
  `Valid_Time` int DEFAULT NULL,
  `Card_Status` varchar(40) DEFAULT NULL,
  PRIMARY KEY (`Card_Number`),
  KEY `Member_SSN` (`Member_SSN`),
  CONSTRAINT `membership_card_ibfk_1` FOREIGN KEY (`Member_SSN`) REFERENCES `Member` (`SSN`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Membership_Card`
--

LOCK TABLES `Membership_Card` WRITE;
/*!40000 ALTER TABLE `Membership_Card` DISABLE KEYS */;
INSERT INTO `Membership_Card` VALUES (1,111111111,'2023-05-06',4,'active'),(2,222222222,'2023-05-06',4,'active'),(3,333333333,'2023-05-06',4,'active'),(5,555555555,'2023-05-07',4,'active'),(6,666666666,'2023-05-07',4,'active'),(7,777777777,'2023-05-07',4,'active');
/*!40000 ALTER TABLE `Membership_Card` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Person`
--

DROP TABLE IF EXISTS `Person`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Person` (
  `SSN` int NOT NULL,
  `Name` varchar(255) DEFAULT NULL,
  `Home_Address` varchar(255) DEFAULT NULL,
  `Campus_Address` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`SSN`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Person`
--

LOCK TABLES `Person` WRITE;
/*!40000 ALTER TABLE `Person` DISABLE KEYS */;
INSERT INTO `Person` VALUES (111111111,'Yan Chen','',''),(222222222,'Haowei Wang','',''),(333333333,'Xinying Chyn','',''),(444444444,'Jone Doe','',''),(555555555,'Bob','',''),(666666666,'David','',''),(777777777,'Edison','','');
/*!40000 ALTER TABLE `Person` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Phone`
--

DROP TABLE IF EXISTS `Phone`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Phone` (
  `SSN` int NOT NULL,
  `Phone_Number` char(12) NOT NULL,
  PRIMARY KEY (`SSN`,`Phone_Number`),
  CONSTRAINT `phone_ibfk_1` FOREIGN KEY (`SSN`) REFERENCES `Person` (`SSN`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Phone`
--

LOCK TABLES `Phone` WRITE;
/*!40000 ALTER TABLE `Phone` DISABLE KEYS */;
/*!40000 ALTER TABLE `Phone` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Staff`
--

DROP TABLE IF EXISTS `Staff`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Staff` (
  `SSN` int NOT NULL,
  `Staff_Type` varchar(40) DEFAULT NULL,
  PRIMARY KEY (`SSN`),
  CONSTRAINT `staff_ibfk_1` FOREIGN KEY (`SSN`) REFERENCES `Person` (`SSN`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Staff`
--

LOCK TABLES `Staff` WRITE;
/*!40000 ALTER TABLE `Staff` DISABLE KEYS */;
INSERT INTO `Staff` VALUES (444444444,'Check-Out Staff');
/*!40000 ALTER TABLE `Staff` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2023-05-07 20:29:26
