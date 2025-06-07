CREATE TABLE job_applied (
    job_id INT,
    application_sent_date DATE,
    custom_resume BOOLEAN,
    resume_file_name VARCHAR(255),
    cover_letter_sent BOOLEAN,
    cover_letter_file_name VARCHAR(255),
    status VARCHAR(50)
);

SELECT *
FROM job_applied;


UPDATE  job_applied
SET     contact = 'Igmar Bergman'
WHERE   job_id = 1;

UPDATE  job_applied
SET     contact = 'Oscar Wilde'
WHERE   job_id = 2;

UPDATE  job_applied
SET     contact = 'Hoid'
WHERE   job_id = 3;

UPDATE  job_applied
SET     contact = 'Judge Holden'
WHERE   job_id = 4

UPDATE  job_applied
SET     contact = 'Iris Chang'
WHERE   job_id = 5;

ALTER TABLE job_applied
RENAME COLUMN contact TO contact_name;

DROP TABLE job_applied;

SELECT
    job_title_short AS title,
    job_location AS location,
    job_posted_date::DATE AS date
FROM
    job_postings_fact;

    SELECT
    job_title_short AS title,
    job_location AS location,
    job_posted_date AT TIME ZONE 'UTC' AT TIME ZONE 'EST' AS date_time 
FROM
    job_postings_fact
    LIMIT 5;

SELECT
    job_title_short AS title,
    job_location AS location,
    job_posted_date AT TIME ZONE 'UTC' AT TIME ZONE 'EST' AS date_time,
    EXTRACT(MONTH FROM job_posted_date) AS date_month,
    EXTRACT(YEAR FROM job_posted_date) AS date_year
FROM
    job_postings_fact
    LIMIT 5;

SELECT
    COUNT(job_id) AS job_posted_count,
    EXTRACT(MONTH FROM job_posted_date) AS month
FROM
    job_postings_fact
WHERE
    job_title_short = 'Data Analyst'
GROUP BY
    month
ORDER BY
    1 DESC;

    CREATE TABLE january_jobs AS 
    SELECT * 
    FROM job_postings_fact 
    WHERE EXTRACT(MONTH FROM job_posted_date) = 1;

CREATE TABLE february_jobs AS 
    SELECT * 
    FROM job_postings_fact 
    WHERE EXTRACT(MONTH FROM job_posted_date) = 2;

CREATE TABLE march_jobs AS 
    SELECT * 
    FROM job_postings_fact 
    WHERE EXTRACT(MONTH FROM job_posted_date) = 3;

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

-- Define high, standard, or low salaries to determine which job postings are worth a damn 
-- Data analyst roles only. Order DESC 

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


-- Subqueries 
SELECT *
FROM (
    SELECT *
    FROM job_postings_fact
    WHERE EXTRACT(MONTH FROM job_posted_date) = 1
    ) AS january_jobs;

-- CTE
WITH january_jobs AS (
    SELECT *
    FROM job_postings_fact
    WHERE EXTRACT(MONTH FROM job_posted_date) = 1
)

SELECT *
FROM january_jobs;


-- Query that searches the subquery (company_id IN (stuff)) 
-- before executing the main 

SELECT 
    company_id,
    name AS company_name
FROM 
    company_dim
WHERE 
    company_id IN (
        SELECT 
            company_id
        FROM 
            job_postings_fact
        WHERE job_no_degree_mention = TRUE
        ORDER BY company_id
)

/* 
Find the companies that have the most job openings.
- Get the total number of job postinigs per company id (job_postings_fact)
- Return the total number of jobs with the compan name (company_dim)
*/
WITH company_job_count AS (
SELECT 
   company_id,
   COUNT(*) AS openings
FROM 
    job_postings_fact
GROUP BY company_id
)

SELECT 
    c_dim.name AS company_name,
    job_count.openings,
    job_count.company_id
FROM company_job_count job_count
LEFT JOIN company_dim c_dim ON c_dim.company_id = job_count.company_id
ORDER BY openings DESC

/*
Find the count of the number of remote job postings per skill
- Display the top 5 skills by their demand in remote jobs
- Include skill ID, name, and count of postings required the skill
*/

WITH remote_job_skills AS (
SELECT
    skill_id,
    COUNT(*) AS skill_count
--    job_postings.job_work_from_home (Used to filter remote jobs and check query results)
FROM 
    skills_job_dim AS skills_to_job
INNER JOIN job_postings_fact AS job_postings ON skills_to_job.job_id = job_postings.job_id
WHERE job_postings.job_work_from_home = TRUE AND
    job_title_short = 'Data Analyst'
GROUP BY 
    skill_id
)

SELECT 
    skills.skill_id,
    skills AS skill_name,
    skill_count
FROM remote_job_skills
INNER JOIN skills_dim AS skills ON remote_job_skills.skill_id = skills.skill_id
ORDER BY 3 DESC
LIMIT 5;

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
    march_jobs

    /*
Find job postings from the first quarter that have a salary greater than $70K
- Combine job postings tables from first quarter of 2023 (Jan-Mar)
- Gets job postings with an avg yearl salary > $70,000
*/

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
FROM march_jobs)
AS q1_jobs
WHERE   salary_year_avg > 70000 AND
        job_title_short = 'Data Analyst'
ORDER BY
    salary_year_avg DESC;