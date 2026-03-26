-- liquibase formatted sql
-- changeset RK_MAIN:1774555713435 stripComments:false logicalFilePath:SCDP/rk_main/tables/isr_massnahme_iso_27001_bk.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot RK_MAIN/src/database/rk_main/tables/isr_massnahme_iso_27001_bk.sql:null:93eeae3c0dd14ab2cfc9db5fd014a2a3988b8565:create

create table rk_main.isr_massnahme_iso_27001_bk (
    mi_id       number not null enable,
    msn_uid     number not null enable,
    i2c_uid     number not null enable,
    inserted    date,
    inserted_by varchar2(100 byte)
)
no inmemory;

