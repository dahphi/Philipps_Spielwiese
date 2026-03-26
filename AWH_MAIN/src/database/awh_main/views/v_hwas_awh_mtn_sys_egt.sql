create or replace force editionable view awh_main.v_hwas_awh_mtn_sys_egt (
    seg_asy_egt,
    asy_lfd_nr,
    egt_uid,
    seg_user,
    seg_timestamp
) as
    select
        seg_asy_egt,
        asy_lfd_nr,
        egt_uid,
        seg_user,
        seg_timestamp
    from
        awh_mtn_sys_egt;


-- sqlcl_snapshot {"hash":"603a1406051f4b7ed1ec829a3adb4f3ddfa36b14","type":"VIEW","name":"V_HWAS_AWH_MTN_SYS_EGT","schemaName":"AWH_MAIN","sxml":""}