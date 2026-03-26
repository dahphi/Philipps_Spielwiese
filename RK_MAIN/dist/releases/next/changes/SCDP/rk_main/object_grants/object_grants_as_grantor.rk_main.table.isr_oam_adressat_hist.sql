-- liquibase formatted sql
-- changeset RK_MAIN:1774554916856 stripComments:false logicalFilePath:SCDP/rk_main/object_grants/object_grants_as_grantor.rk_main.table.isr_oam_adressat_hist.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot RK_MAIN/src/database/rk_main/object_grants/object_grants_as_grantor.rk_main.table.isr_oam_adressat_hist.sql:null:2aacf9d6c19cc4039fa07242934b1030b877cc66:create

grant select on rk_main.isr_oam_adressat_hist to rk_apex;

