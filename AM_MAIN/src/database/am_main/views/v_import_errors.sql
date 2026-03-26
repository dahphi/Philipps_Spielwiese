create or replace force editionable view am_main.v_import_errors (
    routine_name,
    message
) as
    select
        routine_name,
        message
    from
        core.logs;


-- sqlcl_snapshot {"hash":"8a22b8b9b3d39b62eb224f23a3f4aab4d4cde94f","type":"VIEW","name":"V_IMPORT_ERRORS","schemaName":"AM_MAIN","sxml":""}