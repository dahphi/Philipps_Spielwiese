-- liquibase formatted sql
-- changeset APEX_EXPORT_USER:1774559358216 stripComments:false logicalFilePath:SCDP/apex_export_user/sequences/locations_seq.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot SQLCL_TEST/src/database/apex_export_user/sequences/locations_seq.sql:null:5cc5b61b2f4f8c4729c462614700c75a6b7a341e:create

create sequence apex_export_user.locations_seq minvalue 1 maxvalue 9900 increment by 100 start with 3300 nocache noorder nocycle nokeep
noscale global;

