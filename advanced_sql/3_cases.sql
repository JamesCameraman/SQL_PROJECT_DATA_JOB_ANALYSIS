-- Categorize locations using CASE

SELECT
    COUNT(job_id) AS number_of_jobs,
    CASE
        WHEN job_location = 'Anywhere' THEN 'Remote'
        WHEN job_location = 'New York, NY' THEN 'Local'
        ELSE 'Onsite'
    END AS location_category
FROM
    job_postings_fact
WHERE job_title_short = 'Data Analyst'
GROUP BY
    location_category;

-- Define high, standard, or low salaries using CASE

SELECT 
    job_title_short AS jobs,
    job_location AS location,
    salary_year_avg AS salary,
    CASE
        WHEN salary_year_avg <= 65000 THEN 'low'
        WHEN salary_year_avg BETWEEN 65001 AND 90000 THEN 'standard'
        WHEN salary_year_avg > 90000 THEN 'high'
        ELSE 'N/A'
    END AS salary_level
FROM
    job_postings_fact
WHERE
     job_title_short LIKE '%Data Analyst%'
     AND salary_year_avg IS NOT NULL 
ORDER BY 
    salary_year_avg DESC;
