-- liquibase formatted sql
-- changeset RK_MAIN:1774561789405 stripComments:false logicalFilePath:SCDP/rk_main/object_grants/object_grants_as_grantor.rk_main.table.isr_oam_risikosteuerung.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot RK_MAIN/src/database/rk_main/object_grants/object_grants_as_grantor.rk_main.table.isr_oam_risikosteuerung.sql:274a3852d1fdc87dec9daf38a9e79603c8a4b714:a47f8a3f1cf6f5550ea7f2f75fa4831d75025617:alter

grant select on rk_main.isr_oam_risikosteuerung to rk_apex;

