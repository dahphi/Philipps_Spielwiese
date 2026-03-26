-- liquibase formatted sql
-- changeset APEX_EXPORT_USER:1774559729213 stripComments:false logicalFilePath:SCDP/apex_export_user/indexes/emp_manager_ix.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot SQLCL_TEST/src/database/apex_export_user/indexes/emp_manager_ix.sql:null:90802b3974d7cebf95376c4426030da5ab133467:create

create index apex_export_user.emp_manager_ix on
    apex_export_user.employees (
        manager_id
    );

