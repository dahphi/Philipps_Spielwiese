-- liquibase formatted sql
-- changeset RK_MAIN:1774554921326 stripComments:false logicalFilePath:SCDP/rk_main/tables/isr_iso_27001_kapitel_a.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot RK_MAIN/src/database/rk_main/tables/isr_iso_27001_kapitel_a.sql:null:00f76ef28fce395c5e2e15e623c7d0a0241d113a:create

create table rk_main.isr_iso_27001_kapitel_a (
    kap_uid              number default to_number(sys_guid(), 'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX') not null enable,
    kapitel              varchar2(32 byte) not null enable,
    kapitel_beschreibung varchar2(4000 byte),
    kapitel_jahr         number,
    inserted             date default sysdate not null enable,
    updated              date,
    inserted_by          varchar2(100 byte),
    updated_by           varchar2(100 byte)
)
no inmemory;

alter table rk_main.isr_iso_27001_kapitel_a
    add constraint isr_iso_27001_kapitel_a_pk primary key ( kap_uid )
        using index enable;

alter table rk_main.isr_iso_27001_kapitel_a
    add constraint isr_iso_27001_kapitel_a_uk1 unique ( kapitel,
                                                        kapitel_jahr )
        using index enable;

