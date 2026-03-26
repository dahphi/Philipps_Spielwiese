create or replace editionable trigger awh_main.trg_awh_infosec_his_tom_in after
    delete or update on awh_main.awh_infosec_tom_in
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
        ihi_val3
    ) values ( 'AWH_INFOSEC_TOM_IN',
               to_char(:old.asy_lfd_nr),
               to_char(:old.tin_lfd_nr),
               to_char(:old.tin_timestamp),
               :old.tin_user,
               to_char(:old.tin_kontrolle),
               to_char(:old.adt_lfd_nr),
               to_char(:old.chm_lfd_nr) );

end;
/

alter trigger awh_main.trg_awh_infosec_his_tom_in enable;


-- sqlcl_snapshot {"hash":"0f396d9383f2a68da9bbfea57221362b01c1ce50","type":"TRIGGER","name":"TRG_AWH_INFOSEC_HIS_TOM_IN","schemaName":"AWH_MAIN","sxml":""}