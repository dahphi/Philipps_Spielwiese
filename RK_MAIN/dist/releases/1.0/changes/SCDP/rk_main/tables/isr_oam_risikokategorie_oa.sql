-- liquibase formatted sql
-- changeset RK_MAIN:1774561695188 stripComments:false logicalFilePath:SCDP/rk_main/tables/isr_oam_risikokategorie_oa.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot RK_MAIN/src/database/rk_main/tables/isr_oam_risikokategorie_oa.sql:null:d8a6b3b85ffa31261e8ec6d985f64529ffbf4425:create

create table rk_main.isr_oam_risikokategorie_oa (
    rkt_uid             number default to_number(sys_guid(), 'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX') not null enable,
    rkt_titel           varchar2(64 byte) not null enable,
    rkt_beschschreibung varchar2(4000 byte),
    inserted            date default sysdate not null enable,
    updated             date,
    inserted_by         varchar2(100 char),
    updated_by          varchar2(100 char),
    aktiv               number default 1 not null enable
)
no inmemory;

alter table rk_main.isr_oam_risikokategorie_oa
    add constraint isr_oam_risikokategorie_oa_pk primary key ( rkt_uid )
        using index enable;

alter table rk_main.isr_oam_risikokategorie_oa add constraint isr_oam_risikokategorie_oa_uk1 unique ( rkt_titel )
    using index enable;

