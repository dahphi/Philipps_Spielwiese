-- liquibase formatted sql
-- changeset RK_MAIN:1774561693147 stripComments:false logicalFilePath:SCDP/rk_main/package_bodies/pck_isr_oam_massnahmenkontext_dml.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot RK_MAIN/src/database/rk_main/package_bodies/pck_isr_oam_massnahmenkontext_dml.sql:null:77b151a0d0442d23ac9ae9c4b54838f8c64a81cb:create

create or replace package body rk_main.pck_isr_oam_massnahmenkontext_dml as

  -- Variablen etc.
    gcv_package_name constant varchar2(100) := $$plsql_unit;

---------------------------------------------------------------------------------------------------

    function fv_print (
        pir_row         in isr_oam_massnahmenkontext%rowtype,
        piv_output_type in varchar2 default 'no'
    ) return varchar2 is
        cv_sep   constant varchar2(100) := '###cr###';
        v_retval varchar2(32767);
    begin
        if ( piv_output_type in ( 'no', 'pretty' ) ) then
            v_retval := 'mkt_uid = '
                        || to_char(pir_row.mkt_uid)
                        || cv_sep
                        || ', mkt_bezeichnung = '
                        || pir_row.mkt_bezeichnung
                        || cv_sep
                        || ', mkt_beschreibung = '
                        || pir_row.mkt_beschreibung
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
                        || ', aktiv = '
                        || pir_row.aktiv
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
            v_retval := '<table><tr><th>ISR_OAM_MASSNAHMENKONTEXT</th><th>Column</th></tr>'
                        || '<tr><td>mkt_uid</td><td>'
                        || to_char(pir_row.mkt_uid)
                        || '</td></tr>'
                        || '<tr><td>mkt_bezeichnung</td><td>'
                        || pir_row.mkt_bezeichnung
                        || '</td></tr>'
                        || '<tr><td>mkt_beschreibung</td><td>'
                        || pir_row.mkt_beschreibung
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
                        || '<tr><td>aktiv</td><td>'
                        || pir_row.aktiv
                        || '</td></tr>'
                        || '</table>';
        else
            v_retval := null;
        end if;

        return v_retval;
    end fv_print;

---------------------------------------------------------------------------------------------------

    procedure p_insert (
        pior_isr_oam_massnahmenkontext in out isr_oam_massnahmenkontext%rowtype
    ) is

  -- fuer exceptions
        v_routine_name logs.routine_name%type;
        c_message      clob;
    begin
  -- fuer exceptions
        v_routine_name := gcv_package_name || '.P_INSERT';
        pior_isr_oam_massnahmenkontext.inserted := sysdate;
        pior_isr_oam_massnahmenkontext.inserted_by := pck_env.fv_user;
        insert into isr_oam_massnahmenkontext values pior_isr_oam_massnahmenkontext returning mkt_uid into pior_isr_oam_massnahmenkontext.mkt_uid
        ;

    exception
        when others then
    -- Fehlerprotokollierung
            c_message := 'Fehler bei Insert in Tabelle isr_oam_massnahmenkontext! Parameter: ' || fv_print(pir_row => pior_isr_oam_massnahmenkontext
            );
            pck_logs.p_error(
                piv_routine_name => v_routine_name,
                pic_message      => c_message
            );
            raise;
    end p_insert;

    procedure p_insert (
        pi_msn_uid in isr_massnahme_kontext.msn_uid%type,
        pi_mkt_uid in isr_massnahme_kontext.mkt_uid%type
    ) is
        v_conter   number := 0;
        v_sequence number;
    begin
        select
            count(*)
        into v_conter
        from
            isr_massnahme_kontext
        where
                msn_uid = pi_msn_uid
            and mkt_uid = pi_mkt_uid;

        if v_conter = 0 then

	--v_sequence := MASSNAHME_KONTEXT_SEQ.NEXTVAL;
            insert into isr_massnahme_kontext (
        --MK_ID,
                msn_uid,
                mkt_uid,
                inserted,
                inserted_by
            ) values (
          --v_sequence,
             pi_msn_uid,
                       pi_mkt_uid,
                       sysdate,
                       v('APP_USER') );

        end if;

    end p_insert;

    procedure p_delete (
        pi_msn_uid in isr_massnahme_kontext.msn_uid%type
    ) is
    begin
        delete from isr_massnahme_kontext
        where
            msn_uid = pi_msn_uid;

    end p_delete;

