create or replace editionable trigger awh_main.trg_awh_infosec_his_tom_at after
    delete or update on awh_main.awh_infosec_tom_at
    for each row
begin
    insert into awh_infosec_historie (
        ihi_table,
        asy_lfd_nr,
        ihi_tbl_lfd_nr,
        ihi_timestamp,
        ihi_user,
        ihi_val1
    ) values ( 'AWH_INFOSEC_TOM_AT',
               to_char(:old.asy_lfd_nr),
               to_char(:old.tat_lfd_nr),
               to_char(:old.tat_timestamp),
               :old.tat_user,
               to_char(:old.mfa_lfd_nr) );

end;
/

alter trigger awh_main.trg_awh_infosec_his_tom_at enable;


-- sqlcl_snapshot {"hash":"d95e0eefaaab74c3c16282f9ef4c805f32eb69c2","type":"TRIGGER","name":"TRG_AWH_INFOSEC_HIS_TOM_AT","schemaName":"AWH_MAIN","sxml":""}