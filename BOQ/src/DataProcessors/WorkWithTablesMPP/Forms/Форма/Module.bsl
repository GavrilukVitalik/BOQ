	 
&AtClient
Var Project;
	 
&AtServer
Procedure OnCreateAtServer ( Cance, StandartProcessing )
	
    FileName = "C:\1 — копия.mpp";
	IsOpened = False;
	WorkCostsValue = 222;
	UnitsValue = 44;

EndProcedure

&AtClient
Procedure OpenMPP ( Command )
	
	if ( FileName = "" ) then
		ShowMessageBox ( , "Не выбран файл *.mpp!" );
	else
		fillDataMPP ();
	endif;
	
EndProcedure

&AtClient
Procedure SaveMPP ( Command )

	closeProject ();
	
EndProcedure

&AtClient
Procedure fillDataMPP ()
	
	openProject ();
	fillAttibutes ();
	fillMSTasks ();
	fillMSTablesTasks ();
	// fillMSTables ( project );
	g = getTableList ();
	
EndProcedure

&AtClient
Procedure openProject ()
	
	Project = New COMObject ( "MSProject.Application" );
	Project.DisplayAlerts = False;
	Project.FileOpen ( FileName );
	IsOpened = True;
	
EndProcedure

&AtClient
Procedure fillAttibutes ()
	
	Units = getUniqueIDField ( "Базовые затраты", 0 );
	WorkCosts = getUniqueIDField ( "Трудозатраты", 0 );	
	
EndProcedure

&AtClient
Procedure fillMSTasks ()
	
	MSTasks.Clear ();
	MSAssignments.Clear ();
	for each t in Project.ActiveProject.Tasks do
		addRowMSTasks ( t );
		for each assignment in t.Assignments do
			addRowMSAssignments ( assignment );
		enddo;
	enddo;	
	
EndProcedure

&AtClient
Function getUniqueIDField ( Name, TypeResource )
	
	// TypeResource
	// pjProject - 0
	// pjResource - 1
	// pjTask - 2 
	id = Project.Application.FieldNameToFieldConstant ( Name, TypeResource );
	return id;
	
EndFunction

&AtClient
Procedure addRowMSTasks ( Data )
	
	row = MSTasks.Add ();
	row.ID = Data.ID;
	row.Name = Data.Name;
	row.ResourceNames = Data.ResourceNames;
	row.ScheduledStart = Data.ScheduledStart;
	row.ScheduledFinish = Data.ScheduledFinish;
	row.Notes = Data.Notes;
	row.UniqueID = Data.UniqueID;
	
EndProcedure

&AtClient
Procedure addRowMSAssignments ( Data )
	
	row = MSAssignments.Add ();
	row.TaskID = Data.TaskID;
	row.TaskUniqueID = Data.TaskUniqueID;
	row.ResourceUniqueID = Data.ResourceUniqueID;
	row.ResourceID = Data.ResourceID;
	row.ResourceName = Data.ResourceName;
	row.UniqueID = Data.UniqueID;
	row.Units = Data.Units;
	row.Cost = Data.Cost;
	
EndProcedure

&AtClient
Procedure ChangeRow ( Command )
	
	data = Items.MSAssignments.CurrentData;
	if ( data <> undefined ) then
		changeDataRow ( data );				
	endif;
	
EndProcedure

&AtClient
Procedure changeDataRow ( Data )
	
	Units = getUniqueIDField ( "Cost",1 );
	WorkCosts = getUniqueIDField ( "Work", 1 );
	row = Project.ActiveProject.Tasks ( Data.TaskUniqueID ).Assignments ( Data.ResourceID );
	row.Work = WorkCostsValue;
	row.Units = UnitsValue;
	closeProject ();
	openMSProject ();
	
EndProcedure

&AtClient
Procedure fillMSTables ( MSProject ) 
	
	tables = getTableList ();
	level1 = MSTables.GetItems ();
	level1.Clear ();
	for each t in tables do
		branch = level1.Add ();
		branch.TableName = t;
		branch.FieldID = "";
		branch.FieldName = "";
		//for each field in t.TableFields do
		//	fieldName = MSProject.Application.FieldConstantToFieldName ( field.Field );
		//	row = branch.GetItems ().Add ();
		//	row.TableName = t.Name;
		//	row.FieldID = field.Field;
		//	row.FieldName = fieldName;
		//enddo;
	enddo;
	
EndProcedure

&AtClient
Procedure fillMSTablesTasks ()
	
	level1 = MSTables.GetItems ();
	level1.Clear ();
	for each t in Project.ActiveProject.TaskTables do
		branch = level1.Add ();
		branch.TableName = t.Name;
		branch.FieldID = "";
		branch.FieldName = "";
		for each field in t.TableFields do
			fieldName = Project.Application.FieldConstantToFieldName ( field.Field );
			row = branch.GetItems ().Add ();
			row.TableName = t.Name;
			row.FieldID = field.Field;
			row.FieldName = fieldName;
		enddo;
	enddo;
	//for each ttt in MSProject.Application.Использование do
	//	а = 4;
	//enddo;
	
EndProcedure

&AtClient
Function getTableList ()
	
	list = New Array ();
	for each t in Project.ActiveProject.TaskTableList do
		list.Add ( t );	
	enddo;
	return list;
	
EndFunction

&AtClient
Procedure closeProject ()
	
	Project.FileSaveAs ( FileName );
	Project.FileClose ();
	Project.Application.Quit ();
	IsOpened = False;
	// openMSProject ();
	
EndProcedure

&AtClient
Procedure openMSProject ()
	
	p = New Structure ();
	p.Insert ( "Function", "RunApplication" );
	notification = new NotifyDescription ( "FinishRunApplication", ThisObject, p );
	BeginRunningApplication ( notification, FileName, , False );
	
EndProcedure

&AtClient
Procedure FinishRunApplication ( Result, Params ) Export
	
	Execute ( Params.Function + " ( Result ) " );
	
EndProcedure

&AtClient
Procedure RunApplication ( Result ) export
	
	if ( Result = 0 ) then
		// code ...
	else
		Message ( StrTemplate ( "Ошибка скрипта (код ошибки %1)", Result ) );
	endif;
	
EndProcedure

&AtClient
Procedure MSTasksOnActivateRow ( Item )
	
	data = Items.MSTasks.CurrentData;
	if ( data <> undefined ) then
		Items.MSAssignments.RowFilter = New FixedStructure ( "TaskID", data.ID );
	endif;
	
EndProcedure

&AtClient
Procedure BeforeClose ( Cancel, Exit, WarningText, StandardProcessing )
	
	// check attribute IsOpened

EndProcedure
