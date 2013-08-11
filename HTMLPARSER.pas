unit HTMLPARSER;

interface
 //HTMLPARSER
 //funnktioniert nur mit grossen Tücken-hat also unglaublich vile Macken,daher
 //-immer sehr genau auf Leerzeichen achten z.b. ... id='d' > sollte nicht gehen
 //-es können keine unvollstänfigen attrs gepars werden ,also z.b. nicht <input multiple>
//attr-name zwingend in "-Zeichen
//Neu:\" werden escaped!!!!!!!!!ßß->(sebbbx):strings richtig parsen,nicht so ein Murks wie hier
//->also: "\"guten abend\",hallo" geht jetzt !!!!
 uses
  Windows, Messages,ExtCtrls, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ComCtrls, StdCtrls,alphamemo,HTMLRunnerLibrary_u,HTMLTransformer_u,CSSParser,ConversionTypeTagDefinitions,ConversionManager_u,ConversionPropertyDefinitions_u,Collection_langconvertfunctions,FileStorageFileOperations;

type
  HTMLPARSE = class

    procedure parseCSS(str:string);
    procedure parseHTML(html:string);

    constructor Create(ConversionTypeTagDef:ConversionTypeTagDefinition;ConversionMan:ConversionManager;winctrl:TwinControl;ConversionPropertyDefInst:ConversionPropertyDefinitions;form:Tform);
  private
    { Private-Deklarationen }

  public
    { Public-Deklarationen }
  end;
     //wird mi .create() anscheinend keine neue instanz eerzeugt?völlig unabhängig?
var
  tagarray:array of string;

  counted_escape_slashes:integer;
  htmlrunnerlibraryInstance:HTMLRunnerLibrary;
   htmlTransformerInstance:HTMLTransformer;
  CSSParseInstance:CSSParse;

  file_storage_ops_instance:FileStorageFileOperation;
   ConversionPropertyDefInstance:ConversionPropertyDefinitions;
  ConversionTypeTagDefinitionInstance:ConversionTypeTagDefinition;
implementation
//The Bronx-Notice of Eviction
//naja,also mal ein ganz wichtiger Code-Comment,
//nein,es heisst zwar dass man das so nicht machen soll,aber .....das hier ist ja auch n Schulprojekt
//ok,ich wollt auch mal was schreiben,dass vllt. n bissl aners ,ähm.nicht so trocken ist.
constructor HTMLParse.Create(ConversionTypeTagDef:ConversionTypeTagDefinition;ConversionMan:ConversionManager;winctrl:TwinControl;ConversionPropertyDefInst:ConversionPropertyDefinitions;form:Tform);
var hh:Htmlrunnerlibrary;
begin
  ConversionPropertyDefInstance:=ConversionPropertyDefInst;
  file_storage_ops_instance:=FileStorageFileOperation.create();
//str:='#fc{width:66px;height:5em}#fc22222{-ms-border-radius:5em}}';
//hh.set_length(length(str));

ConversionTypeTagDefinitionInstance:=ConversionTypeTagDef;
 htmlTransformerInstance:=HTMLTransformer.Create(ConversionTypeTagDef,conversionman,winctrl,form);
end;


function handle_inner_var_prepare(str:string):string;
var lastindex,i:integer;
begin

