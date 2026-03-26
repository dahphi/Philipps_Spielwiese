-- liquibase formatted sql
-- changeset RK_MAIN:1774561695262 stripComments:false logicalFilePath:SCDP/rk_main/tables/isr_risiko_erkenntnisquelle.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot RK_MAIN/src/database/rk_main/tables/isr_risiko_erkenntnisquelle.sql:null:a43142d7a26ef1c8182e71b0738aea69396f3b18:create

create table rk_main.isr_risiko_erkenntnisquelle (
    re_id       number default on null to_number(sys_guid(), 'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX') not null enable,
    rsk_uid     number not null enable,
    ekq_uid     number not null enable,
    inserted    date,
    inserted_by varchar2(100 byte)
)
no inmemory;

alter table rk_main.isr_risiko_erkenntnisquelle
    add constraint risiko_erkenntnisquelle_pk primary key ( re_id )
        using index enable;

