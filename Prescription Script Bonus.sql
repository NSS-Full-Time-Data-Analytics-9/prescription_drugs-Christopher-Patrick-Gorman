SELECT COUNT(p.npi)-COUNT(p1.npi)
FROM prescriber AS p
LEFT JOIN prescription AS p1
ON p.npi=p1.npi;
--1.

(SELECT d.generic_name, 
		SUM(p1.total_claim_count), 
		p.specialty_description
FROM prescriber AS p
INNER JOIN prescription AS p1
ON p.npi=p1.npi
INNER JOIN drug AS d
ON p1.drug_name=d.drug_name
WHERE p.specialty_description ILIKE 'family practice'
GROUP BY d.generic_name, p.specialty_description
ORDER BY SUM(p1.total_claim_count) DESC
LIMIT 5)
UNION
(SELECT d.generic_name, 
		SUM(p1.total_claim_count), 
		p.specialty_description
FROM prescriber AS p
INNER JOIN prescription AS p1
ON p.npi=p1.npi
INNER JOIN drug AS d
ON p1.drug_name=d.drug_name
WHERE p.specialty_description ILIKE 'cardiology'
GROUP BY d.generic_name, p.specialty_description
ORDER BY SUM(p1.total_claim_count) DESC
LIMIT 5);
--2a,b,c

(SELECT p.npi, 
		SUM(p1.total_claim_count) AS sum_claim_count, 
		p.nppes_provider_city
FROM prescriber AS p
INNER JOIN prescription AS p1
ON p.npi=p1.npi
WHERE p.nppes_provider_city ILIKE 'nashville'
GROUP BY p.npi, p.nppes_provider_city
ORDER BY SUM(p1.total_claim_count) DESC
LIMIT 5)
UNION
(SELECT p.npi, 
		SUM(p1.total_claim_count) AS sum_claim_count, 
		p.nppes_provider_city
FROM prescriber AS p
INNER JOIN prescription AS p1
ON p.npi=p1.npi
WHERE p.nppes_provider_city ILIKE 'memphis'
GROUP BY p.npi, p.nppes_provider_city
ORDER BY SUM(p1.total_claim_count) DESC
LIMIT 5)
UNION
(SELECT p.npi, 
		SUM(p1.total_claim_count)AS sum_claim_count, 
		p.nppes_provider_city
FROM prescriber AS p
INNER JOIN prescription AS p1
ON p.npi=p1.npi
WHERE p.nppes_provider_city ILIKE 'chattanooga'
GROUP BY p.npi, p.nppes_provider_city
ORDER BY SUM(p1.total_claim_count) DESC
LIMIT 5)
UNION
(SELECT p.npi, 
		SUM(p1.total_claim_count) AS sum_claim_count, 
		p.nppes_provider_city
FROM prescriber AS p
INNER JOIN prescription AS p1
ON p.npi=p1.npi
WHERE p.nppes_provider_city ILIKE 'knoxville'
GROUP BY p.npi, p.nppes_provider_city
ORDER BY SUM(p1.total_claim_count) DESC
LIMIT 5)
ORDER BY sum_claim_count DESC
LIMIT 5;
--3a,b,c

SELECT f.county, o.deaths
FROM overdoses AS o
INNER JOIN fips_county AS f
ON o.fipscounty=f.fipscounty
WHERE o.deaths > (SELECT AVG(deaths)
					FROM overdoses)
GROUP BY f.county, o.deaths
ORDER BY o.deaths DESC;
-- 4.





