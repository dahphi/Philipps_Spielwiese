-- liquibase formatted sql
-- changeset RK_MAIN:1774561690397 stripComments:false logicalFilePath:SCDP/rk_main/indexes/isr_brm_gefaehrdungkat_uk1.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot RK_MAIN/src/database/rk_main/indexes/isr_brm_gefaehrdungkat_uk1.sql:null:fe74ddc280eef4ea2f2950c05822c9e78357a63b:create

create unique index rk_main.isr_brm_gefaehrdungkat_uk1 on
    rk_main.isr_brm_gefaehrdungkat (
        gfk_name
    );

