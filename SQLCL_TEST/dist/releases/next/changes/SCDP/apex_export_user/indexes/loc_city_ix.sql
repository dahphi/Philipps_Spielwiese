-- liquibase formatted sql
-- changeset APEX_EXPORT_USER:1774560038508 stripComments:false logicalFilePath:SCDP/apex_export_user/indexes/loc_city_ix.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot SQLCL_TEST/src/database/apex_export_user/indexes/loc_city_ix.sql:null:bd80e52373b875c41d6e391f8ae2cd2f2b53cf94:create

create index apex_export_user.loc_city_ix on
    apex_export_user.locations (
        city
    );

