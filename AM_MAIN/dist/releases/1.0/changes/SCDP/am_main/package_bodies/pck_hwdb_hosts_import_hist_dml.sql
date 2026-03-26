-- liquibase formatted sql
-- changeset AM_MAIN:1774556571548 stripComments:false logicalFilePath:SCDP/am_main/package_bodies/pck_hwdb_hosts_import_hist_dml.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot AM_MAIN/src/database/am_main/package_bodies/pck_hwdb_hosts_import_hist_dml.sql:null:f78b4ae40136b9e89d006f782f28d18ed47aeb83:create

create or replace package body am_main.pck_hwdb_hosts_import_hist_dml as

  -- Variablen etc.
    gcv_package_name constant varchar2(100) := $$plsql_unit;

    procedure p_insert (
        pior_hwdb_hosts_import_hist in out hwdb_hosts_import_hist%rowtype
    ) is

  -- fuer exceptions
        v_routine_name logs.routine_name%type;
        c_message      clob;
    begin
  -- fuer exceptions
        v_routine_name := gcv_package_name || '.P_INSERT';
        pior_hwdb_hosts_import_hist.inserted := sysdate;
        pior_hwdb_hosts_import_hist.inserted_by := pck_env.fv_user;
        insert into hwdb_hosts_import_hist values pior_hwdb_hosts_import_hist returning hwdb_imp_uid into pior_hwdb_hosts_import_hist.hwdb_imp_uid
        ;

    exception
        when others then
    -- Fehlerprotokollierung
    --c_message := 'Fehler bei Insert in Tabelle HWDB_HOSTS_import_hist! Parameter: ' || fv_print( pir_row => pior_HWDB_HOSTS_import_hist );
    --pck_logs.p_error( piv_routine_name => v_routine_name, pic_message => c_message );
            raise;
    end p_insert;

    procedure p_import_hwdb is

        r_hwdb_hosts_import_hist hwdb_hosts_import_hist%rowtype;
        r_hwdb_hosts             hwdb_hosts%rowtype;
        cursor c_neue_geraete is
        select
            *
        from
            am_int.hwdb_hosts
        where
            hostname in (
                select
                    hostname
                from
                    am_int.hwdb_hosts
                minus
                select
                    hostname
                from
                    hwdb_hosts
            );

        cursor c_update_geraete is
        select
            hostname,
            hersteller,
            modell,
            funktionsklasse,
            location,
            raum
        from
            am_int.hwdb_hosts
        minus
        select
            hostname,
            hersteller,
            modell,
            funktionsklasse,
            location,
            raum
        from
            hwdb_hosts;

        cursor c_geraete_entfernt is
        select
            *
        from
            hwdb_hosts
        where
            hostname not in (
                select
                    hostname
                from
                    am_int.hwdb_hosts
            );

    begin
        for i in c_neue_geraete loop

	 --dbms_output.put_line(i.VALID_TO);
            r_hwdb_hosts_import_hist.hwdb_imp_uid := to_number ( sys_guid(), 'xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx' );
            r_hwdb_hosts_import_hist.hostname := i.hostname;
            r_hwdb_hosts_import_hist.hersteller := i.hersteller;
            r_hwdb_hosts_import_hist.modell := i.modell;
            r_hwdb_hosts_import_hist.funktionsklasse := i.funktionsklasse;
            r_hwdb_hosts_import_hist.location := i.location;
            r_hwdb_hosts_import_hist.raum := i.raum;
            r_hwdb_hosts_import_hist.system_kommentar := 'Neues Gerät';
            pck_hwdb_hosts_import_hist_dml.p_insert(pior_hwdb_hosts_import_hist => r_hwdb_hosts_import_hist);
            r_hwdb_hosts.hostname := i.hostname;
            r_hwdb_hosts.hersteller := i.hersteller;
            r_hwdb_hosts.modell := i.modell;
            r_hwdb_hosts.funktionsklasse := i.funktionsklasse;
            r_hwdb_hosts.location := i.location;
            r_hwdb_hosts.raum := i.raum;
            r_hwdb_hosts.status := 1;--aktiv
    --dbms_output.put_line(i.HOSTNAME||' Insert Gerät');
            pck_hwdb_hosts_dml.p_insert(pior_hwdb_hosts => r_hwdb_hosts);
        end loop;

        for u in c_update_geraete loop
            r_hwdb_hosts_import_hist.hwdb_imp_uid := to_number ( sys_guid(), 'xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx' );
            r_hwdb_hosts_import_hist.hostname := u.hostname;
            r_hwdb_hosts_import_hist.hersteller := u.hersteller;
            r_hwdb_hosts_import_hist.modell := u.modell;
            r_hwdb_hosts_import_hist.funktionsklasse := u.funktionsklasse;
            r_hwdb_hosts_import_hist.location := u.location;
            r_hwdb_hosts_import_hist.raum := u.raum;
            r_hwdb_hosts_import_hist.system_kommentar := 'Update Gerät';
            pck_hwdb_hosts_import_hist_dml.p_insert(pior_hwdb_hosts_import_hist => r_hwdb_hosts_import_hist);
            r_hwdb_hosts.hostname := u.hostname;
            r_hwdb_hosts.hersteller := u.hersteller;
            r_hwdb_hosts.modell := u.modell;
            r_hwdb_hosts.funktionsklasse := u.funktionsklasse;
            r_hwdb_hosts.location := u.location;
            r_hwdb_hosts.raum := u.raum;
            r_hwdb_hosts.status := 1;--aktiv
    --dbms_output.put_line(u.HOSTNAME||' Update Gerät');
            pck_hwdb_hosts_dml.p_update(pior_hwdb_hosts => r_hwdb_hosts);
        end loop;

        for d in c_geraete_entfernt loop
            r_hwdb_hosts_import_hist.hwdb_imp_uid := to_number ( sys_guid(), 'xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx' );
            r_hwdb_hosts_import_hist.hostname := d.hostname;
            r_hwdb_hosts_import_hist.hersteller := d.hersteller;
            r_hwdb_hosts_import_hist.modell := d.modell;
            r_hwdb_hosts_import_hist.funktionsklasse := d.funktionsklasse;
            r_hwdb_hosts_import_hist.location := d.location;
            r_hwdb_hosts_import_hist.raum := d.raum;
            r_hwdb_hosts_import_hist.system_kommentar := 'Gerät in HWDB entfernt';
            pck_hwdb_hosts_import_hist_dml.p_insert(pior_hwdb_hosts_import_hist => r_hwdb_hosts_import_hist);
            r_hwdb_hosts.hostname := d.hostname;
            r_hwdb_hosts.hersteller := d.hersteller;
            r_hwdb_hosts.modell := d.modell;
            r_hwdb_hosts.funktionsklasse := d.funktionsklasse;
            r_hwdb_hosts.location := d.location;
            r_hwdb_hosts.raum := d.raum;
            r_hwdb_hosts.status := 0;--inaktiv
            pck_hwdb_hosts_dml.p_update(pior_hwdb_hosts => r_hwdb_hosts);
        end loop;

    end p_import_hwdb;

end pck_hwdb_hosts_import_hist_dml;
/

