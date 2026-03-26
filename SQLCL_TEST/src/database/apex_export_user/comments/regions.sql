comment on table apex_export_user.regions is
    'Regions table that contains region numbers and names. references with the Countries table.';

comment on column apex_export_user.regions.region_id is
    'Primary key of regions table.';

comment on column apex_export_user.regions.region_name is
    'Names of regions. Locations are in the countries of these regions.';


-- sqlcl_snapshot {"hash":"835b58c76d5649a538d3af97b959747e4dfcc651","type":"COMMENT","name":"regions","schemaName":"apex_export_user","sxml":""}