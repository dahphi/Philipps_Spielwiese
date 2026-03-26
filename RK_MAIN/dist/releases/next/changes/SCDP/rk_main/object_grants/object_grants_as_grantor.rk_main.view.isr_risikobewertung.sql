-- liquibase formatted sql
-- changeset RK_MAIN:1774561789425 stripComments:false logicalFilePath:SCDP/rk_main/object_grants/object_grants_as_grantor.rk_main.view.isr_risikobewertung.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot RK_MAIN/src/database/rk_main/object_grants/object_grants_as_grantor.rk_main.view.isr_risikobewertung.sql:01084f02362ad00b2fb8e3765d9a0d0eeb586506:7007d1d277aa6ca95be065c810378584233ece9a:alter

grant select on rk_main.isr_risikobewertung to rk_apex;

