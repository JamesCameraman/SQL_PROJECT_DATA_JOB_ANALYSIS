-- Manipulate job_applied table (create, update, alter, drop)

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
WHERE   job_id = 4;

UPDATE  job_applied
SET     contact = 'Iris Chang'
WHERE   job_id = 5;

ALTER TABLE job_applied
RENAME COLUMN contact TO contact_name;

DROP TABLE job_applied;
