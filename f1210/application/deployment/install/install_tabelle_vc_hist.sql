prompt --application/deployment/install/install_tabelle_vc_hist
begin
--   Manifest
--     INSTALL: INSTALL-Tabelle: VC_HIST
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
 p_id=>wwv_flow_imp.id(90314923828695939)
,p_install_id=>wwv_flow_imp.id(188324513986339742)
,p_name=>'Tabelle: VC_HIST'
,p_sequence=>10
,p_script_type=>'INSTALL'
,p_condition_type=>'NOT_EXISTS'
,p_condition=>'SELECT 1 FROM USER_TABLES WHERE TABLE_NAME = ''VC_HIST'''
,p_script_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'CREATE TABLE VC_HIST (',
'    vc_hist_id NUMBER,',
'	vc_lfd_nr NUMBER,',
'    vorheriger_status VARCHAR(100),',
'    status_aenderungsdatum DATE,',
'	aktueller_status VARCHAR2(100),',
'	aktueller_ausbau_plan_termin DATE,',
'    vorheriger_ausbau_plan_termin DATE,',
'    ausbau_plan_termin_aenderungsdatum DATE,',
'	aenderungsdatum DATE,',
'	operation VARCHAR(100)',
');',
'CREATE UNIQUE INDEX "ROMA_MAIN"."VC_HIST_PK" ON "ROMA_MAIN"."VC_HIST" ("VC_HIST_ID");',
'ALTER TABLE "ROMA_MAIN"."VC_HIST" ADD CONSTRAINT "VC_HIST_PK" PRIMARY KEY ("VC_HIST_ID")',
'  USING INDEX "ROMA_MAIN"."VC_HIST_PK"  ENABLE;',
'  ',
'CREATE INDEX "ROMA_MAIN"."VC_HIST_VC_LFD_NR" ON "ROMA_MAIN"."VC_HIST" ("VC_LFD_NR"); ',
'',
'COMMENT ON COLUMN "ROMA_MAIN"."VC_HIST"."VC_LFD_NR" IS ''VC_LFD_NR'';',
unistr('COMMENT ON COLUMN "ROMA_MAIN"."VC_HIST"."VORHERIGER_STATUS" IS ''Status eines Vermarktungscluster-Objekts vor der \00C4nderung'';'),
unistr('COMMENT ON COLUMN "ROMA_MAIN"."VC_HIST"."STATUS_AENDERUNGSDATUM" IS ''Datum der \00C4nderung vom Objektstatus'';'),
unistr('COMMENT ON COLUMN "ROMA_MAIN"."VC_HIST"."VORHERIGER_AUSBAU_PLAN_TERMIN" IS ''Termin des Ausbaus vor der \00C4nderung'';'),
unistr('COMMENT ON COLUMN "ROMA_MAIN"."VC_HIST"."AUSBAU_PLAN_TERMIN_AENDERUNGSDATUM" IS ''Datum der \00C4nderung des Ausbautermins'';'),
unistr('COMMENT ON COLUMN "ROMA_MAIN"."VC_HIST"."AENDERUNGSDATUM" IS ''Datum der \00C4nderung an Objekten (INSERT, DELETE, UPDATE)'';'),
'COMMENT ON COLUMN "ROMA_MAIN"."VC_HIST"."OPERATION" IS ''Art der Operation an einem Objekt: INSERT, UPDATE, DELETE'';',
'COMMENT ON COLUMN "ROMA_MAIN"."VC_HIST"."VC_HIST_ID" IS ''PK'';',
unistr('COMMENT ON COLUMN "ROMA_MAIN"."VC_HIST"."AKTUELLER_STATUS" IS ''ge\00E4nderter Status'';'),
unistr('COMMENT ON COLUMN "ROMA_MAIN"."VC_HIST"."AKTUELLER_AUSBAU_PLAN_TERMIN" IS ''ge\00E4nderter Plantermin'';'),
'',
'COMMENT ON TABLE "ROMA_MAIN"."VC_HIST"  IS ''FTTH-3187: Historisierung aller Objekte im Vermarktungscluster''; ',
'  '))
);
wwv_flow_imp.component_end;
end;
/
