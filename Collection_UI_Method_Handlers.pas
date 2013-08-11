unit Collection_UI_Method_Handlers;
//völlig überfrachtete Datei,muss aber so sein wegen den methodaddreseen(in dieser Klasse wird gesucht)
interface     //DRagDrop aus youtube video
uses
Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, StdCtrls, Buttons,grrr,Store,typinfo;
type

Collection_UI_Method_Handler=class

  delphi_schrott_workaround:array of TControl;
constructor Create();

  procedure receive_component_var(component:TComponentClass;func_name:string;window_Draw:TWinControl);
  published
  procedure controls_bar_handle_click(Sender:TControl);
  procedure DragDrop_on_MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
  procedure DragDrop_on_MouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
  procedure DragDrop_on_MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
  
end;


implementation
var
P1:TPoint;
Move:boolean;
StoreInstance:arrayofarrayofTControl;
StoreHelperInstance:StoreHelper;

storeComponentClass:array of TComponentClass;
 storeFuncName:array of string;
 windowDraw:TWinControl;
  procedure Collection_UI_Method_Handler.receive_component_var(component:TComponentClass;func_name:string;window_Draw:TWinControl);
  begin
  setlength(storeComponentClass,length(storeComponentClass)+1);
  storeComponentClass[length(storeComponentClass)-1]:=component;
  setlength(storeFuncName,length(storeFuncName)+1);
  storeFuncName[length(storeFuncName)-1]:=func_name;
    windowDraw:=window_Draw;
  end;
constructor Collection_UI_Method_Handler.Create();
begin
//StoreInstance:=StoreInst;
 //StoreHelperInstance:=StoreHelperInst;
end;

procedure Collection_UI_Method_Handler.controls_bar_handle_click(Sender:TControl);
var tag_name:integer;obj:TControl;k:string;nr1:integer;class_ref:TComponentClass;cf:TControl;ctrl:TObject;prop:ppropinfo;method:Tmethod;
begin                  //TODO
tag_name:=Sender.Tag;
k:=StoreHelperInstance.get_key('control_bar');
if (k='') then
begin
   showmessage('Programmierfehler');
end;
nr1:=strtoint(k);

obj:=StoreInstance[nr1][tag_name];
  //showmessage(inttostr(length(storeComponentClass)));
class_ref:=storeComponentClass[tag_name];
//copy n paste


 ctrl:=class_ref.Create(Sender.Parent);           //aaaaufwendige Transformationen ,vorsicht:muss parent sein wegen window
cf:=TControl(ctrl);
///copy and paste


     //delphi ist echt nicht so mein geschmack---dd
     //überhaupt nicht...


prop:=getpropinfo(cf,'OnMouseDown');
method.Code := Collection_UI_Method_Handler.MethodAddress('DragDrop_on_MouseDown'); //schon Ã¶fters,von stackoverflow  //TODO(sebb):Convert into a reusable function with x.methodadress with x as argument(Tclass?,tobject?)
method.Data := pointer(Self); //store pointer to object instance
setMethodProp(cf,Prop,method);

prop:=getpropinfo(cf,'OnMouseUp');
method.Code := Collection_UI_Method_Handler.MethodAddress('DragDrop_on_MouseUp'); //schon Ã¶fters,von stackoverflow  //TODO(sebb):Convert into a reusable function with x.methodadress with x as argument(Tclass?,tobject?)
method.Data := pointer(Self); //store pointer to object instance
setMethodProp(cf,Prop,method);

 prop:=getpropinfo(cf,'OnMouseMove');
method.Code := Collection_UI_Method_Handler.MethodAddress('DragDrop_on_MouseMove'); //schon Ã¶fters,von stackoverflow  //TODO(sebb):Convert into a reusable function with x.methodadress with x as argument(Tclass?,tobject?)
method.Data := pointer(Self); //store pointer to object instance
setMethodProp(cf,Prop,method);
   //so ein mist:self geht nicht
   //und die anderen klassen auch nicht,circual unit references   und auf lange lösungenhab ich keine lust
   //http://stackoverflow.com/questions/5774598/declare-public-global-variable-in-delphi geht netn


    //2.Kritikpunkt hier:published units,vars in klasse werden verzerrt,kein self.methodaddress


setlength(delphi_schrott_workaround,length(delphi_schrott_workaround)+1);
delphi_schrott_workaround[length(delphi_schrott_workaround)-1]:=cf;
cf.Parent:=windowDraw;
end;
procedure Collection_UI_Method_Handler.DragDrop_on_MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
Move:=true;
P1.x:=X;
P1.y:=Y;
end;


procedure Collection_UI_Method_Handler.DragDrop_on_MouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
var obj:Tcontrol;
begin
if(Move=true)then
begin
obj:=TControl(Sender);
if(Y>P1.y)then
       obj.top:=obj.top +(Y - P1.y);
if(Y<P1.y)then
        obj.top:=obj.top-(P1.y-Y);
if(X> P1.x)then
      obj.left:=obj.left+(X-P1.x);
if(X<P1.x)then
       obj.Left:=obj.left-(P1.x-X);



end;

end;


procedure Collection_UI_Method_Handler.DragDrop_on_MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin

Move:=false;
end;

end.
