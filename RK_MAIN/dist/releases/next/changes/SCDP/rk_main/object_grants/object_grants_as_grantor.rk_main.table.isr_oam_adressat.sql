-- liquibase formatted sql
-- changeset RK_MAIN:1774561789370 stripComments:false logicalFilePath:SCDP/rk_main/object_grants/object_grants_as_grantor.rk_main.table.isr_oam_adressat.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot RK_MAIN/src/database/rk_main/object_grants/object_grants_as_grantor.rk_main.table.isr_oam_adressat.sql:947d0604e23217d5976436c4b40358e140997115:0461ad6728042c5cb1a7029f8e1bce0dacb2ff15:alter

grant select on rk_main.isr_oam_adressat to rk_apex;

