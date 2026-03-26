-- liquibase formatted sql
-- changeset RK_MAIN:1774561695207 stripComments:false logicalFilePath:SCDP/rk_main/tables/isr_oam_risikosteuerung.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot RK_MAIN/src/database/rk_main/tables/isr_oam_risikosteuerung.sql:null:9c363c2073b716982b37f1fa60f84432a5b4c10e:create

create table rk_main.isr_oam_risikosteuerung (
    ris_uid          number default to_number(sys_guid(), 'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX') not null enable,
    ris_titel        varchar2(64 byte) not null enable,
    ris_beschreibung varchar2(4000 byte),
    inserted         date default sysdate not null enable,
    updated          date,
    inserted_by      varchar2(100 char),
    updated_by       varchar2(100 char),
    aktiv            number default 1 not null enable,
    ris_akzeptanz    number
)
no inmemory;

alter table rk_main.isr_oam_risikosteuerung
    add constraint isr_oam_risikosteuerung_pk primary key ( ris_uid )
        using index enable;

alter table rk_main.isr_oam_risikosteuerung add constraint isr_oam_risikosteuerung_uk1 unique ( ris_titel )
    using index enable;

