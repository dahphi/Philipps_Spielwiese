prompt --application/deployment/install/install_trigger_trg_vc_hist
begin
--   Manifest
--     INSTALL: INSTALL-Trigger: TRG_VC_HIST
--   Manifest End
wwv_flow_imp.component_begin (
 p_version_yyyy_mm_dd=>'2024.11.30'
,p_release=>'24.2.3'
,p_default_workspace_id=>2800197248760671
,p_default_application_id=>1210
,p_default_id_offset=>61532733767019240
,p_default_owner=>'ROMA_MAIN'
);
wwv_flow_imp_shared.create_install_script(
 p_id=>wwv_flow_imp.id(90315223378700130)
,p_install_id=>wwv_flow_imp.id(188324513986339742)
,p_name=>'Trigger: TRG_VC_HIST'
,p_sequence=>30
,p_script_type=>'INSTALL'
,p_condition_type=>'EXISTS'
,p_condition=>'SELECT 1 FROM USER_TABLES WHERE TABLE_NAME = ''VC_HIST'''
,p_script_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'create or replace TRIGGER "TRG_VC_HIST" ',
'before update of STATUS, AUSBAU_PLAN_TERMIN or insert or delete on VERMARKTUNGSCLUSTER',
'for each row',
'begin',
'    if updating and :new.STATUS != :old.STATUS or :new.AUSBAU_PLAN_TERMIN != :old.AUSBAU_PLAN_TERMIN then',
'        insert into vc_hist (',
'            vc_hist_id,',
'            operation,',
'            vc_lfd_nr,',
'            VORHERIGER_STATUS,',
'            AKTUELLER_STATUS,',
'            STATUS_AENDERUNGSDATUM,',
'            VORHERIGER_AUSBAU_PLAN_TERMIN,',
'            AKTUELLER_AUSBAU_PLAN_TERMIN,',
'            AUSBAU_PLAN_TERMIN_AENDERUNGSDATUM,',
'            AENDERUNGSDATUM',
'        ) ',
'        values (',
'            vc_hist_seq.nextval,',
'            ''U'',',
'            :old.vc_lfd_nr,',
'            :old.STATUS,',
'            :new.STATUS,',
'            case when :new.STATUS != :old.STATUS then SYSDATE end,',
'            :old.AUSBAU_PLAN_TERMIN,',
'            :new.AUSBAU_PLAN_TERMIN,',
'            case when :new.AUSBAU_PLAN_TERMIN != :old.AUSBAU_PLAN_TERMIN then SYSDATE end,',
'            SYSDATE',
'        );',
'    elsif inserting then',
'        insert into vc_hist (',
'            vc_hist_id,',
'            operation,',
'            vc_lfd_nr,',
'            VORHERIGER_STATUS,',
'            AKTUELLER_STATUS,',
'            STATUS_AENDERUNGSDATUM,',
'            VORHERIGER_AUSBAU_PLAN_TERMIN,',
'            AKTUELLER_AUSBAU_PLAN_TERMIN,',
'            AUSBAU_PLAN_TERMIN_AENDERUNGSDATUM,',
'            AENDERUNGSDATUM',
'        ) ',
'        values (',
'            vc_hist_seq.nextval,',
'            ''I'',',
'            :new.vc_lfd_nr,',
'            null,',
'            :new.STATUS,',
'            null,',
'            null,',
'            :new.AUSBAU_PLAN_TERMIN,',
'            null,',
'            SYSDATE',
'        );',
'    elsif deleting then',
'        insert into vc_hist (',
'            vc_hist_id,',
'            operation,',
'            vc_lfd_nr,',
'            VORHERIGER_STATUS,',
'            AKTUELLER_STATUS,',
'            STATUS_AENDERUNGSDATUM,',
'            VORHERIGER_AUSBAU_PLAN_TERMIN,',
'            AKTUELLER_AUSBAU_PLAN_TERMIN,',
'            AUSBAU_PLAN_TERMIN_AENDERUNGSDATUM,',
'            AENDERUNGSDATUM',
'        ) ',
'        values (',
'            vc_hist_seq.nextval,',
'            ''D'',',
'            :old.vc_lfd_nr,',
'            null,',
'            :old.STATUS,',
'            null,',
'            null,',
'            :old.AUSBAU_PLAN_TERMIN,',
'            null,',
'            SYSDATE',
'        );',
'    end if;',
'end;',
'/ '))
);
wwv_flow_imp_shared.create_install_object(
 p_id=>wwv_flow_imp.id(90315263576700131)
,p_script_id=>wwv_flow_imp.id(90315223378700130)
,p_object_owner=>'#OWNER#'
,p_object_type=>'TRIGGER'
,p_object_name=>'TRG_VC_HIST'
);
wwv_flow_imp.component_end;
end;
/
