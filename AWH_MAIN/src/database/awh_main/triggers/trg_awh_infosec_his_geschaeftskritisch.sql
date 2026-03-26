create or replace editionable trigger awh_main.trg_awh_infosec_his_geschaeftskritisch after
    delete or update on awh_main.awh_infosec_geschaeftskritisch
    for each row
begin
    insert into awh_infosec_historie (
        ihi_table,
        asy_lfd_nr,
        ihi_tbl_lfd_nr,
        ihi_timestamp,
        ihi_user,
        ihi_val1
    ) values ( 'AWH_INFOSEC_GESCHAEFTSKRITISCH',
               to_char(:old.asy_lfd_nr),
               to_char(:old.gks_lfd_nr),
               to_char(:old.gks_timestamp),
               :old.gks_user,
               to_char(:old.gek_lfd_nr) );

end;
/

alter trigger awh_main.trg_awh_infosec_his_geschaeftskritisch enable;


-- sqlcl_snapshot {"hash":"7a2d6aa9cf29334c9180840646b11f58a8c0385b","type":"TRIGGER","name":"TRG_AWH_INFOSEC_HIS_GESCHAEFTSKRITISCH","schemaName":"AWH_MAIN","sxml":""}