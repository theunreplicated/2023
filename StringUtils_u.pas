unit StringUtils_u;

interface
uses Windows,Dialogs,StdCtrls;
type
arrayofstring=array of string;
StringUtils=class
function split(split_char:string;text:string):arrayofstring;
end;
implementation

function StringUtils.split(split_char:string;text:string):arrayofstring;
var stringar:arrayofstring;current_text:string;posi:integer;delete_pos,copy_pos,lastpos:integer;
begin
current_text:=text;
while(pos(split_char,current_text)>0)do
begin
setlength(stringar,length(stringar)+1);
lastpos:=pos(split_char,current_text);
copy_pos:=pos(split_char,current_text);
delete_pos:=pos(split_char,current_text);
if(copy_pos<=1)then
begin
 copy_pos:=copy_pos+1;
 end;
stringar[length(stringar)-1]:=copy(current_text,1,copy_pos-1);
// showmessage(copy(current_text,delete_pos+1,length(current_text)));
current_text:=copy(current_text,delete_pos+1,length(current_text));
//showmessage(current_text+inttostr(pos(split_char,current_text)));
end;
setlength(stringar,length(stringar)+1);
stringar[length(stringar)-1]:=current_text;
result:=stringar;
end;
end.
 