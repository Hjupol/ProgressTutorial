/*Programa para trabajar clases en progress.*/


/**/
Class   SampleClass:/*INHERITS superClass*//*IMPLEMENTS Interface*/
/*INHERITS: Se usa para heredar de una superclase*/
/*IMPLEMENTS: Se usa para implementar una interfaz*/


/*Definicion de las diferentes variables de la clase*/
DEFINE TEMP-TABLE ttClientes
    FIELD IndiceCliente AS integer
    FIELD NombreCliente AS CHARACTER
    FIELD EdadCliente AS CHARACTER.

DEFINE DATA-SOURCE srcEmployee FOR AutoEdge.Employee.
DEFINE QUERY qEmployee FOR ttEmployee.
DEFINE VARIABLE mcAssignedCountry AS CHARACTER NO-UND


/*Las funciones que devuelven variables vendrian puedesn convertirse en una propiedad de una clase.*/
DEFINE PUBLIC PROPERTY EmployeeCount AS INTEGER
 GET():
 RETURN QUERY qEmployee:NUM-RESULTS.
 END GET.
 PRIVATE SET.


/*El constructor inicia la insancia de la clase*/
CONSTRUCTOR PUBLIC SampleClass():
 BUFFER ttEmployee:ATTACH-DATA-SOURCE (DATA-SOURCE srcEmployee:HANDLE ).
 DATASET dsEmployee:FILL (). /* All 18 Employees */
 OPEN QUERY qEmployee PRESELECT EACH ttEmployee.
END.

/*El destructor que se encarga de limpiar los datos en memoria de la clase*/
DESTRUCTOR PUBLIC SampleClass():
 CLOSE QUERY qEmployee.
 EMPTY TEMP-TABLE ttEmployee.
END.

/*Un procedimiento dentro de una clase se llamara metodo*/
METHOD PUBLIC VOID InitializeNotes ( INPUT pcPosition AS CHARACTER ):
/*------------------------------------------------------------------------------
Purpose: Assign a value to all empty EmployeeNotes.
Notes: Done for a specific EmployeePosition.
------------------------------------------------------------------------------*/
 FOR EACH ttEmployee WHERE ttEmployee.EmployeePosition = pcPosition:
 ttEmployee.EmployeeNotes = "Initial note for this " + pcPosition.
 END.
END METHOD


/*Un procedimiento con valor de retorno tambien sera un metodo pero no sera void*/
METHOD PUBLIC INTEGER AssignCountry ( INPUT pcCountry AS CHARACTER ):
/*------------------------------------------------------------------------------
Purpose: Assigns a value to all blank EmployeeCountry fields.

Notes: Returns the number of Employees assigned.

------------------------------------------------------------------------------*/

DEFINE VARIABLE iCount AS INTEGER NO-UNDO.
FOR EACH ttEmployee WHERE ttEmployee.EmployeeBirthCountry = "":
 ttEmployee.EmployeeBirthCountry = pcCountry.
 iCount = iCount + 1.
 END.

 mcAssignedCountry = pcCountry.

RETURN iCount.
END METHOD.


END CLASS.






DEFINE VARIABLE miEmployeeCount AS INTEGER NO-UNDO.
DEFINE VARIABLE miCountryCount AS INTEGER NO-UNDO.
DEFINE VARIABLE moSampleClass AS OOSamples.SampleClass NO-UNDO.
moSampleClass = NEW OOSamples.SampleClass().
moSampleClass:InitializeNotes(INPUT "Admin").
miEmployeeCount = moSampleClass:EmployeeCount.
miCountryCount = moSampleClass:AssignCountry (INPUT "France").


DELETE OBJECT moSampleClass.
MESSAGE "There are" miEmployeeCount "employees, of which" SKIP
 miCountryCount "have just been assigned to France."
 VIEW-AS ALERT-BOX.
