-- liquibase formatted sql
-- changeset RK_MAIN:1774554920812 stripComments:false logicalFilePath:SCDP/rk_main/ref_constraints/massnahme_kontext_fk_mkt.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot RK_MAIN/src/database/rk_main/ref_constraints/massnahme_kontext_fk_mkt.sql:null:858758d6e8bcfe59408b4dddff986c6fc7843fb1:create

alter table rk_main.isr_massnahme_kontext
    add constraint massnahme_kontext_fk_mkt
        foreign key ( mkt_uid )
            references rk_main.isr_oam_massnahmenkontext ( mkt_uid )
        enable;

