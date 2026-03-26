create or replace force editionable view awh_main.v_isr_awh_tab_infosec_sys_status (
    sta_lfd_nr,
    sta_name
) as
    select
        sta_lfd_nr,
        sta_name
    from
        awh_tab_infosec_sys_status;


-- sqlcl_snapshot {"hash":"3e3a4ec4a6fb2cc76cc545983f3dd3687fb6dd4c","type":"VIEW","name":"V_ISR_AWH_TAB_INFOSEC_SYS_STATUS","schemaName":"AWH_MAIN","sxml":""}