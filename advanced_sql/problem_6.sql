/*
Find the companies that have the most job openings.
- Get the total number of job postings per company id (job_postings_fact)
- Return the total number of jobs with the company name (company_dim)
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
ORDER BY openings DESC;
