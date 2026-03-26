create or replace editionable trigger awh_main.trg_awh_infosec_his_comp after
    delete or update on awh_main.awh_infosec_comp
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
    ) values ( 'AWH_INFOSEC_COMP',
               to_char(:old.asy_lfd_nr),
               to_char(:old.cop_lfd_nr),
               to_char(:old.cop_timestamp),
               :old.cop_user,
               to_char(:old.cop_dsgvo),
               to_char(:old.cop_betrvg),
               to_char(:old.cop_kritisv),
               :old.cop_elem_infra );

end;
/

alter trigger awh_main.trg_awh_infosec_his_comp enable;


-- sqlcl_snapshot {"hash":"5f129960d1e7f69bb57df7b2aeb41ddc20b04187","type":"TRIGGER","name":"TRG_AWH_INFOSEC_HIS_COMP","schemaName":"AWH_MAIN","sxml":""}