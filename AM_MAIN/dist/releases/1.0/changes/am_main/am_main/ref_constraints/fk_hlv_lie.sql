-- liquibase formatted sql
-- changeset AM_MAIN:1774600122081 stripComments:false logicalFilePath:am_main/am_main/ref_constraints/fk_hlv_lie.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot AM_MAIN/src/database/am_main/ref_constraints/fk_hlv_lie.sql:null:888597dad1385cecd91f009990bf92cdc4b2a098:create

alter table am_main.hwas_lieferant_vertragsdetail
    add constraint fk_hlv_lie
        foreign key ( lie_uid_fk )
            references am_main.sap_lieferanten ( lie_uid )
        enable;

