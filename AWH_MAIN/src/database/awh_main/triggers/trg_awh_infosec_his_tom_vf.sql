create or replace editionable trigger awh_main.trg_awh_infosec_his_tom_vf after
    delete or update on awh_main.awh_infosec_tom_vf
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
    ) values ( 'AWH_INFOSEC_TOM_VF',
               to_char(:old.asy_lfd_nr),
               to_char(:old.tvf_lfd_nr),
               to_char(:old.tvf_timestamp),
               :old.tvf_user,
               to_char(:old.zet_lfd_nr),
               to_char(:old.ueb_lfd_nr),
               to_char(:old.asf_lfd_nr) );

end;
/

alter trigger awh_main.trg_awh_infosec_his_tom_vf enable;


-- sqlcl_snapshot {"hash":"57b2e23e2e68e16f6719972df935a653fad8ccdb","type":"TRIGGER","name":"TRG_AWH_INFOSEC_HIS_TOM_VF","schemaName":"AWH_MAIN","sxml":""}