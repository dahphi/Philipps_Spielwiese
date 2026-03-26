-- liquibase formatted sql
-- changeset AM_MAIN:1774556573027 stripComments:false logicalFilePath:SCDP/am_main/tables/hwas_krit_dienstlstg_e1.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot AM_MAIN/src/database/am_main/tables/hwas_krit_dienstlstg_e1.sql:null:f97256bc4d3a5e40de9930e7a29b0f34055a15a5:create

create table am_main.hwas_krit_dienstlstg_e1 (
    kd1_uid         number default to_number(sys_guid(), 'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX') not null enable,
    kd1_bezeichnung varchar2(64 byte) not null enable,
    kd1_nummer      number,
    inserted        date default sysdate not null enable,
    updated         date,
    inserted_by     varchar2(100 char),
    updated_by      varchar2(100 char),
    kd1_link        varchar2(256 byte)
)
no inmemory;

alter table am_main.hwas_krit_dienstlstg_e1
    add constraint hwas_krit_dienstlstg_e1_pk primary key ( kd1_uid )
        using index enable;

alter table am_main.hwas_krit_dienstlstg_e1 add constraint hwas_krit_dienstlstg_e1_uk1 unique ( kd1_bezeichnung )
    using index enable;

alter table am_main.hwas_krit_dienstlstg_e1 add constraint hwas_krit_dienstlstg_e1_uk2 unique ( kd1_nummer )
    using index enable;

