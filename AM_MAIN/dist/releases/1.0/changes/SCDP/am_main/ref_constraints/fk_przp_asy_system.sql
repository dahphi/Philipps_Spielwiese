-- liquibase formatted sql
-- changeset AM_MAIN:1774556572325 stripComments:false logicalFilePath:SCDP/am_main/ref_constraints/fk_przp_asy_system.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot AM_MAIN/src/database/am_main/ref_constraints/fk_przp_asy_system.sql:null:267930730505581d406cbe8a0584caaaed72cf55:create

alter table am_main.hwas_prozess_system
    add constraint fk_przp_asy_system
        foreign key ( asy_lfd_nr_fk )
            references awh_main.awh_system ( asy_lfd_nr )
        enable;

