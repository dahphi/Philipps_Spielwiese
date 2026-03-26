-- liquibase formatted sql
-- changeset AM_MAIN:1774557119665 stripComments:false logicalFilePath:SCDP/am_main/package_bodies/pck_itwo_site_import_hist_dml.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot AM_MAIN/src/database/am_main/package_bodies/pck_itwo_site_import_hist_dml.sql:null:659000251e2bb91bbe9a7ded69df24971f6f459c:create

create or replace package body am_main.pck_itwo_site_import_hist_dml as

  -- Variablen etc.
    gcv_package_name constant varchar2(100) := $$plsql_unit;

    procedure p_insert (
        pior_itwo_site_import_hist in out itwo_site_import_hist%rowtype
    ) is

  -- fuer exceptions
        v_routine_name logs.routine_name%type;
        c_message      clob;
    begin
  -- fuer exceptions
        v_routine_name := gcv_package_name || '.P_INSERT';
        pior_itwo_site_import_hist.inserted := sysdate;
        pior_itwo_site_import_hist.inserted_by := pck_env.fv_user;
        insert into itwo_site_import_hist values pior_itwo_site_import_hist returning itwo_site_uid into pior_itwo_site_import_hist.itwo_site_uid
        ;

    exception
        when others then
    -- Fehlerprotokollierung
    --c_message := 'Fehler bei Insert in Tabelle ITWO_SITE_import_hist! Parameter: ' || fv_print( pir_row => pior_ITWO_SITE_import_hist );
    --pck_logs.p_error( piv_routine_name => v_routine_name, pic_message => c_message );
            raise;
    end p_insert;

    procedure p_import_itwo_site is

        r_itwo_site_import_hist itwo_site_import_hist%rowtype;
        r_itwo_site             itwo_site%rowtype;
        cursor c_neue_sites is
        select
            *
        from
            v_itwo_site
        where
            obj_id in (
                select
                    obj_id
                from
                    v_itwo_site
                minus
                select
                    obj_id
                from
                    itwo_site
            );

        cursor c_update_sites is
        select
            obj_id,
            site,
            plz,
            stadt,
            strasse,
            haus_nr
        from
            v_itwo_site
        minus
        select
            obj_id,
            site,
            plz,
            stadt,
            strasse,
            haus_nr
        from
            itwo_site;

    begin
        for i in c_neue_sites loop
            r_itwo_site_import_hist.itwo_site_uid := to_number ( sys_guid(), 'xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx' );
            r_itwo_site_import_hist.obj_id := i.obj_id;
            r_itwo_site_import_hist.site := i.site;
            r_itwo_site_import_hist.plz := i.plz;
            r_itwo_site_import_hist.stadt := i.stadt;
            r_itwo_site_import_hist.strasse := i.strasse;
            r_itwo_site_import_hist.haus_nr := i.haus_nr;
            r_itwo_site_import_hist.system_kommentar := 'Neuer Standort';
            dbms_output.put_line(i.site || ' Insert Standort');
            pck_itwo_site_import_hist_dml.p_insert(pior_itwo_site_import_hist => r_itwo_site_import_hist);
            r_itwo_site.obj_id := i.obj_id;
            r_itwo_site.site := i.site;
            r_itwo_site.plz := i.plz;
            r_itwo_site.stadt := i.stadt;
            r_itwo_site.strasse := i.strasse;
            r_itwo_site.haus_nr := i.haus_nr;
    --dbms_output.put_line(i.OBJ_ID||' Insert Standort');
            pck_itwo_site_dml.p_insert(pior_itwo_site => r_itwo_site);
        end loop;

        for u in c_update_sites loop
            r_itwo_site_import_hist.itwo_site_uid := to_number ( sys_guid(), 'xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx' );
            r_itwo_site_import_hist.obj_id := u.obj_id;
            r_itwo_site_import_hist.site := u.site;
            r_itwo_site_import_hist.plz := u.plz;
            r_itwo_site_import_hist.stadt := u.stadt;
            r_itwo_site_import_hist.strasse := u.strasse;
            r_itwo_site_import_hist.haus_nr := u.haus_nr;
            r_itwo_site_import_hist.system_kommentar := 'Update Standort';
    --dbms_output.put_line(u.OBJ_ID||' vor insert');
            pck_itwo_site_import_hist_dml.p_insert(pior_itwo_site_import_hist => r_itwo_site_import_hist);
    --dbms_output.put_line(u.OBJ_ID||' nach insert');
            r_itwo_site.obj_id := u.obj_id;
            r_itwo_site.site := u.site;
            r_itwo_site.plz := u.plz;
            r_itwo_site.stadt := u.stadt;
            r_itwo_site.strasse := u.strasse;
            r_itwo_site.haus_nr := u.haus_nr;
    --dbms_output.put_line(u.OBJ_ID||' Update Standort - vor update');
            pck_itwo_site_dml.p_update(pior_itwo_site => r_itwo_site);
    --dbms_output.put_line(u.OBJ_ID||' Update Standort - nach update');

        end loop;

    end p_import_itwo_site;

end pck_itwo_site_import_hist_dml;
/

