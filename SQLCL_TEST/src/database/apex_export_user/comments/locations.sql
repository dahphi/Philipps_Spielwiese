comment on table apex_export_user.locations is
    'Locations table that contains specific address of a specific office,
warehouse, and/or production site of a company. Does not store addresses /
locations of customers. references with the departments and countries tables. ';

comment on column apex_export_user.locations.city is
    'A not null column that shows city where an office, warehouse, or 
production site of a company is located. ';

comment on column apex_export_user.locations.country_id is
    'Country where an office, warehouse, or production site of a company is
located. Foreign key to country_id column of the countries table.';

comment on column apex_export_user.locations.location_id is
    'Primary key of locations table';

comment on column apex_export_user.locations.postal_code is
    'Postal code of the location of an office, warehouse, or production site 
of a company. ';

comment on column apex_export_user.locations.state_province is
    'State or Province where an office, warehouse, or production site of a 
company is located.';

comment on column apex_export_user.locations.street_address is
    'Street address of an office, warehouse, or production site of a company.
Contains building number and street name';


-- sqlcl_snapshot {"hash":"4edb527e71508db82c9bae04c436ee8fc65c9641","type":"COMMENT","name":"locations","schemaName":"apex_export_user","sxml":""}