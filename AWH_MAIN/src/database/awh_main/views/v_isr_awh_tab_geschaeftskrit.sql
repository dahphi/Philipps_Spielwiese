create or replace force editionable view awh_main.v_isr_awh_tab_geschaeftskrit (
    gek_lfd_nr,
    gek_name
) as
    select
        gek_lfd_nr,
        gek_name
    from
        awh_tab_geschaeftskrit;


-- sqlcl_snapshot {"hash":"6f2079a55eaa7a471149a190d3195391a44d3620","type":"VIEW","name":"V_ISR_AWH_TAB_GESCHAEFTSKRIT","schemaName":"AWH_MAIN","sxml":""}