{us/mf/mfdtitle.i "b+ "}

DEFINE TEMP-TABLE lista NO-UNDO
    FIELD nombre AS CHARACTER
    FIELD tipoArchivo AS CHARACTER.
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

    FOR EACH usrw_wkfl WHERE usrw_wkfl.usrw_domain = global_domain :
        IF usrw_wkfl.usrw_key1 = "archivoListado" THEN DO:
            DELETE usrw_wkfl.
        END.
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
               
               IF lista.nombre MATCHES "*~~.*" THEN DO:
               lista.tipoArchivo = SUBSTRING (lista.nombre, INDEX(lista.nombre, ".") + 1,LENGTH(lista.nombre,"CHARACTER")).
               /*IF LENGTH(lista.tipoArchivo,"CHARACTER")>3 THEN DO:
               usrw_wkfl.usrw_key3 = "".
               END.
               ELSE DO:
               usrw_wkfl.usrw_key3 = lista.tipoArchivo.
               END.*/
               END.
               ELSE DO:
               usrw_wkfl.usrw_key3 = "".
               END.
               /*
               IF lista.nombre MATCHES "*~~.csv" THEN DO:
               usrw_wkfl.usrw_key3 = ".csv".
               END.
               ELSE DO:
               usrw_wkfl.usrw_key3 = " ".
               END.*/
        /*DISPLAY lista.*/
    END.


IF bfusrw AVAILABLE THEN NEXT

/*CODIGO FINAL*/
/*DEFINE TEMP-TABLE lista NO-UNDO
    FIELD nombre AS CHARACTER.
DEFINE STREAM streamImport.
DEFINE STREAM streamExport.
Define buffer bfusrw for usrw_wkfl.



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

FOR EACH bfusrw Exclusive-Lock WHERE bfusrw.usrw_domain = global_domain
AND bfusrw.usrw_key1 = "archivoListado" :
    DELETE bfusrw.
END.

/*Agregar append*/
/*OUTPUT STREAM streamExport TO VALUE(filePath) APPEND.
PUT STREAM streamExport UNFORMATTED a SKIP(1).
OUTPUT STREAM streamExport CLOSE.*/
INPUT STREAM streamImport FROM VALUE(filePath).





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
        CREATE bfusrw.
        ASSIGN bfusrw.usrw_domain = global_domain.    
               bfusrw.usrw_key1 = "archivoListado".    
               bfusrw.usrw_key2 = lista.nombre.   
               IF lista.nombre MATCHES "*~~.csv" THEN DO:
               bfusrw.usrw_key3 = ".csv".
               END.
               ELSE DO:
               bfusrw.usrw_key3 = " ".
               END.
        /*DISPLAY lista.*/
    END.*/
    
    /*********************************** FINAL 10/6/21 ******************************************/
    /*
DEFINE TEMP-TABLE lista NO-UNDO
    FIELD nombre AS CHARACTER
FIELD tipoArchivo AS CHARACTER.
DEFINE STREAM streamImport.
DEFINE STREAM streamExport.
Define buffer bfusrw for usrw_wkfl.
define variable usuario as character.
usuario = global_userid.

DEFINE VARIABLE path AS CHARACTER NO-UNDO.

FIND LAST code_mstr NO-LOCK WHERE code_mstr.code_domain = global_domain
    AND code_mstr.code_fldname = "salida_para" NO-ERROR.
    IF AVAILABLE code_mstr THEN DO:
        path = code_mstr.code_desc.
    END.

DEFINE VARIABLE a AS CHARACTER NO-UNDO. 
DEFINE VARIABLE entrada AS CHARACTER NO-UNDO.

DEFINE VARIABLE filePath AS CHARACTER NO-UNDO.
filePath = path + "/fileLS.txt".

  
OS-COMMAND NO-CONSOLE VALUE("ls -1 " + path + " > " + filePath).


FOR EACH bfusrw Exclusive-Lock WHERE bfusrw.usrw_domain = global_domain
AND bfusrw.usrw_key1 = "archivoListado" 
AND bfusrw.usrw_key5 <> STRING(TODAY) :
    DELETE bfusrw.
END.



INPUT STREAM streamImport FROM VALUE(filePath).





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

FIND FIRST bfusrw WHERE bfusrw.usrw_domain = global_domain    
            AND bfusrw.usrw_key1 = "archivoListado"    
            AND bfusrw.usrw_key2 = lista.nombre 
            AND bfusrw.usrw_key6 = usuario
no-error.

IF NOT AVAILABLE bfusrw THEN DO:
       
        CREATE bfusrw.
        ASSIGN bfusrw.usrw_domain = global_domain    
               bfusrw.usrw_key1 = "archivoListado"    
               bfusrw.usrw_key2 = lista.nombre
               bfusrw.usrw_key5 = STRING(TODAY) 
               bfusrw.usrw_key6 = usuario.



IF lista.nombre MATCHES "*~~.*" THEN DO:
lista.tipoArchivo = SUBSTRING (lista.nombre, R-INDEX(lista.nombre, ".") + 1,LENGTH(lista.nombre,"CHARACTER")).
        Assign bfusrw.usrw_key3 = lista.tipoArchivo.
end.
ELSE DO:
               bfusrw.usrw_key3 = "".
               END.
END.
ELSE DO:
END.

end.
*/

def var nombre as character.                                                    
def var nombredos as character.                                                 
def var pos1 as integer.                                                 
nombre = "/mnt/adaptive/cosas33333333raras.csv".
pos1 = r-index(nombre,"/") + 1.                                
nombredos = SUBSTRING(nombre,1, pos1).
/*(length(nombre)-               
r-index(nombre,"/"))*/                                                       
display nombredos format "x(30)".