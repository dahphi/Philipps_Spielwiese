-- liquibase formatted sql
-- changeset RK_MAIN:1774554918991 stripComments:false logicalFilePath:SCDP/rk_main/package_bodies/pck_isr_oam_massnahme_dml.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot RK_MAIN/src/database/rk_main/package_bodies/pck_isr_oam_massnahme_dml.sql:null:41381ab102ddd5527271b858bd0facf5e69cec93:create

create or replace package body rk_main.pck_isr_oam_massnahme_dml as

  -- Variablen etc.
    gcv_package_name constant varchar2(100) := $$plsql_unit;

---------------------------------------------------------------------------------------------------

    function fv_print (
        pir_row         in isr_oam_massnahme%rowtype,
        piv_output_type in varchar2 default 'no'
    ) return varchar2 is
        cv_sep   constant varchar2(100) := '###cr###';
        v_retval varchar2(32767);
    begin
        if ( piv_output_type in ( 'no', 'pretty' ) ) then
            v_retval := 'msn_uid = '
                        || to_char(pir_row.msn_uid)
                        || cv_sep
                        || ', msn_titel = '
                        || pir_row.msn_titel
                        || cv_sep
                        || ', msn_beschreibung = '
                        || pir_row.msn_beschreibung
                        || cv_sep
                        || ', msn_intern = '
                        || to_char(pir_row.msn_intern)
                        || cv_sep
                --|| ', rsk_uid = '           || TO_CHAR( pir_row.rsk_uid ) || cv_sep
                --|| ', ris_uid = '           || TO_CHAR( pir_row.ris_uid ) || cv_sep
                        || ', mka_uid = '
                        || to_char(pir_row.mka_uid)
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
                        || ', uss_uid = '
                        || to_char(pir_row.uss_uid)
                        || cv_sep
                        || ', zieltermin = '
                        || to_char(pir_row.zieltermin, 'DD.MM.YYYY')
                        || cv_sep
                        || ', uss_ready_date = '
                        || to_char(pir_row.uss_ready_date, 'DD.MM.YYYY')
                        || cv_sep
                --|| ', mkt_uids = '          || pir_row.mkt_uids           || cv_sep
                        || ', mkp_uid = '
                        || to_char(pir_row.mkp_uid)
                        || cv_sep
                --|| ', i2c_uids = '          || pir_row.i2c_uids           || cv_sep
                        ;

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
            v_retval := '<table><tr><th>ISR_OAM_MASSNAHME</th><th>Column</th></tr>'
                        || '<tr><td>msn_uid</td><td>'
                        || to_char(pir_row.msn_uid)
                        || '</td></tr>'
                        || '<tr><td>msn_titel</td><td>'
                        || pir_row.msn_titel
                        || '</td></tr>'
                        || '<tr><td>msn_beschreibung</td><td>'
                        || pir_row.msn_beschreibung
                        || '</td></tr>'
                        || '<tr><td>msn_intern</td><td>'
                        || to_char(pir_row.msn_intern)
                        || '</td></tr>'
                --|| '<tr><td>rsk_uid</td><td>'           || TO_CHAR( pir_row.rsk_uid )     || '</td></tr>'
                --|| '<tr><td>ris_uid</td><td>'           || TO_CHAR( pir_row.ris_uid )     || '</td></tr>'
                        || '<tr><td>mka_uid</td><td>'
                        || to_char(pir_row.mka_uid)
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
                        || '<tr><td>uss_uid</td><td>'
                        || to_char(pir_row.uss_uid)
                        || '</td></tr>'
                        || '<tr><td>zieltermin</td><td>'
                        || to_char(pir_row.zieltermin, 'DD.MM.YYYY')
                        || '</td></tr>'
                        || '<tr><td>uss_ready_date</td><td>'
                        || to_char(pir_row.uss_ready_date, 'DD.MM.YYYY')
                        || '</td></tr>'
                --|| '<tr><td>mkt_uids</td><td>'          || pir_row.mkt_uids               || '</td></tr>'
                        || '<tr><td>mkp_uid</td><td>'
                        || to_char(pir_row.mkp_uid)
                        || '</td></tr>'
                --|| '<tr><td>i2c_uids</td><td>'          || pir_row.i2c_uids               || '</td></tr>'
                        || '</table>';
        else
            v_retval := null;
        end if;

        return v_retval;
    end fv_print;

