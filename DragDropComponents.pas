unit DragDropComponents;

interface
uses    //Die DragDrop implementation war von nem youtube video auf spanisch(nein,spanisch kann ich net,hab einfachauf den code geguckt),der rest selber
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, StdCtrls, Buttons;
  type
  DragDropComponent=class
  constructor Create(reference:Tcontrol);
   procedure fDragDropMoverY(obj:TControl;Y:integer);
   procedure fDragDropMoverX(obj:TControl;X:integer);
   procedure fMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
  procedure fMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
  procedure fMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
   procedure setmaxmin(max_left,min_left,max_top,min_top:integer);
  public
    component_references:Tcontrol;
  max_enabled:boolean;
   max_left,min_left,max_top,min_top:integer;
  DragDropMode:string;testbtn:TButton;
  private
  function checktop(size:integer):integer;
  function checkleft(size:integer):integer;
  end;
var
P1:TPoint;
Move:boolean;

implementation
constructor DragDropComponent.Create(reference:Tcontrol);
begin
  component_references:=reference;
  max_enabled:=false;
end;
  procedure DragDropComponent.setmaxmin(max_left,min_left,max_top,min_top:integer);
  begin
  max_enabled:=true;
  max_left:=max_left;
  min_left:=min_left;
  max_top:=max_top;
  min_top:=min_top;


  end;
function DragDropComponent.checktop(size:integer):integer;
var res:integer;
begin
res:=size;
if(max_enabled)then
begin

if(size>max_top)then
begin
res:=max_top;
end
else if(size<min_top)then
begin
res:=min_top;
end
end;


  result:=res;
end;
function DragDropComponent.checkleft(size:integer):integer;
var res:integer;
begin
res:=size;
if(max_enabled)then
begin

if(size>max_left)then
begin
res:=max_left;
end
else if(size<min_left)then
begin
res:=min_left;  //copy n'paste
end;
end;
result:=Res;
end;
procedure DragDropComponent.fDragDropMoverY(obj:TControl;Y:integer);
begin

 //if(Move=true)then
//begin

if(Y>P1.y)then
       obj.top:=checktop(obj.top +(Y - P1.y));
if(Y<P1.y)then
        obj.top:=checktop(obj.top-(P1.y-Y));

  // end;
end;
procedure DragDropComponent.fDragDropMoverX(obj:TControl;X:integer);
begin

// if(Move=true)then
//begin
if(X> P1.x)then
      obj.left:=checkleft(obj.left+(X-P1.x));
if(X<P1.x)then
       obj.Left:=checkleft(obj.left-(P1.x-X));

 //  end;
end;
procedure DragDropComponent.fMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  Move:=false;
end;

procedure DragDropComponent.fMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
  begin
Move:=true;
P1.x:=X;
P1.y:=Y;
end;

procedure DragDropComponent.fMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
  var buffer_val1,buffer_val2:integer;
begin        //haupt-funktion

if(Move=true)then
begin

  begin

  if(DragDropMode='all')then
  begin
       fDragDropmoverY(component_references,Y);
       fDragDropmoverX(component_references,X);
   end
   else if(DragDropMode='x')then
   begin
       fDragDropmoverX(component_references,X);
   end
   else if(DragDropMode='y')then
   begin

   // testbtn.height:=testbtn.height+(Y-P1.y);
       //buffer_val1:=component_references.top +(Y - P1.y);
       //buffer_val2:=testbtn.height+(Y-P1.y);

       //testsweise
       fDragDropMoverY(component_references,Y);
       //testbtn.top:=component_references.top-testbtn.height;
          //geht nur für den einen shape



   end
   else
   begin
   showmessage('Fehler im Programm-du kannst nix machen---du bist....-matchtlos');




end;
end;
end;
end;
end.

