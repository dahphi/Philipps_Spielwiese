create or replace force editionable view apex_export_user.emp_details_view (
    employee_id,
    job_id,
    manager_id,
    department_id,
    location_id,
    country_id,
    first_name,
    last_name,
    salary,
    commission_pct,
    department_name,
    job_title,
    city,
    state_province,
    country_name,
    region_name,
    philipp_test
) as
    select
        e.employee_id,
        e.job_id,
        e.manager_id,
        e.department_id,
        d.location_id,
        l.country_id,
        e.first_name,
        e.last_name,
        e.salary,
        e.commission_pct,
        d.department_name,
        j.job_title,
        l.city,
        l.state_province,
        c.country_name,
        r.region_name,
        null as philipp_test
    from
        employees   e,
        departments d,
        jobs        j,
        locations   l,
        countries   c,
        regions     r
    where
            e.department_id = d.department_id
        and d.location_id = l.location_id
        and l.country_id = c.country_id
        and c.region_id = r.region_id
        and j.job_id = e.job_id
with read only;


-- sqlcl_snapshot {"hash":"26c8a51520e4b509ca419b1d6830346f32d8c047","type":"VIEW","name":"EMP_DETAILS_VIEW","schemaName":"APEX_EXPORT_USER","sxml":""}