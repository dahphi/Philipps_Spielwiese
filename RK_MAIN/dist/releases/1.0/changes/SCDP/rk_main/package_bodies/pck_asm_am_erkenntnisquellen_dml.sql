-- liquibase formatted sql
-- changeset RK_MAIN:1774554917304 stripComments:false logicalFilePath:SCDP/rk_main/package_bodies/pck_asm_am_erkenntnisquellen_dml.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot RK_MAIN/src/database/rk_main/package_bodies/pck_asm_am_erkenntnisquellen_dml.sql:null:7f0fdc79ae9bc3e6e3dd5008dd3bb0eee55dac66:create

create or replace package body rk_main.pck_asm_am_erkenntnisquellen_dml as

  -- Variablen etc.
    gcv_package_name constant varchar2(100) := $$plsql_unit;

---------------------------------------------------------------------------------------------------

    function fv_print (
        pir_row         in asm_am_erkenntnisquellen%rowtype,
        piv_output_type in varchar2 default 'no'
    ) return varchar2 is
        cv_sep   constant varchar2(100) := '###cr###';
        v_retval varchar2(32767);
    begin
        if ( piv_output_type in ( 'no', 'pretty' ) ) then
            v_retval := 'ekq_uid = '
                        || to_char(pir_row.ekq_uid)
                        || cv_sep
                        || ', ekq_bezeichnung = '
                        || pir_row.ekq_bezeichnung
                        || cv_sep
                        || ', ekq_beschreibung = '
                        || pir_row.ekq_beschreibung
                        || cv_sep
                        || ', inserted = '
                        || to_char(pir_row.inserted, 'DD.MM.YYYY')
                        || cv_sep
                        || ', updated = '
                        || to_char(pir_row.updated, 'DD.MM.YYYY')
                        || cv_sep
                        || ', inserted_by = '
                        || pir_row.inserted_by
                        || cv_sep
                        || ', updated_by = '
                        || pir_row.updated_by
                        || cv_sep
                        || ', ekw_input_sans = '
                        || pir_row.ekw_input_sans
                        || cv_sep;

            if ( piv_output_type = 'no' ) then
                v_retval := replace(
                    trim(v_retval),
                    cv_sep,
                    null
                );
            else
                v_retval := replace(
                    trim(v_retval),
                    cv_sep,
                    chr(10)
                );
            end if;

        elsif ( piv_output_type = 'html' ) then
            v_retval := '<table><tr><th>ASM_AM_ERKENNTNISQUELLEN</th><th>Column</th></tr>'
                        || '<tr><td>ekq_uid</td><td>'
                        || to_char(pir_row.ekq_uid)
                        || '</td></tr>'
                        || '<tr><td>ekq_bezeichnung</td><td>'
                        || pir_row.ekq_bezeichnung
                        || '</td></tr>'
                        || '<tr><td>ekq_beschreibung</td><td>'
                        || pir_row.ekq_beschreibung
                        || '</td></tr>'
                        || '<tr><td>inserted</td><td>'
                        || to_char(pir_row.inserted, 'DD.MM.YYYY')
                        || '</td></tr>'
                        || '<tr><td>updated</td><td>'
                        || to_char(pir_row.updated, 'DD.MM.YYYY')
                        || '</td></tr>'
                        || '<tr><td>inserted_by</td><td>'
                        || pir_row.inserted_by
                        || '</td></tr>'
                        || '<tr><td>updated_by</td><td>'
                        || pir_row.updated_by
                        || '</td></tr>'
                        || '<tr><td>ekw_input_sans</td><td>'
                        || pir_row.ekw_input_sans
                        || '</td></tr>'
                        || '</table>';
        else
            v_retval := null;
        end if;

        return v_retval;
    end fv_print;

