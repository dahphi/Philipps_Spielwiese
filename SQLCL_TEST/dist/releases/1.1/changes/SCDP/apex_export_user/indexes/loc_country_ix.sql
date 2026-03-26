-- liquibase formatted sql
-- changeset APEX_EXPORT_USER:1774560228739 stripComments:false logicalFilePath:SCDP/apex_export_user/indexes/loc_country_ix.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot SQLCL_TEST/src/database/apex_export_user/indexes/loc_country_ix.sql:null:2b57c2164616dfa4415078aa4169148922358bba:create

create index apex_export_user.loc_country_ix on
    apex_export_user.locations (
        country_id
    );