if not(str='')AND not(str=#13#10)then

begin
lastindex:=length(str);
i:=1;
if(length(str)>=1)then
begin
if((str[1]='>') OR (str[1]='<'))OR(str[1]=#13#10)then
begin
delete(str,1,1);
lastindex:=length(str);
end;
end;
if(length(str)>=2)then
begin
if((str[2]='>') OR (str[2]='<'))OR(str[2]=#13#10)then
begin
delete(str,2,2);
lastindex:=length(str);
end;
end;

if(length(str)>2)then
begin
if((str[length(str)]='>') OR (str[length(str)]='<'))OR(str[length(str)]=#13#10)then
begin
delete(str,length(str),length(str));
lastindex:=length(str);
end;
end;
{
while(i<=lastindex)do
if((str[i]='>') OR (str[i]='<'))OR(str[i]=#13#10)then
begin
delete(str,i,i);
lastindex:=length(str);
end;

if(i=1)then
begin
i:=2;
end
else if(i=2)then
begin

i:=lastindex-1;

end
else if(i=(lastindex)-1)then
begin
i:=lastindex;
end;
end;} //unsafe,gefahr der endlos-Schleife
//nochmals:schnell
//nochmals:schnell
if(length(str)>=1)then
begin
if((str[1]='>') OR (str[1]='<'))OR(str[i]=#13#10)then
begin
 delete(str,1,1);
end;
end;
lastindex:=length(str);
if(length(str)>=1)then
begin
if((str[lastindex]='>') OR (str[lastindex]='<'))OR(str[lastindex]=#13#10)then
begin
 delete(str,lastindex,lastindex);
end;
end;


//OK:Valid

result:=str;
end;


end;

procedure handle_inner_var(str:String);
begin
if not(str='')AND not(str=#13#10)then
begin
htmlTransformerInstance.push_inner_var(handle_inner_var_prepare(str));

end;
end;

function remove_angular_braces(str:string):string;
var res:string;lastcharpos:integer;
begin
res:=str;                             //TODO(subb):merge to stringutils
Delete(res,1,1);
lastcharpos:=length(res);
if(res[lastcharpos]='>')then       //TOD=(seb):beim parser mit leerzeichen eingigermassen klarkommen(in statement)
begin
delete(res,lastcharpos,lastcharpos);
end;
result:=res;
end;
function remove_first_and_last_char(str:string):string;
var res:string;
begin
res:=str;
delete(res,1,1);
delete(res,length(res),length(res));//schlecht,ich weiß,so wie der gesamte code
result:=res;
end;
function remove_angular_braces_and_slash(str:string):string;
var res:string;
begin
res:=remove_angular_braces(str);             //TODO(sebb):use rem last_char
delete(res,1,1);                             //"Mit heißer Nadel gestrickt"-so wie alles hier
result:=res;
end;
function remove_last_char(str:string):string;
var res:string;lastpos:integer;//INkonsistenz,extravagance
begin
res:=str;
lastpos:=length(res);
delete(res,lastpos,lastpos);
result:=res;
end;
procedure handle_tag_start(tag:string);
begin

if(tag[2]='/')then
begin
                     //showmessage('END:'+remove_angular_braces_and_slash(tag));
 htmlTransformerInstance.end_tag(tag);
end
else
begin
//showmessage('START:'+remove_angular_braces(tag));
 htmlTransformerInstance.push_tag(remove_angular_braces(tag));
end;
end;

procedure parser_parse_char(char:string;current_position:integer);
var text:string; completed_run:string;verschiss:boolean;
//tag wird geöffnet beginnt
//muss vorher aufgerufen werden
begin
verschiss:=false;
htmlrunnerlibraryInstance.push(char,current_position);
if(htmlrunnerlibraryInstance.is_in('_helper_entry_point'))then
begin
htmlrunnerlibraryInstance.end_run('_helper_entry_point');
htmlrunnerlibraryInstance.set_value('run-TO-<');//run to the hills
end;


//Sprung
if(htmlrunnerlibraryInstance.is_in('in_attr_string_real'))then
begin
if(char='"')then
begin
if not(counted_escape_slashes>0)then//TODO(sebb080000000):->ungerade-gerade,natürlich falsch ,ungerade oder gerade
begin

completed_run:=htmlrunnerlibraryInstance.end_run('in_attr_string_real');
    //showmessage('ATTR_VALUE:'+remove_first_and_last_char(completed_run));
    htmlTransformerInstance.push_value(remove_first_and_last_char(completed_run));
//HANDLE
 htmlrunnerlibraryInstance.set_value('in_attr_string_finish_next_check');
 end;
 counted_escape_slashes:=0;
 end
 else if(char='\')then
 begin
   counted_escape_slashes:=counted_escape_slashes+1;

 end
 else
 begin
  counted_escape_slashes:=0;
 end;
end;
 if(htmlrunnerlibraryInstance.is_in('br_run-to-<-after-helper')) then
 begin                                                        //zeilensprünge oder leerzeichen gehen da schon mal nicht

 htmlrunnerlibraryInstance.end_run('br_run-to-<-after-helper');
 htmlrunnerlibraryInstance.set_value('tag_name');//copy n paste
htmlrunnerlibraryInstance.set_value('in_tag');
 end;

if(htmlrunnerlibraryInstance.is_in('run-TO-<br'))AND (char='<')then
begin
//showmessage('RUNT_OBR');
completed_run:=htmlrunnerlibraryInstance.end_run('run-TO-<br');
if not(completed_run='')then
begin


 //showmessage(completed_run);
 //HANDLE
 //nicht gut
 completed_run:=handle_inner_var_prepare(completed_run);
 if not(completed_run='')AND not(completed_run=#13#10)then
 begin
 //internal op
 htmlTransformerInstance.pushed_inner_vars[length(htmlTransformerInstance.pushed_inner_vars)-2]:=htmlTransformerInstance.pushed_inner_vars[length(htmlTransformerInstance.pushed_inner_vars)-2]+#13#10+completed_run;
 //handle_inner_var_prepare(completed_run);

 end;


end;
htmlrunnerlibraryInstance.set_value('br_run-to-<-after-helper');
end;

if(htmlrunnerlibraryInstance.is_in('run-TO-<'))AND (char='<')then
begin
completed_run:=htmlrunnerlibraryInstance.end_run('run-TO-<');
if not(completed_run='')then
begin
handle_inner_var(completed_run);
end;
htmlrunnerlibraryInstance.set_value('tag_name');
htmlrunnerlibraryInstance.set_value('in_tag');
end;



if(htmlrunnerlibraryInstance.is_in('tag_name'))then
begin
//tnt:=tnt+char;
         //showmessage('in_tag'+char+tagarray[0]);


 //REihenfolge
{ if(htmlrunnerlibraryInstance.is_in('maybe_in_br_helper'))then
 begin

    //ShowMessage(htmlrunnerlibraryInstance.contents[htmlrunnerlibraryInstance.gcurrent_position]);

 end;
   }
if(char='/')AND(htmlrunnerlibraryInstance.contents[htmlrunnerlibraryInstance.gcurrent_position-1]='r')AND(htmlrunnerlibraryInstance.contents[htmlrunnerlibraryInstance.gcurrent_position-2]='b')then
begin
//htmlrunnerlibraryInstance.set_value('maybe_in_br_helper');verschiss:=false;
//also:</br bereits, es fehlt >,pass #13#10
 htmlrunnerlibraryInstance.set_value('pass_br');
 htmlrunnerlibraryInstance.end_run('tag_name');

end;



if(char=' ')OR (char='>')OR(char=#13#10)then
begin
setlength(tagarray,length(tagarray)+1);
completed_run:=htmlrunnerlibraryInstance.end_run('tag_name');
  //showmessage('in_x'+tagarray[length(tagarray)-1]);


     // showmessage('RR: '+completed_run);
handle_tag_start(completed_run);

if(char=' ')OR(char=#13#10)then
begin
htmlrunnerlibraryInstance.set_value('in_tag_inner_space1/2');
end
else if(char='>')then
begin
htmlrunnerlibraryInstance.set_value('run-TO-<');
end;
//showmessage(tagarray[0]);
//tnt:='';
//tagarray[length(tagarray)-1]:=tagarray[length(tagarray)-1]+char;
end;

end;//eigentlich sinnlos
if(htmlrunnerlibraryInstance.is_in('in_tag_inner_space1/2'))AND (char=' ')then
begin
htmlrunnerlibraryInstance.end_run('in_tag_inner_space1/2');
//showmessageshowmessage('fsfd');
htmlrunnerlibraryInstance.set_value('in_tag_inner_space2/2');
end;

if(htmlrunnerlibraryInstance.is_in('in_tag_inner_space2/2'))AND not (char=' ')then
begin
htmlrunnerlibraryInstance.end_run('in_tag_inner_space2/2');
htmlrunnerlibraryInstance.set_value('in_attr_stmt');
end;

if(htmlrunnerlibraryInstance.is_in('in_attr_stmt'))AND (char='=')then

begin
completed_run:=htmlrunnerlibraryInstance.end_run('in_attr_stmt');
//HANDLE
        //showmessage('ATTR_NAME:'+remove_last_char(completed_run));
        htmlTransformerInstance.push_var(remove_last_char(completed_run));
htmlrunnerlibraryInstance.set_value('in_attr_stmt_quote1');
end;

if(htmlrunnerlibraryInstance.is_in('in_attr_stmt_quote1')) AND (char='"')then
begin
//showmessage('asdd');
counted_escape_slashes:=0; //einfach mal sicherheitshalber
htmlrunnerlibraryInstance.end_run('in_attr_stmt_quote1');
htmlrunnerlibraryInstance.set_value('in_attr_string_real');
end;
//if(htmlrunnerlibraryInstance.is_in('in_attr_string1'))AND not(char='"')THEN
//BEGIN
//htmlrunnerlibraryInstance.end_run('in_attr_string1');
//htmlrunnerlibraryInstance.set_value('in_attr_string_real');
//end;

//Sprng z7m 2.Statement,aus technischen gründen



if(htmlrunnerlibraryInstance.is_in('in_attr_string_finish_next_check'))AND ((char=' ')OR (char='>'))then
begin

    htmlrunnerlibraryInstance.end_run('in_attr_string_finish_next_check');

if(char=' ') OR(char=#13#10)then
begin
   htmlrunnerlibraryInstance.set_value('in_tag_inner_space2/2')
   end
   else if(char='>')then
   begin
htmlrunnerlibraryInstance.set_value('run-TO-<');
end;
end;
if(htmlrunnerlibraryInstance.is_in('pass_br'))AND (char='>')then
begin
htmlrunnerlibraryInstance.end_run('pass_br');
htmlrunnerlibraryInstance.set_value('run-TO-<br');

end;
//anmekung zur REIHENFOLGE:sPRUNG NACH WEILS SONST SICH SELBST AUFRUFT

     //TODO(void-ungultig):überarbeiten,auf jeden fall
//if(char='<')then
//begin
//htmlrunnerlibraryInstance.set_value('tag_name');
//htmlrunnerlibraryInstance.set_value('in_tag');
end;




procedure loop_string_by_chars(str:string);
var i:integer;
begin
setlength(tagarray,length(tagarray)+1);
htmlrunnerlibraryInstance.set_value('_helper_entry_point');
for i:=1 to length(str)do
begin

parser_parse_char(str[i],i);

end;
htmlrunnerlibraryInstance.set_length(length(str));
end;

procedure render_results();
var i,i2,i3,iz,cid_key:integer;controls_edit:array of TControl;am:TTransparentMemo;memo:Tmemo;to_edit_add:array of string;cic:array of TImage;ci:TImage;v:string;img_srcs:array of string;local_imgs:array of TControl;current_css_idKey:string;valx,valy:string;img_src:string;obj:TControl;name,realvalue,value:string;m:tmethod;inner_var:string;
begin
//html action
for i:=0 to length(htmlTransformerInstance.pushed_html_vars)-1 do
begin
     if(htmlTransformerInstance.pushed_html_vars[i]='src')then
 begin
 setlength(img_srcs,length(img_srcs)+1);

 img_Srcs[length(img_srcs)-1]:=htmlTransformerInstance.pushed_html_values[i];
 end;
 if(htmlTransformerInstance.pushed_html_vars[i]='value')then
 begin
 setlength(to_edit_add,length(to_edit_add)+1);

 to_edit_add[length(to_edit_add)-1]:=htmlTransformerInstance.pushed_html_values[i];
 end;
 if(htmlTransformerInstance.pushed_html_vars[i]='id')then
 begin
 //load css



  current_css_idKey:=CSSParseInstance.TransformerInstance.storeHelperInstance.get_key(htmlTransformerInstance.pushed_html_values[i]);
   //delete(current_css_idKey,length(current_css_idKey),length(current_css_idKey));
  //valy:=htmlTransformerInstance.pushed_html_values[i];
  if not(current_css_idKey='')then
  begin
   cid_key:=strtoint(current_css_idKey);

   //push inner var
  obj:=htmlTransformerInstance.created_components_copy_structure[htmlTransformerInstance.html_vars_identifier[i]];
  if(obj.ClassName='TEdit')then
  begin
  SetLength(controls_edit,length(controls_edit)+1);
  controls_edit[length(controls_edit)-1]:=obj;
  end;


  if not(obj.ClassName='TImage')AND (length(htmlTransformerInstance.pushed_inner_vars)-1>=htmlTransformerInstance.html_vars_identifier[i])then
  begin


 inner_var:=htmlTransformerInstance.pushed_inner_vars[htmlTransformerInstance.html_vars_identifier[i]];

   //inner_var:='';
   end
  else
  begin
  inner_var:='';
  end;

    for i2:=0 to length(CSSParseInstance.TransformerInstance.store_vars[cid_key])-1 do
    begin
        name:=CSSParseInstance.TransformerInstance.store_vars[cid_key][i2];//showmessage(name);
        value:=CSSParseInstance.TransformerInstance.store_values[cid_key][i2];
           iz:=length(name);
    while(iz>0)do      //"unwartbarer Code"
    begin
    if(name[iz]=' ')OR(name[iz]=#13#10)then //copy n paste
    begin
    delete(name,iz,iz);
    end;
    iz:=iz-1;
    end;
     //showmessage(CSSParseInstance.TransformerInstance.store_vars[cid_key][i2]+CSSParseInstance.TransformerInstance.store_values[cid_key][i2]);
     for i3:=0 to length(ConversionPropertyDefInstance.properties)-1 do
     begin
      if(ConversionPropertyDefInstance.properties[i3][3].available)AND not (inner_var='')then
      begin

      if( not ConversionManagerInstance.getinfoprop(obj,ConversionPropertyDefInstance.properties[i3][3].component_name).error)then
        begin
         //showmessage(ConversionPropertyDefInstance.properties[i3][3].component_name);
         ConversionManagerInstance.setvalue(obj,ConversionPropertyDefInstance.properties[i3][3].component_name,inner_var);
         inner_var:='';
        end;
       end;

     if(ConversionPropertyDefInstance.properties[i3][1].lang_name=name)then
     begin
     //OK:prop da
     realvalue:=value;//prefix
      if not (ConversionPropertyDefInstance.properties[i3][1].lang_prefix='')then
      begin
      delete(realvalue,1,length(ConversionPropertyDefInstance.properties[i3][1].lang_prefix));
      end;

      if not (ConversionPropertyDefInstance.properties[i3][1].lang_suffix='')then
      begin
      delete(realvalue,length(realvalue),length(realvalue)-length(ConversionPropertyDefInstance.properties[i3][1].lang_suffix));
      end;

     if(obj.ClassName='TImage')AND((ConversionPropertyDefInstance.properties[i3][1].component_name='width')OR(ConversionPropertyDefInstance.properties[i3][1].component_name='height'))then
     begin
       delete(realvalue,length(realvalue)-1,length(realvalue));

     end
     else if not (ConversionPropertyDefInstance.properties[i3][1].convert_function='')then
     begin
      m.Code := LangConvertFunctions.MethodAddress(ConversionPropertyDefInstance.properties[i3][1].convert_function+'_back'); //find method code  //TODO(sebb):Convert into a reusable function with x.methodadress with x as argument(Tclass?,tobject?)
      m.Data := pointer(HTMLParse); //store pointer to object instance
     value := LangConvertFunction(m)(value,ConversionPropertyDefInstance.properties[i3][1].lang_name,ConversionPropertyDefInstance.properties[i3][1].component_name);
     realvalue:=value;
      end;

      //Set
  
      if( not ConversionManagerInstance.getinfoprop(obj,ConversionPropertyDefInstance.properties[i3][1].component_name).error)then
      begin
       ConversionManagerInstance.setvalue(obj,ConversionPropertyDefInstance.properties[i3][1].component_name,realvalue);

      end;


      end;

     //if(ConversionPropertyDefInstance.properties[i3][3].component_name=htmlTransformerInstance.pushed_inner_vars[i])then
     //begin

     //    showmessage('m');
    // end;
        end;
        end;

  //end;
  //obj.Top:=2;

  ConversionManagerInstance.applyMode(obj,'DragDrop');
  if(obj.ClassName='TImage')then
  begin
  setlength(local_imgs,length(local_imgs)+1);
  local_imgs[length(local_imgs)-1]:=obj;
  end
  else
  begin
  obj.Parent:=wincontrol;
  end;

  if(obj.ClassName='TMemo')then begin
       memo:=tmemo(obj);
                   memo.Lines.Text:=inner_var;
  end;
    if(obj.ClassName='TTransparentMemo')then begin
      am:=TTransparentMemo(obj);
         am.Lines.Text:=inner_var;
  end;

 end;


end;

end; //TODO:mit src drauf aufpassen
for i:=0 to length(local_imgs)-1 do
begin
v:=img_srcs[i];
delete(v,1,7);   //rem file://
//ci:=Timage(obj);
SetLength(cic,length(cic)+1);
cic[length(cic)-1]:=Timage(local_imgs[i]);
//ci.Picture.LoadFromFile(v);
ConversionManagerInstance.loadImg(v,cic[length(cic)-1]);
conversionManagerInstance.resizeTimagewithBitmapConversion(cic[length(cic)-1].width,cic[length(cic)-1].height,cic[length(cic)-1]);
cic[length(cic)-1].Parent:=wincontrol;
//ConversionManagerInstance.selected_component:=cic[length(cic)-1];
//ConversionManagerInstance.set_selected_component(cic[length(cic)-1],true);
end;

for i:=0 to length(controls_edit)-1 do
begin
ConversionManagerInstance.setvalue(controls_edit[i],'Text',stringreplace(to_edit_add[i],'\"','"',[rfReplaceAll]))

end;                                              //nicht optimal

ConversionManagerInstance.selected_component:=obj;
ConversionManagerInstance.set_selected_component(obj,true);

end;
procedure HTMLPARSE.parseHTML(html:string);
var i:integer;
begin
htmlrunnerlibraryInstance:= HTMLRunnerLibrary.Create();
//html:='<html><a><div id="#gen-12" enabled="enabled" value="val\"allo">hallo></div></a></html>';
counted_escape_slashes:=0;
loop_string_by_chars(html);
htmlrunnerlibraryInstance.Destroy;



//loop results
for i:=0 to length(htmlTransformerInstance.pushed_style_vars)-1 do
begin
parsecss(htmlTransformerInstance.pushed_style_vars[i]);
end;
render_results();



//parser_runner_library_createEntry('fcb');
//showmessage(inttostr(parser_runner_library_getEntry('fcb')));
//TODO:n bisschen performanter,1.bei global formcreate htmlrunnerlibraryinstance rezeugen(n bisschen mehr ram,darauf kommts aber nicht an),2. neu schreiben,parsen während datei einlesen(wirklich eher aufwendig,habe keine Lust dazu)
end;



procedure HTMLPARSE.parseCSS(str:string);
var hh:htmlrunnerlibrary;
begin
hh:=HTMLRunnerLibrary.Create();
//str:='#fc{width:66px;height:5em}#fc22222{-ms-border-radius:5em}}';
hh.set_length(length(str));
             CSSParseInstance:=cssparse.Create(hh);
           CSSParseInstance.parse(str);
hh.set_length(0);
hh.Destroy;
end;

end.
