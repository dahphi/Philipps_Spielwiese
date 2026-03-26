create or replace editionable trigger awh_main.trg_awh_infosec_his_anlagenkat after
    delete or update on awh_main.awh_infosec_anlagenkat
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
    ) values ( 'AWH_INFOSEC_ANLAGENKAT',
               to_char(:old.asy_lfd_nr),
               to_char(:old.ank_lfd_nr),
               sysdate,
               :old.ank_user,
               :old.ank_kat1,
               :old.ank_kat2,
               :old.ank_kat3,
               :old.ank_funk );

end;
/

alter trigger awh_main.trg_awh_infosec_his_anlagenkat enable;


-- sqlcl_snapshot {"hash":"24ac9774f3ea8c29eb878cd85f7d6b304e8a421a","type":"TRIGGER","name":"TRG_AWH_INFOSEC_HIS_ANLAGENKAT","schemaName":"AWH_MAIN","sxml":""}