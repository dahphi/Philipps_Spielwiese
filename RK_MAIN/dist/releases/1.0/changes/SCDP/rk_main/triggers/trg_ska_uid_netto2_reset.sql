-- liquibase formatted sql
-- changeset RK_MAIN:1774561695310 stripComments:false logicalFilePath:SCDP/rk_main/triggers/trg_ska_uid_netto2_reset.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot RK_MAIN/src/database/rk_main/triggers/trg_ska_uid_netto2_reset.sql:null:bf617c7aafc5c3fab35584fbe2b1fa0fbb9822a6:create

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

