    {mfdtitle.i}

DEFINE TEMP-TABLE tabla NO-UNDO
    FIELD id AS CHARACTER
    FIELD monto AS DECIMAL.

DEFINE VARIABLE a AS CHARACTER NO-UNDO. 
DEFINE STREAM streamImport.
DEFINE STREAM streamExport.
DEFINE VARIABLE entrada AS CHARACTER NO-UNDO.
DEFINE VARIABLE filePath AS CHARACTER NO-UNDO INITIAL "/u1/shares/cobranza/Listado3.csv".
/*Agregar append*/
OUTPUT STREAM streamExport TO VALUE(filePath) APPEND.
PUT STREAM streamExport UNFORMATTED a SKIP(1).
OUTPUT STREAM streamExport CLOSE.
INPUT STREAM streamImport FROM VALUE(filePath).
DEFINE VARIABLE cont AS INTEGER INITIAL 0. 

REPEAT :
    IMPORT STREAM streamImport UNFORMATTED entrada.
    IF entrada = " " THEN NEXT.
    IF ENTRY(1,entrada,";") BEGINS "Entidad" THEN NEXT.
    CREATE tabla.
    ASSIGN id = SUBSTRING(ENTRY(2,entrada,";"),1,8) NO-ERROR.
    
    ASSIGN monto = DECIMAL(ENTRY(5,entrada,";")) NO-ERROR.
    
END.
INPUT CLOSE.


FOR EACH tabla:
    id = REPLACE(id,"-","").
    IF LENGTH(id,"CHARACTER") < 8 THEN id = "0" + id.
    /*FIND FIRST ad_mstr WHERE ad_domain = global_domain
                AND ad_gst_id = id NO-ERROR.*/
    
    /*IF AVAILABLE ad_mstr THEN DO:*/
    FIND FIRST cm_mstr WHERE cm_domain = global_domain
        AND cm_addr = id.
        IF AVAILABLE cm_mstr THEN DO:
            /*IF cm__dec02 = 0 THEN DO:*/
            cont = cont + 1. 
            ASSIGN cm__dec02 = monto. 
            DISPLAY cm_addr cm__dec02 cm_cr_terms.
            /*END.*/
            
        END.
        ELSE DISPLAY id.
    /*END.*/
    /*ELSE DO:
        DISPLAY id monto.
    END.*/
       
END.
DISPLAY cont.


/*FOR EACH cm_mstr WHERE cm_domain = global_domain SHARE-LOCK:
    DISPLAY cm_addr cm__dec02.
END.*/

/*
77.379.286-0  m500
91.575.000-1  m5000 
76.939.143-6  m350
*/