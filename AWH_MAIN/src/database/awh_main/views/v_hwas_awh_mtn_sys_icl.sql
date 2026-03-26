create or replace force editionable view awh_main.v_hwas_awh_mtn_sys_icl (
    sic_asy_icl,
    asy_lfd_nr,
    icl_uid,
    sic_user,
    sic_timestamp
) as
    select
        sic_asy_icl,
        asy_lfd_nr,
        icl_uid,
        sic_user,
        sic_timestamp
    from
        awh_mtn_sys_icl;


-- sqlcl_snapshot {"hash":"de87460df12c1fa8b8fd639ae5c57ceaf22bd670","type":"VIEW","name":"V_HWAS_AWH_MTN_SYS_ICL","schemaName":"AWH_MAIN","sxml":""}