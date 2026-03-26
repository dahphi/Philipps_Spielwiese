-- liquibase formatted sql
-- changeset RK_MAIN:1774561789421 stripComments:false logicalFilePath:SCDP/rk_main/object_grants/object_grants_as_grantor.rk_main.table.isr_wirkbereich.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot RK_MAIN/src/database/rk_main/object_grants/object_grants_as_grantor.rk_main.table.isr_wirkbereich.sql:964a6dc430c6a461a8b86d2b15327e4115c39c99:3b79e41f4b2f4993bd0bafc61bf77257d2b88dfa:alter

grant select on rk_main.isr_wirkbereich to rk_apex;

