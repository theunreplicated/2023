unit HTMLTransFormer_u;
//Button1
//Button1.width:=''
//<div multiple  funz net
//           //TODO(seb):villeicht interface mit csstransformer
interface
uses ComponentCreation,ConversionTypeTagDefinitions,Windows,StdCtrls,Dialogs, Messages,Controls,Forms,SysUtils, Classes,ConversionManager_u;
type
HTMLTransformer=class
  identifier:array of boolean;
  created_components:array of TControl;
  created_components_copy_structure:array of TControl;
  pushed_inner_vars:array of string;
  pushed_style_vars:array of string;
  pushed_html_vars:array of  string;
  pushed_html_values:array of  string;
  html_vars_identifier:array of integer;
  html_values_identifier:array of integer;
constructor Create(ConversionTypeTagDef:ConversionTypeTagDefinition;ConversionMan:ConversionManager;winctrl:TwinControl;form:Tform);
procedure push_tag(tag:string);
procedure end_tag(tag:string);
procedure push_var(name:string);
procedure push_value(name:string);
procedure push_inner_var(str:string);
private
current_var:string;
current_tag:string;
end;
var

  ConversionTypeTagDefinitionInstance:ConversionTypeTagDefinition;
  wincontrol:TWinControl;
  current_obj:TControl;
  active:boolean;
  g_form:TForm;
  current_identifier:integer;
  ConversionManagerInstance:ConversionManager;
//t:boolean;
//tags:array of string;    //tags[length(tags)-1]  = active, besser nicht direkt funktion aufrufen,da ich dann wahrscheinlich das mit pointern,speicheradresse
//active_tags:array of string;
implementation
constructor HTMLTransformer.Create(ConversionTypeTagDef:ConversionTypeTagDefinition;ConversionMan:ConversionManager;winctrl:TwinControl;form:TForm);
begin
g_form:=form;

ConversionTypeTagDefinitionInstance:=ConversionTypeTagDef;//copy n paste
ConversionManagerInstance:=ConversionMan;
WinControl:=winctrl;
end;
procedure HTMLTransformer.push_inner_var(str:string);
//var hh:HTMLRunnerLibrary;

begin
//if(str='')then showmessage('has_code');
if not(str='')then
begin
//showmessage('DElphi sucks');
//sdsds //leaks? im array
setlength(pushed_inner_vars,length(identifier)+1);
 pushed_inner_vars[length(identifier)-1]:=str;


 if(LowerCase(current_tag)='style')then
 begin
  setlength(pushed_style_vars,length(pushed_style_vars)+1);
  pushed_style_vars[length(pushed_style_vars)-1]:=str;




 end;
 end;
end;
procedure HTMLTransformer.push_tag(tag:string); //setzen des Tags als =aktiv,alle anderen Calls müssten(sofern möglich)sich auf das aktuelle Tag beziehen
var compClass:TComponentClass;cres:componentresult;wl:integer;i:integer;
begin

//setlength(tags,length(tags)+1);
//tags[length(tags)-1]:=tag;
//setlength(active_tags,length(active_tags)+1);
//active_tags[length(active_tags)-1]:=tag;
setlength(created_components_copy_structure,length(created_components_copy_structure)+1);
setlength(identifier,length(identifier)+1);
wl:=length(identifier)-1;
identifier[length(identifier)-1]:=true;
current_tag:=tag;
current_identifier:=wl;
// showmessage('fdspiö');
//for i:=length(tag) to 1 do
//begin
//showmessage('fdspiö');
//das regt mich echt auf das ich mich die ganze Zeit mit irgendwelchen Eigenheiten von DElphi rumschlagen muss
//habs rausgefunden:downto
i:=length(tag);
while(i>0)do
begin
if(tag[i]=' ')OR(tag[i]=#13#10)then
begin
delete(tag,i,i);
end;
i:=i-1;
end;



//if(tag[length(tag)]=' ')then
//begin
//delete(tag,length(tag),length(tag));//TODO for schleife
//end;
//showmessage('length'+inttostr(length(tag)));
cres:=ConversionTypeTagDefinitionInstance.getDelphiComponentName(tag);
if(cres.error)then
begin
//showmessage('not supported');
end
else
begin
//showmessage('yeah');
compClass:=cres.component;
current_obj:=ConversionManagerInstance.createComponent(compClass,g_form,'created_components');
active:=true;
setlength(created_components,length(identifier));
created_components[length(identifier)-1]:=current_obj;
created_components_copy_structure[length(created_components_copy_structure)-1]:=current_obj;
end
end;

procedure HTMLTransformer.push_var(name:string);
begin

current_var:=name; //showmessage(name);
setlength(pushed_html_vars,length(pushed_html_vars)+1);
setlength(html_vars_identifier,length(html_vars_identifier)+1);
pushed_html_vars[length(pushed_html_vars)-1]:=name;
html_vars_identifier[length(html_vars_identifier)-1]:=current_identifier;
//setlength(pushed_html_vars[length(identifier)-1],length(pushed_html_vars[length(identifier)-1])+1);

//pushed_html_vars[length(identifier)-1][length(pushed_html_vars[length(identifier)-1])-1]:=name;
end;

procedure HTMLTransformer.push_value(name:string);
begin
 //ssdsd
 //showmessage(current_var+'--'+name);
 if(active)then
 begin
 if not(ConversionManagerInstance.getvalue(current_obj,current_var).error)then
 begin
  //showmessage(current_var+'---'+name);
 //ConversionManagerInstance.setvalue(current_obj,current_var,name);


 end;
 end;
  //showmessage(inttostr(length(pushed_html_values))+inttostr(length(identifier)));
setlength(pushed_html_values,length(pushed_html_values)+1);
setlength(html_values_identifier,length(html_values_identifier)+1);
pushed_html_values[length(pushed_html_values)-1]:=name;
html_values_identifier[length(html_values_identifier)-1]:=current_identifier;
end;


procedure HTMLTransformer.end_tag(tag:string);
var i:integer;
begin
  //showmessage('end');

 // for i:=length(active_tags)-1 to 0 do
 // begin
 // if (active_tags[i]=tag)then
  //begin //ok,filter,es
        //TODO(sebb):vielleciht besser machen,das delte ist aber ziemlich schwer
    //      active_tags[i]:='';
      //    break;

  //  end;
//end;
active:=false;
//if not(current_obj=nil)then
//begin
//current_obj.Parent:=wincontrol;
//end;
end;
end.
