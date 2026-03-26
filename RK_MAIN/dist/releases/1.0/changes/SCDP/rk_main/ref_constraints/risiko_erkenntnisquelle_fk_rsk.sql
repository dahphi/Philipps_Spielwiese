-- liquibase formatted sql
-- changeset RK_MAIN:1774554920831 stripComments:false logicalFilePath:SCDP/rk_main/ref_constraints/risiko_erkenntnisquelle_fk_rsk.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot RK_MAIN/src/database/rk_main/ref_constraints/risiko_erkenntnisquelle_fk_rsk.sql:null:809e5b716e524110f08b46ebb16ab23d91d92fdc:create

alter table rk_main.isr_risiko_erkenntnisquelle
    add constraint risiko_erkenntnisquelle_fk_rsk
        foreign key ( rsk_uid )
            references rk_main.isr_oam_risikoinventar ( rsk_uid )
        enable;

