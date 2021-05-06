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
DEFINE VARIABLE clienteAgregado AS LOGICAL NO-UNDO.


PROCEDURE listarClientes:
FOR EACH clientes:
    DISPLAY clientes.nombre clientes.edad clientes.indice clientes.array.
    END.
END PROCEDURE.


    /*Agregar cliente*/
    FUNCTION agregarCliente RETURNS LOGICAL (INPUT nomb AS CHARACTER, INPUT num AS INTEGER,INPUT arry AS CHARACTER EXTENT 2):
        DEFINE VARIABLE indiceCliente AS INTEGER NO-UNDO.
        FIND LAST clientes NO-ERROR.
        IF NOT AVAILABLE clientes THEN DO:
                ASSIGN indiceCliente = 1.
        END.
        ELSE DO:
                ASSIGN indiceCliente = clientes.indice + 1.
        END.
        CREATE clientes.
        ASSIGN clientes.indice = indiceCliente.
        ASSIGN clientes.nombre = REPLACE(nomb,'"',"").
        ASSIGN clientes.edad = num.
        ASSIGN clientes.array[1] = REPLACE(arry[1],'"',"").
        ASSIGN clientes.array[2] = REPLACE(arry[2],'"',"").
        RETURN TRUE.
    END FUNCTION.




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
        ASSIGN nombre = ENTRY(1,entrada,",") NO-ERROR.
        ASSIGN edad = INTEGER(ENTRY(2,entrada,",")) NO-ERROR.
        ASSIGN indice = INTEGER(ENTRY(3,entrada,",")) NO-ERROR.
        ASSIGN rango[1] = ENTRY(4,entrada,",") NO-ERROR.
        ASSIGN rango[2] = ENTRY(5,entrada,",") NO-ERROR.
    END.
END.
FOR EACH tabla:
    clienteAgregado = agregarCliente(tabla.nombre,tabla.edad,tabla.rango).
END.

INPUT CLOSE.

RUN listarClientes.