create or replace TRIGGER "TRG_VC_HIST" 
before update of STATUS, AUSBAU_PLAN_TERMIN or insert or delete on VERMARKTUNGSCLUSTER
for each row
begin
    if updating and ( :new.STATUS != :old.STATUS or :new.AUSBAU_PLAN_TERMIN != :old.AUSBAU_PLAN_TERMIN ) then
        insert into vc_hist (
            vc_hist_id,
            operation,
            vc_lfd_nr,
            VORHERIGER_STATUS,
            AKTUELLER_STATUS,
            STATUS_AENDERUNGSDATUM,
            VORHERIGER_AUSBAU_PLAN_TERMIN,
            AKTUELLER_AUSBAU_PLAN_TERMIN,
            AUSBAU_PLAN_TERMIN_AENDERUNGSDATUM,
            AENDERUNGSDATUM,
            LOESCHGRUND
        ) 
        values (
            vc_hist_seq.nextval,
            'U',
            :old.vc_lfd_nr,
            :old.STATUS,
            :new.STATUS,
            case when :new.STATUS != :old.STATUS then SYSDATE end,
            :old.AUSBAU_PLAN_TERMIN,
            :new.AUSBAU_PLAN_TERMIN,
            case when :new.AUSBAU_PLAN_TERMIN != :old.AUSBAU_PLAN_TERMIN then SYSDATE end,
            SYSDATE,
            null
        );
    elsif inserting then
        insert into vc_hist (
            vc_hist_id,
            operation,
            vc_lfd_nr,
            VORHERIGER_STATUS,
            AKTUELLER_STATUS,
            STATUS_AENDERUNGSDATUM,
            VORHERIGER_AUSBAU_PLAN_TERMIN,
            AKTUELLER_AUSBAU_PLAN_TERMIN,
            AUSBAU_PLAN_TERMIN_AENDERUNGSDATUM,
            AENDERUNGSDATUM,
            LOESCHGRUND
        ) 
        values (
            vc_hist_seq.nextval,
            'I',
            :new.vc_lfd_nr,
            null,
            :new.STATUS,
            null,
            null,
            :new.AUSBAU_PLAN_TERMIN,
            null,
            SYSDATE,
            null
        );
    elsif deleting then
        insert into vc_hist (
            vc_hist_id,
            operation,
            vc_lfd_nr,
            VORHERIGER_STATUS,
            AKTUELLER_STATUS,
            STATUS_AENDERUNGSDATUM,
            VORHERIGER_AUSBAU_PLAN_TERMIN,
            AKTUELLER_AUSBAU_PLAN_TERMIN,
            AUSBAU_PLAN_TERMIN_AENDERUNGSDATUM,
            AENDERUNGSDATUM,
            LOESCHGRUND
        ) 
        values (
            vc_hist_seq.nextval,
            'D',
            :old.vc_lfd_nr,
            null,
            :old.STATUS,
            null,
            null,
            :old.AUSBAU_PLAN_TERMIN,
            null,
            SYSDATE,
            :old.loeschgrund
        );
    end if;
end;
/


-- sqlcl_snapshot {"hash":"82f935d917177125f6a8a436ca92741949f4365c","type":"APEX_APPLICATION","name":"f1210","schemaName":"APEX_EXPORT_USER"}