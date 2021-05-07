DEFINE TEMP-TABLE tabla LIKE clientes.
DEFINE INPUT-OUTPUT PARAMETER TABLE FOR tabla. 

FOR EACH clientes:
    FIND FIRST tabla WHERE tabla.indice = clientes.indice NO-ERROR.
    IF NOT AVAILABLE tabla THEN DO:
        CREATE tabla.
        BUFFER-COPY clientes TO tabla.
    END.
END.



