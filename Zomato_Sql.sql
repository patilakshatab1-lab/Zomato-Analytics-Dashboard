use zomato_sql_tableau;
select count(*) from zomato;

CREATE TABLE zomato (
RestaurantID BIGINT,
RestaurantName VARCHAR(255),
CountryCode INT,
City VARCHAR(100),
Address TEXT,
Locatlity varchar(100),
Localityverbose varchar(100),
Longitude INT,
Latitude INT,
Cuisines varchar(100),
Currency varchar(100),
Has_Table_booking varchar(5),
Has_Online_delivary varchar(5),
Is_delivering_now varchar(5),
Switch_to_order_menu varchar(5),
Price_range int,
Votes int,
Average_Cost_for_two int,
Rating varchar(5),
Year_Opening int,
Month_Opening int,
Day_Opening int	
);

LOAD DATA LOCAL INFILE 'E:/Projects of Excler/Zomato/ZOMATO ANALYTICS/SQL_Tableau/zomato_sql_proj.csv'
INTO TABLE zomato
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

select count(*) from zomato;

create table country(CountryID int,CountryName varchar(50));
alter table country rename column CountryID to CountryCode;
LOAD DATA LOCAL INFILE 'E:/Projects of Excler/Zomato/ZOMATO ANALYTICS/SQL_Tableau/zomato_country.csv'
INTO TABLE country
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

drop table country;
CREATE TABLE currency (
Country VARCHAR(50),
Currency VARCHAR(50),
USD_Rate DECIMAL(10,6)
);

INSERT INTO currency (Country, Currency, USD_Rate) VALUES
('India','Indian Rupees(Rs.)',0.012),
('United States','Dollar($)',1),
('United Kingdom','Pounds(£)',1.24),
('New Zealand','NewZealand($)',0.6),
('United Arab Emirates','Emirati Dirham(AED)',0.27),
('Brazil','Brazilian Real(R$)',0.2),
('Turkey','Turkish Lira(TL)',0.05),
('Qatar','Qatari Rial(QR)',0.27),
('South Africa','Rand(R)',0.051),
('Botswana','Botswana Pula(P)',0.073),
('Sri Lanka','Sri Lankan Rupee(LKR)',0.0034),
('Indonesia','Indonesian Rupiah(IDR)',0.000067);

LOAD DATA LOCAL INFILE 'E:/Projects of Excler/Zomato/ZOMATO ANALYTICS/SQL_Tableau/zomato_currency.csv'
INTO TABLE currency
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

select count(*) from currency;
select count(*) from country;
select count(*) from zomato;

select * from currency;
select * from country;
select * from zomato;

DELETE FROM country
WHERE CountryID = 0;

select z.*,c.CountryName 
from zomato z 
join Country c
on z.CountryCode=c.CountryCode;

DESCRIBE currency;

SELECT z.*, c.CountryName, cu.Currency, cu.USD_Rate
FROM zomato z
JOIN country c
ON z.CountryCode = c.CountryCode
JOIN currency cu
ON c.CountryName = cu.Country;

SELECT 
z.RestaurantName,
c.CountryName,
cu.Currency,
z.Average_Cost_for_two,
cu.USD_Rate,
z.Average_Cost_for_two * cu.USD_Rate AS Cost_USD
FROM zomato z
JOIN country c
ON z.CountryCode = c.CountryCode
JOIN currency cu
ON c.CountryName = cu.Country;

select * from zomato;

ALTER TABLE currency
ADD Country VARCHAR(50);
DESCRIBE currency;

UPDATE currency SET Country='India' WHERE Currency='Indian Rupees(Rs.)';
UPDATE currency SET Country='United States' WHERE Currency='Dollar($)';
UPDATE currency SET Country='United Kingdom' WHERE Currency='Pounds(£)';
UPDATE currency SET Country='Brazil' WHERE Currency='Brazilian Real(R$)';
UPDATE currency SET Country='Turkey' WHERE Currency='Turkish Lira(TL)';
UPDATE currency SET Country='Qatar' WHERE Currency='Qatari Rial(QR)';
UPDATE currency SET Country='South Africa' WHERE Currency='Rand(R)';
UPDATE currency SET Country='Sri Lanka' WHERE Currency='Sri Lankan Rupee(LKR)';
UPDATE currency SET Country='Indonesia' WHERE Currency='Indonesian Rupiah(IDR)';

##############

CREATE TABLE Country (
    CountryID INT PRIMARY KEY,
    CountryName VARCHAR(50),
    CountryCode VARCHAR(5)
);

INSERT INTO Country VALUES
(1,'India','IN'),
(14,'Australia','AU'),
(30,'Brazil','BR'),
(37,'Canada','CA'),
(94,'Indonesia','ID'),
(148,'New Zealand','NZ'),
(162,'Philippines','PH'),
(166,'Qatar','QA'),
(184,'Singapore','SG'),
(189,'South Africa','ZA'),
(191,'Sri Lanka','LK'),
(208,'Turkey','TR'),
(214,'United Arab Emirates','AE'),
(215,'United Kingdom','UK'),
(216,'United States','US');

