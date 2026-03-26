-- liquibase formatted sql
-- changeset AM_MAIN:1774557220980 stripComments:false logicalFilePath:SCDP/am_main/ref_constraints/fk_hwas_prozessstufe_parent.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot AM_MAIN/src/database/am_main/ref_constraints/fk_hwas_prozessstufe_parent.sql:null:c34e3f4f584a8c4c39872e920ca56eb6a9d5de8e:create

alter table am_main.hwas_prozessstufe
    add constraint fk_hwas_prozessstufe_parent
        foreign key ( parent_przs_uid )
            references am_main.hwas_prozessstufe ( przs_uid )
        enable;

