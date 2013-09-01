unit ConversionPropertyDefinitions_u;

interface
uses Windows, Messages, SysUtils, Classes, Graphics,Controls, Forms, Dialogs,
  StdCtrls,Typinfo;
type
arrayofstring=array of string;
LangType=record
  available:boolean;
  component_name:string;//org_name wie in Delphi
  lang_name:string;
  lang_prefix:string;
  lang_suffix:string;
  convert_function:string;
  end;
ConversionPropertyDefinitions=class
         //Tipp zur verwendung von app oder replace:in global_peroperty_definitions add ,im specific replace
procedure add(codeType:string;set_properties:langtype);
procedure replace(codeType:string;set_properties:langtype);
public
properties:array of array of Langtype;
function getwriteNumberkey(codeType:string):integer;

function langTypeBuilder(componentName:string='';langName:string='';suffix:string='';prefix:string='';convert_function:string=''):LangType;
private
procedure increase_properties_array_length_1();

end;


implementation




function ConversionPropertyDefinitions.langTypeBuilder(componentName:string='';langName:string='';suffix:string='';prefix:string='';convert_function:string=''):LangType;
var lang:LangType;i:integer;langSuffix,langPrefix,buffered_addtional:string;
begin
langSuffix:=suffix;
langPrefix:=prefix;
lang.convert_function:=convert_function;
lang.available:=true;
lang.component_name:=componentName;
lang.lang_suffix:=langSuffix;
lang.lang_name:=langName;
lang.lang_prefix:=langPrefix;
result:=lang;
end;


procedure ConversionPropertyDefinitions.increase_properties_array_length_1();
begin
setlength(properties,length(properties)+1);
setlength(properties[length(properties)-1],4);//4 normalerweise 1 für html,2 für css,3 für js ,4 für htmlvar
end;

function ConversionPropertyDefinitions.getwriteNumberkey(codeType:string):integer;
var writeNumberkey:integer;
begin
if(codeType='CSS')then
begin
writeNumberkey:=1;
end
else if(codeType='HTML')then
begin
writeNumberkey:=0;
end
else if(codeType='JS')then
begin
writeNumberkey:=2;
end
else if(codeType='HTML_INNER_VAR')then
begin
writeNumberkey:=3;
end
else
begin
showmessage('Programmierfehler');
end;
result:=writeNumberkey;
end;

procedure ConversionPropertyDefinitions.add(codeType:string;set_properties:langtype);
var writeNumberkey:integer;
begin
increase_properties_array_length_1();
writeNumberkey:=getwriteNumberkey(codeType);
properties[length(properties)-1][writeNumberkey]:=set_properties;
end;

procedure ConversionPropertyDefinitions.replace(codeType:string;set_properties:langtype);//wegen performance muss man selbst zwischen replace und add
var writeNumberkey,mainkey,i:integer; found:boolean;                                                  //unterscheiden,da saonst bei jedem add mit ner loop geuscht werden müsste
begin
found:=false;
writeNumberkey:= getwriteNumberkey(codeType);
for i:=0 to length(properties)-1 do
begin                                      //Design Note:Verhält sich genauso wie add,es wird beim ersetzen das Aktuelle ersetzt
if(properties[i][WriteNumberKey].lang_name=set_properties.lang_name)then
begin
mainkey:=i;
found:=true;
end;
end;
if not(found)then
begin
increase_properties_array_length_1();
mainkey:=length(properties)-1;//TODO():log funktion wär net schlecht
end;
properties[mainkey][WriteNumberKey]:=set_properties;

end;
end.
 