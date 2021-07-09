SELECT *
FROM PortofolioProject.dbo.Sample_Data

--Lokasi manakah yang paling banyak mengalami kemacetan level 5?
SELECT geometry, COUNT(geometry) AS Jumlah_Kemacetan_lv5
FROM PortofolioProject.dbo.Sample_Data
WHERE level = 5
GROUP BY geometry

--Berapa banyak kemacetan level 5 yang terjadi di Kota Bandung dalam sebulan terakhir?
SELECT COUNT(geometry) AS Jumlah_Macet_Bandung
FROM PortofolioProject.dbo.Sample_Data
WHERE level = 5 
AND DATE BETWEEN '01/01/2020' AND '03/01/2020'
ORDER BY COUNT(geometry)

--3 lokasi manakah yang memiliki rata-rata kecepatan terendah dalam satu minggu terakhir pada jam 15-18?
SELECT id, geometry, avg_speed_kmh AS rata_rata_kecepatan, hour
FROM PortofolioProject.dbo.Sample_Data
WHERE DATE BETWEEN '01/01/2020'AND '1/03/2020'
AND hour BETWEEN 15 AND 18
ORDER BY avg_speed_kmh ASC

--Temukan anomali yang terdapat pada tabel sampel data tersebut!--First, find the meanSELECT AVG(hour) AS mean
FROM PortofolioProject.dbo.Sample_Data
--Mean is 7.96666666666667

--Second, find the standard deviation
---finding the deviatian and the variance, deviation is distance
SELECT hour, hour-7.96666666666667 AS distance, SQUARE(hour-7.96666666666667) AS distance_squared
FROM PortofolioProject.dbo.Sample_Data
---sum all the squared value
SELECT SUM(SQUARE(hour-7.96666666666667)) AS sum_of_the_squared
FROM PortofolioProject.dbo.Sample_Data
---then averaged, which is the variance
SELECT SUM(SQUARE(hour-7.96666666666667)) / COUNT(hour) AS variance
FROM PortofolioProject.dbo.Sample_Data
---and the population standard deviation, which is equal to the square root of variance
SELECT SQRT(SUM(SQUARE(hour-7.96666666666667)) / COUNT(hour)) as stdv
FROM PortofolioProject.dbo.Sample_Data

--Third, finding the range
SELECT AVG(hour) - SQRT(SUM(SQUARE(hour-7.96666666666667)) / COUNT(hour)) AS lower_bound,
AVG(hour) + SQRT(SUM(SQUARE(hour-7.96666666666667)) / COUNT(hour)) AS upper_bound
FROM PortofolioProject.dbo.Sample_Data
--Any value above or below the range is considered and ANOMALY
--the lower_bound is 6.40283945256801
--the upper_bound is 9.53049388076532

--Fourth, finding the anomaly
SELECT id, hour, geometry
FROM PortofolioProject.dbo.Sample_Data
GROUP BY id, hour, geometry
HAVING hour < 6.40283945256801
OR hour > 9.53049388076532