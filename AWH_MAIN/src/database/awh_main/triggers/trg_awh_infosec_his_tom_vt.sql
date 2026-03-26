create or replace editionable trigger awh_main.trg_awh_infosec_his_tom_vt after
    delete or update on awh_main.awh_infosec_tom_vt
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
    ) values ( 'AWH_INFOSEC_TOM_VT',
               to_char(:old.asy_lfd_nr),
               to_char(:old.tvt_lfd_nr),
               to_char(:old.tvt_timestamp),
               :old.tvt_user,
               to_char(:old.trv_lfd_nr),
               to_char(:old.sov_lfd_nr),
               :old.tvt_zugsteu,
               to_char(:old.tvt_berechtko),
               to_char(:old.tvt_rollen),
               to_char(:old.tvt_einerolle),
               to_char(:old.tvt_zugverw),
               to_char(:old.ere_lfd_nr) );

end;
/

alter trigger awh_main.trg_awh_infosec_his_tom_vt enable;


-- sqlcl_snapshot {"hash":"795bfc1acd72160e08aa335619d33438a8254702","type":"TRIGGER","name":"TRG_AWH_INFOSEC_HIS_TOM_VT","schemaName":"AWH_MAIN","sxml":""}