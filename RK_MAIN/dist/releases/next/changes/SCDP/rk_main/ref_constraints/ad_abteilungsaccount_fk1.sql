-- liquibase formatted sql
-- changeset RK_MAIN:1774561694320 stripComments:false logicalFilePath:SCDP/rk_main/ref_constraints/ad_abteilungsaccount_fk1.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot RK_MAIN/src/database/rk_main/ref_constraints/ad_abteilungsaccount_fk1.sql:null:6f7d5d11be99e8481c374c226e2584ca2f8f1ef8:create

alter table rk_main.ad_abteilungsaccount
    add constraint ad_abteilungsaccount_fk1
        foreign key ( aa_uid )
            references rk_main.ad_abteilung ( aa_uid )
        enable;

