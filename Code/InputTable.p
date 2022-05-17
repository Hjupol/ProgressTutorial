DEFINE TEMP-TABLE tabla NO-UNDO
    FIELD nombre AS CHARACTER
    FIELD edad AS INTEGER
    FIELD indice AS INTEGER
    FIELD rango AS CHARACTER EXTENT 2.

DEFINE VARIABLE a AS CHARACTER NO-UNDO. 
DEFINE STREAM streamImport.
DEFINE STREAM streamExport.
DEFINE VARIABLE entrada AS CHARACTER NO-UNDO.
DEFINE VARIABLE filePath AS CHARACTER NO-UNDO INITIAL "C:\Users\QAD\Desktop\Documentos_Trabajo\clientes1.csv".
/*Agregar append*/
OUTPUT STREAM streamExport TO VALUE(filePath) APPEND.
PUT STREAM streamExport UNFORMATTED a SKIP(1).
OUTPUT STREAM streamExport CLOSE.
INPUT STREAM streamImport FROM VALUE(filePath).

REPEAT :
    /* Default separator is space so use , instead */
    IMPORT STREAM streamImport UNFORMATTED entrada.
    IF entrada = " " THEN NEXT.
    ELSE DO:
        CREATE tabla.
        ASSIGN nombre = ENTRY(1,entrada,";") NO-ERROR.
        ASSIGN edad = INTEGER(ENTRY(2,entrada,";")) NO-ERROR.
        ASSIGN indice = INTEGER(ENTRY(3,entrada,";")) NO-ERROR.
        ASSIGN rango[1] = ENTRY(4,entrada,";") NO-ERROR.
        ASSIGN rango[2] = ENTRY(5,entrada,";") NO-ERROR.
    END.
END.
INPUT CLOSE.


FOR EACH tabla:
    DISPLAY tabla.
END.