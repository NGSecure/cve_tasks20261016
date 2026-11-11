-- phpMyAdmin SQL Dump
-- version 5.2.0
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Apr 16, 2023 at 03:10 PM
-- Server version: 10.4.27-MariaDB
-- PHP Version: 8.2.0

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `chitor_db`
--

-- --------------------------------------------------------

--
-- Table structure for table `class_subjects`
--

CREATE TABLE `class_subjects` (
  `Id` int(11) NOT NULL,
  `School_Id` int(11) DEFAULT NULL,
  `Class_Id` int(11) NOT NULL,
  `Subject_Id` int(11) NOT NULL,
  `Lock_Status` int(1) NOT NULL DEFAULT 0,
  `Total_Marks` int(3) NOT NULL DEFAULT 40,
  `Status` tinyint(1) NOT NULL DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data for table `class_subjects`
--

INSERT INTO `class_subjects` (`Id`, `School_Id`, `Class_Id`, `Subject_Id`, `Lock_Status`, `Total_Marks`, `Status`) VALUES
(1, 1, 25, 1, 0, 50, 1),
(2, 1, 2, 1, 0, 100, 1),
(3, 1, 3, 1, 0, 100, 1),
(4, 1, 4, 1, 0, 100, 1),
(5, 1, 5, 1, 0, 100, 1),
(6, 1, 6, 1, 0, 100, 1),
(7, 1, 7, 1, 0, 100, 1),
(9, 1, 1, 2, 0, 50, 1),
(10, 1, 1, 3, 1, 100, 1),
(11, 1, 23, 1, 0, 100, 1);

-- --------------------------------------------------------

--
-- Table structure for table `employees`
--

CREATE TABLE `employees` (
  `Id` int(2) NOT NULL,
  `Personal_No` int(11) DEFAULT NULL,
  `Name` varchar(30) NOT NULL,
  `Father_Name` varchar(30) DEFAULT NULL,
  `Designation` varchar(20) DEFAULT NULL,
  `Mac_Address` varchar(17) DEFAULT NULL,
  `Mobile_No` varchar(12) DEFAULT NULL,
  `Status` int(2) NOT NULL DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data for table `employees`
--

INSERT INTO `employees` (`Id`, `Personal_No`, `Name`, `Father_Name`, `Designation`, `Mac_Address`, `Mobile_No`, `Status`) VALUES
(1, NULL, 'Guest', NULL, NULL, NULL, NULL, 1),
(2, NULL, 'Waqas Ahmad', NULL, NULL, NULL, NULL, 1),
(3, NULL, 'admin', 'admin', 'admin', NULL, NULL, 1);

-- --------------------------------------------------------

--
-- Table structure for table `exam_committee`
--

CREATE TABLE `exam_committee` (
  `Id` int(11) NOT NULL,
  `Member_Id` int(11) NOT NULL,
  `Status` int(11) NOT NULL DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `login`
--

CREATE TABLE `login` (
  `Id` int(11) NOT NULL,
  `Employee_Id` int(11) NOT NULL,
  `User_Name` varchar(30) NOT NULL,
  `Password` varchar(256) NOT NULL,
  `Status` int(11) NOT NULL DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data for table `login`
--

INSERT INTO `login` (`Id`, `Employee_Id`, `User_Name`, `Password`, `Status`) VALUES
(1, 1, 'Guest', 'adb831a7fdd83dd1e2a309ce7591dff8', 1),
(2, 2, 'waqaskanju', '119e882fb3cee50d9272ba79822715f5', 1),
(3, 3, 'admin', '21232f297a57a5a743894a0e4a801fc3', 1);

-- --------------------------------------------------------

--
-- Table structure for table `marks`
--

CREATE TABLE `marks` (
  `Serial_No` int(11) NOT NULL,
  `Roll_No` int(11) NOT NULL,
  `English_Marks` int(3) NOT NULL DEFAULT 0,
  `Urdu_Marks` int(3) NOT NULL DEFAULT 0,
  `Maths_Marks` int(3) NOT NULL DEFAULT 0,
  `Science_Marks` int(3) NOT NULL DEFAULT 0,
  `Hpe_Marks` int(3) NOT NULL DEFAULT 0,
  `Nazira_Marks` int(3) NOT NULL DEFAULT 0,
  `History_Marks` int(3) NOT NULL DEFAULT 0,
  `Drawing_Marks` int(3) NOT NULL DEFAULT 0,
  `Islamyat_Marks` int(3) NOT NULL DEFAULT 0,
  `Computer_Marks` int(3) NOT NULL DEFAULT 0,
  `Arabic_Marks` int(3) NOT NULL DEFAULT 0,
  `Mutalia_Marks` int(3) NOT NULL DEFAULT 0,
  `Qirat_Marks` int(3) NOT NULL DEFAULT 0,
  `Pashto_Marks` int(3) NOT NULL DEFAULT 0,
  `Social_Marks` int(3) NOT NULL DEFAULT 0,
  `Biology_Marks` int(3) NOT NULL DEFAULT 0,
  `Chemistry_Marks` int(3) NOT NULL DEFAULT 0,
  `Physics_Marks` int(3) NOT NULL DEFAULT 0,
  `Civics_Marks` int(3) NOT NULL DEFAULT 0,
  `Economics_Marks` int(3) NOT NULL DEFAULT 0,
  `Islamic_Study_Marks` int(3) NOT NULL DEFAULT 0,
  `Islamic_Education_Marks` int(3) NOT NULL DEFAULT 0,
  `Statistics_Marks` int(3) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- --------------------------------------------------------

--
-- Table structure for table `position`
--

CREATE TABLE `position` (
  `Serial_No` int(11) NOT NULL,
  `Roll_No` int(11) NOT NULL,
  `Total_Marks` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data for table `position`
--

INSERT INTO `position` (`Serial_No`, `Roll_No`, `Total_Marks`) VALUES
(1608, 2264, 65),
(1609, 2265, 33),
(1610, 2266, 0),
(1611, 2267, 0),
(1612, 2268, 0),
(1613, 2269, 0),
(1614, 3435, 0),
(1615, 21617, 0),
(1616, 21633, 0),
(1617, 21634, 0),
(1618, 21638, 0),
(1619, 21639, 0),
(1620, 21640, 0),
(1621, 22610, 0),
(1622, 22611, 0),
(1623, 22612, 0),
(1624, 22613, 0),
(1625, 22614, 0),
(1626, 22615, 0),
(1627, 22616, 0),
(1628, 22617, 0),
(1629, 22618, 0),
(1630, 22619, 0),
(1631, 22620, 0),
(1632, 22621, 0),
(1633, 22622, 0),
(1634, 22623, 0),
(1635, 22624, 0),
(1636, 22625, 0),
(1637, 22626, 0),
(1638, 22627, 0),
(1639, 22628, 0),
(1640, 22629, 0),
(1641, 22630, 0),
(1642, 22631, 0),
(1643, 22632, 0),
(1644, 22633, 0),
(1645, 22634, 0),
(1646, 22635, 0),
(1647, 22636, 0),
(1648, 22637, 0),
(1649, 22638, 0),
(1650, 22639, 0),
(1651, 22640, 0),
(1652, 22641, 0),
(1653, 22642, 0),
(1654, 22643, 0),
(1655, 22645, 0);

-- --------------------------------------------------------

--
-- Table structure for table `schools`
--

CREATE TABLE `schools` (
  `Id` int(11) NOT NULL,
  `Name` varchar(30) NOT NULL,
  `Status` int(2) NOT NULL DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data for table `schools`
--

INSERT INTO `schools` (`Id`, `Name`, `Status`) VALUES
(1, 'GHSS Chitor', 1),
(2, 'GMS Marghazar', 1),
(3, 'GMS Spal Bandai', 1),
(4, 'GPS Kokrai', 1),
(5, 'GPS Chitor', 1),
(6, 'GCPS Jabba', 1),
(7, 'Iqra', 1),
(8, 'Anfal', 1),
(11, '@#$%^&amp;*(KBB&amp;*()!~!@#$%', 1);

-- --------------------------------------------------------

--
-- Table structure for table `school_classes`
--

CREATE TABLE `school_classes` (
  `Id` int(11) NOT NULL,
  `Name` varchar(20) NOT NULL,
  `School_Id` int(2) NOT NULL,
  `Pass_Percentage` float NOT NULL DEFAULT 0,
  `Status` tinyint(1) NOT NULL DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data for table `school_classes`
--

INSERT INTO `school_classes` (`Id`, `Name`, `School_Id`, `Pass_Percentage`, `Status`) VALUES
(1, '6th', 1, 20, 1),
(2, '7th', 1, 19.4, 1),
(3, '8th', 1, 24, 1),
(4, '9th A', 1, 33, 1),
(5, '9th B', 1, 33, 1),
(6, '10th A', 1, 33, 1),
(7, '10th B', 1, 33, 1),
(8, '5th', 5, 19.4, 1),
(14, '8th', 2, 24, 1),
(16, '5th', 6, 19.4, 1),
(17, '5th', 4, 19.4, 1),
(18, '8th', 3, 24, 1),
(22, '8th', 6, 33.3, 1),
(23, '5th', 1, 19.4, 1),
(25, '4th', 1, 19.4, 1),
(26, '11th A', 1, 33.3, 1),
(27, '12th&lt;!----&gt;', 1, 33.3, 1);

-- --------------------------------------------------------

--
-- Table structure for table `setting`
--

CREATE TABLE `setting` (
  `User_Id` int(11) NOT NULL,
  `Selected_School_Id` int(11) NOT NULL DEFAULT 1,
  `Selected_Class_Id` int(11) NOT NULL DEFAULT 1,
  `Student_Changes` int(1) NOT NULL DEFAULT 0,
  `Batch_Marks_Changes` int(1) NOT NULL DEFAULT 0,
  `Single_Marks_Changes` int(1) NOT NULL DEFAULT 0,
  `Subject_Changes` int(1) NOT NULL DEFAULT 0,
  `School_Changes` int(1) NOT NULL DEFAULT 0,
  `Marks_Lock_Changes` int(1) NOT NULL DEFAULT 0,
  `Permission_Changes` int(1) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data for table `setting`
--

INSERT INTO `setting` (`User_Id`, `Selected_School_Id`, `Selected_Class_Id`, `Student_Changes`, `Batch_Marks_Changes`, `Single_Marks_Changes`, `Subject_Changes`, `School_Changes`, `Marks_Lock_Changes`, `Permission_Changes`) VALUES
(1, 1, 1, 0, 0, 0, 0, 9, 0, 0),
(2, 1, 1, 1, 1, 1, 1, 1, 0, 0),
(3, 1, 1, 1, 11, 1, 1, 1, 1, 1);

-- --------------------------------------------------------

--
-- Table structure for table `students_info`
--

CREATE TABLE `students_info` (
  `Roll_No` int(11) NOT NULL,
  `Name` varchar(30) NOT NULL,
  `FName` varchar(30) NOT NULL,
  `Gender` enum('Male','Female') NOT NULL DEFAULT 'Male',
  `Dob` date DEFAULT NULL,
  `Mobile_No` varchar(12) NOT NULL DEFAULT '03',
  `Admission_Date` date DEFAULT NULL,
  `Admission_No` int(6) DEFAULT NULL,
  `Father_Cnic` varchar(15) DEFAULT NULL,
  `Student_Form_B` varchar(15) DEFAULT NULL,
  `School` varchar(30) NOT NULL DEFAULT 'GHSS CHITOR',
  `Class` enum('5th','6th A','6th B','7th','8th A','8th B','8th','10th A','10th B','9th A','9th B','6th','7th A','7th B','4th','11th') NOT NULL,
  `Class_Position` varchar(10) DEFAULT NULL,
  `Status` int(11) NOT NULL DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- --------------------------------------------------------

--
-- Table structure for table `subjects`
--

CREATE TABLE `subjects` (
  `Id` int(11) NOT NULL,
  `Name` varchar(30) NOT NULL,
  `Status` tinyint(4) NOT NULL DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data for table `subjects`
--

INSERT INTO `subjects` (`Id`, `Name`, `Status`) VALUES
(1, 'English', 1),
(2, 'Urdu', 1),
(3, 'Maths', 1),
(4, 'Computer Science', 1),
(5, 'Islamyat', 1),
(6, 'History And Geography', 1),
(7, 'Hpe', 1),
(8, 'General Science', 1),
(9, 'Qirat', 1),
(10, 'Arabic', 1),
(11, 'Drawing', 1),
(12, 'Mutalia Quran', 1),
(13, 'Pashto', 1),
(14, 'Nazira', 1),
(15, 'Physics', 1),
(16, 'Social Study', 1),
(17, 'Chemistry', 1),
(18, 'Biology', 1),
(19, 'Pak Study', 1),
(22, 'Introduction to Computing', 1),
(23, 'Financial Accounting Managemen', 1),
(24, 'C plus plus 3', 1);

-- --------------------------------------------------------

--
-- Table structure for table `subject_teacher`
--

CREATE TABLE `subject_teacher` (
  `Id` int(11) NOT NULL,
  `Class_Subject_Id` int(11) NOT NULL,
  `Teacher_Id` int(11) NOT NULL,
  `Status` int(1) NOT NULL DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `subject_teacher`
--

INSERT INTO `subject_teacher` (`Id`, `Class_Subject_Id`, `Teacher_Id`, `Status`) VALUES
(1, 1, 1, 1),
(2, 2, 2, 1),
(3, 3, 2, 1),
(4, 4, 1, 1),
(5, 5, 1, 1),
(6, 6, 1, 1),
(7, 7, 2, 1),
(8, 10, 2, 1);

-- --------------------------------------------------------

--
-- Table structure for table `tab_index`
--

CREATE TABLE `tab_index` (
  `Tab_index_id` int(11) NOT NULL,
  `English` int(11) NOT NULL,
  `Urdu` int(11) NOT NULL,
  `Maths` int(11) NOT NULL,
  `Hpe` int(11) NOT NULL,
  `Nazira` int(11) NOT NULL,
  `Science` int(11) NOT NULL,
  `Arabic` int(11) NOT NULL,
  `Islamyat` int(11) NOT NULL,
  `History` int(11) NOT NULL,
  `Computer` int(11) NOT NULL,
  `Mutalia` int(11) NOT NULL,
  `Qirat` int(11) NOT NULL,
  `Drawing` int(11) NOT NULL,
  `Social` int(2) NOT NULL DEFAULT 0,
  `Pashto` int(2) NOT NULL DEFAULT 0,
  `Biology` int(2) NOT NULL,
  `Chemistry` int(2) NOT NULL,
  `Physics` int(2) NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data for table `tab_index`
--

INSERT INTO `tab_index` (`Tab_index_id`, `English`, `Urdu`, `Maths`, `Hpe`, `Nazira`, `Science`, `Arabic`, `Islamyat`, `History`, `Computer`, `Mutalia`, `Qirat`, `Drawing`, `Social`, `Pashto`, `Biology`, `Chemistry`, `Physics`) VALUES
(1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 3, 12, 13, 14, 15, 16, 17, 18, 19);

--
-- Indexes for dumped tables
--

--
-- Indexes for table `class_subjects`
--
ALTER TABLE `class_subjects`
  ADD PRIMARY KEY (`Id`),
  ADD UNIQUE KEY `uqSchool_Class_Subject` (`School_Id`,`Class_Id`,`Subject_Id`),
  ADD KEY `class_id_reference` (`Class_Id`),
  ADD KEY `subject_id_reference` (`Subject_Id`);

--
-- Indexes for table `employees`
--
ALTER TABLE `employees`
  ADD PRIMARY KEY (`Id`);

--
-- Indexes for table `exam_committee`
--
ALTER TABLE `exam_committee`
  ADD PRIMARY KEY (`Id`),
  ADD UNIQUE KEY `unique` (`Member_Id`);

--
-- Indexes for table `login`
--
ALTER TABLE `login`
  ADD PRIMARY KEY (`Id`),
  ADD UNIQUE KEY `username` (`User_Name`),
  ADD KEY `Employee_Id` (`Employee_Id`);

--
-- Indexes for table `marks`
--
ALTER TABLE `marks`
  ADD PRIMARY KEY (`Serial_No`),
  ADD UNIQUE KEY `forign` (`Roll_No`);

--
-- Indexes for table `position`
--
ALTER TABLE `position`
  ADD PRIMARY KEY (`Serial_No`),
  ADD UNIQUE KEY `po` (`Roll_No`);

--
-- Indexes for table `schools`
--
ALTER TABLE `schools`
  ADD PRIMARY KEY (`Id`),
  ADD UNIQUE KEY `Name` (`Name`);

--
-- Indexes for table `school_classes`
--
ALTER TABLE `school_classes`
  ADD PRIMARY KEY (`Id`),
  ADD UNIQUE KEY `unique_index` (`Name`,`School_Id`),
  ADD KEY `school_id` (`School_Id`);

--
-- Indexes for table `setting`
--
ALTER TABLE `setting`
  ADD PRIMARY KEY (`User_Id`),
  ADD KEY `selected_school` (`Selected_School_Id`),
  ADD KEY `selected_class` (`Selected_Class_Id`);

--
-- Indexes for table `students_info`
--
ALTER TABLE `students_info`
  ADD PRIMARY KEY (`Roll_No`),
  ADD UNIQUE KEY `uniqe_adm` (`Admission_No`);

--
-- Indexes for table `subjects`
--
ALTER TABLE `subjects`
  ADD PRIMARY KEY (`Id`),
  ADD UNIQUE KEY `Name` (`Name`);

--
-- Indexes for table `subject_teacher`
--
ALTER TABLE `subject_teacher`
  ADD PRIMARY KEY (`Id`),
  ADD KEY `class_subject` (`Class_Subject_Id`),
  ADD KEY `subject_teacher` (`Teacher_Id`);

--
-- Indexes for table `tab_index`
--
ALTER TABLE `tab_index`
  ADD PRIMARY KEY (`Tab_index_id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `class_subjects`
--
ALTER TABLE `class_subjects`
  MODIFY `Id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=12;

--
-- AUTO_INCREMENT for table `employees`
--
ALTER TABLE `employees`
  MODIFY `Id` int(2) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `exam_committee`
--
ALTER TABLE `exam_committee`
  MODIFY `Id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `login`
--
ALTER TABLE `login`
  MODIFY `Id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `marks`
--
ALTER TABLE `marks`
  MODIFY `Serial_No` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `position`
--
ALTER TABLE `position`
  MODIFY `Serial_No` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=1656;

--
-- AUTO_INCREMENT for table `schools`
--
ALTER TABLE `schools`
  MODIFY `Id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=12;

--
-- AUTO_INCREMENT for table `school_classes`
--
ALTER TABLE `school_classes`
  MODIFY `Id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=28;

--
-- AUTO_INCREMENT for table `subjects`
--
ALTER TABLE `subjects`
  MODIFY `Id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=25;

--
-- AUTO_INCREMENT for table `subject_teacher`
--
ALTER TABLE `subject_teacher`
  MODIFY `Id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT for table `tab_index`
--
ALTER TABLE `tab_index`
  MODIFY `Tab_index_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `class_subjects`
--
ALTER TABLE `class_subjects`
  ADD CONSTRAINT `class_id` FOREIGN KEY (`Class_Id`) REFERENCES `school_classes` (`Id`),
  ADD CONSTRAINT `class_subjects_ibfk_1` FOREIGN KEY (`School_Id`) REFERENCES `schools` (`Id`),
  ADD CONSTRAINT `subject_id` FOREIGN KEY (`Subject_Id`) REFERENCES `subjects` (`Id`);

--
-- Constraints for table `exam_committee`
--
ALTER TABLE `exam_committee`
  ADD CONSTRAINT `member_id` FOREIGN KEY (`member_id`) REFERENCES `employees` (`Id`);

--
-- Constraints for table `login`
--
ALTER TABLE `login`
  ADD CONSTRAINT `emp_id` FOREIGN KEY (`Employee_Id`) REFERENCES `employees` (`Id`);

--
-- Constraints for table `marks`
--
ALTER TABLE `marks`
  ADD CONSTRAINT `forkey` FOREIGN KEY (`Roll_No`) REFERENCES `students_info` (`Roll_No`);

--
-- Constraints for table `school_classes`
--
ALTER TABLE `school_classes`
  ADD CONSTRAINT `school_id` FOREIGN KEY (`School_Id`) REFERENCES `schools` (`Id`);

--
-- Constraints for table `setting`
--
ALTER TABLE `setting`
  ADD CONSTRAINT `selected_class` FOREIGN KEY (`Selected_Class_Id`) REFERENCES `school_classes` (`Id`),
  ADD CONSTRAINT `selected_school` FOREIGN KEY (`Selected_School_Id`) REFERENCES `schools` (`Id`),
  ADD CONSTRAINT `user_id` FOREIGN KEY (`User_Id`) REFERENCES `employees` (`Id`);

--
-- Constraints for table `subject_teacher`
--
ALTER TABLE `subject_teacher`
  ADD CONSTRAINT `class_subject_fk` FOREIGN KEY (`Class_Subject_Id`) REFERENCES `class_subjects` (`Id`),
  ADD CONSTRAINT `teacher_id` FOREIGN KEY (`Teacher_Id`) REFERENCES `employees` (`Id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
