-- liquibase formatted sql
-- changeset RK_MAIN:1774561694453 stripComments:false logicalFilePath:SCDP/rk_main/sequences/risiko_erkenntnisquelle_seq.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot RK_MAIN/src/database/rk_main/sequences/risiko_erkenntnisquelle_seq.sql:null:4f96e22626124cc04905bff39577720803fa8f95:create

create sequence rk_main.risiko_erkenntnisquelle_seq minvalue 1 maxvalue 9999999999999999999999999999 increment by 1 start with 4414 nocache
noorder nocycle nokeep noscale global;