---------------------------------------------------------------------------------------------------

    procedure p_insert (
        pior_isr_oam_massnahme in out isr_oam_massnahme%rowtype
    ) is

  -- fuer exceptions
        v_routine_name logs.routine_name%type;
        c_message      clob;
    begin
  -- fuer exceptions
        v_routine_name := gcv_package_name || '.P_INSERT';
        pior_isr_oam_massnahme.inserted := sysdate;
        pior_isr_oam_massnahme.inserted_by := pck_env.fv_user;
        insert into isr_oam_massnahme values pior_isr_oam_massnahme returning msn_uid into pior_isr_oam_massnahme.msn_uid;

    exception
        when others then
    -- Fehlerprotokollierung
            c_message := 'Fehler bei Insert in Tabelle isr_oam_massnahme! Parameter: ' || fv_print(pir_row => pior_isr_oam_massnahme)
            ;
            pck_logs.p_error(
                piv_routine_name => v_routine_name,
                pic_message      => c_message
            );
            raise;
    end p_insert;

-------------------------------------------------------------------------------

    procedure p_merge (
        pir_isr_oam_massnahme in isr_oam_massnahme%rowtype
    ) is
        r_isr_oam_massnahme isr_oam_massnahme%rowtype;

  -- fuer exceptions
        v_routine_name      logs.routine_name%type;
        c_message           clob;
    begin
  -- fuer exceptions
        v_routine_name := gcv_package_name || '.P_MERGE';
        r_isr_oam_massnahme := pir_isr_oam_massnahme;
        r_isr_oam_massnahme.inserted := sysdate;
        r_isr_oam_massnahme.updated := sysdate;
        r_isr_oam_massnahme.inserted_by := pck_env.fv_user;
        r_isr_oam_massnahme.updated_by := pck_env.fv_user;
        merge into isr_oam_massnahme
        using dual on ( msn_uid = r_isr_oam_massnahme.msn_uid )
        when matched then update
        set msn_titel = r_isr_oam_massnahme.msn_titel,
            msn_beschreibung = r_isr_oam_massnahme.msn_beschreibung,
            msn_intern = r_isr_oam_massnahme.msn_intern
     -- , rsk_uid            = r_isr_oam_massnahme.rsk_uid
      --, ris_uid            = r_isr_oam_massnahme.ris_uid
            ,
            mka_uid = r_isr_oam_massnahme.mka_uid,
            updated = r_isr_oam_massnahme.updated,
            updated_by = r_isr_oam_massnahme.updated_by,
            uss_uid = r_isr_oam_massnahme.uss_uid,
            zieltermin = r_isr_oam_massnahme.zieltermin,
            uss_ready_date = r_isr_oam_massnahme.uss_ready_date
     -- , mkt_uids           = r_isr_oam_massnahme.mkt_uids
            ,
            mkp_uid = r_isr_oam_massnahme.mkp_uid
      --, i2c_uids           = r_isr_oam_massnahme.i2c_uids
        when not matched then
        insert (
            msn_titel,
            msn_beschreibung,
            msn_intern
      --, rsk_uid
      --, ris_uid
            ,
            mka_uid,
            inserted,
            inserted_by,
            uss_uid,
            zieltermin,
            uss_ready_date
      --, mkt_uids
            ,
            mkp_uid
      --, i2c_uids
             )
        values
            ( r_isr_oam_massnahme.msn_titel,
              r_isr_oam_massnahme.msn_beschreibung,
              r_isr_oam_massnahme.msn_intern
      --, r_isr_oam_massnahme.rsk_uid
      --, r_isr_oam_massnahme.ris_uid
              ,
              r_isr_oam_massnahme.mka_uid,
              r_isr_oam_massnahme.inserted,
              r_isr_oam_massnahme.inserted_by,
              r_isr_oam_massnahme.uss_uid,
              r_isr_oam_massnahme.zieltermin,
              r_isr_oam_massnahme.uss_ready_date
      --, r_isr_oam_massnahme.mkt_uids
              ,
              r_isr_oam_massnahme.mkp_uid
      --, r_isr_oam_massnahme.i2c_uids
               );

    exception
        when others then
    -- Fehlerprotokollierung
            c_message := 'Fehler bei Merge! Parameter: ' || fv_print(pir_row => pir_isr_oam_massnahme);
            pck_logs.p_error(
                piv_routine_name => v_routine_name,
                pic_message      => c_message
            );
            raise;
    end p_merge;

