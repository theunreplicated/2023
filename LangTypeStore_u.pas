unit LangTypeStore_u;

interface
uses ConversionPropertyDefinitions_u;
 type
  LangTypeStore = class
   
    function getEntryKey(name:string):integer;

    function writeEntry(name:string;data:array of LangType):integer;
    constructor Create();
  private
    { Private-Deklarationen }

  public
    { Public-Deklarationen }
    assign_to_library_type:array of String;
    store_library:array of array of array of LangType;
  end;


implementation
function  LangTypeStore.getEntryKey(name:string):integer;
var i,found:integer;
begin
found:=0;
for i:=1 to length(store_library)-1 do
begin
if(assign_to_library_type[i]=name)then
begin
found:=i;
end;
end;
result:=found;

//if not found=0 ->eintrag exisitiert noch nicht
end;




function  LangTypeStore.writeEntry(name:string;data:array of LangType):integer;
var entrykey:integer;i,slekl:integer;
begin
entrykey:=getEntryKey(name);
if(entrykey=0)then
begin
//unterschied:noch
entrykey:=length(assign_to_library_type);
setlength(assign_to_library_type,entrykey+1);
setlength(store_library,entrykey+1);
assign_to_library_type[entrykey-1]:=name;
entrykey:=entrykey-1;
end;
slekl:=length(store_library[entrykey]);
setlength(store_library[entrykey],slekl+1);


for i:=0 to length(data)-1 do
begin

setlength(store_library[entrykey][slekl-1],length(store_library[entrykey][slekl-1])+1);
store_library[entrykey][slekl-1][i]:=data[i];


end;
end;

constructor LangTypeStore.Create();
begin
setlength(store_library,2);
end;
end.

