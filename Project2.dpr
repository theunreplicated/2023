program Project2;

uses
  Forms,
  Unit1 in 'Unit1.pas' {Form1},
  FileStorageFileOperations in 'FileStorageFileOperations.pas',
  Collection_LangConvertFunctions in 'Collection_LangConvertFunctions.pas',
  IFileOperations in 'IFileOperations.pas',
  Collection_Global_conversion_property_definitions in 'Collection_Global_conversion_property_definitions.pas',
  ConversionPropertyDefinitions_u in 'ConversionPropertyDefinitions_u.pas',
  StringUtils_u in 'StringUtils_u.pas',
  ConversionManager_u in 'ConversionManager_u.pas',
  ConversionTypeTagDefinitions in 'ConversionTypeTagDefinitions.pas',
  Collection_ConversionTypeTag_Definitions in 'Collection_ConversionTypeTag_Definitions.pas',
  ComponentCreation in 'ComponentCreation.pas',
  Collection_UI_Method_Handlers in 'Collection_UI_Method_Handlers.pas',
  PropertyConversionManager in 'PropertyConversionManager.pas',
  Collection_Local_property_definitons in 'Collection_Local_property_definitons.pas',
  LangTypeStore_u in 'LangTypeStore_u.pas',
  Conversion_Additional_u in 'Conversion_Additional_u.pas',
  Store in 'Store.pas',
  Collection_UI_Apply_Modes in 'Collection_UI_Apply_Modes.pas',
  grrr in 'grrr.pas',
  SharedGlobals in 'SharedGlobals.pas',
  TMYControls in 'TMYControls.pas';

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
