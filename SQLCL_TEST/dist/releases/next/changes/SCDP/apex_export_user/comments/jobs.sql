-- liquibase formatted sql
-- changeset apex_export_user:1774559729137 stripComments:false logicalFilePath:SCDP/apex_export_user/comments/jobs.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot SQLCL_TEST/src/database/apex_export_user/comments/jobs.sql:null:93dbbb12bebbfd1043b688c1efb7516be9fe606c:create

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