---------------------------------------------------------------------------------------------------

    procedure p_update (
        pir_isr_oam_massnahme in isr_oam_massnahme%rowtype,
        piv_art               in varchar2
    ) is
        r_isr_oam_massnahme      isr_oam_massnahme%rowtype;
        r_isr_oam_massnahme_hist isr_oam_massnahme_hist%rowtype;

  -- fuer exceptions
        v_routine_name           logs.routine_name%type;
        c_message                clob;
    begin
  -- fuer exceptions
        v_routine_name := gcv_package_name || '.P_UPDATE';
        r_isr_oam_massnahme.msn_titel := pir_isr_oam_massnahme.msn_titel;
        r_isr_oam_massnahme.msn_beschreibung := pir_isr_oam_massnahme.msn_beschreibung;
        r_isr_oam_massnahme.msn_intern := pir_isr_oam_massnahme.msn_intern;
  --r_isr_oam_massnahme.rsk_uid           := pir_isr_oam_massnahme.rsk_uid;
  --r_isr_oam_massnahme.ris_uid           := pir_isr_oam_massnahme.ris_uid;
        r_isr_oam_massnahme.mka_uid := pir_isr_oam_massnahme.mka_uid;
        r_isr_oam_massnahme.updated := sysdate;
        r_isr_oam_massnahme.updated_by := pck_env.fv_user;
        r_isr_oam_massnahme.uss_uid := pir_isr_oam_massnahme.uss_uid;
        r_isr_oam_massnahme.zieltermin := pir_isr_oam_massnahme.zieltermin;
        r_isr_oam_massnahme.uss_ready_date := pir_isr_oam_massnahme.uss_ready_date;
  --r_isr_oam_massnahme.mkt_uids          := pir_isr_oam_massnahme.mkt_uids;
        r_isr_oam_massnahme.mkp_uid := pir_isr_oam_massnahme.mkp_uid;
  --r_isr_oam_massnahme.i2c_uids          := pir_isr_oam_massnahme.i2c_uids;
        r_isr_oam_massnahme.msn_statusbeschreibung := pir_isr_oam_massnahme.msn_statusbeschreibung;
        case piv_art
            when '<replace>' then
                update isr_oam_massnahme
                set
                    msn_uid = pir_isr_oam_massnahme.msn_uid
                where
                    msn_uid = pir_isr_oam_massnahme.msn_uid;

            when '<full>' then    
      -- �bernehmen der Eingabedaten  
                r_isr_oam_massnahme := pir_isr_oam_massnahme;  
      -- Erg�nzen der Anlagedaten  
                select
                    inserted,
                    inserted_by
                into
                    r_isr_oam_massnahme.inserted,
                    r_isr_oam_massnahme.inserted_by
                from
                    isr_oam_massnahme
                where
                    msn_uid = pir_isr_oam_massnahme.msn_uid;  
      -- Erg�nzen der Update-Daten  
                r_isr_oam_massnahme.updated := sysdate;
                r_isr_oam_massnahme.updated_by := pck_env.fv_user;
                update isr_oam_massnahme
                set
                    row = r_isr_oam_massnahme
                where
                    msn_uid = pir_isr_oam_massnahme.msn_uid;
      --HISTORY--
                r_isr_oam_massnahme_hist.msn_uid := pir_isr_oam_massnahme.msn_uid;
                pck_isr_oam_massnahme_hist_dml.p_insert(pior_isr_oam_massnahme_hist => r_isr_oam_massnahme_hist);
            else
                raise_application_error(-20000, 'Parameter wird nicht unterstuetzt!');
        end case;

    exception
        when others then
    -- Fehlerprotokollierung
            c_message := 'Fehler bei Update! Parameter: ' || fv_print(pir_row => pir_isr_oam_massnahme);
            pck_logs.p_error(
                piv_routine_name => v_routine_name,
                pic_message      => c_message
            );
            raise;
    end p_update;

---------------------------------------------------------------------------------------------------

    procedure p_delete (
        pin_msn_uid in isr_oam_massnahme.msn_uid%type
    ) is

  -- fuer exceptions
        v_routine_name logs.routine_name%type;
        v_parameter    varchar2(4000);
        c_message      clob;
        e_no_data exception;
    begin
  -- fuer exceptions
        v_routine_name := gcv_package_name || '.P_DELETE';
        v_parameter := 'Parameter: pin_msn_uid: ' || to_char(pin_msn_uid);
        delete from isr_oam_massnahme
        where
            msn_uid = pin_msn_uid;

        if sql%notfound then
            raise e_no_data;
        end if;
    exception
        when e_no_data then
    -- nur Hinweis fuer evt. Fehlersuche
            c_message := 'Hinweis! Zu loeschender DS existiert nicht. Tabelle isr_oam_massnahme! ' || v_parameter;
            pck_logs.p_error_exp(
                piv_routine_name => v_routine_name,
                pic_message      => c_message
            );
        when others then
    -- Fehlerprotokollierung
            c_message := 'Fehler beim Loeschen in Tabelle isr_oam_massnahme! ' || v_parameter;
            pck_logs.p_error(
                piv_routine_name => v_routine_name,
                pic_message      => c_message
            );
            raise;
    end p_delete;

end pck_isr_oam_massnahme_dml;
/

