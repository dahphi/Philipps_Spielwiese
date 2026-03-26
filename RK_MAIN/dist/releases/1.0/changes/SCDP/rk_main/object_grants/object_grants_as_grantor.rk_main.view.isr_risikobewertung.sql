-- liquibase formatted sql
-- changeset RK_MAIN:1774554916953 stripComments:false logicalFilePath:SCDP/rk_main/object_grants/object_grants_as_grantor.rk_main.view.isr_risikobewertung.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot RK_MAIN/src/database/rk_main/object_grants/object_grants_as_grantor.rk_main.view.isr_risikobewertung.sql:null:7007d1d277aa6ca95be065c810378584233ece9a:create

grant select on rk_main.isr_risikobewertung to rk_apex;

grant read on rk_main.isr_risikobewertung to rk_read;

