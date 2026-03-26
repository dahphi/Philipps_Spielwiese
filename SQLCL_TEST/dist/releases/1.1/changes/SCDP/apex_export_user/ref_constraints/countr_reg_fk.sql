-- liquibase formatted sql
-- changeset APEX_EXPORT_USER:1774559152751 stripComments:false logicalFilePath:SCDP/apex_export_user/ref_constraints/countr_reg_fk.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot SQLCL_TEST/src/database/apex_export_user/ref_constraints/countr_reg_fk.sql:null:b7ba2f4c38fdc02b263c0d9c5bec02cd611ea2c1:create

alter table apex_export_user.countries
    add constraint countr_reg_fk
        foreign key ( region_id )
            references apex_export_user.regions ( region_id )
        enable;

