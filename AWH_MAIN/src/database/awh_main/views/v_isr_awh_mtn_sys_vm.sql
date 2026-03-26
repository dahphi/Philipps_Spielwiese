create or replace force editionable view awh_main.v_isr_awh_mtn_sys_vm (
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


-- sqlcl_snapshot {"hash":"ebc7cb12bc7cd7dd3e2ae16c9ab2e23172aea9c4","type":"VIEW","name":"V_ISR_AWH_MTN_SYS_VM","schemaName":"AWH_MAIN","sxml":""}