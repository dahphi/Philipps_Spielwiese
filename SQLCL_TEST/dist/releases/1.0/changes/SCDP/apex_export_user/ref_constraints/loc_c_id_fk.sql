-- liquibase formatted sql
-- changeset APEX_EXPORT_USER:1774560975013 stripComments:false logicalFilePath:SCDP/apex_export_user/ref_constraints/loc_c_id_fk.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot SQLCL_TEST/src/database/apex_export_user/ref_constraints/loc_c_id_fk.sql:null:b967f05f08a2d095f0b4e9d43426668a8e274de7:create

alter table apex_export_user.locations
    add constraint loc_c_id_fk
        foreign key ( country_id )
            references apex_export_user.countries ( country_id )
        enable;

