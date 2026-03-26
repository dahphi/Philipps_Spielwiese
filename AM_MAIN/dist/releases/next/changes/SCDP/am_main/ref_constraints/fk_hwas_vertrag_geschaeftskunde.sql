-- liquibase formatted sql
-- changeset AM_MAIN:1774556572308 stripComments:false logicalFilePath:SCDP/am_main/ref_constraints/fk_hwas_vertrag_geschaeftskunde.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot AM_MAIN/src/database/am_main/ref_constraints/fk_hwas_vertrag_geschaeftskunde.sql:null:1be1eea664256a32059467557c260df7fe1a2f9a:create

alter table am_main.hwas_vertrag
    add constraint fk_hwas_vertrag_geschaeftskunde
        foreign key ( gesku_uid_fk )
            references am_main.hwas_geschaeftskunden ( gesku_uid )
        enable;

