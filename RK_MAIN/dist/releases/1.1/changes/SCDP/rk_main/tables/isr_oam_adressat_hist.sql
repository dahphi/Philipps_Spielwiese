-- liquibase formatted sql
-- changeset RK_MAIN:1774555713523 stripComments:false logicalFilePath:SCDP/rk_main/tables/isr_oam_adressat_hist.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot RK_MAIN/src/database/rk_main/tables/isr_oam_adressat_hist.sql:null:b801ae64c10ea1fe3f0fd3a5392f516d51c5c8be:create

create table rk_main.isr_oam_adressat_hist (
    adrh_uid         number default to_number(sys_guid(), 'xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx') not null enable,
    adr_uid          number,
    msn_uid          number,
    adr_rolle        varchar2(64 byte),
    adr_responsible  number(1, 0),
    adr_accountable  number(1, 0),
    adr_consulted    number(1, 0),
    adr_informed     number(1, 0),
    inserted         date,
    updated          date,
    inserted_by      varchar2(100 byte),
    updated_by       varchar2(100 byte),
    adr_san          varchar2(20 byte),
    adr_bereich      varchar2(4000 byte),
    adr_oe           varchar2(4000 byte),
    adr_support      number(1, 0),
    adrh_inserted    date,
    adrh_inserted_by varchar2(200 byte),
    adrh_info        varchar2(400 byte)
)
no inmemory;

alter table rk_main.isr_oam_adressat_hist
    add constraint adrh_uid_pk primary key ( adrh_uid )
        using index enable;

