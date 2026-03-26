-- liquibase formatted sql
-- changeset AM_MAIN:1774557120486 stripComments:false logicalFilePath:SCDP/am_main/ref_constraints/fk_przpbsi_przp.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot AM_MAIN/src/database/am_main/ref_constraints/fk_przpbsi_przp.sql:null:ef419323569d4e82b5758c2363bd95f671434afc:create

alter table am_main.hwas_prozesse_bsi_bausteine
    add constraint fk_przpbsi_przp
        foreign key ( przp_uid_fk )
            references am_main.hwas_prozess ( przp_uid )
        enable;

