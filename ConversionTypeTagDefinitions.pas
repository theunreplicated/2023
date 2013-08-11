unit ConversionTypeTagDefinitions;

interface

uses ConversionPropertyDefinitions_u,Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,Variants,
  StdCtrls,ExtCtrls;

type
componentresult=record
component:TComponentClass;
error:boolean;
end;
TagTypeType=record
additional_function:string;
//check_function:string;
delphi_typ_names:TComponentClass; //TComponentClass ist es    ,nich Tcontrol(wäre auch quatsch)
html_tag_names:string;
invoke_lang_code:array of string;//[0]:=html,[1]:=css
//condition_has_var:array of array of string;
//start_values:array of array of string;
end;
ConversionTypeTagDefinition=class
procedure add(delphi_typ_names:TComponentClass;html_tag_names:string;invoke_lang_code:array of string;additional_function:string='');
function get(delphi_typ_name:string):string;
function getDelphiComponentName(html_name:string):componentresult;
public
definitions:array of TagTypeType;
end;
implementation
function ConversionTypeTagDefinition.get(delphi_typ_name:string):string;
var i:integer;res:string;
begin
for i:=0 to length(definitions)-1 do
begin
if(LowerCase(delphi_typ_name)=LowerCase(definitions[i].delphi_typ_names.ClassName))then
begin
res:= definitions[i].html_tag_names;
break;
end;
end;
result:=res;
end;

function ConversionTypeTagDefinition.getDelphiComponentName(html_name:string):componentresult;
var i:integer;res:TComponentClass;res2:componentresult;
begin
res2.error:=true;
for i:=0 to length(definitions)-1 do
begin

if(LowerCase(html_name)=LowerCase(definitions[i].html_tag_names))then
begin
res:= definitions[i].delphi_typ_names;
res2.error:=false;
break;
end;
end;
res2.component:=res;
result:=res2;
end;

procedure ConversionTypeTagDefinition.add(delphi_typ_names:TComponentClass;html_tag_names:string;invoke_lang_code:array of string;additional_function:string='');
var t:TagTypeType;i:integer;buffer_typ_names:array of string;
begin
//SCHEISSE
//for i:=0 to length(delphi_typ_names)-1 do   //typ name
//begin
//setlength(t.delphi_typ_names,length(t.delphi_typ_names)+1);
//t.delphi_typ_names[length(t.delphi_typ_names)-1]:=delphi_typ_names[i];
//end;
t.delphi_typ_names:=delphi_typ_names;//code könnte man  noch wartbarer machen,nur leider kenn ich mich in Delphi net so suas,z.b. wäre func_getargs net schlecht
//for i:=0 to length(html_tag_names)-1 do   //typ name
//begin
//setlength(t.html_tag_names,length(t.html_tag_names)+1);
//t.html_tag_names[length(t.html_tag_names)-1]:=html_tag_names[i];
//end;
t.html_tag_names:=html_tag_names;

for i:=0 to length(invoke_lang_code)-1 do   //typ name
begin
setlength(t.invoke_lang_code,length(t.invoke_lang_code)+1);
t.invoke_lang_code[length(t.invoke_lang_code)-1]:=invoke_lang_code[i];
end;
//t.delphi_typ_names:=buffer_typ_names;
//t.html_tag_names:=html_tag_names;
//t.invoke_lang_code:=invoke_lang_code;
t.additional_function:=additional_function;//the lonely only one
setlength(definitions,length(definitions)+1);//TODO(seb):überall dieser setlength code durch ein funktionsaufruf ersetzen ,vllt.so fc[inc(fc)] :='value';
definitions[length(definitions)-1]:=t;
end;
end.
