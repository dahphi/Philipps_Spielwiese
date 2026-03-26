create or replace editionable trigger awh_main.trg_awh_infosec_his_tom_handbuch after
    delete or update on awh_main.awh_infosec_tom_handbuch
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
        ihi_val4,
        ihi_val5,
        ihi_val6,
        ihi_val7,
        ihi_val8
    ) values ( 'AWH_INFOSEC_TOM_HANDBUCH',
               to_char(:old.asy_lfd_nr),
               to_char(:old.hnb_lfd_nr),
               to_char(:old.hnb_timestamp),
               :old.hnb_user,
               :old.hnb_patch_chng,
               :old.hnb_zugangsverw,
               :old.hnb_wiederanlauf,
               :old.hnb_buch1,
               :old.hnb_buch2,
               :old.hnb_buch3,
               :old.hnb_buch4,
               :old.hnb_buch5 );

end;
/

alter trigger awh_main.trg_awh_infosec_his_tom_handbuch enable;


-- sqlcl_snapshot {"hash":"19dfeebee74588a46cf9ce252f2ef980df37bd2b","type":"TRIGGER","name":"TRG_AWH_INFOSEC_HIS_TOM_HANDBUCH","schemaName":"AWH_MAIN","sxml":""}