---------------------------------------------------------------------------------------------------

    procedure p_insert (
        pior_asm_am_erkenntnisquellen in out asm_am_erkenntnisquellen%rowtype
    ) is

  -- fuer exceptions
        v_routine_name logs.routine_name%type;
        c_message      clob;
    begin
  -- fuer exceptions
        v_routine_name := gcv_package_name || '.P_INSERT';
        pior_asm_am_erkenntnisquellen.inserted := sysdate;
        pior_asm_am_erkenntnisquellen.inserted_by := pck_env.fv_user;
        insert into asm_am_erkenntnisquellen values pior_asm_am_erkenntnisquellen returning ekq_uid into pior_asm_am_erkenntnisquellen.ekq_uid
        ;

    exception
        when others then
    -- Fehlerprotokollierung
            c_message := 'Fehler bei Insert in Tabelle asm_am_erkenntnisquellen! Parameter: ' || fv_print(pir_row => pior_asm_am_erkenntnisquellen
            );
            pck_logs.p_error(
                piv_routine_name => v_routine_name,
                pic_message      => c_message
            );
            raise;
    end p_insert;

    procedure p_insert (
        pi_rsk_uid in isr_risiko_erkenntnisquelle.rsk_uid%type,
        pi_ekq_uid in isr_risiko_erkenntnisquelle.ekq_uid%type
    ) is
        v_conter   number := 0;
        v_sequence number;
    begin
        select
            count(*)
        into v_conter
        from
            isr_risiko_erkenntnisquelle
        where
                rsk_uid = pi_rsk_uid
            and ekq_uid = pi_ekq_uid;

        if v_conter = 0 then

	--v_sequence := RISIKO_ERKENNTNISQUELLE_SEQ.NEXTVAL;
            insert into isr_risiko_erkenntnisquelle (
        --RE_ID,
                rsk_uid,
                ekq_uid,
                inserted,
                inserted_by
            ) values (
          --v_sequence,
             pi_rsk_uid,
                       pi_ekq_uid,
                       sysdate,
                       v('APP_USER') );

        end if;

    end p_insert;

    procedure p_delete (
        pi_rsk_uid in isr_risiko_erkenntnisquelle.rsk_uid%type
    ) is
    begin
        delete from isr_risiko_erkenntnisquelle
        where
            rsk_uid = pi_rsk_uid;

    end p_delete;

-------------------------------------------------------------------------------

    procedure p_merge (
        pir_asm_am_erkenntnisquellen in asm_am_erkenntnisquellen%rowtype
    ) is
        r_asm_am_erkenntnisquellen asm_am_erkenntnisquellen%rowtype;

  -- fuer exceptions
        v_routine_name             logs.routine_name%type;
        c_message                  clob;
    begin
  -- fuer exceptions
        v_routine_name := gcv_package_name || '.P_MERGE';
        r_asm_am_erkenntnisquellen := pir_asm_am_erkenntnisquellen;
        r_asm_am_erkenntnisquellen.inserted := sysdate;
        r_asm_am_erkenntnisquellen.updated := sysdate;
        r_asm_am_erkenntnisquellen.inserted_by := pck_env.fv_user;
        r_asm_am_erkenntnisquellen.updated_by := pck_env.fv_user;
        merge into asm_am_erkenntnisquellen
        using dual on ( ekq_uid = r_asm_am_erkenntnisquellen.ekq_uid )
        when matched then update
        set ekq_bezeichnung = r_asm_am_erkenntnisquellen.ekq_bezeichnung,
            ekq_beschreibung = r_asm_am_erkenntnisquellen.ekq_beschreibung,
            updated = r_asm_am_erkenntnisquellen.updated,
            updated_by = r_asm_am_erkenntnisquellen.updated_by,
            ekw_input_sans = r_asm_am_erkenntnisquellen.ekw_input_sans
        when not matched then
        insert (
            ekq_bezeichnung,
            ekq_beschreibung,
            inserted,
            inserted_by,
            ekw_input_sans )
        values
            ( r_asm_am_erkenntnisquellen.ekq_bezeichnung,
              r_asm_am_erkenntnisquellen.ekq_beschreibung,
              r_asm_am_erkenntnisquellen.inserted,
              r_asm_am_erkenntnisquellen.inserted_by,
              r_asm_am_erkenntnisquellen.ekw_input_sans );

    exception
        when others then
    -- Fehlerprotokollierung
            c_message := 'Fehler bei Merge! Parameter: ' || fv_print(pir_row => pir_asm_am_erkenntnisquellen);
            pck_logs.p_error(
                piv_routine_name => v_routine_name,
                pic_message      => c_message
            );
            raise;
    end p_merge;

