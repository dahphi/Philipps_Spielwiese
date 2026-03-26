create or replace editionable trigger rk_main.trg_ska_uid_netto2_reset before
    update of ska_uid on rk_main.isr_oam_risikoinventar
    for each row
begin
    if
        :new.ska_uid = 269631043604196086024472092990263820296
        and nvl(:old.ska_uid,
                -1) <> :new.ska_uid
    then
        :new.netto2_ews_uid := null;
        :new.netto2_auw_uid := null;
    end if;
end;
/

alter trigger rk_main.trg_ska_uid_netto2_reset enable;


-- sqlcl_snapshot {"hash":"fe8a348a449f2fe4ef66603e1e8cd941b7eea1ea","type":"TRIGGER","name":"TRG_SKA_UID_NETTO2_RESET","schemaName":"RK_MAIN","sxml":""}