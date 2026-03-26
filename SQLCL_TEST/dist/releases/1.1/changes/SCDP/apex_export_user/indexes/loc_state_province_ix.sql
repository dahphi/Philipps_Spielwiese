-- liquibase formatted sql
-- changeset APEX_EXPORT_USER:1774559152742 stripComments:false logicalFilePath:SCDP/apex_export_user/indexes/loc_state_province_ix.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot SQLCL_TEST/src/database/apex_export_user/indexes/loc_state_province_ix.sql:null:fb660860711a44ecc5a1302ba227152b8a6b30dd:create

create index apex_export_user.loc_state_province_ix on
    apex_export_user.locations (
        state_province
    );

