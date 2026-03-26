create or replace editionable trigger awh_main.trg_awh_infosec_his_sysverbindung after
    delete or update on awh_main.awh_infosec_sysverbindung
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
        ihi_val7
    ) values ( 'AWH_INFOSEC_SYSVERBINDUNG',
               to_char(:old.asy_lfd_nr_out),
               to_char(:old.svb_lfd_nr),
               to_char(:old.svb_timestamp),
               :old.svb_user,
               to_char(:old.asy_lfd_nr_in),
               to_char(:old.trv_lfd_nr),
               to_char(:old.vet_lfd_nr),
               to_char(:old.int_lfd_nr),
               to_char(:old.vef_lfd_nr),
               to_char(:old.aut_lfd_nr),
               :old.svb_erlauterung );

end;
/

alter trigger awh_main.trg_awh_infosec_his_sysverbindung enable;


-- sqlcl_snapshot {"hash":"3366d3166aeaff3c90e243a31aa9bebea7395835","type":"TRIGGER","name":"TRG_AWH_INFOSEC_HIS_SYSVERBINDUNG","schemaName":"AWH_MAIN","sxml":""}