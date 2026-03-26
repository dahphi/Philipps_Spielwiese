-- liquibase formatted sql
-- changeset RK_MAIN:1774555713650 stripComments:false logicalFilePath:SCDP/rk_main/tables/isr_oam_risikoinventar.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot RK_MAIN/src/database/rk_main/tables/isr_oam_risikoinventar.sql:null:fe27ff2052cb306be610a627c269066cdd35f8ae:create

create table rk_main.isr_oam_risikoinventar (
    rsk_uid                number default to_number(sys_guid(), 'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX') not null enable,
    rsk_risikotitel        varchar2(128 byte) not null enable,
    rsk_beschreibung       varchar2(4000 byte),
    gef_uid                number,
    abweichung_sollzustand varchar2(4000 byte) not null enable,
    rkt_uid                number,
    inserted               date default sysdate not null enable,
    updated                date,
    inserted_by            varchar2(100 char),
    updated_by             varchar2(100 char),
    netto1_ews_uid         number,
    netto1_auw_uid         number,
    netto2_ews_uid         number,
    netto2_auw_uid         number,
    ska_uid                number,
    rsk_workflow_status    varchar2(32 byte) default 'initial erfasst',
    rsk_unit_risikotraeger varchar2(4000 byte),
    ris_uid                number,
    rsk_accepted_date      date,
    rsk_accepted_san       varchar2(32 byte)
)
no inmemory;

alter table rk_main.isr_oam_risikoinventar
    add constraint isr_oam_risiko_pk primary key ( rsk_uid )
        using index enable;

alter table rk_main.isr_oam_risikoinventar add constraint isr_oam_risiko_uk1 unique ( rsk_risikotitel )
    using index enable;

