-- liquibase formatted sql
-- changeset AM_MAIN:1774605607167 stripComments:false logicalFilePath:am_main/am_main/tables/bsi_asset_baustein.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot AM_MAIN/src/database/am_main/tables/bsi_asset_baustein.sql:null:ff0105ceb2f51f4bafa68ba8f2a10a614c43768d:create

create table am_main.bsi_asset_baustein (
    ass_bsi_uid number default to_number(substr(
        rawtohex(sys_guid()),
        1,
        30
    ),
          'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXX') not null enable,
    bsi_uid_fk  number not null enable,
    ass_uid_fk  number not null enable,
    asset_typ   varchar2(50 byte) not null enable,
    inserted    date default sysdate not null enable,
    inserted_by varchar2(50 byte)
)
no inmemory;

alter table am_main.bsi_asset_baustein
    add constraint pk_bsi_asset_baustein primary key ( ass_bsi_uid )
        using index enable;

alter table am_main.bsi_asset_baustein
    add constraint uq_bsi_asset_baustein
        unique ( bsi_uid_fk,
                 ass_uid_fk,
                 asset_typ )
            using index enable;

