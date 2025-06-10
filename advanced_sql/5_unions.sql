-- UNION across January, February, March jobs

SELECT
    job_title_short,
    company_id,
    job_location
FROM 
    january_jobs

UNION 

SELECT
    job_title_short,
    company_id,
    job_location
FROM 
    february_jobs

UNION

SELECT
    job_title_short,
    company_id,
    job_location
FROM 
    march_jobs;

-- UNION ALL with salary filter

SELECT 
    job_title_short,
    job_location,
    job_via,
    job_posted_date::DATE,
    salary_year_avg
FROM (
SELECT *
FROM january_jobs
UNION ALL
SELECT *
FROM february_jobs
UNION ALL
SELECT * 
FROM march_jobs
) AS q1_jobs
WHERE   salary_year_avg > 70000 AND
        job_title_short = 'Data Analyst'
ORDER BY
    salary_year_avg DESC;
