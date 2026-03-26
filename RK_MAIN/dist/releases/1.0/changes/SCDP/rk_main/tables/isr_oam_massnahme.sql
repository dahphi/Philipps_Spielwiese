-- liquibase formatted sql
-- changeset RK_MAIN:1774554921544 stripComments:false logicalFilePath:SCDP/rk_main/tables/isr_oam_massnahme.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot RK_MAIN/src/database/rk_main/tables/isr_oam_massnahme.sql:null:21a7bd99fe131a3901e1e4fbfab0525ca79005dd:create

create table rk_main.isr_oam_massnahme (
    msn_uid                number default to_number(sys_guid(), 'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX') not null enable,
    msn_titel              varchar2(70 byte) not null enable,
    msn_beschreibung       varchar2(4000 byte),
    msn_intern             number default on null 1 not null enable,
    mka_uid                number,
    inserted               date default sysdate not null enable,
    updated                date,
    inserted_by            varchar2(100 char),
    updated_by             varchar2(100 char),
    uss_uid                number not null enable,
    zieltermin             date,
    uss_ready_date         date,
    mkp_uid                number,
    msn_statusbeschreibung varchar2(4000 byte)
)
no inmemory;

alter table rk_main.isr_oam_massnahme
    add constraint isr_oam_massnahme_pk primary key ( msn_uid )
        using index enable;

alter table rk_main.isr_oam_massnahme add constraint isr_oam_massnahme_uk1 unique ( msn_titel )
    using index enable;

alter table rk_main.isr_oam_massnahme
    add constraint msn_intern_ck
        check ( msn_intern in ( 0, 1 ) ) enable;

