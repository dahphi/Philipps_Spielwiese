-- liquibase formatted sql
-- changeset RK_MAIN:1774554921488 stripComments:false logicalFilePath:SCDP/rk_main/tables/isr_oam_adressat.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot RK_MAIN/src/database/rk_main/tables/isr_oam_adressat.sql:null:3177a81d7e64a64013bb2eda79b0eb919694bf89:create

create table rk_main.isr_oam_adressat (
    adr_uid         number default to_number(sys_guid(), 'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX') not null enable,
    msn_uid         number not null enable,
    adr_rolle       varchar2(64 byte),
    adr_responsible number(1, 0),
    adr_accountable number(1, 0),
    adr_consulted   number(1, 0),
    adr_informed    number(1, 0),
    inserted        date default sysdate not null enable,
    updated         date,
    inserted_by     varchar2(100 char),
    updated_by      varchar2(100 char),
    adr_san         varchar2(20 byte),
    adr_bereich     varchar2(4000 byte),
    adr_oe          varchar2(4000 byte),
    adr_support     number(1, 0) default on null 0 not null enable,
    freigabeprozess number
)
no inmemory;

alter table rk_main.isr_oam_adressat
    add constraint adr_support_ck
        check ( adr_support in ( 0, 1 ) ) enable;

alter table rk_main.isr_oam_adressat
    add constraint isr_oam_adressat_pk primary key ( adr_uid )
        using index enable;

alter table rk_main.isr_oam_adressat
    add constraint isr_oam_adressat_uk1 unique ( adr_uid,
                                                 msn_uid )
        using index enable;

alter table rk_main.isr_oam_adressat
    add constraint isr_oam_adressat_uk2 unique ( msn_uid,
                                                 adr_san )
        using index enable;

