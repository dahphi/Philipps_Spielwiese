-- liquibase formatted sql
-- changeset RK_MAIN:1774554916810 stripComments:false logicalFilePath:SCDP/rk_main/object_grants/object_grants_as_grantor.rk_main.table.isr_iso_27001_controls.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot RK_MAIN/src/database/rk_main/object_grants/object_grants_as_grantor.rk_main.table.isr_iso_27001_controls.sql:null:c9fe1a481e010f22f52180d956c054a379e9a7c1:create

grant select on rk_main.isr_iso_27001_controls to rk_apex;

grant read on rk_main.isr_iso_27001_controls to rk_read;

grant read on rk_main.isr_iso_27001_controls to rk_apex;

