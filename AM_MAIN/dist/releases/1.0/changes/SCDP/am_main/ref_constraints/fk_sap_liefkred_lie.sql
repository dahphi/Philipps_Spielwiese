-- liquibase formatted sql
-- changeset AM_MAIN:1774556572342 stripComments:false logicalFilePath:SCDP/am_main/ref_constraints/fk_sap_liefkred_lie.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot AM_MAIN/src/database/am_main/ref_constraints/fk_sap_liefkred_lie.sql:null:d7d91b6d49553dfaf7e466166cf725d0f67c49ba:create

alter table am_main.sap_lieferanten_kreditoren_nr
    add constraint fk_sap_liefkred_lie
        foreign key ( lie_uid_fk )
            references am_main.sap_lieferanten ( lie_uid )
        enable;

