-- liquibase formatted sql
-- changeset AM_MAIN:1774556573375 stripComments:false logicalFilePath:SCDP/am_main/tables/hwas_rufbereitschaft.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot AM_MAIN/src/database/am_main/tables/hwas_rufbereitschaft.sql:null:108c63884ab84b87467bf9e6b5588e046c2adab8:create

create table am_main.hwas_rufbereitschaft (
    ruf_uid         number default to_number(sys_guid(), 'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX') not null enable,
    name            varchar2(200 char) not null enable,
    telefon         varchar2(50 char),
    email           varchar2(150 char),
    ansprechpartner varchar2(150 char),
    ad_gruppe       varchar2(200 char),
    bemerkung       varchar2(400 char),
    inserted        date default sysdate,
    inserted_by     varchar2(100 char),
    updated         date,
    updated_by      varchar2(100 char)
)
no inmemory;

alter table am_main.hwas_rufbereitschaft
    add constraint pk_hwas_rufbereitschaft primary key ( ruf_uid )
        using index enable;

alter table am_main.hwas_rufbereitschaft add constraint uq_hwas_rufbereitschaft_name unique ( name )
    using index enable;

