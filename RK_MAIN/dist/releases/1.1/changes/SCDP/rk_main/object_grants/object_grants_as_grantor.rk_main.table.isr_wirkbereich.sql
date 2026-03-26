-- liquibase formatted sql
-- changeset RK_MAIN:1774555709307 stripComments:false logicalFilePath:SCDP/rk_main/object_grants/object_grants_as_grantor.rk_main.table.isr_wirkbereich.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot RK_MAIN/src/database/rk_main/object_grants/object_grants_as_grantor.rk_main.table.isr_wirkbereich.sql:null:3b79e41f4b2f4993bd0bafc61bf77257d2b88dfa:create

grant select on rk_main.isr_wirkbereich to rk_apex;

grant read on rk_main.isr_wirkbereich to rk_read;

