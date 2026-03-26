-- liquibase formatted sql
-- changeset AM_MAIN:1774556573528 stripComments:false logicalFilePath:SCDP/am_main/tables/hwas_vertrag_titel.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot AM_MAIN/src/database/am_main/tables/hwas_vertrag_titel.sql:null:1da0ffc156b43c7ff663057d11a10e188d834984:create

create table am_main.hwas_vertrag_titel (
    ver_ti_uid  number(38, 0) not null enable,
    name        varchar2(255 byte) not null enable,
    vert_uid_fk number(38, 0) not null enable,
    inserted    date,
    inserted_by varchar2(255 byte),
    updated     date,
    updated_by  varchar2(255 byte)
)
no inmemory;

alter table am_main.hwas_vertrag_titel
    add constraint hwas_vertrag_titel_uk1 unique ( name,
                                                   vert_uid_fk )
        using index enable;

alter table am_main.hwas_vertrag_titel
    add constraint pk_hwas_vertrag_titel primary key ( ver_ti_uid )
        using index enable;

