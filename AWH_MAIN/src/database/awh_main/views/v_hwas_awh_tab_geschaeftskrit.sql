create or replace force editionable view awh_main.v_hwas_awh_tab_geschaeftskrit (
    gek_lfd_nr,
    gek_name
) as
    select
        gek_lfd_nr,
        gek_name
    from
        awh_tab_geschaeftskrit;


-- sqlcl_snapshot {"hash":"8b4840c5412a5fe71a2ff40caf5043414c8a449a","type":"VIEW","name":"V_HWAS_AWH_TAB_GESCHAEFTSKRIT","schemaName":"AWH_MAIN","sxml":""}