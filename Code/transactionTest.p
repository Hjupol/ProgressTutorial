DEFINE VARIABLE i AS INTEGER NO-UNDO INITIAL 0. 
DEFINE VARIABLE clienteAgregado AS LOGICAL NO-UNDO.
DEFINE VARIABLE indiceCliente AS INTEGER NO-UNDO.

PROCEDURE listarClientes:
FOR EACH clientes:
    DISPLAY clientes.nombre clientes.edad clientes.indice clientes.array.
    END.
END PROCEDURE.


    /*Agregar cliente*/
    FUNCTION agregarCliente RETURNS LOGICAL (INPUT nomb AS CHARACTER, INPUT num AS INTEGER):
        FIND LAST clientes NO-ERROR.
        IF NOT AVAILABLE clientes THEN DO:
                ASSIGN indiceCliente = 1.
        END.
        ELSE DO:
                ASSIGN indiceCliente = clientes.indice + 1.
        END.
        
            CREATE clientes.
            ASSIGN clientes.indice = indiceCliente.
            ASSIGN clientes.nombre = nomb.
            ASSIGN clientes.edad = num.
       
        RETURN TRUE.
    END FUNCTION.
    

    REPEAT i = 0 TO i < 5:
            clienteAgregado = agregarCliente("oscar n°" + STRING(i),i).
            MESSAGE TRANSACTION VIEW-AS ALERT-BOX.
            RUN listarClientes.
            i = i + 1.
    END.

RUN listarClientes.
/*    
DO TRANSACTION:    
    DO WHILE i<5 :
            clienteAgregado = agregarCliente("oscar n°" + STRING(i),i).
            MESSAGE TRANSACTION VIEW-AS ALERT-BOX.
            RUN listarClientes.
            i = i + 1.
            IF i = 4 THEN UNDO,RETRY.
    END.
END.
RUN listarClientes.
*/
/*Para eliminar los registros basura generados:

for each clientes where clientes.nombre begins "oscar n".
DELETE clientes.
MESSAGE "Cliente eliminado." VIEW-AS ALERT-BOX.
end.

BUTTON:

DEFINE VARIABLE ix       AS INTEGER NO-UNDO. 
DEFINE VARIABLE stop-sel AS LOGICAL NO-UNDO. 
DEFINE BUTTON stop-it LABEL "STOP". 
DISPLAY stop-it. 
ON CHOOSE OF stop-it 
   stop-sel = TRUE. 
ENABLE stop-it. 
DO ix = 1 TO 1000:   
  DISPLAY ix VIEW-AS TEXT. 
  PROCESS EVENTS. 
  IF stop-sel THEN LEAVE.  
END. 

*/