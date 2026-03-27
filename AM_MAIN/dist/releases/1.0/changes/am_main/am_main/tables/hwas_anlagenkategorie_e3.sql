-- liquibase formatted sql
-- changeset AM_MAIN:1774600123588 stripComments:false logicalFilePath:am_main/am_main/tables/hwas_anlagenkategorie_e3.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot AM_MAIN/src/database/am_main/tables/hwas_anlagenkategorie_e3.sql:null:3a9aa843f978bcd2e0c920963fcbdf0a7ef79f42:create

create table am_main.hwas_anlagenkategorie_e3 (
    ak3_uid                          number default to_number(sys_guid(), 'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX') not null enable,
    ak3_beschreibung                 varchar2(4000 byte),
    ak3_bemessungskriterium          varchar2(4000 byte),
    ak3_schwellwert                  varchar2(128 byte),
    be2_uid                          number,
    ak3_nummer                       number,
    ak3_nc_implementierung           varchar2(4000 byte),
    ak3_nc_bezeichnung               varchar2(32 byte),
    ak3_definition                   varchar2(4000 byte),
    inserted                         date default sysdate not null enable,
    updated                          date,
    inserted_by                      varchar2(100 char),
    updated_by                       varchar2(100 char),
    ak3_versorgungsgrad              number,
    ak3_schwellenwert_ueberschritten number,
    ak3_dataenquelle_vg              varchar2(4000 byte)
)
no inmemory;

alter table am_main.hwas_anlagenkategorie_e3
    add constraint hwas_anlagenkategorie_e3_pk primary key ( ak3_uid )
        using index enable;

alter table am_main.hwas_anlagenkategorie_e3 add constraint hwas_anlagenkategorie_e3_uk1 unique ( ak3_nc_bezeichnung )
    using index enable;

alter table am_main.hwas_anlagenkategorie_e3
    add constraint hwas_anlagenkategorie_e3_uk2 unique ( ak3_nummer,
                                                         be2_uid )
        using index enable;

