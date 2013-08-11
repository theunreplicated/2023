unit CssTransformer_u;

interface
uses Dialogs,Store,Sysutils;
type
CssTransformer=class
constructor Create();
procedure push_id(name:string);
procedure push_var(name:string);
procedure push_value(name:string);
public
store_vars:array of array of string;
store_values:array of array of string;
current_id:string;
storeHelperInstance:StoreHelper;
current_var:string;
current_key:integer;
end;
implementation
constructor CssTransformer.Create();
begin
storeHelperInstance:=storeHelper.Create();
end;
procedure CssTransformer.push_id(name:string);
var i:integer;
begin
   current_id:=name;
   delete(name,length(name),length(name));//ein leerzeichen nach #id
  i:=strtoint(storeHelperInstance.create_entry(name));
    current_key:=i;
     // showmessage(inttostr(i));
end;
procedure CssTransformer.push_var(name:string);
var wk:integer;
begin

       current_var:=name;


       setlength(store_vars,current_key+1);

setlength(store_vars[current_key],length(store_vars[current_key])+1);

store_vars[current_key][length(store_vars[current_key])-1]:=name;




end;
procedure CssTransformer.push_value(name:string);
begin
    //showmessage(name);
     setlength(store_values,current_key+1);

setlength(store_values[current_key],length(store_values[current_key])+1);
 
store_values[current_key][length(store_values[current_key])-1]:=name;

end;
end.
 