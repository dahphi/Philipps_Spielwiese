-- liquibase formatted sql
-- changeset AM_MAIN:1774557120408 stripComments:false logicalFilePath:SCDP/am_main/ref_constraints/fk_hvp_vertrag.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot AM_MAIN/src/database/am_main/ref_constraints/fk_hvp_vertrag.sql:null:7daacc2a7c43f69564f20ed3191580018713a77b:create

alter table am_main.hwas_vertrag_produkt
    add constraint fk_hvp_vertrag
        foreign key ( vert_uid_fk )
            references am_main.hwas_vertrag ( vert_uid )
        enable;

