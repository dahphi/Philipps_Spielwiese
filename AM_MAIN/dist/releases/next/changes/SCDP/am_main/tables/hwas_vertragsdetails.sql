-- liquibase formatted sql
-- changeset AM_MAIN:1774557222317 stripComments:false logicalFilePath:SCDP/am_main/tables/hwas_vertragsdetails.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot AM_MAIN/src/database/am_main/tables/hwas_vertragsdetails.sql:null:51442e29a3736fec64a4ce1149172a4240213643:create

create table am_main.hwas_vertragsdetails (
    vd_uid           number default to_number(sys_guid(), 'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX') not null enable,
    prod_uid_fk      number not null enable,
    vert_uid_fk      number not null enable,
    inserted         date default sysdate,
    inserted_by      varchar2(100 char),
    updated          date,
    updated_by       varchar2(100 char),
    ver_ti_uid_fk    number,
    prod_bes_uid_fk  number,
    bemerkung        varchar2(400 byte),
    betriebsrelevanz number
)
no inmemory;

alter table am_main.hwas_vertragsdetails
    add constraint pk_hwas_vertragsdetails primary key ( vd_uid )
        using index enable;

