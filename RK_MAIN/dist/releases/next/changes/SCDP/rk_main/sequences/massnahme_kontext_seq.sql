-- liquibase formatted sql
-- changeset RK_MAIN:1774561694445 stripComments:false logicalFilePath:SCDP/rk_main/sequences/massnahme_kontext_seq.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot RK_MAIN/src/database/rk_main/sequences/massnahme_kontext_seq.sql:null:f37f19b590844575796e3c12a9ef226ce4d9025c:create

create sequence rk_main.massnahme_kontext_seq minvalue 1 maxvalue 9999999999999999999999999999 increment by 1 start with 7011 nocache
noorder nocycle nokeep noscale global;

