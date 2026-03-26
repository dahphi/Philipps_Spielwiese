comment on table apex_export_user.countries is
    'country table. References with locations table.';

comment on column apex_export_user.countries.country_id is
    'Primary key of countries table.';

comment on column apex_export_user.countries.country_name is
    'Country name';

comment on column apex_export_user.countries.region_id is
    'Region ID for the country. Foreign key to region_id column in the departments table.';


-- sqlcl_snapshot {"hash":"4874571f41fd74b5822fdc62092ab5aea078370f","type":"COMMENT","name":"countries","schemaName":"apex_export_user","sxml":""}