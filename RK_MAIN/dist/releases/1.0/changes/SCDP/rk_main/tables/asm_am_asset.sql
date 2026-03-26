-- liquibase formatted sql
-- changeset RK_MAIN:1774561694584 stripComments:false logicalFilePath:SCDP/rk_main/tables/asm_am_asset.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot RK_MAIN/src/database/rk_main/tables/asm_am_asset.sql:null:0f6ecddef8fb7707c02a75ae8d81408c71826b1b:create

create table rk_main.asm_am_asset (
    ass_uid             number default to_number(sys_guid(), 'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX') not null enable,
    ass_id              varchar2(64 byte) not null enable,
    ass_beschreibung    varchar2(4000 byte),
    inserted            date default sysdate not null enable,
    updated             date,
    inserted_by         varchar2(100 char),
    updated_by          varchar2(100 char),
    ass_spot_referenz   varchar2(2048 byte),
    gek_lfd_nr          number,
    ass_kritis_relevant number(1, 0) default 0,
    aut_lfd_nr          number,
    int_lfd_nr          number,
    vef_lfd_nr          number,
    vet_lfd_nr          number,
    ass_dataowner_san   varchar2(20 byte),
    ass_custodian_san   varchar2(20 byte),
    fkl_uid             number
)
no inmemory;

alter table rk_main.asm_am_asset
    add constraint asm_am_asset_pk primary key ( ass_uid )
        using index enable;

alter table rk_main.asm_am_asset add constraint asm_am_asset_uk1 unique ( ass_id )
    using index enable;

