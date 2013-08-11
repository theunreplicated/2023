unit Collection_UI_Apply_Modes;

interface
uses Store,Classes,SysUtils,StdCtrls;
type
UI_Apply_Modes=class
constructor Create();
public
store:array of array of string;
StoreHelperInstance:StoreHelper;
function zahlgerade(zahl:integer):boolean;
private
procedure push(group_name:string;vals:array of string);
procedure start();
end;
implementation



function UI_Apply_Modes.zahlgerade(zahl:integer):boolean; //TODO:intutils
begin
if(zahl mod 2=0)then//http://phpforum.de/archiv_38399_ungerade@oder@gerade@Zahl@feststellen_anzeigen.html
begin
result:=true;
end
else
begin
result:=false;
end;
end;//copy unit1,TODO:eigene unit machen


procedure UI_Apply_Modes.push(group_name:string;vals:array of string);
var i,s1:integer;store_nr:string;
begin
store_nr:=storeHelperInstance.handler_getkey(group_name);
if(strtoint(store_nr)>length(store)-1)then
begin
setlength(store,length(store)+1);
   // showmessage('fcs'+inttostr(length(store)));
end;
s1:=strtoint(store_nr);
for i:=0 to length(vals)-1 do
begin

setlength(store[s1],length(store[s1])+1);
store[s1][length(store[s1])-1]:=vals[i];

end;

end;

procedure UI_Apply_Modes.start();
begin

push('DragDrop',['OnMouseDown','DragDrop_on_MouseDown','OnMouseUp','DragDrop_on_MouseUp','OnMouseMove','DragDrop_on_MouseMove']);

                                                                                                                    //TODO:onclick,set_selected_component
end;
constructor UI_Apply_Modes.Create();
begin

StoreHelperInstance:=StoreHelper.Create;
start();
end;


end.
