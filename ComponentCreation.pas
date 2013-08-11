unit ComponentCreation;

interface
uses Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,Variants,
  StdCtrls,Store,Collection_UI_Apply_Modes,ConversionManager_u,Conversion_Additional_u,grrr;
type

ComponentCreator=class
constructor Create(ConversionMan:ConversionManager;Conversion_Add:Conversion_Additional);
public
store:arrayofarrayofTControl;
storeHelperInstance:StoreHelper;
 function createComponent(class_ref:TcomponentClass;parent:TwinControl;component_group:string):TControl;
 procedure applyMode(obj:TControl;mode_name:string);
function create_standard_Component(class_ref:TComponentClass;parent:TwinControl):Tcontrol;
end;
implementation
var
 UIApplyModesInstance:UI_Apply_Modes;
 ConversionManagerInstance:ConversionManager;
 ConversionAdditionalInstance:Conversion_Additional;

//TODO(sebbö):store type
constructor ComponentCreator.Create(ConversionMan:ConversionManager;Conversion_Add:Conversion_Additional);
begin
storeHelperInstance:=StoreHelper.Create;//TODO(nicht so wichtig):Store per constructor-argument injecten
//TODO(seb):vllt. sonstwo aufrufen,niein,is ok,,da bei formcreate call
 UIApplyModesInstance:=UI_Apply_Modes.Create;
 ConversionManagerInstance:= ConversionMan;
 ConversionAdditionalInstance:=conversion_add;

// showmessage(inttostr(length(store)));
end;

function ComponentCreator.create_standard_Component(class_ref:TComponentClass;parent:TWinControl):Tcontrol;//TODO(sebz):vielleicht parent als 2.arg noch
var cf:TControl;ctrl:TObject;
begin


 ctrl:=class_ref.Create(parent);           //aaaaufwendige Transformationen ,vorsicht:muss parent sein wegen window
 cf:=TControl(ctrl);
 //cf.parent:=parent;
result:=cf;
end;
function ComponentCreator.createComponent(class_ref:TcomponentClass;parent:TwinControl;component_group:string):Tcontrol;
var obj:Tcontrol;i:integer;store_nr:string;s1,s2:integer;                             //component_group= das wo es eingeordnet werden sollte,z.b. all_created_components
begin
//showmessage(class_Ref.ClassName);
obj:=create_standard_Component(class_ref,parent);


store_nr:=storeHelperInstance.handler_getkey(component_group);
if(strtoint(store_nr)>length(store)-1)then
begin
setlength(store,length(store)+1);
   // showmessage('fcs'+inttostr(length(store)));
end;
s1:=StrToInt(store_nr);

s2:=length(store[s1]);

SetLength(store[s1],s2+1);    
obj.tag:=s2;
store[s1][s2]:=obj;

  ConversionManagerInstance.set_store_inst(store,storeHelperInstance);




result:=obj;

end;
procedure ComponentCreator.applyMode(obj:TControl;mode_name:string);
var i:integer;s_nr:string;store_nr:integer;buf_var:string;
begin
s_nr:=UIApplyModesInstance.StoreHelperInstance.handler_getkey(mode_name);
  if not(s_nr='')then
    begin
      store_nr:=StrToInt(s_nr);

      ConversionAdditionalInstance.applyValuestoComponent(obj,UIApplyModesInstance.store[store_nr]);

      end
  else
  begin
      ShowMessage('machtlos -programmierfehler');
  end;
end;
end.
