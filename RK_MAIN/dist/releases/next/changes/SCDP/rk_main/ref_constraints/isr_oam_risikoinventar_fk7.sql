-- liquibase formatted sql
-- changeset RK_MAIN:1774555712865 stripComments:false logicalFilePath:SCDP/rk_main/ref_constraints/isr_oam_risikoinventar_fk7.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot RK_MAIN/src/database/rk_main/ref_constraints/isr_oam_risikoinventar_fk7.sql:null:47ad96142788145f55ee343b6f14ed7574c6d4b0:create

alter table rk_main.isr_oam_risikoinventar
    add constraint isr_oam_risikoinventar_fk7
        foreign key ( ska_uid )
            references rk_main.isr_brm_schwachstellenkat ( ska_uid )
        enable;

