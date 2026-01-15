-- liquibase formatted sql
-- changeset ROMA_MAIN:1768480976870 stripComments:false logicalFilePath:develop/roma_main/functions/fb_is_valid_vkz.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot GLASCONTAINER_MAIN/src/database/roma_main/functions/fb_is_valid_vkz.sql:null:f1907e91d566633041e1641264399989ab43cffc:create

create or replace function roma_main.fb_is_valid_vkz (
    piv_vkz in varchar2
) return boolean is
/**
 * Liefert TRUE zurück, wenn es sich bei dem übergebenen String um die Kennzeichnung
 * eines gültigen VKZ (Vertriebskennzeichens) handelt, FALSE wenn nicht, und NULL falls der Eingabestring leer ist.
 * Der Vergleich erfolgt nicht case-sensitiv, sondern der
 * eingegebene String wird in UPPERCASE umgewandelt und erst dann case-sensitiv gegen
 * die aktuellen VKZ verglichen: Nach Aussage von Thorsten Westenberg liegen alle gültigen
 * VKZ in Siebel in GROSSSCHREIBWEISE vor (Ausnahmen sind "..._old", was aber per Definition nicht
 * relevant ist).
 *
 * @param piv_vkz  [IN ]  Typischerweise von User eingegebener String, dessen Übereinstimmung
 *                        mit einem gültigen VKZ geprüft werden soll. Der eingegebene String muss getrimmt sein (
 *                        keine Leerzeichen oder Sonderzeichen links oder rechts), um einen Treffer erzielen zu können.
 *
 * @ticket FTTH-2946 
 *
 * @creation 2024-09-10
 * @author   Andreas Wismann  WISAND  <wismann@when-others.com>
 * @usage    APEX App "Glascontainer"
 *
 * @example
 * BEGIN
 *   DBMS_OUTPUT.PUT_LINE(CASE fb_is_valid_vkz('ECOWBS036') WHEN TRUE THEN 'TRUE' WHEN FALSE THEN 'FALSE' END);  
 * END;
 *
 * @unittest
 * SELECT * FROM TABLE(ut.run('UT_VKZ', a_tags => 'fb_is_valid_vkz'));
 */

begin
  -- Diese Zeile filtert die NULL-Eingabe heraus. Dadurch ist gewährleistet, dass diese FUNCTION ein klareres Ergebnis
  -- liefert als FV_VALID_VKZ selbst: Die Werte TRUE, FALSE und NULL werden zurückgegeben.
    if piv_vkz is null then
        return null;
    end if;
    
  -- Die Function fv_valid_vkz beherrscht als Ausgabe nur String mit entweder NOT NULL oder NULL, bei letzteren
  -- kann nicht zwischen NULL-Eingabe und Nichtvorhandensein des VKZ entschieden werden. fv_valid_vkz hat in erster Linie
  -- eine andere Aufgabe: nämlich das eingegebene VKZ, falls es existiert, zu NORMALISIEREN und dadurch
  -- Validierungen und Folgeprozesse abzusichern.
    return fv_valid_vkz(piv_vkz) is not null;
end;
/

