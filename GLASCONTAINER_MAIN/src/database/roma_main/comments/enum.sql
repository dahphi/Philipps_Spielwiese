comment on table enum is
    'Projekt FTTH / Glascontainer: Aufzählungen / List of Values (LOV) zur Abfrage durch unterschiedliche Systeme: Für einen Schlüsselwert (Kombination von DOMAIN und KEY) gibt es für ein bestimmtes System bzw. eine bestimmte Sprache (sprache) eine Singular- und ggf. eine Plural-Übersetzung. @author: Andreas Wismann <wismann@when-others.com>'
    ;

comment on column enum.domain is
    '"Domäne", also der (häufig englischsprachige oder technisch geprägte) Name der Liste, beispielsweise "legalForm" (kontext-sensitiv)'
    ;

comment on column enum.id is
    'Technischer PK';

comment on column enum.key is
    'Der Listen-Schlüsselwert, in APEX oft als Return Value bezeichnet, dessen Ausprägung für die technische Weiterverarbeitung benötigt wird, z.B. PRIVATE_CITIZEN'
    ;

comment on column enum.kontext is
    'Projekt oder Anwendung, zu welchem die Werteliste gehört (z.B. "FTTH"). Hierdurch wird es möglich, Wertelisten gleichen Namens (etwa "ANREDE") in unterschiedlichen System unabhängig voneinander zu führen'
    ;

comment on column enum.plural is
    'Die optional verfügbare Mehrzahl des Begriffs, beispielsweise "Privatpersonen" - dies kann etwa zum Gruppieren von Daten in Reports hilfreich sein'
    ;

comment on column enum.pos is
    'Die vorgeschlagene, nummerische Position dieses Eintrags in der Liste. Diese Spalte ist ausdrücklich kein Schlüssel und darf auch leer sein, dann entscheidet das aufrufende System selbst über die Reihenfolge. Durch die Kombination mit dem Parameter SPRACHE kann jedes abfragende System die geeignete Reihenfolge der Listeneinträge fest vorgeben.'
    ;

comment on column enum.singular is
    'Der üblicherweise anzuzeigende Begriff für diesen Schlüssel, beispielsweise "Privatperson". Dies Spalte ist bewusst NULLABLE, damit eine Liste noch nicht übersetzter Schlüssel importiert werden kann'
    ;

comment on column enum.sprache is
    'Entweder "*" (dann handelt es sich um die Default-Übersetzung) oder das Kürzel für ein bestimmtes Anwendung bzw. eine natürliche Sprache, für die innerhalb des gegebenen Kontexts eine individuelle Übersetzung benötigt wird (denkbare Beispiele sind etwa DWH für Datawarehouse, EN für englisch oder WEB für ein Web-Frontend, das sich an den Kunden richtet)'
    ;

comment on column enum.status is
    'immer NULL (Vereinbarung: Wertelisteneinträge sind nur dann gültig, wenn ihr Status leer ist - weitere Statuswerte können später an dieser Stelle definiert werden)'
    ;


-- sqlcl_snapshot {"hash":"bb0396138034cb7394af1e82483557dab9028e78","type":"COMMENT","name":"enum","schemaName":"roma_main","sxml":""}