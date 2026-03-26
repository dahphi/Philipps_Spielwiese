create or replace force editionable view awh_main.v_hwas_awh_mtn_sys_grt (
    sgr_asy_grt,
    asy_lfd_nr,
    grt_uid,
    sgr_user,
    sgr_timestamp
) as
    select
        sgr_asy_grt,
        asy_lfd_nr,
        grt_uid,
        sgr_user,
        sgr_timestamp
    from
        awh_mtn_sys_grt;


-- sqlcl_snapshot {"hash":"5666f6ae73dbf084e0a4849c08975f35148e0369","type":"VIEW","name":"V_HWAS_AWH_MTN_SYS_GRT","schemaName":"AWH_MAIN","sxml":""}