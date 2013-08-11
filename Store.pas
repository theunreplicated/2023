unit Store;

interface
uses Windows,StdCtrls,Sysutils,Classes;
type
StoreHelper=class
public
store_helper:array of string;
function handler_getkey(key:string):string;
function get_key(key:string):string;
function create_entry(key:string):string;


end;
implementation
function StoreHelper.get_key(key:string):string;
var i:integer;found:string;
begin
found:='';
for i:=0 to length(store_helper)-1 do
begin
if(store_helper[i]=key)then
begin
found:=inttostr(i);
break;                
end;
end;
result:=found;
end;
function StoreHelper.create_entry(key:string):string;
var len:integer;
begin
len:=length(store_helper);
setlength(store_helper,len+1);
store_helper[len]:=key;

//setlength(store,length(store)+1);
result:=IntToStr(len);
end;
function StoreHelper.handler_getkey(key:string):string;
var store_nr:string;
begin
store_nr:=get_key(key);

if (store_nr='')then//!exists
begin
store_nr:=create_entry(key);

end;
result:=store_nr;
end;
end.
