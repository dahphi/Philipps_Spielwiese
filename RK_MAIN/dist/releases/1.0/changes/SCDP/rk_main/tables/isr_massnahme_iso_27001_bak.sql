-- liquibase formatted sql
-- changeset RK_MAIN:1774561694936 stripComments:false logicalFilePath:SCDP/rk_main/tables/isr_massnahme_iso_27001_bak.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot RK_MAIN/src/database/rk_main/tables/isr_massnahme_iso_27001_bak.sql:null:4205ae3582830f22f6606c005f1fa09442e1b58b:create

create table rk_main.isr_massnahme_iso_27001_bak (
    mi_id       number not null enable,
    msn_uid     number not null enable,
    i2c_uid     number not null enable,
    inserted    date,
    inserted_by varchar2(100 byte)
)
no inmemory;

