-- liquibase formatted sql
-- changeset APEX_EXPORT_USER:1774559358195 stripComments:false logicalFilePath:SCDP/apex_export_user/sequences/departments_seq.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot SQLCL_TEST/src/database/apex_export_user/sequences/departments_seq.sql:null:aae2870f75a8d2dd04a9bdb70a28bac492c3fcad:create

create sequence apex_export_user.departments_seq minvalue 1 maxvalue 9990 increment by 10 start with 280 nocache noorder nocycle nokeep
noscale global;

