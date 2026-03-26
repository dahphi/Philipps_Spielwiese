-- liquibase formatted sql
-- changeset APEX_EXPORT_USER:1774559729268 stripComments:false logicalFilePath:SCDP/apex_export_user/ref_constraints/dept_loc_fk.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot SQLCL_TEST/src/database/apex_export_user/ref_constraints/dept_loc_fk.sql:null:e29854218e6f5130fe50628daf64cb27c337aa77:create

alter table apex_export_user.departments
    add constraint dept_loc_fk
        foreign key ( location_id )
            references apex_export_user.locations ( location_id )
        enable;

