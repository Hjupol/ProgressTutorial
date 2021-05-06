/*ABM try*/
    /*Definicion de las variables necesarias*/
    DEFINE VARIABLE nombreCliente AS CHARACTER NO-UNDO.
    DEFINE VARIABLE edadCliente AS INTEGER NO-UNDO.
    DEFINE VARIABLE indiceCliente AS INTEGER NO-UNDO.

    DEFINE VARIABLE clienteAgregado AS LOGICAL NO-UNDO.
    DEFINE VARIABLE clienteEncontrado AS LOGICAL NO-UNDO.
    DEFINE VARIABLE modificar AS LOGICAL NO-UNDO.
    DEFINE VARIABLE eliminar AS LOGICAL NO-UNDO.
    DEFINE VARIABLE agregar AS LOGICAL NO-UNDO.
    DEFINE VARIABLE buscarNum AS LOGICAL NO-UNDO.

    FORM 
    nombreCliente COLON 20
    edadCliente COLON 20
    indiceCliente COLON 20
    WITH FRAME a SIDE-LABELS WIDTH 80. 

    /*Actualización de los datos*/
    PROCEDURE Actualizar:
        /*DISPLAY clientes.nombre clientes.edad clientes.indice WITH FRAME a.*/
        UPDATE nombreCliente edadCliente WITH FRAME a.
    END PROCEDURE.

    /*Cambia los valores logicos*/
    PROCEDURE ActualizarValorLogicoModificacion:
        DEFINE INPUT-OUTPUT PARAMETER  valorLogicoPregunta AS LOGICAL NO-UNDO.
        /*DISPLAY clientes.nombre clientes.edad clientes.indice WITH FRAME a.*/
        MESSAGE "Desea modificar el cliente " + clientes.nombre + "?" VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO
        UPDATE valorLogicoPregunta.
    END PROCEDURE.
    
        /*Cambia los valores logicos*/
    PROCEDURE ActualizarValorLogicoEliminacion:
        DEFINE INPUT-OUTPUT PARAMETER  valorLogicoPregunta AS LOGICAL NO-UNDO.
        /*DISPLAY clientes.nombre clientes.edad clientes.indice WITH FRAME a.*/
        MESSAGE "Desea eliminar el cliente " + clientes.nombre + "?" VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO
        UPDATE valorLogicoPregunta.
    END PROCEDURE.


    /*Modificar valores*/
    FUNCTION modificarValores RETURNS LOGICAL (INPUT nomb AS CHARACTER,INPUT num AS INTEGER):
        ASSIGN clientes.nombre = nomb.
        ASSIGN clientes.edad = num.
        RETURN TRUE.
    END FUNCTION.

    /*Busqueda de registro para modificarlo o eliminarlo a través de su indice*/
    PROCEDURE buscarClienteNum:
    DEFINE INPUT PARAMETER num AS INTEGER NO-UNDO.
        FIND clientes EXCLUSIVE-LOCK WHERE clientes.indice = num NO-ERROR. /*Numero de cliente a buscar*/ 
        IF AVAILABLE clientes THEN DO:
            RUN ActualizarValorLogicoModificacion(INPUT-OUTPUT modificar).
    /*La opcion de modificarlo o eliminarlo, si es modificarlo:*/
            IF modificar = TRUE THEN DO:   
                RUN Actualizar.            
                clienteAgregado = modificarValores(nombreCliente,edadCliente).
                RETURN.
            END.
    /*Si es eliminarlo*/
            ELSE DO:
                RUN ActualizarValorLogicoEliminacion(INPUT-OUTPUT eliminar).
                IF eliminar = TRUE THEN DO:   
                    ASSIGN nombreCliente = clientes.nombre.
                    DELETE clientes.
                    MESSAGE "Cliente " + nombreCliente + " eliminado." VIEW-AS ALERT-BOX.
                END.
            RETURN.
        END.
        END.
        ELSE DO:
            FIND LAST clientes NO-ERROR.
            IF NOT AVAILABLE clientes THEN DO:
                MESSAGE "No hay clientes disponibles" VIEW-AS ALERT-BOX.
                RETURN.
            END.
            ELSE DO:
                MESSAGE "Cliente no encontrado" VIEW-AS ALERT-BOX.
                RETURN.
            END.
        END.
    END PROCEDURE.

    /*Busqueda de registro para modificarlo o eliminarlo a través de su nombre*/
    PROCEDURE buscarClienteNom:
    DEFINE INPUT PARAMETER nom AS CHARACTER NO-UNDO.
        FIND clientes WHERE clientes.nombre = nom NO-ERROR. /*Nombre de cliente a buscar*/ 
        IF AVAILABLE clientes THEN DO:
            RUN ActualizarValorLogicoModificacion(INPUT-OUTPUT modificar).
    /*La opcion de modificarlo o eliminarlo, si es modificarlo:*/
            IF modificar = TRUE THEN DO:   
                RUN Actualizar.            
                clienteAgregado = modificarValores(nombreCliente,edadCliente).
                RETURN.
            END.
    /*Si es eliminarlo*/
            ELSE DO:
                RUN ActualizarValorLogicoEliminacion(INPUT-OUTPUT eliminar).
                IF eliminar = TRUE THEN DO:   
                    ASSIGN nombreCliente = clientes.nombre.
                    DELETE clientes.
                    MESSAGE "Cliente " + nombreCliente + " eliminado." VIEW-AS ALERT-BOX.
                END.
            RETURN.
        END.
        END.
        ELSE DO:
            FIND LAST clientes NO-ERROR.
            IF NOT AVAILABLE clientes THEN DO:
                MESSAGE "No hay clientes disponibles" VIEW-AS ALERT-BOX.
                RETURN.
            END.
            ELSE DO:
                MESSAGE "Cliente no encontrado" VIEW-AS ALERT-BOX.
                RETURN.
            END.
        END.
    END PROCEDURE.

PROCEDURE listarClientes:
FOR EACH clientes:
    DISPLAY clientes.nombre clientes.edad clientes.indice.
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

    REPEAT:
        VIEW FRAME a.
        RUN listarClientes.
        MESSAGE "Toque si para agregar un cliente, toque no para buscar uno." VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO-CANCEL
        UPDATE agregar.
        IF agregar = TRUE THEN DO:
    
            UPDATE  edadCliente
                    nombreCliente WITH FRAME a.
                clienteAgregado = agregarCliente(nombreCliente,edadCliente).
            IF clienteAgregado = TRUE THEN DO:
                MESSAGE "Cliente: " + nombreCliente + " agregado." VIEW-AS ALERT-BOX.
                RUN listarClientes.
            END.
            ELSE DO:
                MESSAGE "No se pudo agregar al cliente:  " + nombreCliente VIEW-AS ALERT-BOX.
                RUN listarClientes.
            END.
        END.
        ELSE DO:
            MESSAGE "Toque si para buscar a través del nombre, toque no para buscar a través del numero." VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO-CANCEL
            UPDATE buscarNum.
            IF buscarNum = TRUE THEN DO:
                UPDATE  nombreCliente WITH FRAME a.
                RUN buscarClienteNom(nombreCliente).
            END.
            ELSE DO:
                UPDATE  indiceCliente WITH FRAME a.
                RUN buscarClienteNum(indiceCliente).
                
            END.
        RUN listarClientes.
        END.    
    END.