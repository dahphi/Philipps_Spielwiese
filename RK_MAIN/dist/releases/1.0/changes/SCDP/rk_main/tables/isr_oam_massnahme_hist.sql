-- liquibase formatted sql
-- changeset RK_MAIN:1774554921572 stripComments:false logicalFilePath:SCDP/rk_main/tables/isr_oam_massnahme_hist.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot RK_MAIN/src/database/rk_main/tables/isr_oam_massnahme_hist.sql:null:40829ef85472429605f0a21b73a8a25d52523cc3:create

create table rk_main.isr_oam_massnahme_hist (
    msnh_uid               number default to_number(sys_guid(), 'xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx') not null enable,
    msn_uid                number,
    msn_titel              varchar2(70 byte),
    msn_beschreibung       varchar2(4000 byte),
    msn_intern             number,
    mka_uid                number,
    inserted               date,
    updated                date,
    inserted_by            varchar2(100 byte),
    updated_by             varchar2(100 byte),
    uss_uid                number,
    zieltermin             date,
    uss_ready_date         date,
    mkp_uid                number,
    msn_statusbeschreibung varchar2(4000 byte),
    msnh_version           number,
    msnh_inserted          date
)
no inmemory;

alter table rk_main.isr_oam_massnahme_hist
    add constraint msnh_uid_pk primary key ( msnh_uid )
        using index enable;

