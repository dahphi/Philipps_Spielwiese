create or replace function fv_vkz (
    piv_user in varchar2
) return varchar2 is
/**
 * Gibt das VKZ für einen Usernamen aus dem NetCologne-AD zurück.
 * Existiert das Namenskürzel nicht im Active Directory oder ist kein VKZ zugeordnet, 
 * wird NULL zurückgegeben.
 *
 * @param piv_user  [IN ]  Kürzel der Mitarbeiterin/des Mitarbeiters (in APEX typischerweise :APP_USER)
 *
 * @exception Alle Exceptions werden geworfen, außer NO_DATA_FOUND
 * @usage     APEX-App 1200 (Objektinfo)
 * @ticket    FTTH-1526 
 * @author    Andreas Wismann <wismann@when-others.com>
 */
    c_user constant varchar2(4000) := trim(piv_user);
    v_vkz  varchar2(4000);
begin
    if c_user is null then
        return null;
    end if;
    select
        val
    into v_vkz
    from
        table ( core.ad.search(
            p_search_base     => 'OU=Abteilungen,DC=netcologne,DC=intern',
            p_search_filter   => '&(objectCategory=Person)(sAMAccountName='
                               || c_user
                               || ')',
            p_attribute_names => 'msExchExtensionAttribute42'
        ) );

    return v_vkz;
exception
    when no_data_found then
        return null;
    when others then
        raise;
end;
/


-- sqlcl_snapshot {"hash":"50581a4794cd799a4e6c04dad5a9de6fe57547f0","type":"FUNCTION","name":"FV_VKZ","schemaName":"ROMA_MAIN","sxml":""}