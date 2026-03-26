create or replace editionable trigger awh_main.awh_eudsgvo_tab_benkat_bui before
    insert or update on awh_main.awh_eudsgvo_tab_benkat
    for each row
begin
    if :new.bka_lfd_nr is null then
        :new.bka_lfd_nr := to_number ( sys_guid(), 'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX' );
    end if;
end awh_eudsgvo_tab_benkat_bui;
/

alter trigger awh_main.awh_eudsgvo_tab_benkat_bui enable;


-- sqlcl_snapshot {"hash":"7b6fa4d71f733af08beb6d4eaf84846d0d082bd2","type":"TRIGGER","name":"AWH_EUDSGVO_TAB_BENKAT_BUI","schemaName":"AWH_MAIN","sxml":""}