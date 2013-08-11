unit HTMLRunnerLibrary_u;

interface
uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls;
type

  HTMLRunnerLibrary = class
   function set_value(val:string):integer;
   function getkey(val:String):string;
   function is_in(val:string):boolean;
   function end_run(val:String):string;
   procedure push(char:string;current_position:integer);
   procedure set_length(length:integer);
   destructor Destroy();
  private
  public          //TODO(seb):code aufräumen mit store-class (integration)
    gcurrent_position:integer;

  contents:string;
  end;
 var
  runner_library:array of string;
  delphi_unwissend_helper:boolean;
  runner_library_state:array of boolean;
  runner_library_start_points:array of string;
  glength:integer;


implementation
destructor HTMLRunnerLibrary.Destroy();
begin
set_length(0);
setlength(runner_library,0);
setlength(runner_library_state,0);
setlength(runner_library_start_points,0);
gcurrent_position:=0;
contents:='';
end;
procedure HTMLRunnerLibrary.set_length(length:integer);
begin
glength:=length;
end;

procedure HTMLRunnerLibrary.push(char:string;current_position:integer);
begin

                  gcurrent_position:=current_position;
                       contents:=contents+char;

end;
 function HTMLRunnerLibrary.getkey(val:String):string;
var i:integer;found:string;
begin
found:='';
for i:=0 to length(runner_library)-1 do
begin
if(runner_library[i]=val)then
begin
found:=inttostr(i);
break;
end;
end;
result:=found;
end;


function HTMLRunnerLibrary.set_value(val:string):integer;
var key_position:integer;rk:string;
begin
rk:=getkey(val);
if (rk='')then //if not exists
begin
setlength(runner_library,length(runner_library)+1);    //inkompatible type,hallo,wer hat den bitte den Compiler geschrieben?
setlength(runner_library_state,length(runner_library_state)+1);
setlength(runner_library_start_points,length(runner_library_start_points)+1);
key_position:=length(runner_library)-1;
runner_library[key_position]:=val;
runner_library_state[key_position]:=true;

runner_library_start_points[key_position]:='';

end
else
begin
key_position:=strtoint(rk);
runner_library_state[key_position]:=true;
end;
if (runner_library_start_points[key_position]='') then
begin
 runner_library_start_points[key_position]:=inttostr(gcurrent_position);

end;

result:=key_position;
end;
//end of the 2 main functions   --englisch comment :-D irgendwie sind so viele scuh deutsche projekte (wie z.b. 1+1 qooxdoo) komplett auf engliisch,
//also vbersuchs ichs auch mal

function HTMLRunnerLibrary.is_in(val:string):boolean;
var key:string;
begin
key:=getkey(val);
if(key='')then
begin
result:=false;

end
else
begin
result:=runner_library_state[strtoint(key)]; //nicht gefunden,leider keine eindeutige UNterscheidung,müsste man mit klassen machen
end;
end;

function HTMLRunnerLibrary.end_run(val:String):string;
var key,data:string; //copy n paste :D
begin
key:=getkey(val);
if not (key='')then
begin
runner_library_state[strtoint(key)]:=false;

data:=copy(contents,strtoint(runner_library_start_points[strtoint(key)]),gcurrent_position);
//showmessageshowmessage(data);
runner_library_start_points[strtoint(key)]:='';
end
else
begin
    result:='';//schlecht,eigentlich müsst ich ne error-klasse machen

end;

//result:=runner_library[strtoint(key)];//sry
           //  showmessageshowmessage(data);

result:=data;
end;

end.
