-- liquibase formatted sql
-- changeset AM_MAIN:1774556572264 stripComments:false logicalFilePath:SCDP/am_main/ref_constraints/fk_hvp_produkt.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot AM_MAIN/src/database/am_main/ref_constraints/fk_hvp_produkt.sql:null:1b2a0e513a18157beabe5e4c03e59cf7ffefc9c8:create

alter table am_main.hwas_vertrag_produkt
    add constraint fk_hvp_produkt
        foreign key ( prod_uid_fk )
            references am_main.hwas_produkt ( prod_uid )
        enable;

