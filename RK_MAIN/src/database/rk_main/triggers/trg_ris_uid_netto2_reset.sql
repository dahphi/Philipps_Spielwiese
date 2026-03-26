create or replace editionable trigger rk_main.trg_ris_uid_netto2_reset before
    update of ris_uid on rk_main.isr_oam_risikoinventar
    for each row
begin
    if
        :new.ris_uid = 269631043604196086024472092990263820296
        and nvl(:old.ris_uid,
                -1) <> :new.ris_uid
    then
        :new.netto2_ews_uid := null;
        :new.netto2_auw_uid := null;
    end if;
end;
/

alter trigger rk_main.trg_ris_uid_netto2_reset enable;


-- sqlcl_snapshot {"hash":"dd22072c60d235bab061fb8f7eb1e9872f816511","type":"TRIGGER","name":"TRG_RIS_UID_NETTO2_RESET","schemaName":"RK_MAIN","sxml":""}