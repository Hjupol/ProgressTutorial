/* corrida con disable triggers */
/* solo permanece activo dentro del procedimiento donde se invoco */
/* al salir del procedimiento se vuelven a activar los triggers */

RUN crear.
MESSAGE 'crear1'
VIEW-AS ALERT-BOX.
RUN borrar.
MESSAGE 'borrar1 '
VIEW-AS ALERT-BOX.  
MESSAGE 'hara 2do run crear y tiene que dispararse nuevamente el trigger de create '
VIEW-AS ALERT-BOX.      .
RUN crear.
MESSAGE 'crear2 luego de disable trigger'
VIEW-AS ALERT-BOX.




PROCEDURE crear:
    
    CREATE customer.
    ASSIGN customer.NAME = 'carlos'.
END.

PROCEDURE borrar:
    DISABLE TRIGGERS FOR LOAD OF customer.
    FIND FIRST customer
        WHERE customer.NAME = 'carlos'.
    DELETE customer.
END.
