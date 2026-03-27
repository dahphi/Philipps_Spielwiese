-- liquibase formatted sql
-- changeset AM_MAIN:1774600126148 stripComments:false logicalFilePath:am_main/am_main/tables/hwas_promotion.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot AM_MAIN/src/database/am_main/tables/hwas_promotion.sql:null:b22cb7bd72a5438b8cc79ee3c1e0dd717feb0131:create

create table am_main.hwas_promotion (
    prom_uid       number default to_number(sys_guid(), 'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX') not null enable,
    name           varchar2(200 char),
    bemerkung      varchar2(4000 char),
    prod_ln_uid_fk number
)
no inmemory;

alter table am_main.hwas_promotion
    add constraint pk_hwas_promotion primary key ( prom_uid )
        using index enable;

alter table am_main.hwas_promotion add constraint uc_hwas_promotion_name unique ( name )
    using index enable;

