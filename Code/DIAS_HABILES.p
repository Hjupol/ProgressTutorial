define var icontador as integer.
define var icantdias as integer initial 8.
define var dtfecaux as date initial today.

DO icontador = 1 TO icantdias:
             dtfecaux = today + icontador.
                          IF WEEKDAY(dtfecaux) = 1 OR WEEKDAY(dtfecaux) = 7
THEN ASSIGN icantdias = icantdias + 1.
            END.

            display icantdias icontador .