---------------------------------------------------------------------------------------------------

    procedure p_update (
        pir_asm_am_erkenntnisquellen in asm_am_erkenntnisquellen%rowtype,
        piv_art                      in varchar2
    ) is
        r_asm_am_erkenntnisquellen asm_am_erkenntnisquellen%rowtype;

  -- fuer exceptions
        v_routine_name             logs.routine_name%type;
        c_message                  clob;
    begin
  -- fuer exceptions
        v_routine_name := gcv_package_name || '.P_UPDATE';
        r_asm_am_erkenntnisquellen.ekq_bezeichnung := pir_asm_am_erkenntnisquellen.ekq_bezeichnung;
        r_asm_am_erkenntnisquellen.ekq_beschreibung := pir_asm_am_erkenntnisquellen.ekq_beschreibung;
        r_asm_am_erkenntnisquellen.updated := sysdate;
        r_asm_am_erkenntnisquellen.updated_by := pck_env.fv_user;
        r_asm_am_erkenntnisquellen.ekw_input_sans := pir_asm_am_erkenntnisquellen.ekw_input_sans;
        case piv_art
            when '<replace>' then
                update asm_am_erkenntnisquellen
                set
                    ekq_uid = pir_asm_am_erkenntnisquellen.ekq_uid
                where
                    ekq_uid = pir_asm_am_erkenntnisquellen.ekq_uid;

            when '<full>' then    
      -- Übernehmen der Eingabedaten  
                r_asm_am_erkenntnisquellen := pir_asm_am_erkenntnisquellen;  
      -- Ergänzen der Anlagedaten  
                select
                    inserted,
                    inserted_by
                into
                    r_asm_am_erkenntnisquellen.inserted,
                    r_asm_am_erkenntnisquellen.inserted_by
                from
                    asm_am_erkenntnisquellen
                where
                    ekq_uid = pir_asm_am_erkenntnisquellen.ekq_uid;  
      -- Ergänzen der Update-Daten  
                r_asm_am_erkenntnisquellen.updated := sysdate;
                r_asm_am_erkenntnisquellen.updated_by := pck_env.fv_user;
                update asm_am_erkenntnisquellen
                set
                    row = r_asm_am_erkenntnisquellen
                where
                    ekq_uid = pir_asm_am_erkenntnisquellen.ekq_uid;

            else
                raise_application_error(-20000, 'Parameter wird nicht unterstuetzt!');
        end case;

    exception
        when others then
    -- Fehlerprotokollierung
            c_message := 'Fehler bei Update! Parameter: ' || fv_print(pir_row => pir_asm_am_erkenntnisquellen);
            pck_logs.p_error(
                piv_routine_name => v_routine_name,
                pic_message      => c_message
            );
            raise;
    end p_update;

---------------------------------------------------------------------------------------------------

    procedure p_delete (
        pin_ekq_uid in asm_am_erkenntnisquellen.ekq_uid%type
    ) is

  -- fuer exceptions
        v_routine_name logs.routine_name%type;
        v_parameter    varchar2(4000);
        c_message      clob;
        e_no_data exception;
    begin
  -- fuer exceptions
        v_routine_name := gcv_package_name || '.P_DELETE';
        v_parameter := 'Parameter: pin_ekq_uid: ' || to_char(pin_ekq_uid);
        delete from asm_am_erkenntnisquellen
        where
            ekq_uid = pin_ekq_uid;

        if sql%notfound then
            raise e_no_data;
        end if;
    exception
        when e_no_data then
    -- nur Hinweis fuer evt. Fehlersuche
            c_message := 'Hinweis! Zu loeschender DS existiert nicht. Tabelle asm_am_erkenntnisquellen! ' || v_parameter;
            pck_logs.p_error_exp(
                piv_routine_name => v_routine_name,
                pic_message      => c_message
            );
        when others then
    -- Fehlerprotokollierung
            c_message := 'Fehler beim Loeschen in Tabelle asm_am_erkenntnisquellen! ' || v_parameter;
            pck_logs.p_error(
                piv_routine_name => v_routine_name,
                pic_message      => c_message
            );
            raise;
    end p_delete;

end pck_asm_am_erkenntnisquellen_dml;
/

