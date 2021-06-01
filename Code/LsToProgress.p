{us/mf/mfdtitle.i "b+ "}

DEFINE TEMP-TABLE lista NO-UNDO
    FIELD nombre AS CHARACTER.
DEFINE STREAM streamImport.
DEFINE STREAM streamExport.

    DEFINE VARIABLE path AS CHARACTER NO-UNDO.

    FIND LAST code_mstr NO-LOCK WHERE code_mstr.code_domain = global_domain
        AND code_mstr.code_fldname = "salida_para" NO-ERROR.
        IF AVAILABLE code_mstr THEN DO:
            path = code_mstr.code_desc.
        END.

    DEFINE VARIABLE a AS CHARACTER NO-UNDO. 
    DEFINE VARIABLE entrada AS CHARACTER NO-UNDO.
    /*DEFINE VARIABLE filePath AS CHARACTER NO-UNDO INITIAL "C:\Users\crmor\Desktop\Adriel\ProgressTutorial\dirFile.txt".*/
    DEFINE VARIABLE filePath AS CHARACTER NO-UNDO.
    filePath = path + "/fileLS.txt".

    /*OS-COMMAND NO-WAIT VALUE("DIR C:\Users\crmor\Desktop\Adriel\ProgressTutorial /b > C:\Users\crmor\Desktop\Adriel\ProgressTutorial\dirFile.txt").*/  
    OS-COMMAND NO-CONSOLE VALUE("ls -1 " + path + " > " + filePath).
    /*Agregar append*/
    /*OUTPUT STREAM streamExport TO VALUE(filePath) APPEND.
    PUT STREAM streamExport UNFORMATTED a SKIP(1).
    OUTPUT STREAM streamExport CLOSE.*/
    INPUT STREAM streamImport FROM VALUE(filePath).

    FOR EACH usrw_wkfl WHERE usrw_wkfl.usrw_domain = global_domain
    AND usrw_wkfl.usrw_key1 = "archivoListado" :
        DELETE usrw_wkfl.
    END.

    REPEAT :
        /* Default separator is space so use , instead */
        IMPORT STREAM streamImport UNFORMATTED entrada.
        IF entrada = "fileLS.txt" THEN NEXT.
        ELSE DO:
            IF entrada = " " THEN NEXT. /*Chequear el verdadero separador*/
            ELSE DO:
                CREATE lista.
                ASSIGN nombre = ENTRY(1,entrada,"") NO-ERROR.
            END.
        END.
    END.
    INPUT CLOSE.


    OS-COMMAND NO-CONSOLE VALUE("rm " + filePath).


    FOR EACH lista:
        CREATE usrw_wkfl.
        ASSIGN usrw_wkfl.usrw_domain = global_domain.    
               usrw_wkfl.usrw_key1 = "archivoListado".    
               usrw_wkfl.usrw_key2 = lista.nombre.    
        /*DISPLAY lista.*/
    END.