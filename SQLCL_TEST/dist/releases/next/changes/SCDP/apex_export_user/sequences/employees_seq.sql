-- liquibase formatted sql
-- changeset APEX_EXPORT_USER:1774559573256 stripComments:false logicalFilePath:SCDP/apex_export_user/sequences/employees_seq.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot SQLCL_TEST/src/database/apex_export_user/sequences/employees_seq.sql:null:4a7417d4aca7754985635c81e8ad1ffdb854a718:create

create sequence apex_export_user.employees_seq minvalue 1 maxvalue 9999999999999999999999999999 increment by 1 start with 207 nocache
noorder nocycle nokeep noscale global;

