-- liquibase formatted sql
-- changeset AM_MAIN:1774600122397 stripComments:false logicalFilePath:am_main/am_main/ref_constraints/fk_przp_przp.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot AM_MAIN/src/database/am_main/ref_constraints/fk_przp_przp.sql:null:9c8123042c32c5aa63639366ab3b74bcec2ca1da:create

alter table am_main.hwas_prozesse_vertragsdetails
    add constraint fk_przp_przp
        foreign key ( przp_uid_fk )
            references am_main.hwas_prozess ( przp_uid )
        enable;

