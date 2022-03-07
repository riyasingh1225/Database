-- phpMyAdmin SQL Dump
-- version 5.1.1
-- https://www.phpmyadmin.net/
--
-- Host: localhost:3306
-- Generation Time: Nov 30, 2021 at 04:52 PM
-- Server version: 10.4.21-MariaDB
-- PHP Version: 8.0.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `project`
--

DELIMITER $$
--
-- Procedures
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `Age_Update` ()  BEGIN
DECLARE Vn Int;
DECLARE finished INT;
DECLARE cursor_Age CURSOR FOR SELECT Cid FROM customer;
DECLARE CONTINUE HANDLER FOR NOT FOUND SET finished = 1;

OPEN cursor_Age;
update_Age:LOOP
FETCH cursor_Age INTO Vn;
IF finished = 1 THEN
LEAVE update_Age;
END IF;
-- update Payment
update customer set Age = Age_calculation(Vn)
    where Cid=Vn;
               
END LOOP update_Age;

CLOSE cursor_Age;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `Car_in_Inventory` ()  SELECT * from Car C WHERE NOT EXISTS (SELECT * FROM Payment P WHERE P.VinNo = C.VinNo)$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `Car_Make` (IN `Mk` VARCHAR(10))  Select * from Car WHERE Mk=Make$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `Customer_Car_Count` (IN `id` INT)  SELECT Cid, Fname, Lname, COUNT(*) as Cnt FROM Payment NATURAL JOIN Customer WHERE id = Cid$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `Cust_Amount` ()  BEGIN 
DECLARE Vn Int;
DECLARE finished INT;
DECLARE cursor_payment CURSOR FOR SELECT VinNo FROM Payment;
DECLARE CONTINUE HANDLER FOR NOT FOUND SET finished = 1;

OPEN cursor_payment;
update_Amount:LOOP
	FETCH cursor_payment INTO Vn;
	IF finished = 1 THEN 
		LEAVE update_Amount;
	END IF;
	-- update Payment
	update Payment set Amount = Total_Price(Vn) 
    			where VinNo=Vn;
                
END LOOP update_Amount;

CLOSE cursor_payment;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `Max_Car_Sale_Date` ()  SELECT PayDate, maxcnt from 
(select max(T.cnt) as maxcnt from 
     (select PayDate, count(*) as cnt from Payment group by PayDate)as T) as A  
inner join 
(select PayDate, count(*) as cnt from Payment group by PayDate) as B 
     on A.maxcnt = B.cnt$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `Servicing_Date` (IN `id` INT)  SELECT Cid, Fname, Lname , DateRec, VinNo from Service natural join Payment natural join Customer where 
id = Cid$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `Total_Inv` ()  SELECT count(*) from Car C WHERE NOT EXISTS (SELECT * FROM Payment P WHERE P.VinNo = C.VinNo)$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `Vin_Inventory` ()  SELECT C.VinNo from Car C WHERE NOT EXISTS (SELECT * FROM Payment P WHERE P.VinNo = C.VinNo)$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `Vin_No` ()  SELECT C.VinNo from Car C WHERE NOT EXISTS (SELECT * FROM Payment P WHERE P.VinNo = C.VinNo)$$

--
-- Functions
--
CREATE DEFINER=`root`@`localhost` FUNCTION `Age_calculation` (`Cusid` INT) RETURNS INT(11) BEGIN
DECLARE Age INT;
SELECT TIMESTAMPDIFF(YEAR,Dob,CURDATE()) INTO Age
       FROM customer where Cusid = Cid;
RETURN Age;
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `Cus_Totprice` (`id` INT) RETURNS INT(11) BEGIN
DECLARE Tot INT;
SELECT sum(Amount) INTO Tot FROM Payment WHERE id=Cid;

if Tot is null THEN
  set Tot = 0;
end if;

RETURN Tot;
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `Service_Count` (`id` INT) RETURNS INT(11) BEGIN
DECLARE x int;
SELECT Count(*) INTO x FROM Service WHERE id=Cid;
RETURN x;
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `Total_Price` (`VinN` INT) RETURNS INT(11) BEGIN
DECLARE VN INT;
SELECT sum(price) INTO VN FROM Car WHERE VinN=VinNO;

