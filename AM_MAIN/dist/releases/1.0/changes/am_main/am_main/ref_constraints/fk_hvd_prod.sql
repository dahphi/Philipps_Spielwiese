-- liquibase formatted sql
-- changeset AM_MAIN:1774600122124 stripComments:false logicalFilePath:am_main/am_main/ref_constraints/fk_hvd_prod.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot AM_MAIN/src/database/am_main/ref_constraints/fk_hvd_prod.sql:null:177697ae4f3e3027668540c27cb92b11b309ad52:create

alter table am_main.hwas_vertragsdetails
    add constraint fk_hvd_prod
        foreign key ( prod_uid_fk )
            references am_main.hwas_produkt ( prod_uid )
        enable;

