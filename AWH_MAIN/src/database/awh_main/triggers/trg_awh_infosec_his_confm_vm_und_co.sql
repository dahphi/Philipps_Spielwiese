create or replace editionable trigger awh_main.trg_awh_infosec_his_confm_vm_und_co after
    delete or update on awh_main.awh_confm_vm_und_co
    for each row
begin
    insert into awh_infosec_historie (
        ihi_table,
        asy_lfd_nr,
        ihi_tbl_lfd_nr,
        ihi_timestamp,
        ihi_user,
        ihi_val1,
        ihi_val2,
        ihi_val3,
        ihi_val4
    ) values ( 'AWH_CONFM_VM_UND_CO',
               to_char(:old.asy_lfd_nr),
               to_char(:old.vvg_lfd_nr),
               sysdate,
               :old.vvg_user,
               :old.vvg_gvb,
               :old.vvg_vms,
               :old.vvg_geraet,
               :old.vvg_was );

end;
/

alter trigger awh_main.trg_awh_infosec_his_confm_vm_und_co enable;


-- sqlcl_snapshot {"hash":"23920f15ac7234aeb3de925f27c3afeea86ebfb3","type":"TRIGGER","name":"TRG_AWH_INFOSEC_HIS_CONFM_VM_UND_CO","schemaName":"AWH_MAIN","sxml":""}