if VN is null THEN
  set VN = 0;
end if;

RETURN VN;
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `Total_Type_Car` (`ctype` VARCHAR(20)) RETURNS INT(11) BEGIN
DECLARE x INT;
SELECT COUNT(*) into x from Car WHERE Car_Type=ctype;
RETURN x;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `admin`
--

CREATE TABLE `admin` (
  `Aid` int(11) NOT NULL,
  `Uname` varchar(50) NOT NULL,
  `Password` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `admin`
--

INSERT INTO `admin` (`Aid`, `Uname`, `Password`) VALUES
(1, 'Riya', '1234'),
(2, 'Charmi', '1234'),
(3, 'Shweta', '1234'),
(4, 'Archana', '1234'),
(10, 'Dhruv', '1234'),
(11, 'Josh', '1234'),
(12, 'Joe', '1234');

-- --------------------------------------------------------

--
-- Table structure for table `car`
--

CREATE TABLE `car` (
  `Aid` int(11) NOT NULL,
  `VinNo` int(11) NOT NULL,
  `Engine` varchar(50) NOT NULL,
  `Make` varchar(10) NOT NULL,
  `Model` varchar(100) NOT NULL,
  `Trim` varchar(15) NOT NULL,
  `Year` varchar(10) NOT NULL,
  `ExtColor` varchar(10) NOT NULL,
  `IntColor` varchar(10) NOT NULL,
  `Price` int(11) NOT NULL,
  `Car_Type` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `car`
--

INSERT INTO `car` (`Aid`, `VinNo`, `Engine`, `Make`, `Model`, `Trim`, `Year`, `ExtColor`, `IntColor`, `Price`, `Car_Type`) VALUES
(1, 120009, '2.0 L', 'Chrysler', '200', 'Limited', '2012', 'Whie', 'Black', 17000, 'Old'),
(2, 120010, '2.0L', 'Chrysler', '200', 'Limited', '2012', 'Black', 'Grey', 18500, 'Old'),
(2, 120011, '3.6L', 'Chrysler', '200', 'Sports', '2013', 'Red', 'Black', 15000, 'Old'),
(2, 120012, '2.4L', 'Toyota', 'Camry', 'SE', '2010', 'Black', 'Black', 7000, 'Old'),
(1, 120013, '3.6L', 'Toyota', 'Avalon', 'XLE', '2013', 'White', 'Grey', 12500, 'Old'),
(1, 120014, '3.6L', 'Chrysler', 'Pacifica', 'Sports', '2018', 'Black', 'Grey', 22500, 'Old'),
(1, 120015, '3.6L', 'Jeep', 'Wrangler', 'Sahara', '2017', 'Red', 'Black', 14700, 'Old'),
(1, 120016, '2.0L', 'Jeep', 'Cherokee', 'Limited', '2019', 'Silver', 'Black', 21000, 'Old'),
(2, 120017, '3.0L DS', 'Jeep', 'Wrangler', 'Rubicon', '2020', 'Red', 'Black', 31500, 'Old'),
(1, 120018, '5.7L', 'Jeep', 'Cherokee', 'Limited', '2016', 'Black', 'Grey', 17600, 'Old'),
(1, 120019, '5.7 L', 'Jeep', 'Cherokee', 'Limited', '2017', 'black', 'White', 9000, 'Old'),
(2, 120021, '5.7 L', 'Jeep', 'Compass', 'Limited', '2021', 'black', 'Black', 28999, 'New'),
(2, 120030, '5.7L', 'Jeep', 'Cherokee', 'Limited', '2018', 'Red', 'Red', 31999, 'New'),
(2, 120031, '5.7L', 'Jeep', 'Cherokee', 'Limited', '2018', 'Black', 'Black', 17999, 'Old'),
(10, 120032, '5.7L', 'Jeep', 'Cherokee', 'Limited', '2021', 'Black', 'Black', 31999, 'New'),
(3, 120040, '3.2 L', 'Chrysler', '200', 'Limited', '2015', 'Black', 'Beige', 15000, 'Old'),
(3, 120041, '2.4 L', 'Chrysler ', '200', 'Sports', '2017', 'Silver', 'Black', 17000, 'Old'),
(3, 120042, '2.4 L', 'Dodge', 'Avenger', 'SXT', '2015', 'Grey', 'Black', 15000, 'Old'),
(3, 120043, '3.6 L', 'Chrysler', 'Pacifica', 'Limited', '2021', 'White', 'Black', 35000, 'New'),
(4, 120044, '5.7 L', 'RAM', '1500', 'Long Horn', '2018', 'Black', 'Black', 32000, 'Old'),
(2, 120045, '3.6 L', 'RAM', '1500', 'Tradesman', '2019', 'Black', 'Black', 31000, 'Old'),
(1, 130021, '3.6L', 'Jeep', 'Wagoneer', 'Series 2', '2021', 'Velvet Red', 'Black', 65000, 'New'),
(1, 130022, '2.0L', 'Jeep', 'Grand Cherokee L', 'Limited', '2021', 'White', 'Red', 45000, 'New'),
(2, 130024, '3.6l', 'Jeep', 'Gladiator', 'Mojave', '2021', 'Black', 'Red', 65000, 'New'),
(1, 130025, '6.4L', 'RAM', '2500', 'Rebel', '2021', 'Blue', 'Black', 60000, 'New'),
(1, 130095, '5.7L', 'RAM', '1500', 'Limited', '2022', 'Black', 'Beige', 49220, 'New'),
(2, 130096, '3.6L', 'RAM', '1500', 'Long Horn', '2021', 'Red', 'Grey', 45000, 'New'),
(2, 130097, '3.0L DS', 'RAM', '1500', 'Laramie', '2022', 'White', 'Beige', 55000, 'New'),
(2, 130098, '6.4L', 'RAM', '2500', 'Rebel', '2021', 'Blue', 'Black', 40000, 'New'),
(1, 130099, '6.7L DS', 'RAM', '2500', 'Power Wagon', '2022', 'White', 'Black', 50000, 'New'),
(3, 140009, '6.2 L', 'Dodge', 'Charger', 'SXT AWD', '2021', 'Blue', 'Black', 63000, 'New'),
(2, 140010, '6.2L', 'Dodge', 'Charger', 'Scat Pack', '2022', 'Yellow', 'Black', 60000, 'New'),
(1, 140011, '3.6L', 'Dodge', 'Charger', 'SXT AWD', '2021', 'Orange', 'Black', 62000, 'New'),
(1, 140015, '2.4L', 'Jeep', 'Compass', 'Limited', '2022', 'Black', 'Beige', 57900, 'New'),
(2, 140017, '2.4L', 'Jeep', 'Compass', 'High Altitude', '2021', 'White', 'Black', 49000, 'New'),
(1, 140020, '2.4L', 'Jeep', 'Compass', 'Altitude', '2021', 'Red', 'Black', 39000, 'New'),
(2, 140021, '2.4L', 'Jeep', 'Compass', 'Altitude', '2022', 'White', 'Black', 44000, 'New'),
(11, 140098, '6.2 L', 'Dodge', 'Charger', 'Scat Pack', '2021', 'Black', 'White', 62000, 'New'),
(2, 150001, '3.6 L', 'Jeep', 'Wrangler', 'Rubicon', '2022', 'Red', 'Black', 50000, 'New'),
(2, 150002, '6.4 L', 'Jeep', 'Grand Cherokee', 'Track Hawk', '2021', 'Red', 'Black', 75000, 'New'),
(3, 150003, '6.2 L', 'Dodge', 'Charger', 'Hell Cat', '2021', 'Blue', 'Black', 80000, 'New'),
(3, 150004, '2.0 L', 'Jeep', 'Wrangler', 'Sahara', '2021', 'Grey', 'Black', 40000, 'New'),
(3, 150005, '2.0 L Diesel', 'Jeep', 'Compass', 'Limited', '2021', 'Black', 'Beige', 30000, 'New'),
(10, 150006, '2.4 L', 'Jeep', 'Renegade', 'Sports', '2021', 'Black', 'Beige', 25000, 'New'),
(3, 150007, '3.6 L', 'Chrysler', '300', 'S AWD', '2021', 'Red', 'Black', 35000, 'New'),
(4, 150008, '3.0 L Diesel', 'Jeep', 'Gladiator', 'Rubicon', '2021', 'Black', 'Black', 50000, 'New'),
(4, 150009, '5.7L', 'Jeep', 'Cherokee', 'Limited', '2021', 'Black', 'Black', 49000, 'New'),
(1, 150010, '5.7L', 'Jeep', 'Cherokee', 'Rubicon', '2021', 'Black', 'Black', 51000, 'New'),
(1, 572978, '3.6L', 'Chrysler', 'Pacifica', 'Hybrid Limited', '2021', 'Blue', 'Black', 50555, 'New'),
(2, 634005, '6.4L', 'Dodge', 'Charger', 'R/T AWD', '2021', 'Red', 'Black', 53600, 'New');

-- --------------------------------------------------------

--
-- Table structure for table `customer`
--

CREATE TABLE `customer` (
  `Cid` int(11) NOT NULL,
  `Fname` varchar(50) NOT NULL,
  `Lname` varchar(50) NOT NULL,
  `Address` varchar(100) NOT NULL,
  `City` varchar(100) NOT NULL,
  `State` varchar(100) NOT NULL,
  `DrNo` varchar(15) NOT NULL,
  `Dob` date NOT NULL,
  `Total_Amount` int(11) DEFAULT NULL,
  `Age` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `customer`
--

INSERT INTO `customer` (`Cid`, `Fname`, `Lname`, `Address`, `City`, `State`, `DrNo`, `Dob`, `Total_Amount`, `Age`) VALUES
(1, 'Denis', 'Hoffman', '4468, abc drive', 'Clarkston', 'Michigan', 'S00999765431', '2001-11-07', 52700, 20),
(2, 'Lee', 'Higgins', '3456, xyzzy Dr', 'Rochester Hills', 'Michigan', 'S00999765432', '1999-08-02', 0, 22),
(5, 'Smita', 'Patel', '456, Doogwood,', 'Clarkston', 'Michigan', 'S00999765433', '2002-11-16', 73055, 19),
(6, 'Josh', 'Patel', '9976, Brooke Field', 'Rochester Hills', 'Michigan', 'S00999765434', '2002-11-03', 62500, 19),
(7, 'Sagar', 'Shah', '5467 DogWood dr', 'Clarkston', 'Michigan', 'S00999765435', '2002-08-05', 15000, 19),
(8, 'Dhruv', 'Patel', '4458 Cedar brook Dr', 'Rochester Hills', 'Michigan', 'S00999765436', '1987-06-13', 84000, 34),
(9, 'John', 'Pash', '3456 S Adams Creek', 'Auburn Hills', 'Michigan', 'S00999765437', '1989-11-01', 55000, 32),
(18, 'Harsh', 'Patel', '44572 Croock dr', 'Rochester Hills', 'Michigan', 'S00999765437', '1989-09-16', 7000, 32);

-- --------------------------------------------------------

--
-- Table structure for table `payment`
--

CREATE TABLE `payment` (
  `RecId` int(11) NOT NULL,
  `Aid` int(11) NOT NULL,
  `Cid` int(11) NOT NULL,
  `VinNo` int(11) NOT NULL,
  `PayDate` date NOT NULL,
  `Amount` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `payment`
--

INSERT INTO `payment` (`RecId`, `Aid`, `Cid`, `VinNo`, `PayDate`, `Amount`) VALUES
(8, 2, 6, 130099, '2021-10-09', 50000),
(10, 2, 8, 140020, '2021-09-13', 39000),
(11, 2, 9, 130097, '2021-11-01', 55000),
(12, 2, 8, 130022, '2021-03-08', 45000),
(16, 1, 5, 572978, '2021-10-01', 50555),
(17, 4, 7, 120011, '2021-06-06', 15000),
(18, 2, 18, 120012, '2021-06-06', 7000),
(19, 2, 6, 120013, '2021-12-06', 12500),
(21, 2, 5, 120014, '2021-12-15', 22500),
(25, 1, 1, 120009, '2021-12-09', 17000),
(26, 1, 1, 120016, '2021-06-06', 21000),
(27, 1, 1, 120015, '2021-12-06', 14700);

--
-- Triggers `payment`
--
DELIMITER $$
CREATE TRIGGER `ad_customer` AFTER DELETE ON `payment` FOR EACH ROW BEGIN
   DECLARE creds INT;
   select Cus_Totprice (old.Cid) into creds; 
   update Customer set Total_Amount = creds WHERE
          Cid = old.Cid;
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `ai_customer` AFTER INSERT ON `payment` FOR EACH ROW BEGIN
   DECLARE creds INT;
   
   select Cus_Totprice (new.Cid) into creds; 
   update Customer set Total_Amount = creds WHERE
          Cid = new.Cid;
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `au_customer` AFTER UPDATE ON `payment` FOR EACH ROW BEGIN
  DECLARE creds INT;
  select Cus_Totprice(old.Cid) into creds;
  update Customer set Total_Amount = creds where Cid = old.Cid;
  select Cus_Totprice(new.Cid) into creds;
  update Customer set Total_Amount = creds where Cid = new.Cid;
  
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `service`
--

CREATE TABLE `service` (
  `ServId` int(11) NOT NULL,
  `Aid` int(11) NOT NULL,
  `Cid` int(11) NOT NULL,
  `VinNo` int(11) NOT NULL,
  `DateRec` date NOT NULL,
  `Comment` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `service`
--

INSERT INTO `service` (`ServId`, `Aid`, `Cid`, `VinNo`, `DateRec`, `Comment`) VALUES
(5, 1, 8, 130022, '2021-09-01', 'Next Service after 2 months'),
(6, 1, 1, 120015, '2021-11-09', 'Next service after 2000 Mile');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `admin`
--
ALTER TABLE `admin`
  ADD PRIMARY KEY (`Aid`),
  ADD KEY `Aid` (`Aid`);

--
-- Indexes for table `car`
--
ALTER TABLE `car`
  ADD PRIMARY KEY (`VinNo`),
  ADD UNIQUE KEY `VinNo_2` (`VinNo`),
  ADD KEY `VinNo` (`VinNo`),
  ADD KEY `Aid` (`Aid`);

--
-- Indexes for table `customer`
--
ALTER TABLE `customer`
  ADD PRIMARY KEY (`Cid`),
  ADD KEY `Cid` (`Cid`);

--
-- Indexes for table `payment`
--
ALTER TABLE `payment`
  ADD PRIMARY KEY (`RecId`),
  ADD KEY `Cid` (`Cid`),
  ADD KEY `aid` (`Aid`),
  ADD KEY `payment_ibfk_5` (`VinNo`);

--
-- Indexes for table `service`
--
ALTER TABLE `service`
  ADD PRIMARY KEY (`ServId`),
  ADD KEY `Aid` (`Aid`),
  ADD KEY `Cid` (`Cid`),
  ADD KEY `VinNo` (`VinNo`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `admin`
--
ALTER TABLE `admin`
  MODIFY `Aid` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- AUTO_INCREMENT for table `customer`
--
ALTER TABLE `customer`
  MODIFY `Cid` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=21;

--
-- AUTO_INCREMENT for table `payment`
--
ALTER TABLE `payment`
  MODIFY `RecId` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=28;

--
-- AUTO_INCREMENT for table `service`
--
ALTER TABLE `service`
  MODIFY `ServId` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `car`
--
ALTER TABLE `car`
  ADD CONSTRAINT `car_ibfk_1` FOREIGN KEY (`Aid`) REFERENCES `admin` (`Aid`);

--
-- Constraints for table `payment`
--
ALTER TABLE `payment`
  ADD CONSTRAINT `payment_ibfk_1` FOREIGN KEY (`Cid`) REFERENCES `customer` (`Cid`),
  ADD CONSTRAINT `payment_ibfk_4` FOREIGN KEY (`Aid`) REFERENCES `admin` (`Aid`),
  ADD CONSTRAINT `payment_ibfk_5` FOREIGN KEY (`VinNo`) REFERENCES `car` (`VinNo`);

--
-- Constraints for table `service`
--
ALTER TABLE `service`
  ADD CONSTRAINT `service_ibfk_1` FOREIGN KEY (`Aid`) REFERENCES `admin` (`Aid`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `service_ibfk_2` FOREIGN KEY (`Cid`) REFERENCES `customer` (`Cid`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `service_ibfk_3` FOREIGN KEY (`VinNo`) REFERENCES `payment` (`VinNo`) ON DELETE CASCADE ON UPDATE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
