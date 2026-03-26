-- liquibase formatted sql
-- changeset RK_MAIN:1774554920721 stripComments:false logicalFilePath:SCDP/rk_main/ref_constraints/asm_isr_assets_risken_fk2.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot RK_MAIN/src/database/rk_main/ref_constraints/asm_isr_assets_risken_fk2.sql:null:b134f6d67445f140c1cde853637bfd0c40199243:create

alter table rk_main.asm_isr_assets_risiken
    add constraint asm_isr_assets_risken_fk2
        foreign key ( rsk_uid )
            references rk_main.isr_oam_risikoinventar ( rsk_uid )
        enable;