drop table Currency;
CREATE TABLE Currency (
    CountryCode VARCHAR(5),
    Currency VARCHAR(50)
);

INSERT INTO Currency VALUES
('IN','Indian Rupees(Rs.)'),
('AU','Australian Dollar(AUD)'),
('BR','Brazilian Real(R$)'),
('CA','Canadian Dollar(CAD)'),
('ID','Indonesian Rupiah(IDR)'),
('NZ','New Zealand Dollar(NZD)'),
('PH','Philippine Peso(PHP)'),
('QA','Qatari Rial(QR)'),
('SG','Singapore Dollar(SGD)'),
('ZA','Rand(R)'),
('LK','Sri Lankan Rupee(LKR)'),
('TR','Turkish Lira(TL)'),
('AE','Emirati Dirham(AED)'),
('UK','Pounds(£)'),
('US','Dollar($)');

SELECT 
c.CountryName,
cu.Currency
FROM Country c
JOIN Currency cu
ON c.CountryCode = cu.CountryCode;

SELECT 
z.RestaurantName,
c.CountryName
FROM zomato z
JOIN Country c
ON z.CountryCode = c.CountryCode;

SELECT  
z.RestaurantName,  
cu.Currency  
FROM zomato z  
JOIN Currency cu  
ON z.Currency = cu.Currency;


SELECT DISTINCT Currency
FROM zomato;

SELECT DISTINCT Currency
FROM Currency;

SELECT 
z.RestaurantName,
c.CountryName
FROM zomato z
JOIN Country c
ON z.CountryCode = c.CountryID;



select * from zomato;

### Calendar Table
SELECT 
RestaurantID,
RestaurantName,
Year_Opening,
Month_Opening,
Day_Opening,
STR_TO_DATE(CONCAT(Year_Opening,'-',Month_Opening,'-',Day_Opening),'%Y-%m-%d') AS OpeningDate
FROM zomato
LIMIT 10;

ALTER TABLE zomato
ADD OpeningDate DATE;

UPDATE zomato
SET OpeningDate = STR_TO_DATE(CONCAT(Year_Opening,'-',Month_Opening,'-',Day_Opening),'%Y-%m-%d');

CREATE TABLE calendar AS
SELECT DISTINCT OpeningDate AS DateKey
FROM zomato;

ALTER TABLE calendar
ADD Year INT,
ADD MonthNo INT,
ADD MonthFullName VARCHAR(20),
ADD Quarter VARCHAR(2),
ADD YearMonth VARCHAR(10),
ADD WeekdayNo INT,
ADD WeekdayName VARCHAR(20);

UPDATE calendar
SET 
Year = YEAR(DateKey),
MonthNo = MONTH(DateKey),
MonthFullName = MONTHNAME(DateKey),
Quarter = CONCAT('Q',QUARTER(DateKey)),
YearMonth = DATE_FORMAT(DateKey,'%Y-%b'),
WeekdayNo = WEEKDAY(DateKey)+1,
WeekdayName = DAYNAME(DateKey);

SELECT * 
FROM calendar
LIMIT 10;


SELECT 
z.*,
c.CountryName,
cu.Currency,
cal.Year,
cal.MonthNo,
cal.MonthFullName,
cal.Quarter
FROM zomato z
LEFT JOIN country c
ON z.CountryCode = c.CountryID
LEFT JOIN currency cu
ON c.CountryCode = cu.CountryCode
LEFT JOIN calendar cal
ON z.OpeningDate = cal.DateKey;

SELECT z.CountryCode, c.CountryName
FROM zomato z
LEFT JOIN country c
ON z.CountryCode = c.CountryID
LIMIT 20;

CREATE TABLE zomato_final AS
SELECT 
z.*,
c.CountryName,
cu.Currency AS CountryCurrency,
cal.Year,
cal.MonthNo,
cal.MonthFullName,
cal.Quarter
FROM zomato z
LEFT JOIN country c
ON z.CountryCode = c.CountryID
LEFT JOIN currency cu
ON c.CountryCode = cu.CountryCode
LEFT JOIN calendar cal
ON z.OpeningDate = cal.DateKey;

SELECT * FROM zomato_final;

SELECT DISTINCT CountryCode 
FROM zomato;


SELECT DISTINCT CountryCode FROM country;
SELECT DISTINCT CountryCode FROM currency;

select * from currency;
select * from country;

### KPI's
# 1.Total Restaurants 
SELECT COUNT(RestaurantID) AS Total_Restaurants
FROM zomato;

# 2. Total Countries
 select count(distinct CountryCode) as Total_Countries
 from zomato;
 
 # 3. Average Rating
 select Avg(Rating) as Average_Rating
 from zomato;
 
 # 4. Average cost for two
 select avg(Average_Cost_for_two) as Average_Cost_For_Two
 from zomato;
 
 # 5. Restaurants with Online Delivery
SELECT COUNT(*) 
FROM zomato
WHERE Has_Online_delivary = 'Yes';

select * from zomato;

select Rating from zomato;