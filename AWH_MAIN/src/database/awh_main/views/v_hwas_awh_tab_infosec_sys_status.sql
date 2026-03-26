create or replace force editionable view awh_main.v_hwas_awh_tab_infosec_sys_status (
    sta_lfd_nr,
    sta_name
) as
    select
        sta_lfd_nr,
        sta_name
    from
        awh_tab_infosec_sys_status;


-- sqlcl_snapshot {"hash":"890ac28ec5a64b7a552bac022ee4e7f569696299","type":"VIEW","name":"V_HWAS_AWH_TAB_INFOSEC_SYS_STATUS","schemaName":"AWH_MAIN","sxml":""}