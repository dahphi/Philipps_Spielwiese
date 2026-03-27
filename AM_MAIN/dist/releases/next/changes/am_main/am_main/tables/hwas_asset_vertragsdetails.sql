-- liquibase formatted sql
-- changeset AM_MAIN:1774600123671 stripComments:false logicalFilePath:am_main/am_main/tables/hwas_asset_vertragsdetails.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot AM_MAIN/src/database/am_main/tables/hwas_asset_vertragsdetails.sql:null:7e45385d9ac12c3818bf9d5783efb7ca8febfb0e:create

create table am_main.hwas_asset_vertragsdetails (
    verass_uid  number default to_number(sys_guid(), 'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX') not null enable,
    vd_uid_fk   number not null enable,
    ass_uid_fk  number not null enable,
    inserted    date default sysdate,
    inserted_by varchar2(100 char),
    updated     date,
    updated_by  varchar2(100 char)
)
no inmemory;

alter table am_main.hwas_asset_vertragsdetails
    add constraint pk_hwas_asset_vertragsdetails primary key ( verass_uid )
        using index enable;

