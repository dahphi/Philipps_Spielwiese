-- liquibase formatted sql
-- changeset AM_MAIN:1774557121774 stripComments:false logicalFilePath:SCDP/am_main/tables/hwas_virtuelle_maschinen.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot AM_MAIN/src/database/am_main/tables/hwas_virtuelle_maschinen.sql:null:0c70bde7f694177987486992ab6441ed29bb44a9:create

create table am_main.hwas_virtuelle_maschinen (
    vm_uid           number default to_number(sys_guid(), 'xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx') not null enable,
    vm_bezeichnung   varchar2(256 byte) not null enable,
    vm_host          number,
    vm_san           varchar2(64 byte),
    inserted         date default sysdate,
    updated          date,
    inserted_by      varchar2(100 char),
    updated_by       varchar2(100 char),
    vm_link_wiki     varchar2(256 byte),
    vm_beschreibung  varchar2(4000 byte),
    lz_id_fk         number,
    system_id_fk     number,
    ip_adresse       varchar2(400 byte),
    nzone_uid        number,
    umgebung         varchar2(20 byte),
    sza_ueberwachung number,
    ruf_uid_fk       number
)
no inmemory;

alter table am_main.hwas_virtuelle_maschinen
    add constraint hwas_virtuelle_machinen_pk primary key ( vm_uid )
        using index enable;

alter table am_main.hwas_virtuelle_maschinen add constraint hwas_virtuelle_machinen_uk1 unique ( vm_bezeichnung )
    using index enable;

