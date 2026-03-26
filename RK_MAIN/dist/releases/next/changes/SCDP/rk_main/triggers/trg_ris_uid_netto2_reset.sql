-- liquibase formatted sql
-- changeset RK_MAIN:1774561695297 stripComments:false logicalFilePath:SCDP/rk_main/triggers/trg_ris_uid_netto2_reset.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot RK_MAIN/src/database/rk_main/triggers/trg_ris_uid_netto2_reset.sql:null:33e40414c201f77a7f74e40ebc26e899b6280025:create

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

