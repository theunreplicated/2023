unit Collection_Local_property_definitons;
      //keine echte collection,wusste nur nicht was ich mit machen sollte
      //TODO(sebbb):merger mit ConversionPropertyDefinitions
      //TODO(seb):store injecten in constructor
interface
uses Windows, Messages, SysUtils, Classes, Graphics,Controls, Forms, Dialogs,
  StdCtrls,ConversionPropertyDefinitions_u,LangTypeStore_u;
type
Local_property_definitons=class
procedure add(forComponent:TcomponentClass;data:array of langtype);//TODO(seb):syntax der beiden angleichen
constructor Create();
public
StoreInstance:LangTypeStore;
end;

implementation
procedure Local_property_definitons.add(forComponent:TcomponentClass;data:array of langtype);
var clName:string;
begin
clName:=forComponent.ClassName;
StoreInstance.writeEntry(clName,data);
end;

constructor Local_property_definitons.Create();
begin
StoreInstance:=LangTypeStore.Create();

end;



end.
