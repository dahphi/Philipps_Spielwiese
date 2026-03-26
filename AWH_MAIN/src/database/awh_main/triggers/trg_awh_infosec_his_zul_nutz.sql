create or replace editionable trigger awh_main.trg_awh_infosec_his_zul_nutz after
    delete or update on awh_main.awh_infosec_zul_nutzung
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
    ) values ( 'AWH_INFOSEC_ZUL_NUTZUNG',
               to_char(:old.asy_lfd_nr),
               to_char(:old.zul_lfd_nr),
               sysdate,
               :old.zul_user,
               to_char(:old.zdf_lfd_nr),
               to_char(:old.zul_referenz_regel),
               to_char(:old.zul_kennzeichnung) );

end;
/

alter trigger awh_main.trg_awh_infosec_his_zul_nutz enable;


-- sqlcl_snapshot {"hash":"638222799107ed1817c741cd59cf29308d98537f","type":"TRIGGER","name":"TRG_AWH_INFOSEC_HIS_ZUL_NUTZ","schemaName":"AWH_MAIN","sxml":""}