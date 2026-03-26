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


-- sqlcl_snapshot {"hash":"33bf53ccce3a1d25da7ec7301c6a42e64da1e299","type":"VIEW","name":"ISR_RISIKOBEWERTUNG","schemaName":"RK_MAIN","sxml":""}