-- liquibase formatted sql
-- changeset RK_MAIN:1774561694422 stripComments:false logicalFilePath:SCDP/rk_main/ref_constraints/risiko_erkenntnisquelle_fk_ekq.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot RK_MAIN/src/database/rk_main/ref_constraints/risiko_erkenntnisquelle_fk_ekq.sql:null:cea7821e60ab869f71321edb860a04e53cd07ad8:create

alter table rk_main.isr_risiko_erkenntnisquelle
    add constraint risiko_erkenntnisquelle_fk_ekq
        foreign key ( ekq_uid )
            references rk_main.asm_am_erkenntnisquellen ( ekq_uid )
        enable;

