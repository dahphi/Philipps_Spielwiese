-- liquibase formatted sql
-- changeset AM_MAIN:1774557120480 stripComments:false logicalFilePath:SCDP/am_main/ref_constraints/fk_przpbsi_bsi.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot AM_MAIN/src/database/am_main/ref_constraints/fk_przpbsi_bsi.sql:null:78754d3e81ac1f20a7de9cbb887af1c2f2e68479:create

alter table am_main.hwas_prozesse_bsi_bausteine
    add constraint fk_przpbsi_bsi
        foreign key ( bsi_uid_fk )
            references am_main.bsi_grundschutzbausteine ( bsi_uid )
        enable;

