-- liquibase formatted sql
-- changeset AM_MAIN:1774556571600 stripComments:false logicalFilePath:SCDP/am_main/package_bodies/pck_itwo_raum_import_hist_dml.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot AM_MAIN/src/database/am_main/package_bodies/pck_itwo_raum_import_hist_dml.sql:null:687d0a324024b4c7d54c401cc5abc6b4b451177d:create

create or replace package body am_main.pck_itwo_raum_import_hist_dml as

  -- Variablen etc.
    gcv_package_name constant varchar2(100) := $$plsql_unit;

    procedure p_insert (
        pior_itwo_raum_import_hist in out itwo_raum_import_hist%rowtype
    ) is

  -- fuer exceptions
        v_routine_name logs.routine_name%type;
        c_message      clob;
    begin
  -- fuer exceptions
        v_routine_name := gcv_package_name || '.P_INSERT';
        pior_itwo_raum_import_hist.inserted := sysdate;
        pior_itwo_raum_import_hist.inserted_by := pck_env.fv_user;
        insert into itwo_raum_import_hist values pior_itwo_raum_import_hist returning itwo_raum_uid into pior_itwo_raum_import_hist.itwo_raum_uid
        ;

    exception
        when others then
    -- Fehlerprotokollierung
    --c_message := 'Fehler bei Insert in Tabelle ITWO_RAUM_import_hist! Parameter: ' || fv_print( pir_row => pior_ITWO_RAUM_import_hist );
    --pck_logs.p_error( piv_routine_name => v_routine_name, pic_message => c_message );
            raise;
    end p_insert;

    procedure p_import_itwo_raum is

        r_itwo_raum_import_hist itwo_raum_import_hist%rowtype;
        r_itwo_raum             itwo_raum%rowtype;
        cursor c_neue_raeume is
        select
            *
        from
            v_itwo_raum
        where
            raum in (
                select
                    raum
                from
                    v_itwo_raum
                minus
                select
                    raum
                from
                    itwo_raum
            );

        cursor c_update_raume is
        select
            raum,
            site,
            standortpfad
        from
            v_itwo_raum
        minus
        select
            raum,
            site,
            standortpfad
        from
            itwo_raum;

    begin
        for i in c_neue_raeume loop
            r_itwo_raum_import_hist.itwo_raum_uid := to_number ( sys_guid(), 'xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx' );
            r_itwo_raum_import_hist.raum := i.raum;
            r_itwo_raum_import_hist.site := i.site;
            r_itwo_raum_import_hist.standortpfad := i.standortpfad;
            r_itwo_raum_import_hist.system_kommentar := 'Neuer Raum';
            pck_itwo_raum_import_hist_dml.p_insert(pior_itwo_raum_import_hist => r_itwo_raum_import_hist);
            r_itwo_raum.raum := i.raum;
            r_itwo_raum.site := i.site;
            r_itwo_raum.standortpfad := i.standortpfad;
    --dbms_output.put_line(i.RAUM||'vor Insert Raum');
            pck_itwo_raum_dml.p_insert(pior_itwo_raum => r_itwo_raum);
    --dbms_output.put_line(i.RAUM||'nach Insert Raum');

        end loop;

        for u in c_update_raume loop
            r_itwo_raum_import_hist.itwo_raum_uid := to_number ( sys_guid(), 'xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx' );
            r_itwo_raum_import_hist.raum := u.raum;
            r_itwo_raum_import_hist.site := u.site;
            r_itwo_raum_import_hist.standortpfad := u.standortpfad;
            r_itwo_raum_import_hist.system_kommentar := 'Update Raum';
            pck_itwo_raum_import_hist_dml.p_insert(pior_itwo_raum_import_hist => r_itwo_raum_import_hist);
            r_itwo_raum.raum := u.raum;
            r_itwo_raum.site := u.site;
            r_itwo_raum.standortpfad := u.standortpfad;
    --dbms_output.put_line(u.RAUM||'vor Update RAUM');
            pck_itwo_raum_dml.p_update(pior_itwo_raum => r_itwo_raum);
    --dbms_output.put_line(u.RAUM||'nach Update RAUM');

        end loop;

    end p_import_itwo_raum;

end pck_itwo_raum_import_hist_dml;
/

