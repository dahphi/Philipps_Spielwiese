-- liquibase formatted sql
-- changeset RK_MAIN:1774554920839 stripComments:false logicalFilePath:SCDP/rk_main/sequences/massnahme_iso_controls_seq.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot RK_MAIN/src/database/rk_main/sequences/massnahme_iso_controls_seq.sql:null:fdf926e69963a57b93ca5f91497eb3b5cc60e03f:create

create sequence rk_main.massnahme_iso_controls_seq minvalue 1 maxvalue 9999999999999999999999999999 increment by 1 start with 1157 nocache
noorder nocycle nokeep noscale global;

