unit Conversion_Additional_u;

interface
uses ConversionPropertyDefinitions_u,ConversionManager_u,StringUtils_u,Dialogs;
type
arrayofarrayofLangType=array of array of LangType;
arrayofstring=array of string;

Conversion_Additional=class
constructor Create(ConversionManagerInstance_:ConversionManager);
public //nur public wegen arreay of langtype
procedure applyValuestoComponent(Component:Tobject;values:array of string);
function getavailablepropertiesforComponent(Component:Tobject;properties_copy:arrayofarrayofLangType):arrayofstring;
private
ConversionManagerInstance:ConversionManager;
end;


implementation

function zahlgerade(zahl:integer):boolean; //TODO:intutils
begin
if(zahl mod 2=0)then//http://phpforum.de/archiv_38399_ungerade@oder@gerade@Zahl@feststellen_anzeigen.html
begin
result:=true;
end
else
begin
result:=false;
end;               //copy n paste
end;//copy unit1,TODO:eigene unit machen

procedure Conversion_Additional.applyValuestoComponent(Component:Tobject;values:array of string);
var i:integer;buf_var:string;
begin

  for i:=0 to length(values)-1 do
        begin
        if(zahlgerade(i))then
        begin
        buf_var:=values[i];

        end
        else
        begin

        
        ConversionManagerInstance.setvalue(Component,buf_var,values[i]);
        end;

        end;

end;
constructor Conversion_Additional.Create(ConversionManagerInstance_:ConversionManager);
begin
ConversionManagerInstance:=ConversionManagerInstance;
end;
function Conversion_Additional.getavailablepropertiesforComponent(Component:Tobject;properties_copy:arrayofarrayofLangType):arrayofstring;
var i,i2:integer;res:arrayofstring;
begin
for i:=0 to length(properties_copy)-1 do//haten ma schonmal gehabt
begin
for i2:=0 to length(properties_copy[i2])-1 do
begin


 //check if exists
if not(properties_copy[i][i2].component_name='')then
begin
if( not ConversionManagerInstance.getinfoprop(Component,properties_copy[i][i2].component_name).error)then
begin
setlength(res,length(res)+1);
res[length(res)-1]:=properties_copy[i][i2].component_name;
end;
end;
end;
end;
result:=res;
end;

end.
