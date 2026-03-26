-- liquibase formatted sql
-- changeset AM_MAIN:1774556572212 stripComments:false logicalFilePath:SCDP/am_main/ref_constraints/fk_beauftragungen_dienstleister.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot AM_MAIN/src/database/am_main/ref_constraints/fk_beauftragungen_dienstleister.sql:null:fd52dce2792294a5f5c1be436e2b60d17cb5e68c:create

alter table am_main.hwas_beauftragungen
    add constraint fk_beauftragungen_dienstleister
        foreign key ( dtl_uid_fk )
            references am_main.hwas_dienstleister ( dtl_uid )
        enable;

