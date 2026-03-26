-- liquibase formatted sql
-- changeset RK_MAIN:1774554921856 stripComments:false logicalFilePath:SCDP/rk_main/views/isr_risikobewertung.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot RK_MAIN/src/database/rk_main/views/isr_risikobewertung.sql:null:33bf53ccce3a1d25da7ec7301c6a42e64da1e299:create

create or replace force editionable view rk_main.isr_risikobewertung (
    bewertung,
    auswirkung,
    eintrittswahrscheinlichkeit,
    ampel
) as
    (
        select
            bewertung,
            auswirkung,
            eintrittswahrscheinlichkeit,
            nvl(decode(gruen.par_bezeichnung, 'RISIKO_BEWERTUNG_MAX_GRUEN', 'GRUEN', '')
                || decode(rot.par_bezeichnung, 'RISIKO_BEWERTUNG_MIN_ROT', 'ROT', ''),
                'GELB') ampel
        from
            (
                select
                    isr_auswirkung.auw_bezeichnung                                     auswirkung,
                    isr_auswirkung.auw_wert,
                    isr_eintrittswahrscheinlichkeit.ews_bezeichnung                    eintrittswahrscheinlichkeit,
                    isr_eintrittswahrscheinlichkeit.ews_wert,
                    isr_auswirkung.auw_wert * isr_eintrittswahrscheinlichkeit.ews_wert bewertung
                from
                         isr_auswirkung
                    join isr_eintrittswahrscheinlichkeit on 1 = 1
            )
            left outer join isr_parameter gruen on gruen.par_bezeichnung = 'RISIKO_BEWERTUNG_MAX_GRUEN'
                                                   and bewertung <= to_number(gruen.par_string_value, '99')
            left outer join isr_parameter rot on rot.par_bezeichnung = 'RISIKO_BEWERTUNG_MIN_ROT'
                                                 and bewertung >= to_number(rot.par_string_value, '99')
    );

