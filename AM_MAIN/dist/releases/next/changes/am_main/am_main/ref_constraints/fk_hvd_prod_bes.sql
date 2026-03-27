-- liquibase formatted sql
-- changeset AM_MAIN:1774605607131 stripComments:false logicalFilePath:am_main/am_main/ref_constraints/fk_hvd_prod_bes.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot AM_MAIN/src/database/am_main/ref_constraints/fk_hvd_prod_bes.sql:null:f59f943c67c7e1676229c68a8e6e1f6147bdaa3d:create

alter table am_main.hwas_vertragsdetails
    add constraint fk_hvd_prod_bes
        foreign key ( prod_bes_uid_fk )
            references am_main.hwas_produktbestandteil ( prod_bes_uid )
        enable;