-------------------------------------------------------------------------------

    procedure p_merge (
        pir_isr_oam_massnahmenkontext in isr_oam_massnahmenkontext%rowtype
    ) is
        r_isr_oam_massnahmenkontext isr_oam_massnahmenkontext%rowtype;

  -- fuer exceptions
        v_routine_name              logs.routine_name%type;
        c_message                   clob;
    begin
  -- fuer exceptions
        v_routine_name := gcv_package_name || '.P_MERGE';
        r_isr_oam_massnahmenkontext := pir_isr_oam_massnahmenkontext;
        r_isr_oam_massnahmenkontext.inserted := sysdate;
        r_isr_oam_massnahmenkontext.updated := sysdate;
        r_isr_oam_massnahmenkontext.inserted_by := pck_env.fv_user;
        r_isr_oam_massnahmenkontext.updated_by := pck_env.fv_user;
        merge into isr_oam_massnahmenkontext
        using dual on ( mkt_uid = r_isr_oam_massnahmenkontext.mkt_uid )
        when matched then update
        set mkt_bezeichnung = r_isr_oam_massnahmenkontext.mkt_bezeichnung,
            mkt_beschreibung = r_isr_oam_massnahmenkontext.mkt_beschreibung,
            updated = r_isr_oam_massnahmenkontext.updated,
            updated_by = r_isr_oam_massnahmenkontext.updated_by
        when not matched then
        insert (
            mkt_bezeichnung,
            mkt_beschreibung,
            inserted,
            inserted_by )
        values
            ( r_isr_oam_massnahmenkontext.mkt_bezeichnung,
              r_isr_oam_massnahmenkontext.mkt_beschreibung,
              r_isr_oam_massnahmenkontext.inserted,
              r_isr_oam_massnahmenkontext.inserted_by );

    exception
        when others then
    -- Fehlerprotokollierung
            c_message := 'Fehler bei Merge! Parameter: ' || fv_print(pir_row => pir_isr_oam_massnahmenkontext);
            pck_logs.p_error(
                piv_routine_name => v_routine_name,
                pic_message      => c_message
            );
            raise;
    end p_merge;

---------------------------------------------------------------------------------------------------

    procedure p_update (
        pir_isr_oam_massnahmenkontext in isr_oam_massnahmenkontext%rowtype,
        piv_art                       in varchar2
    ) is
        r_isr_oam_massnahmenkontext isr_oam_massnahmenkontext%rowtype;

  -- fuer exceptions
        v_routine_name              logs.routine_name%type;
        c_message                   clob;
    begin
  -- fuer exceptions
        v_routine_name := gcv_package_name || '.P_UPDATE';
        r_isr_oam_massnahmenkontext.mkt_bezeichnung := pir_isr_oam_massnahmenkontext.mkt_bezeichnung;
        r_isr_oam_massnahmenkontext.mkt_beschreibung := pir_isr_oam_massnahmenkontext.mkt_beschreibung;
        r_isr_oam_massnahmenkontext.updated := sysdate;
        r_isr_oam_massnahmenkontext.updated_by := pck_env.fv_user;
        r_isr_oam_massnahmenkontext.aktiv := pir_isr_oam_massnahmenkontext.aktiv;
        case piv_art
            when '<replace>' then
                update isr_oam_massnahmenkontext
                set
                    mkt_uid = pir_isr_oam_massnahmenkontext.mkt_uid
                where
                    mkt_uid = pir_isr_oam_massnahmenkontext.mkt_uid;

            when '<full>' then    
      -- Übernehmen der Eingabedaten  
                r_isr_oam_massnahmenkontext := pir_isr_oam_massnahmenkontext;  
      -- Ergänzen der Anlagedaten  
                select
                    inserted,
                    inserted_by
                into
                    r_isr_oam_massnahmenkontext.inserted,
                    r_isr_oam_massnahmenkontext.inserted_by
                from
                    isr_oam_massnahmenkontext
                where
                    mkt_uid = pir_isr_oam_massnahmenkontext.mkt_uid;  
      -- Ergänzen der Update-Daten  
                r_isr_oam_massnahmenkontext.updated := sysdate;
                r_isr_oam_massnahmenkontext.updated_by := pck_env.fv_user;
                update isr_oam_massnahmenkontext
                set
                    row = r_isr_oam_massnahmenkontext
                where
                    mkt_uid = pir_isr_oam_massnahmenkontext.mkt_uid;

            else
                raise_application_error(-20000, 'Parameter wird nicht unterstuetzt!');
        end case;

    exception
        when others then
    -- Fehlerprotokollierung
            c_message := 'Fehler bei Update! Parameter: ' || fv_print(pir_row => pir_isr_oam_massnahmenkontext);
            pck_logs.p_error(
                piv_routine_name => v_routine_name,
                pic_message      => c_message
            );
            raise;
    end p_update;

---------------------------------------------------------------------------------------------------

    procedure p_delete (
        pin_mkt_uid in isr_oam_massnahmenkontext.mkt_uid%type
    ) is

  -- fuer exceptions
        v_routine_name logs.routine_name%type;
        v_parameter    varchar2(4000);
        c_message      clob;
        e_no_data exception;
    begin
  -- fuer exceptions
        v_routine_name := gcv_package_name || '.P_DELETE';
        v_parameter := 'Parameter: pin_mkt_uid: ' || to_char(pin_mkt_uid);
        delete from isr_oam_massnahmenkontext
        where
            mkt_uid = pin_mkt_uid;

        if sql%notfound then
            raise e_no_data;
        end if;
    exception
        when e_no_data then
    -- nur Hinweis fuer evt. Fehlersuche
            c_message := 'Hinweis! Zu loeschender DS existiert nicht. Tabelle isr_oam_massnahmenkontext! ' || v_parameter;
            pck_logs.p_error_exp(
                piv_routine_name => v_routine_name,
                pic_message      => c_message
            );
        when others then
    -- Fehlerprotokollierung
            c_message := 'Fehler beim Loeschen in Tabelle isr_oam_massnahmenkontext! ' || v_parameter;
            pck_logs.p_error(
                piv_routine_name => v_routine_name,
                pic_message      => c_message
            );
            raise;
    end p_delete;

end pck_isr_oam_massnahmenkontext_dml;
/

