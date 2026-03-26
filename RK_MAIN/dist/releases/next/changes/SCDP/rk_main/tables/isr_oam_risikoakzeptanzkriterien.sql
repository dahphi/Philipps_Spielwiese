-- liquibase formatted sql
-- changeset RK_MAIN:1774561695128 stripComments:false logicalFilePath:SCDP/rk_main/tables/isr_oam_risikoakzeptanzkriterien.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot RK_MAIN/src/database/rk_main/tables/isr_oam_risikoakzeptanzkriterien.sql:null:0ec7c007810b95d1d699a7c1f63f198791007b1d:create

create table rk_main.isr_oam_risikoakzeptanzkriterien (
    rak_uid          number default to_number(sys_guid(), 'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX') not null enable,
    rak_bezeichnung  varchar2(64 byte) not null enable,
    rak_wert         number,
    rak_beschreibung varchar2(4000 byte),
    inserted         date default sysdate not null enable,
    updated          date,
    inserted_by      varchar2(100 char),
    updated_by       varchar2(100 char)
)
no inmemory;

alter table rk_main.isr_oam_risikoakzeptanzkriterien
    add constraint isr_oam_risikoakzeptanzkriterien_pk primary key ( rak_uid )
        using index enable;

alter table rk_main.isr_oam_risikoakzeptanzkriterien add constraint isr_oam_risikoakzeptanzkriterien_uk1 unique ( rak_bezeichnung )
    using index enable;

