-- liquibase formatted sql
-- changeset AM_MAIN:1774557221485 stripComments:false logicalFilePath:SCDP/am_main/tables/hwas_dienstleister.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot AM_MAIN/src/database/am_main/tables/hwas_dienstleister.sql:null:f5bccaf866776ee8925ab480d4cb0f458725d45e:create

create table am_main.hwas_dienstleister (
    dtl_uid                   number default to_number(sys_guid(), 'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX'),
    name                      varchar2(255 byte) not null enable,
    kreditoren_nr             number,
    inserted_by               varchar2(200 byte),
    inserted                  date,
    updated_by                varchar2(200 byte),
    updated                   date,
    link_kooperationsfreigabe varchar2(400 byte)
)
no inmemory;

alter table am_main.hwas_dienstleister
    add constraint pk_hwas_dienstleister primary key ( dtl_uid )
        using index enable;

alter table am_main.hwas_dienstleister add constraint uq_hwas_dienstleister_kredidorennr unique ( kreditoren_nr )
    using index enable;

alter table am_main.hwas_dienstleister add constraint uq_hwas_dienstleister_name unique ( name )
    using index enable;

