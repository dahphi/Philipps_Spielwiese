-- liquibase formatted sql
-- changeset ROMA_MAIN:1768480991198 stripComments:false logicalFilePath:develop/roma_main/tables/ftth_factory_ansichtsgruppen.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot GLASCONTAINER_MAIN/src/database/roma_main/tables/ftth_factory_ansichtsgruppen.sql:null:ec77567180b81dacbcb827599fe6f66d5aef71db:create

create table roma_main.ftth_factory_ansichtsgruppen (
    ftthag_id   number(*, 0) not null enable,
    status      varchar2(3 byte) not null enable,
    name        varchar2(50 byte) not null enable,
    reihenfolge number(*, 0)
);

alter table roma_main.ftth_factory_ansichtsgruppen
    add constraint ftth_factory_ansichtsgruppen_pk primary key ( ftthag_id )
        using index enable;

alter table roma_main.ftth_factory_ansichtsgruppen flashback archive mongo

