comment on table apex_export_user.jobs is
    'jobs table with job titles and salary ranges.
References with employees and job_history table.';

comment on column apex_export_user.jobs.job_id is
    'Primary key of jobs table.';

comment on column apex_export_user.jobs.job_title is
    'A not null column that shows job title, e.g. AD_VP, FI_ACCOUNTANT';

comment on column apex_export_user.jobs.max_salary is
    'Maximum salary for a job title';

comment on column apex_export_user.jobs.min_salary is
    'Minimum salary for a job title.';


-- sqlcl_snapshot {"hash":"2e829720e132532e38ba1938882d0c3f7e760c70","type":"COMMENT","name":"jobs","schemaName":"apex_export_user","sxml":""}