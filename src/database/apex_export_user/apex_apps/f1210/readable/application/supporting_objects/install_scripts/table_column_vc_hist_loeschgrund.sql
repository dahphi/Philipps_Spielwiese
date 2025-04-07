--Einfügen einer Spalte mit Kommentar in VC_HIST

ALTER TABLE VC_HIST
ADD LOESCHGRUND NUMBER;

COMMENT ON COLUMN "ROMA_MAIN"."VC_HIST"."LOESCHGRUND" IS '@ticket FTTH-2323: Grund, der beim Löschen eines Vermarktungsclusters angegeben werden muss: 1 = Projekt fertiggestellt 2 = Projekt zurückgezogen 3 = Test';



-- sqlcl_snapshot {"hash":"a3b2c8840b11e8f28873d3dcfb54986c39c363d4","type":"APEX_APPLICATION","name":"f1210","schemaName":"APEX_EXPORT_USER"}