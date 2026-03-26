-- liquibase formatted sql
-- changeset AM_MAIN:1774557122326 stripComments:false logicalFilePath:SCDP/am_main/views/v_import_errors.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot AM_MAIN/src/database/am_main/views/v_import_errors.sql:null:8a22b8b9b3d39b62eb224f23a3f4aab4d4cde94f:create

create or replace force editionable view am_main.v_import_errors (
    routine_name,
    message
) as
    select
        routine_name,
        message
    from
        core.logs;

