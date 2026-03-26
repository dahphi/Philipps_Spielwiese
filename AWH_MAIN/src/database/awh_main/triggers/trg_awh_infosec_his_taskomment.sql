create or replace editionable trigger awh_main.trg_awh_infosec_his_taskomment after
    delete or update on awh_main.awh_infosec_taskomment
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
    ) values ( 'AWH_INFOSEC_TASKOMMENT',
               to_char(:old.asy_lfd_nr),
               to_char(:old.tsk_lfd_nr),
               to_char(:old.tsk_timestamp),
               :old.tsk_user,
               :old.tsk_vet,
               :old.tsk_int,
               :old.tsk_vef,
               :old.tsk_aut );

end;
/

alter trigger awh_main.trg_awh_infosec_his_taskomment enable;


-- sqlcl_snapshot {"hash":"3cb81c26daac587609b07ca4f6ffa347ba6aa208","type":"TRIGGER","name":"TRG_AWH_INFOSEC_HIS_TASKOMMENT","schemaName":"AWH_MAIN","sxml":""}