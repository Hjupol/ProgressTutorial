DEFINE VARIABLE valid-choice AS CHARACTER NO-UNDO INITIAL "NPFQ".
DEFINE VARIABLE selection    AS CHARACTER NO-UNDO FORMAT "x".

main-loop:
REPEAT:
  choose:
  REPEAT ON ENDKEY UNDO choose, RETURN:
    MESSAGE "(N)ext (P)rev (F)ind (Q)uit"
      UPDATE selection AUTO-RETURN.
    /* Selection was valid */
    IF INDEX(valid-choice, selection) <> 0 THEN LEAVE choose. 
    BELL.
  END.  /* choose */

  /* Processing for menu choices N, P, F here */
  IF selection = "Q" THEN LEAVE main-loop.
END. /* REPEAT */

