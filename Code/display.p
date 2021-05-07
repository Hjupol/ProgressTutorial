DEFINE TEMP-TABLE tablaTemporal NO-UNDO
    FIELD indice AS INTEGER INITIAL 0.
DEFINE VARIABLE hTablaTemporal AS HANDLE NO-UNDO.

ASSIGN hTablaTemporal = BUFFER tablaTemporal:HANDLE.

PROCEDURE listarTabla:
DEFINE INPUT PARAMETER tabla AS CHARACTER NO-UNDO. 

FOR EACH _file NO-LOCK WHERE _file-name = tabla.

    FOR EACH _field OF _file NO-LOCK:
    
        
        hTablaTemporal:ADD-NEW-FIELD ( _field._field-name , _field._dType ).
        
        
    END.
    
END.

ASSIGN tablaTemporal = tabla.

DISPLAY tablaTemporal.

END PROCEDURE.

RUN listarTabla(clientes).




REPEAT iCounter = 1 TO NUM-ENTRIES(cRecord, cDelChar) ON ERROR UNDO:        

            lbltext = TRIM(ENTRY(iCounter, cRecord, cDelChar), cTrimChar).        
            
            hTempTable:ADD-NEW-FIELD(STRING(iCounter),'CHAR').
        END.