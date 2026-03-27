-- liquibase formatted sql
-- changeset AM_MAIN:1774600126087 stripComments:false logicalFilePath:am_main/am_main/tables/hwas_produktlinie.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot AM_MAIN/src/database/am_main/tables/hwas_produktlinie.sql:null:8da569f33b25cc6f099ca4a0a25e2205b9005468:create

create table am_main.hwas_produktlinie (
    prod_ln_uid number default to_number(sys_guid(), 'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX') not null enable,
    name        varchar2(200 char),
    bemerkung   varchar2(4000 char)
)
no inmemory;

alter table am_main.hwas_produktlinie add constraint hwas_produktlinie_uk1 unique ( name )
    using index enable;

alter table am_main.hwas_produktlinie
    add constraint pk_hwas_promotion_gruppe primary key ( prod_ln_uid )
        using index enable;

