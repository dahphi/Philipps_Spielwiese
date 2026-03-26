-- liquibase formatted sql
-- changeset AM_MAIN:1774556572645 stripComments:false logicalFilePath:SCDP/am_main/tables/hwas_beauftragungen.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot AM_MAIN/src/database/am_main/tables/hwas_beauftragungen.sql:null:a83c00eee57f1f6b78482251e0519c8c839706a1:create

create table am_main.hwas_beauftragungen (
    bean_uid        number default to_number(sys_guid(), 'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX'),
    bestellnr       number,
    beschreibung    varchar2(4000 byte),
    kostenstelle    number(5, 0),
    anforderer      varchar2(200 byte),
    ab_lieferdatum  date,
    bis_lieferdatum date,
    inserted        date,
    inserted_by     varchar2(200 byte),
    updated         date,
    updated_by      varchar2(200 byte),
    dtl_uid_fk      number
)
no inmemory;

alter table am_main.hwas_beauftragungen
    add constraint pk_bestellanforderung primary key ( bean_uid )
        using index enable;

