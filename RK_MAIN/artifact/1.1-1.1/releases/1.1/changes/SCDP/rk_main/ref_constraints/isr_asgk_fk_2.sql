-- liquibase formatted sql
-- changeset RK_MAIN:1774555712808 stripComments:false logicalFilePath:SCDP/rk_main/ref_constraints/isr_asgk_fk_2.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot RK_MAIN/src/database/rk_main/ref_constraints/isr_asgk_fk_2.sql:null:45aa50ab0e87a9c1840dd040a46431294d388f55:create

alter table rk_main.isr_assettypen_gefaehrdungkat
    add constraint isr_asgk_fk_2
        foreign key ( gfk_uid )
            references rk_main.isr_brm_gefaehrdungkat ( gfk_uid )
        enable;

