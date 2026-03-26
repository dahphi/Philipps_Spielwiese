-- liquibase formatted sql
-- changeset rk_main:1774561689997 stripComments:false logicalFilePath:SCDP/rk_main/comments/isr_brm_gefaehrdung.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot RK_MAIN/src/database/rk_main/comments/isr_brm_gefaehrdung.sql:null:fc054b3cb69710df7437d58342e9363c2f911047:create

comment on column rk_main.isr_brm_gefaehrdung.gef_aut_betroffen is
    'SBF Authentizität betroffen';

comment on column rk_main.isr_brm_gefaehrdung.gef_beschreibung is
    'Beschreibung des Objekts';

comment on column rk_main.isr_brm_gefaehrdung.gef_int_betroffen is
    'SBF Integrität betroffen';

comment on column rk_main.isr_brm_gefaehrdung.gef_titel is
    'eindeutige Bezeichnung';

comment on column rk_main.isr_brm_gefaehrdung.gef_uid is
    'Primärschlüssel';

comment on column rk_main.isr_brm_gefaehrdung.gef_vef_betroffen is
    'SBF Verfügbarkeit betroffen';

comment on column rk_main.isr_brm_gefaehrdung.gef_vet_betroffen is
    'SBF Vertraulichkeit betroffen';

comment on column rk_main.isr_brm_gefaehrdung.inserted is
    'Insert Datum';

comment on column rk_main.isr_brm_gefaehrdung.inserted_by is
    'Insert User';

comment on column rk_main.isr_brm_gefaehrdung.updated is
    'Update Datum';

comment on column rk_main.isr_brm_gefaehrdung.updated_by is
    'Update User';

