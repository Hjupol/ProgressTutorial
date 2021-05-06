    C:\OpenEdge\WRK\testData.db
    /* Codigo de prueba, ABM de la tabla testData.db */
    FOR EACH customer.
    DISPLAY customer.NAME customer.contact customer.country customer.city

    insert customer
    .ASSIGN customer.NAME="Adriel".
    .ASSIGN customer.country ="Argentina"

    for each customer:
    display customer.name customer.cust-num.
    end.

    DEFINE VARIABLE iCusNum AS INTEGER NO-UNDO.
    DEFINE VARIABLE namech AS CHARACTER NO-UNDO.


    FIND LAST customer
    IF AVAILABLE customer THEN
        ASSIGN iCusNum = customer.cust-num +1.
    IF NOT AVAILABLE customer THEN
        ASSIGN iCusNum=1.
        
    ASSIGN namech = "Adriel".
    CREATE  customer.
    ASSIGN  customer.name=namech
            customer.cust-num=iCusNum
            customer.country=namech
            customer.city= namech
            customer.postal-code=1704
            customer.sales-rep=1111
            customer.comments=namech
    DISPLAY customer WITH 1 COLUMN.
    /* Lo de arriba no funcionó, el código de abajo si*/

    CREATE  state.
    ASSIGN  state.state="Ramos mejia".
    ASSIGN  state.state-name="Barrio pileta".
    ASSIGN  state.region="La matanza".
    DISPLAY state.

    //Muestra todos los states con sus respectivos datos. 
    FOR EACH state.
    DISPLAY state.state state.state-name state.region 

    //Dia 2

    //Un FIZZBUZZ si el numero es divisible por 5, 3 o ninguno. 
    DEFINE VARIABLE i AS INTEGER NO-UNDO.
    DEFINE VARIABLE cout AS CHARACTER NO-UNDO.

    DO i = 0 TO 100 :
       /* si el numero representado por i es divisible por 3 entonces 
       cout sera igual a "Fizz",si lo es por 5 sera "Buzz"*/
       IF i MODULO 3 = 0 THEN DO:
        cout = "D3".
          DISPLAY cout.
            DISPLAY i.
            END.
        ELSE IF i MODULO 5 = 0 THEN DO:
        cout = "D5".
          DISPLAY cout.
            DISPLAY i.
            END.
        ELSE DO:
        cout = "None".
          DISPLAY cout.
            DISPLAY i.
        END.
       down 1.
       /*DISPLAY cout STRING(i).
       display cout with frame a.
       display i with frame a.
       down 1.*/
    END.
        
    //Un loop que se encarga de encontrar los customer que comiencen con la letra t    
    findLoop:
    REPEAT :
     FIND NEXT Customer NO-LOCK WHERE customer.name BEGINS "t" NO-ERROR.
     IF AVAILABLE customer THEN DO:
     DISPLAY Customer.NAME.
     END.
     ELSE DO:
     LEAVE findLoop.
     END.
    END.
        
        
    //Definir una tabla temporal    
    DEFINE TEMP-TABLE tt NO-UNDO
     FIELD nr AS INTEGER.
    CREATE tt.
    tt.nr = 1.
    CREATE tt.
    tt.nr = 2.
    CREATE tt.
    tt.nr = 3.
    DISPLAY AVAILABL tt. // yes (tt with nr = 3 is still available)
    FIND FIRST tt WHERE tt.nr = 1 NO-ERROR.
    DISPLAY AVAILABLE tt. //yes
    FIND FIRST tt WHERE tt.nr = 2 NO-ERROR.
    DISPLAY AVAILABLE tt. //yes
    FIND FIRST tt WHERE tt.nr = 3 NO-ERROR.
    DISPLAY AVAILABLE tt. //yes
    FIND FIRST tt WHERE tt.nr = 4 NO-ERROR.
    DISPLAY AVAILABLE tt. //no

    //Define una tabla temporal y le asigna valores 
    DEFINE VARIABLE i AS INTEGER NO-UNDO.
    DEFINE TEMP-TABLE tt NO-UNDO
     FIELD nr AS INTEGER
     FIELD ch AS CHARACTER.
     
    PROCEDURE av:
     DISPLAY AVAILABLE tt.
     IF AVAILABLE tt THEN DO:
     DISPLAY tt.nr.
     DISPLAY tt.ch.
     END.
    END PROCEDURE.

    DO i = 0 TO 100:
    CREATE tt.
    tt.nr = i.
    IF i MODULO 3 = 0 THEN DO:
    tt.ch = "D3".
    END.
    ELSE IF i MODULO 5 = 0 THEN DO:
    tt.ch = "D5".
    END.
    ELSE DO:
    tt.ch = "D_0".
    END.
    RUN av. /*yes. tt.nr = 1*/
    END.

    RUN av. /* no (and no tt.nr displayed)*/



    FUNCTION isTheLetterB RETURNS LOGICAL (INPUT pcString AS CHARACTER):
     IF pcString = "B" THEN
     RETURN TRUE.
     ELSE
     RETURN FALSE.
    END FUNCTION.



    FUNCTION cat RETURNS CHARACTER ( c AS CHARACTER, d AS CHARACTER):
     RETURN c + " " + d.
    END.

    define variable i as integer no-undo.
    do i = 0 to 20:
    MESSAGE cat("HELLO", "WORLD") VIEW-AS ALERT-BOX.
    end.
    MESSAGE cat("Hola", "Compadre") VIEW-AS ALERT-BOX.



    FUNCTION returning DATE ( dat AS DATE):
     IF dat < TODAY THEN DO:
     DISPLAY "<".
     RETURN dat - 365.
     END.
     ELSE DO:
     DISPLAY ">".
     RETURN TODAY.
     END.
    END.
    MESSAGE returning(TODAY + RANDOM(-50, -1)) VIEW-AS ALERT-BOX.


    FUNCTION returning DATE ( dat AS DATE):
     IF dat < TODAY THEN DO:
     DISPLAY "Hace un año era el dia: ".
     RETURN dat - 364.
     END.
     ELSE DO:
     DISPLAY ">".
     RETURN TODAY.
     END.
    END.
    MESSAGE returning(TODAY - 1) VIEW-AS ALERT-BOX.


    /* Para saber la fecha que fue hace x dias*/
    FUNCTION returning DATE ( i as integer):
      RETURN today - i.
     END function.

    MESSAGE returning(/*determinar cantidad de dias atras*/) VIEW-AS ALERT-BOX.


    /*Toca una vocal*/
    DEFINE VARIABLE OKkeys AS CHARACTER NO-UNDO INIT "aeiou".

    REPEAT:
    MESSAGE "Press a vocal key".
    READKEY.
      IF INDEX(OKKeys, CHR(LASTKEY)) <> 0 THEN DO:
    MESSAGE "You pressed the key " + CHR(LASTKEY) VIEW-AS ALERT-BOX.
    end.
    ELSE IF LASTKEY = keycode("ESC")  THEN LEAVE.
    ELSE do:
    message "Incorrect key" VIEW-AS ALERT-BOX.
    end.
    END.

    /*para reemplazar las letras de un string */
    DEFINE VARIABLE cString AS CHARACTER NO-UNDO.
    cString = "ABCDEFGH".
    SUBSTRING(cString, 4, 2) = "XY".
    DISPLAY cString.

    /*Array*/ 
    DEFINE VARIABLE a AS CHARACTER EXTENT 3 INITIAL ["one","two","three"] NO-UNDO.
    /* Some statements (like DISPLAY) can handle a whole array: */
    DISPLAY a.

FOR EACH clientes.
    DISPLAY clientes.nombre clientes.edad clientes.indice.

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
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