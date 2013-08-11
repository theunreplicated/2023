unit DragDropBase_u;
//@deprecated   -failed
interface
uses  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls,TypInfo;
type
OnMethodFunction = function(caller:Tobject):String
                         of object;//http://www.delphi-central.com/callback.aspx
DragDropBase=class
constructor Create(objekt:TObject);
procedure setOnMethodFunction(Sender:TObject;method_name:string;set_method:String);
published                                                       //ganz schwerer Fehler: http://www.entwickler-ecke.de/topic_TObjectMethodAddress+gibt+immer+nil+zurueck_103169,0.html
function testfunc(caller:Tobject):string;
                                                                 //published,ist aber auch komisch gemacht,einmal gehts,einmal net
 procedure COMMONMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
end;

implementation
function DragDropBase.testfunc(caller:Tobject):String;
begin
         showmessage('fsdfdsfds');
end;
procedure DragDropBase.setOnMethodFunction(Sender:TObject;method_name:string;set_method:String);
var m:Tmethod;Propinfo:PPropinfo;
begin
  m.Code := self.MethodAddress(set_method); //find method code
  m.Data := pointer(self); //store pointer to object instance
  PropInfo := GetPropInfo(Sender.ClassInfo, method_name);
  SetmethodProp(Sender, PropInfo,m);
end;
constructor DragDropBase.Create(objekt:TObject);
begin
setonmethodfunction(objekt,'OnClick','testfunc');
setonmethodfunction(objekt,
end;





end.
