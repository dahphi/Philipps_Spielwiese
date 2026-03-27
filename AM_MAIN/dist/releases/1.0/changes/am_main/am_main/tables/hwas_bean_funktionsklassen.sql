-- liquibase formatted sql
-- changeset AM_MAIN:1774600123708 stripComments:false logicalFilePath:am_main/am_main/tables/hwas_bean_funktionsklassen.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot AM_MAIN/src/database/am_main/tables/hwas_bean_funktionsklassen.sql:null:15038478f100f10fbe3ed9eb89cefbdf6cd52d72:create

create table am_main.hwas_bean_funktionsklassen (
    bean_uid_fk number,
    fkl_uid_fk  number,
    inserted_by varchar2(200 byte),
    inserted    date
)
no inmemory;

alter table am_main.hwas_bean_funktionsklassen
    add constraint pk_bean_funktionsklassen primary key ( bean_uid_fk,
                                                          fkl_uid_fk )
        using index enable;

