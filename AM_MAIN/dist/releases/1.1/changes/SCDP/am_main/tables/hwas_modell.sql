-- liquibase formatted sql
-- changeset AM_MAIN:1774557121326 stripComments:false logicalFilePath:SCDP/am_main/tables/hwas_modell.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot AM_MAIN/src/database/am_main/tables/hwas_modell.sql:null:a815b5257047288abd89af7b7126cbe8a5ab700b:create

create table am_main.hwas_modell (
    mdl_uid                number default to_number(sys_guid(), 'xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx') not null enable,
    mdl_bezeichnung        varchar2(128 byte) not null enable,
    mdl_anzahl_systeme     number,
    mdl_tn_je_system       number,
    mdl_grund_tn_je_system varchar2(4000 byte),
    mdl_regel              varchar2(4000 byte),
    hst_uid                number,
    gkl_uid                number,
    fkl_uid                number,
    inserted               date default sysdate not null enable,
    updated                date,
    inserted_by            varchar2(100 char),
    updated_by             varchar2(100 char)
)
no inmemory;

alter table am_main.hwas_modell
    add constraint hwas_modell_pk primary key ( mdl_uid )
        using index enable;

alter table am_main.hwas_modell add constraint hwas_modell_uk1 unique ( mdl_bezeichnung )
    using index enable;

