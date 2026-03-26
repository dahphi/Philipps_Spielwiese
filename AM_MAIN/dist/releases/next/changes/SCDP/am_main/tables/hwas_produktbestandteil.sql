-- liquibase formatted sql
-- changeset AM_MAIN:1774557121413 stripComments:false logicalFilePath:SCDP/am_main/tables/hwas_produktbestandteil.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot AM_MAIN/src/database/am_main/tables/hwas_produktbestandteil.sql:null:d954ee4db7971f1e5263263c4264526e0928a629:create

create table am_main.hwas_produktbestandteil (
    prod_bes_uid number(*, 0) not null enable,
    name         varchar2(255 byte) not null enable,
    prod_uid_fk  number(*, 0) not null enable,
    kommentar    varchar2(4000 byte),
    inserted     date,
    inserted_by  varchar2(255 byte),
    updated      date,
    updated_by   varchar2(255 byte)
)
no inmemory;

alter table am_main.hwas_produktbestandteil
    add constraint hwas_produktbestandteil_uk1 unique ( prod_uid_fk,
                                                        name )
        using index enable;

alter table am_main.hwas_produktbestandteil
    add constraint pk_hwas_produktbestandteil primary key ( prod_bes_uid )
        using index enable;

