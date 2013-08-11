unit CSSPARSER;
     //Parser:sehr rudimentär-dürfte probleme haben,und zwar viele,z.b.
     //TODO(seb):leerzeichen entferenen,wird sonst nicht erkannt
interface
uses HTMLRunnerLibrary_u,Dialogs,CssTransformer_u,Windows,StdCtrls,SysUtils, Classes;
type
CssParse=class
TransformerInstance:CSSTransformer;
constructor Create(hc:htmlrunnerlibrary);
procedure parse(input:STRING);

private
procedure realparse(char:string);
function removeLastandFirstChar(str:string):string;
end;


var
htmlrunnerLibraryInstance:htmlrunnerlibrary;
implementation




constructor CssParse.Create(hc:htmlrunnerlibrary);
begin
htmlrunnerLibraryInstance:=hc;

TransformerInstance:=CssTransformer.create;
end;

function CssParse.removeLastandFirstChar(str:string):string;
var c:string;
begin              //copy n paste
c:=str;
Delete(c,1,1);
delete(c,length(c),length(c));
result:=c;
end;

procedure CssParse.realparse(char:string);
var completed_run:string;
begin
//nur ids
if(htmlrunnerLibraryInstance.is_in('_helper_entry_point'))then
begin
htmlrunnerLibraryInstance.end_run('_helper_entry_point');
htmlrunnerLibraryInstance.set_value('run-TO-#');
end;
if(htmlrunnerLibraryInstance.is_in('run-TO-#')) AND (char='#')then
begin
htmlrunnerLibraryInstance.end_run('run-TO-#');
htmlrunnerLibraryInstance.set_value('in_id_hash_name');

end;
if(htmlrunnerLibraryInstance.is_in('in_id_hash_name')) AND (char='{')then
begin
completed_run:=htmlrunnerLibraryInstance.end_run('in_id_hash_name');

TransformerInstance.push_id(removeLastandFirstChar(completed_run));
//ShowMessage(removeLastandFirstChar(completed_run)+'id');//TODO:# filtern
htmlrunnerlibraryinstance.set_value('prop_set');

end;
if(htmlrunnerLibraryInstance.is_in('prop_set'))AND (char=':')then
begin
//TODO(sebbz,seb.bz gibts net):bei verarbeiten immer { und ; in string streichen
completed_run:=htmlrunnerLibraryInstance.end_run('prop_set');
TransformerInstance.push_var(removeLastandFirstChar(completed_run));
//ShowMessage(removeLastandFirstChar(completed_run)+'var');
htmlrunnerLibraryInstance.set_value('prop_value');
end;
if(htmlrunnerLibraryInstance.is_in('prop_value'))AND ((char=';')OR(char='}'))then
begin
    completed_run:=htmlrunnerLibraryInstance.end_run('prop_value');
     TransformerInstance.push_value(removeLastandFirstChar(completed_run));
  // ShowMessage(removeLastandFirstChar(completed_run)+'val');
    if(char=';')then
    begin
    htmlrunnerLibraryInstance.set_value('prop_set');
end
else if(char='}')then
begin
htmlrunnerLibraryInstance.set_value('run-TO-#');
         end;
end; end;
procedure CssParse.parse(input:string);
var i:integer;
begin

htmlrunnerLibraryInstance.set_value('_helper_entry_point');
for i:=1 to length(input)do
begin
htmlrunnerLibraryInstance.push(input[i],i);
    realparse(input[i]);


end;

end;
end.
