create or replace force editionable view awh_main.v_hwas_awh_mtn_sys_vm (
    asy_lfd_nr,
    vm_uid,
    sv_user,
    sv_timestamp,
    sv_uid
) as
    select
        asy_lfd_nr,
        vm_uid,
        sv_user,
        sv_timestamp,
        sv_uid
    from
        awh_mtn_sys_vm;


-- sqlcl_snapshot {"hash":"ccafef9780a3ef5f2bb07bf01faf71df61fdd5c6","type":"VIEW","name":"V_HWAS_AWH_MTN_SYS_VM","schemaName":"AWH_MAIN","sxml":""}