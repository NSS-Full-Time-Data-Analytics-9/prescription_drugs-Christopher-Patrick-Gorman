SELECT DISTINCT npi, SUM(total_claim_count)
FROM prescription
GROUP BY DISTINCT npi
ORDER BY SUM(total_claim_count) DESC;
-- 1a: 1881634483

SELECT DISTINCT p1.npi,
		p1.total_claim_count, 
		p2.nppes_provider_first_name, 
		p2.nppes_provider_last_org_name,
		p2.specialty_description
FROM prescription AS p1
INNER JOIN prescriber AS p2
ON p1.npi=p2.npi;
--1b

SELECT SUM(p1.total_claim_count), p2.specialty_description
FROM prescription AS p1
INNER JOIN prescriber AS p2
ON p1.npi=p2.npi
GROUP BY p2.specialty_description
ORDER BY SUM(p1.total_claim_count) DESC;
-- 2a. Family Practice

SELECT SUM(p1.total_claim_count), p2.specialty_description 
FROM prescription AS p1
INNER JOIN prescriber AS p2
ON p1.npi=p2.npi
INNER JOIN drug AS d
ON p1.drug_name=d.drug_name
WHERE d.opioid_drug_flag = 'Y'
GROUP BY p2.specialty_description
ORDER BY SUM(p1.total_claim_count)DESC;
--2b. Nurse Practitioner

SELECT DISTINCT p1.specialty_description, SUM(p2.total_claim_count)
FROM prescriber AS p1
LEFT JOIN prescription AS p2
ON p1.npi=p2.npi
GROUP BY p1.specialty_description
ORDER BY SUM(p2.total_claim_count)DESC
LIMIT 15;
--2c.

WITH opioid_count AS(SELECT SUM(p1.total_claim_count) AS opioid_claim, 
					p.specialty_description
					FROM prescriber AS p
					INNER JOIN prescription AS p1
					ON p.npi=p1.npi
					INNER JOIN drug AS d
					ON p1.drug_name=d.drug_name
					WHERE d.opioid_drug_flag = 'Y'
					GROUP BY p.specialty_description)
SELECT p.specialty_description, 
		opioid_claim, 
		SUM(p1.total_claim_count),
		ROUND((opioid_claim/SUM(p1.total_claim_count))*100,2) AS percent_opioid_claim
FROM prescriber AS p
INNER JOIN prescription AS p1
ON p.npi=p1.npi
INNER JOIN drug AS d
ON p1.drug_name=d.drug_name
INNER JOIN opioid_count
USING (specialty_description)
GROUP BY p.specialty_description, opioid_claim
ORDER BY percent_opioid_claim DESC;
--2d.

SELECT d.generic_name, (SUM(p.total_drug_cost))::MONEY
FROM drug AS d
INNER JOIN prescription AS p
ON d.drug_name=p.drug_name
GROUP BY d.generic_name
ORDER BY SUM(p.total_drug_cost) DESC;
-- 3a. Insulin

SELECT d.generic_name, 
		(SUM(total_drug_cost)/SUM(total_day_supply))::MONEY AS cost_per_day
FROM drug AS d
INNER JOIN prescription AS p
ON d.drug_name=p.drug_name
GROUP BY d.generic_name
ORDER BY cost_per_day DESC;
--3b. C1 Esterase Inhibitor

SELECT (SUM(p.total_drug_cost))::MONEY,
		CASE WHEN opioid_drug_flag = 'Y' THEN 'opioid'
		WHEN antibiotic_drug_flag = 'Y' THEN 'antibiotic'
		ELSE 'neither' END AS drug_type
FROM drug AS d
INNER JOIN prescription AS p
ON p.drug_name=d.drug_name
GROUP BY drug_type
ORDER BY SUM(p.total_drug_cost) DESC;
--4a,b. Opioids

SELECT DISTINCT cbsa,cbsaname
FROM cbsa
WHERE cbsaname LIKE '%TN%';
--5a. 10

SELECT c.cbsa, c.cbsaname, SUM(p.population)
FROM cbsa AS c
INNER JOIN population AS p
ON c.fipscounty= p.fipscounty
GROUP BY c.cbsa, c.cbsaname
ORDER BY SUM(p.population) DESC;
-- Nashville_Davidson_Murfreesboro-Franklin,TN 1830410

SELECT non_cbsa.fipscounty, p.population, f.county
FROM(SELECT fipscounty
	FROM population
	EXCEPT
	SELECT fipscounty
	FROM cbsa) AS non_cbsa
INNER JOIN population AS p
ON non_cbsa.fipscounty=p.fipscounty
INNER JOIN fips_county AS f
ON f.fipscounty=p.fipscounty
ORDER BY p.population DESC;
-- 5c. Sevier

SELECT p.total_claim_count,
		d.drug_name,
		d.opioid_drug_flag,
		p1.nppes_provider_last_org_name,
		p1.nppes_provider_first_name
FROM prescription AS p
INNER JOIN drug AS d
ON d.drug_name=p.drug_name
INNER JOIN prescriber AS p1
ON p.npi=p1.npi
WHERE total_claim_count >=3000;
--6a,b,c.

SELECT DISTINCT p.npi,
		d.drug_name,
		COALESCE(SUM(p1.total_claim_count),0)
FROM prescriber AS p
CROSS JOIN drug AS d
LEFT JOIN prescription AS p1
ON p.npi=p1.npi 
	AND d.drug_name=p1.drug_name
WHERE p.specialty_description ILIKE 'Pain Management'
	AND p.nppes_provider_city ILIKE '%nashville%'
	AND d.opioid_drug_flag = 'Y'
GROUP BY d.drug_name, p.npi
ORDER BY COALESCE DESC;
--7a,b,c








