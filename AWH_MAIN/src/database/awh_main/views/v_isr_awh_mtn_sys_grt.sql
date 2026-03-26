create or replace force editionable view awh_main.v_isr_awh_mtn_sys_grt (
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


-- sqlcl_snapshot {"hash":"f0033ca6d01d001d62352559a18101ea3d962c8b","type":"VIEW","name":"V_ISR_AWH_MTN_SYS_GRT","schemaName":"AWH_MAIN","sxml":""}