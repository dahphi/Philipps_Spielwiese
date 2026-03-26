-- liquibase formatted sql
-- changeset AM_MAIN:1774557221319 stripComments:false logicalFilePath:SCDP/am_main/tables/bsi_grundschutzbausteine.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot AM_MAIN/src/database/am_main/tables/bsi_grundschutzbausteine.sql:null:3786a59eb9b1c75a67f3be99fa9fb2ece9321b11:create

create table am_main.bsi_grundschutzbausteine (
    bsi_uid     number default to_number(sys_guid(), 'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX') not null enable,
    name        varchar2(200 char) not null enable,
    bausteintyp number,
    url         varchar2(500 char),
    inserted    date default sysdate,
    inserted_by varchar2(100 char),
    updated     date,
    updated_by  varchar2(100 char),
    art         number,
    iv_relevanz number,
    bemerkung   varchar2(400 byte)
)
no inmemory;

alter table am_main.bsi_grundschutzbausteine
    add constraint pk_bsi_grundschutzbausteine primary key ( bsi_uid )
        using index enable;

alter table am_main.bsi_grundschutzbausteine add constraint uq_bsi_grundschutzbausteine_name unique ( name )
    using index enable;

