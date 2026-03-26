-- liquibase formatted sql
-- changeset RK_MAIN:1774554921691 stripComments:false logicalFilePath:SCDP/rk_main/tables/isr_oam_risikoinventar_hist.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot RK_MAIN/src/database/rk_main/tables/isr_oam_risikoinventar_hist.sql:null:ecfa2b828bafc46f42502f45167d929155bc7a28:create

create table rk_main.isr_oam_risikoinventar_hist (
    rskh_uid               number default to_number(sys_guid(), 'xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx') not null enable,
    rsk_uid                number,
    rsk_risikotitel        varchar2(128 byte),
    rsk_beschreibung       varchar2(4000 byte),
    gef_uid                number,
    abweichung_sollzustand varchar2(4000 byte),
    rkt_uid                number,
    inserted               date,
    updated                date,
    inserted_by            varchar2(100 char),
    updated_by             varchar2(100 char),
    netto1_ews_uid         number,
    netto1_auw_uid         number,
    netto2_ews_uid         number,
    netto2_auw_uid         number,
    ska_uid                number,
    rsk_workflow_status    varchar2(32 byte),
    rsk_unit_risikotraeger varchar2(4000 byte),
    ris_uid                number,
    rsk_accepted_date      date,
    rsk_accepted_san       varchar2(32 byte),
    rskh_version           number,
    rskh_inserted          date
)
no inmemory;

alter table rk_main.isr_oam_risikoinventar_hist
    add constraint rskh_uid_pk primary key ( rskh_uid )
        using index enable;

