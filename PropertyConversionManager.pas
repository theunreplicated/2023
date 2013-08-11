unit PropertyConversionManager;

interface
uses ConversionPropertyDefinitions_u;                     //TODO(seb)umbenennnen in Manager
type
PropertyConversionManage=class
public
global_properties:array of array of LangType;
ConversionPropertyDefinitionsInstance:ConversionPropertyDefinitions;
constructor Create(ConversionPropertyDefinitionsInstance_:ConversionPropertyDefinitions);
private
current_component:TObject;
procedure setCurrentComponent(component:Tobject);//verwirrend:machmal Type,manchmal Component->besser

end;
implementation
procedure PropertyConversionManage.setCurrentComponent(component:Tobject);
begin
current_component:=component;
//GET Properties for current object
end;
constructor PropertyConversionManage.Create(ConversionPropertyDefinitionsInstance_:ConversionPropertyDefinitions);
begin

 //TODO(verbessern,sehr wichtig)
end;
end.
 