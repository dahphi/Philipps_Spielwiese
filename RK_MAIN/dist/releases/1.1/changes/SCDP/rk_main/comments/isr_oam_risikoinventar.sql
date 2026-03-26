-- liquibase formatted sql
-- changeset rk_main:1774555708850 stripComments:false logicalFilePath:SCDP/rk_main/comments/isr_oam_risikoinventar.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot RK_MAIN/src/database/rk_main/comments/isr_oam_risikoinventar.sql:null:398fea89b16b8413965be7d0eed0935045b6e259:create

comment on column rk_main.isr_oam_risikoinventar.abweichung_sollzustand is
    'Abweichung vom gewollten Zustand';

comment on column rk_main.isr_oam_risikoinventar.gef_uid is
    'Fremdschlüssel Gefährdung';

comment on column rk_main.isr_oam_risikoinventar.inserted is
    'Insert Datum';

comment on column rk_main.isr_oam_risikoinventar.inserted_by is
    'Insert User';

comment on column rk_main.isr_oam_risikoinventar.netto1_auw_uid is
    'Auswirkung des Risikos (Netto(1) = Ist)
';

comment on column rk_main.isr_oam_risikoinventar.netto1_ews_uid is
    'Eintrittswahrscheinlichkeit des Risikos in % (Netto(1) = Ist)';

comment on column rk_main.isr_oam_risikoinventar.netto2_auw_uid is
    'Auswirkung des Risikos (Netto(2) =Plan)';

comment on column rk_main.isr_oam_risikoinventar.netto2_ews_uid is
    'Eintrittswahreinlichkeit des Risikos in % (Netto(2) = Plan)';

comment on column rk_main.isr_oam_risikoinventar.ris_uid is
    'Fremdschlüssel Risikosteuerung';

comment on column rk_main.isr_oam_risikoinventar.rkt_uid is
    'Fremdschlüssel Risikokategorie';

comment on column rk_main.isr_oam_risikoinventar.rsk_accepted_date is
    'Zeitpunkt, zu dem das Risiko akzeiptiert wurde';

comment on column rk_main.isr_oam_risikoinventar.rsk_accepted_san is
    'Account, durch den das Risiko akzeptiert wurde';

comment on column rk_main.isr_oam_risikoinventar.rsk_beschreibung is
    'Beschreibung des Objekts';

comment on column rk_main.isr_oam_risikoinventar.rsk_risikotitel is
    'eindeutige Bezeichnung';

comment on column rk_main.isr_oam_risikoinventar.rsk_uid is
    'Primärschlüssel';

comment on column rk_main.isr_oam_risikoinventar.rsk_unit_risikotraeger is
    'Bereich oder GF als Rsiikoträger';

comment on column rk_main.isr_oam_risikoinventar.rsk_workflow_status is
    'Workflostatus des Risikos (iniial erfasst, validiert)';

comment on column rk_main.isr_oam_risikoinventar.ska_uid is
    'Fremdschlüssel Schwachstellenkategorie';

comment on column rk_main.isr_oam_risikoinventar.updated is
    'Update Datum';

comment on column rk_main.isr_oam_risikoinventar.updated_by is
    'Update User';

