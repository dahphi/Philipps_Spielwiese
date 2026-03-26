create or replace editionable trigger awh_main.trg_awh_infosec_his_eb_9 after
    delete or update on awh_main.awh_erhebungsbogen_9
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
        ihi_val8,
        ihi_val9,
        ihi_val10,
        ihi_val11,
        ihi_val12,
        ihi_val13
    ) values ( 'AWH_ERHEBUNGSBOGEN_9',
               to_char(:new.asy_lfd_nr),
               to_char(:new.eb9_lfd_nr),
               sysdate,
               :new.eb9_user,
               :new.eb9_ds_itsicherheit_grund,
               to_char(:new.eb9_risikoanalyse_erfolgt),
               to_char(:new.eb9_massnahmen_sicherheitskonz),
               :new.eb9_anonym_pseudonym,
               null,
               :new.eb9_backup,
               :new.eb9_redundantedaten,
               null,
               null,
               null,
               :new.eb9_schutzderrechte,
               :new.eb9_protokollierung,
               :new.eb9_pruefung_abstaende );

end;
/

alter trigger awh_main.trg_awh_infosec_his_eb_9 enable;


-- sqlcl_snapshot {"hash":"27e61fa0f4de225b7edac8ab3808f62e4f77262a","type":"TRIGGER","name":"TRG_AWH_INFOSEC_HIS_EB_9","schemaName":"AWH_MAIN","sxml":""}