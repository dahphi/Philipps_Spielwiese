-- liquibase formatted sql
-- changeset RK_MAIN:1774561690838 stripComments:false logicalFilePath:SCDP/rk_main/package_bodies/msm_utils.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot RK_MAIN/src/database/rk_main/package_bodies/msm_utils.sql:null:0e8ec360dabab3bcba9c701e0ccdf024666c3826:create

create or replace package body rk_main.msm_utils as

    function get_ldap_attribute (
        p_attribute in varchar2,
        p_user      in varchar2
    ) return varchar2 as
        result varchar2(1000) := p_attribute;
    begin
        result := replace(result, ',', ':');
        for attr in (
            select
                name,
                val
            from
                table ( apex_ldap.search(
                    p_host            => 'ad.netcologne.intern',
                    p_port            => 636,
                    p_use_ssl         => 'A',
                    p_username        => 'CN=dienst_apex,OU=Dienste,DC=netcologne,DC=intern',
                    p_pass            => 'ZMORj3Pw',
                    p_search_base     => 'OU=Abteilungen,DC=netcologne,DC=intern',
                    p_search_filter   => 'sAMAccountName='
                                       || apex_escape.ldap_search_filter(replace(p_user, 'NC_OFFICE\')),
                    p_attribute_names => p_attribute
                ) )
        ) loop
            result := replace(result, attr.name, attr.val);
        end loop;

        if result = p_attribute then
        -- kein Ergebnis gefunden
            result := null;
        end if;
        return result;
    end;

    function html_encode_ger (
        p_string varchar2
    ) return varchar2 as

        type html_symbol_type is
            table of varchar2(16) index by varchar2(2);
        html   html_symbol_type;
        c      varchar2(2);
        result varchar2(4000);
    begin
        html('<') := 'lt';
        html('>') := 'gt';
        html('&') := 'amp';
--    html('#') := '#35';
        html(';') := '#59';
        html('Ä') := 'Auml';
        html('Ö') := 'Ouml';
        html('Ü') := 'Uuml';
        html('ä') := 'auml';
        html('ö') := 'ouml';
        html('ü') := 'uuml';
        html('ß') := 'szlig';
        c := html.first;
        result := p_string;
        while ( c is not null ) loop
            result := replace(result,
                              c,
                              '&'
                              || html(c)
                              || ';');

            c := html.next(c);
        end loop;

        result := replace(result,
                          chr(10),
                          '<br>');
        return result;
    end html_encode_ger;

    function is_test_environment return number as
        result number;
    begin
        select
            count(*)
        into result
        from
            global_name
        where
            global_name in
    /* Liste der Servicenamen der Testumgebungen */ ( 'SCDT.NETCOLOGNE.INTERN', 'COLLIX.NETCOLOGNE.INTERN', 'COLLIU.NETCOLOGNE.INTERN'
            , 'COLLIE.NETCOLOGNE.INTERN', 'NMCE.NETCOLOGNE.INTERN',
                             'NMCX3.NETCOLOGNE.INTERN' );

        return result;
    end is_test_environment;

-- https://ferien-api.de/
    function holidays_from_string (
        p_holidays varchar2
    ) return holiday_table
        pipelined
    as
        l_clob     clob;
        von        date;
        bis        date;
        row_buffer holiday_record;
        l_count    number;
    begin
        dbms_lob.createtemporary(l_clob, false);
        dbms_lob.writeappend(l_clob,
                             length(p_holidays),
                             p_holidays);
        for h in (
            select
                *
            from
                json_table ( l_clob, '$[*]'
                    columns (
                        row_number for ordinality,
                        h_start varchar2 path '$.start',
                        h_end varchar2 path '$.end',
                        h_year number path '$.year',
                        h_statecode varchar2 path '$.stateCode',
                        h_name varchar2 path '$.name',
                        h_slug varchar2 path '$.slug'
                    )
                )
        ) loop
            row_buffer.h_start := to_date ( substr(h.h_start, 1, 10), 'YYYY-MM-DD' );

            row_buffer.h_end := to_date ( substr(h.h_end, 1, 10), 'YYYY-MM-DD' );

            row_buffer.h_year := h.h_year;
            row_buffer.h_statecode := h.h_statecode;
            row_buffer.h_name := h.h_name;
            row_buffer.h_slug := h.h_slug;
            pipe row ( row_buffer );
        end loop;

        return;                            
/*
            xmlbuf := XMLType(l_clob);

            FOR absence IN 
            (
                select *
                from xmltable(xmlnamespaces(default 'http://RelaxWS.netcologne.intern/'),
                                '/ArrayOfMAUrlaubProjectile/MAUrlaubProjectile'
                passing xmlbuf
                columns 
                      vorname varchar2(100) path 'Vorname',
                      nachname varchar2(100) path 'Nachname',
                      von varchar2(100) path 'UrlaubsantragVon',
                      bis varchar2(100) path 'UrlaubsantragBis',
                      status varchar2(100) path 'UrlaubsantragStatus',
                      art varchar2(100) path 'Abwesenheitsart')
            ) 
            LOOP
                von := to_date(SUBSTR(absence.von, 1,10), 'YYYY-MM-DD');
                bis := to_date(SUBSTR(absence.bis, 1,10), 'YYYY-MM-DD');

                row_buffer."ns1:Vorname" := absence.vorname;
                row_buffer."ns1:Nachname" := absence.nachname;
                row_buffer."ns1:UrlaubssantragVon" := von;
                row_buffer."ns1:UrlaubssantragBis" := bis;
                row_buffer."ns1:UrlaubssantragStatus" := absence.status;
                row_buffer."ns1:Abwesenheitsart" := absence.art;
                pipe row ( row_buffer );
            END LOOP;
*/
    end holidays_from_string;

    function all_ad_accounts return vc256_2_table
        pipelined
    as

        type vc256_array_t is
            table of varchar2(256);
        search_base_array vc256_array_t := vc256_array_t();
        i                 number := 1;
        row_buffer        vc256_2_record;
    begin
        for ou in (
            select
                dn
            from
                table ( apex_ldap.search(
                    p_host            => 'ad.netcologne.intern',
                    p_username        => 'CN=dienst_apex,OU=Dienste,DC=netcologne,DC=intern',
                    p_pass            => 'ZMORj3Pw',
                    p_search_base     => 'OU=Abteilungen,DC=netcologne,DC=intern',
                    p_search_filter   => 'objectClass=organizationalUnit',
                    p_attribute_names => 'objectClass'
                ) )
            where
                    val = 'organizationalUnit'
                and substr(dn,
                           instr(dn, ',') + 1,
                           12) = 'OU=Abteilung'
        ) loop
            search_base_array.extend();
            search_base_array(i) := ou.dn;
            i := i + 1;
        end loop;

        for sb in search_base_array.first..search_base_array.last loop
            for acct in (
                select
                    *
                from
                    (
                        select
                            name,
                            dn,
                            val
                        from
                            table ( apex_ldap.search(
                                p_host            => 'ad.netcologne.intern',
                                p_username        => 'CN=dienst_apex,OU=Dienste,DC=netcologne,DC=intern',
                                p_pass            => 'ZMORj3Pw',
                                p_search_base     => search_base_array(sb),
                                p_search_filter   => '&(objectCategory=Person)(sAMAccountName=*)',
                                p_attribute_names => 'sAMAccountName,displayName'
                            ) )
                    ) pivot (
                        max(val)
                        for name
                        in ( 'sAMAccountName',
                        'displayName' )
                    )
            ) loop
                row_buffer.val1 := acct."'sAMAccountName'";
                row_buffer.val2 := acct."'displayName'";
                pipe row ( row_buffer );
            end loop;
        end loop;

        return;
    end all_ad_accounts;

/*
procedure datenpumpe_ad_accounts
as
begin
    delete from AD_ABTEILUNGSACCOUNT;
    delete from ad_abteilung;

    for abt in 
    (
        SELECT DN 
        FROM table(apex_ldap.search (
                                p_host            => 'ad.netcologne.intern',
                                p_username        => 'CN=dienst_apex,OU=Dienste,DC=netcologne,DC=intern',
                                p_pass            => 'ZMORj3Pw',
                                p_search_base     => 'OU=Abteilungen,DC=netcologne,DC=intern',
                                p_search_filter   => 'objectClass=organizationalUnit',
                                p_attribute_names => 'objectClass' ))
        where val='organizationalUnit'
        and substr(dn, instr(dn, ',')+1, 12) = 'OU=Abteilung'
    ) 
    loop
        insert into AD_ABTEILUNG(aa_dn)
        values (abt.dn);
    end loop;

    for abt in
    (
        select aa_uid, aa_dn
        from ad_abteilung
    )
    loop
        for acct in
        (
            select * from
            (
                SELECT NAME,dn,val
                FROM table(apex_ldap.search (
                                        p_host            => 'ad.netcologne.intern',
                                        p_username        => 'CN=dienst_apex,OU=Dienste,DC=netcologne,DC=intern',
                                        p_pass            => 'ZMORj3Pw',
                                        p_search_base     => abt.aa_dn,
                                        p_search_filter   => '&(objectCategory=Person)(sAMAccountName=*)',
                                        p_attribute_names => 'sAMAccountName,displayName' ))
            )
            pivot
            (
                max(val)
                for name in ('sAMAccountName','displayName')
            )                                    
        )
        loop
            insert into AD_ABTEILUNGSACCOUNT(aa_uid, aaa_san, aaa_displayname)
            values (abt.aa_uid, acct."'sAMAccountName'", acct."'displayName'");
        end loop;
    end loop;
    commit;
end datenpumpe_ad_accounts;
*/
end msm_utils;
/

