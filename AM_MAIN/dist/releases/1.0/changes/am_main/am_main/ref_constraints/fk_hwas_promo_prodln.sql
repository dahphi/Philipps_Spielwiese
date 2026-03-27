-- liquibase formatted sql
-- changeset AM_MAIN:1774600122252 stripComments:false logicalFilePath:am_main/am_main/ref_constraints/fk_hwas_promo_prodln.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot AM_MAIN/src/database/am_main/ref_constraints/fk_hwas_promo_prodln.sql:null:5b47f0d444a88bd66d8169fb4b3c157ca907fac0:create

alter table am_main.hwas_promotion
    add constraint fk_hwas_promo_prodln
        foreign key ( prod_ln_uid_fk )
            references am_main.hwas_produktlinie ( prod_ln_uid )
        enable;

