-- liquibase formatted sql
-- changeset AM_MAIN:1774600122356 stripComments:false logicalFilePath:am_main/am_main/ref_constraints/fk_przp_asy_przp.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot AM_MAIN/src/database/am_main/ref_constraints/fk_przp_asy_przp.sql:null:db6976397ec0eed9bab6efe4ef08097818a0b903:create

alter table am_main.hwas_prozess_system
    add constraint fk_przp_asy_przp
        foreign key ( przp_uid_fk )
            references am_main.hwas_prozess ( przp_uid )
        enable;

