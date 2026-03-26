-- liquibase formatted sql
-- changeset AM_MAIN:1774556567776 stripComments:false logicalFilePath:SCDP/am_main/indexes/unique_vd_index.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot AM_MAIN/src/database/am_main/indexes/unique_vd_index.sql:null:d1a4ecd2b717ad0524243bbbf9a4b81aa0e2034f:create

create unique index am_main.unique_vd_index on
    am_main.hwas_vertragsdetails (
        vert_uid_fk,
        prod_uid_fk,
    nvl(ver_ti_uid_fk,(-1)),
    nvl(prod_bes_uid_fk,(-1)) );

