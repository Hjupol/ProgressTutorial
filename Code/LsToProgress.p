DEFINE TEMP-TABLE lista NO-UNDO
    FIELD nombre AS CHARACTER.

DEFINE VARIABLE a AS CHARACTER NO-UNDO. 
DEFINE STREAM streamImport.
DEFINE STREAM streamExport.
DEFINE VARIABLE entrada AS CHARACTER NO-UNDO.
DEFINE VARIABLE filePath AS CHARACTER NO-UNDO INITIAL "C:\Users\crmor\Desktop\Adriel\ProgressTutorial\dirFile.txt".
/*DEFINE VARIABLE filePath AS CHARACTER NO-UNDO INITIAL "C:\Users\crmor\Desktop\Adriel\ProgressTutorial\lsFile.txt".*/

/*Agregar append*/
OUTPUT STREAM streamExport TO VALUE(filePath) APPEND.
PUT STREAM streamExport UNFORMATTED a SKIP(1).
OUTPUT STREAM streamExport CLOSE.
INPUT STREAM streamImport FROM VALUE(filePath).

REPEAT :
    /* Default separator is space so use , instead */
    OS-COMMAND NO-WAIT VALUE("DIR C:\Users\crmor\Desktop\Adriel\ProgressTutorial /b > C:\Users\crmor\Desktop\Adriel\ProgressTutorial\dirFile.txt").
  /*OS-COMMAND VALUE("ls >> lsFile.txt &").*/
    IMPORT STREAM streamImport UNFORMATTED entrada.
    IF entrada = " " THEN NEXT. /*Chequear el verdadero separador*/
    ELSE DO:
        CREATE lista.
        ASSIGN nombre = ENTRY(1,entrada,"") NO-ERROR.
    END.
END.
INPUT CLOSE.


FOR EACH lista:
    DISPLAY lista.
END.