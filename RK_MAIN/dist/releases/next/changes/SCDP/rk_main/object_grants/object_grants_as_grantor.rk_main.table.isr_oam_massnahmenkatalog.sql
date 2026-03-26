-- liquibase formatted sql
-- changeset RK_MAIN:1774561789381 stripComments:false logicalFilePath:SCDP/rk_main/object_grants/object_grants_as_grantor.rk_main.table.isr_oam_massnahmenkatalog.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot RK_MAIN/src/database/rk_main/object_grants/object_grants_as_grantor.rk_main.table.isr_oam_massnahmenkatalog.sql:4a799f3304bac10b857ea81c436e0aa611d19d26:dd0463ceff5c64222949ef1427d8d99272fa144e:alter

grant select on rk_main.isr_oam_massnahmenkatalog to rk_apex;

grant select on rk_main.isr_oam_massnahmenkatalog to awh_apex;

