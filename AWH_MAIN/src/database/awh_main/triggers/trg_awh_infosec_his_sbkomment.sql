create or replace editionable trigger awh_main.trg_awh_infosec_his_sbkomment after
    delete or update on awh_main.awh_infosec_sbkomment
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
    ) values ( 'AWH_INFOSEC_SBKOMMENT',
               to_char(:old.asy_lfd_nr),
               to_char(:old.sbk_lfd_nr),
               to_char(:old.sbk_timestamp),
               :old.sbk_user,
               :old.sbk_vet,
               :old.sbk_int,
               :old.sbk_vef,
               :old.sbk_aut );

end;
/

alter trigger awh_main.trg_awh_infosec_his_sbkomment enable;


-- sqlcl_snapshot {"hash":"79b887092122b1c9d518c7d438584e732635f060","type":"TRIGGER","name":"TRG_AWH_INFOSEC_HIS_SBKOMMENT","schemaName":"AWH_MAIN","sxml":""}