-- liquibase formatted sql
-- changeset RK_MAIN:1774555709163 stripComments:false logicalFilePath:SCDP/rk_main/object_grants/object_grants_as_grantor.rk_main.table.isr_brm_massnahmenkat.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot RK_MAIN/src/database/rk_main/object_grants/object_grants_as_grantor.rk_main.table.isr_brm_massnahmenkat.sql:null:60cad24ed53cd36125d9d08de1c8aed625fd7803:create

grant select on rk_main.isr_brm_massnahmenkat to rk_apex;

grant read on rk_main.isr_brm_massnahmenkat to rk_read;

