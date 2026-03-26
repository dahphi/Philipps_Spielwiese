-- liquibase formatted sql
-- changeset AM_MAIN:1774556572388 stripComments:false logicalFilePath:SCDP/am_main/ref_constraints/hwas_geraet_fk4.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot AM_MAIN/src/database/am_main/ref_constraints/hwas_geraet_fk4.sql:null:e1bd35522a3f8119dbe376600ea99634e2bdd8a2:create

alter table am_main.hwas_geraet
    add constraint hwas_geraet_fk4
        foreign key ( hst_uid )
            references am_main.hwas_hersteller ( hst_uid )
        enable;

