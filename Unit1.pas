unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,Variants,
  StdCtrls,TypINfo,DragDropComponents,Math,FileStorageFileOperations,Collection_LangConvertFunctions,IFileOperations,
  Collection_Global_conversion_property_definitions,ConversionPropertyDefinitions_u,
  ConversionManager_u,ConversionTypeTagDefinitions,Collection_ConversionTypeTag_Definitions,ComponentCreation,
  ExtCtrls,Conversion_Additional_u, Grids, ValEdit,HTMLPARSER,SharedGlobals,
  ExtDlgs,TMYControls,alphamemo,cefvcl,ceflib;

type
arrayofstringwitherror=array of stringwitherror;


FinishWebTypes=record
CSS:string;
HTML:string;
end;
    PreparedHTMLCSSJS=record
    html_attrs:array of string;
    css_values:array of string;
    js_values:array of string;
    html_innervar:array of string;
    html_available:boolean;
    css_available:boolean;
    js_available:boolean;
    end;

  TForm1 = class(TForm)
    Button2: TButton;
    ScrollBox1: TScrollBox;
    Button3: TButton;
    SaveDialog1: TSaveDialog;
    OpenDialog1: TOpenDialog;
    ScrollBox2: TScrollBox;
    OpenPictureDialog1: TOpenPictureDialog;
    Chromium1: TChromium;
    Button1: TButton;
    Button4: TButton; //the only purpose of this function is using it as asrgument,no contents



   function createcomponent(typ:TComponentClass;parent:TwinControl;defaultvalues:array of string):Tcontrol;
    procedure FormCreate(Sender: TObject);
    function createhtml(component_reference:TObject):PreparedHTMLCSSJS;
    function finish_html(component:TObject;prepared:PreparedHTMLCSSJS;cssid:string):FinishWebTypes;
    procedure Button2Click(Sender: TObject);
    function LangConvertFunction_Proxy(FunctionName:string;value:string;lang_name:string;component_name:string):string;
     procedure create_controls_bar();
//    procedure Button4Click(Sender: TObject);
//    procedure Button5Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure add_controls_bar_item(component:TComponentClass;desc:string;call_function:string='');
    procedure Button1Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);



  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
  end;

var

  Form1: TForm1;

  all_created_components:array of TObject;fcs:string;
  FileOperationsInstance:IFileOperation;
  LangConvertFunctionsInstance:LangConvertFunctions;
  global_conversion_property_definitionsInstance:global_conversion_property_definitions; //TODO(sebbbi):change to collection
  ConversionPropertyDefinition:ConversionPropertyDefinitions;
  ConversionManagerInstance:ConversionManager;
  ConversionTypeTagDefinitionInstance:ConversionTypeTagDefinition;
  Collection_ConversionTypeTag_DefinitionInstance:Collection_ConversionTypeTag_Definition;
 // ComponentCreatorInstance:ComponentCreator;
  //Conversion_AdditionalInstance:Conversion_Additional;
  HTMLPARSERInstance:HTMLPARSE;
  __stuemperhaft_change:boolean;
  cbleft:integer;cbpadding:integer;cbtop:integer;cb_last_width:integer;
 m1,m2:TMemo;cb_r_lw:integer;
  nl:String;
implementation

{$R *.DFM}

function TForm1.LangConvertFunction_Proxy(FunctionName:string;value:string;lang_name:string;component_name:string):string;
var m: TMethod;//http://stackoverflow.com/questions/4186458/delphi-call-a-function-whose-name-is-stored-in-a-string
begin
m.Code := LangConvertFunctions.MethodAddress(FunctionName); //find method code  //TODO(sebb):Convert into a reusable function with x.methodadress with x as argument(Tclass?,tobject?)
  m.Data := pointer(Self); //store pointer to object instance
  Result := LangConvertFunction(m)(value,lang_name,component_name);
end;
function zahlgerade(zahl:integer):boolean;
begin
if(zahl mod 2=0)then//http://phpforum.de/archiv_38399_ungerade@oder@gerade@Zahl@feststellen_anzeigen.html
begin
result:=true;
end
else
begin
result:=false;
end;
end;



function TForm1.createcomponent(typ:TComponentClass;parent:TwinControl;defaultvalues:array of string):TControl;
var obj:Tcontrol;
begin

//createbutton(defaultvalues);
obj:=ConversionManagerinstance.createComponent(typ,parent,'created_components');//registerClass

ConversionManagerinstance.applyMode(obj,'DragDrop');

ConversionManagerInstance.applyValuestoComponent(obj,defaultvalues);
obj.Parent:=parent;
//ConversionManagerInstance.setvalue(obj,'parent','form1');
//setlength(all_created_components,length(all_created_components)+1);
  //all_created_components[length(all_created_components)-1]:=obj;

 result:=obj;
end;


function TForm1.createhtml(component_reference:TObject):PreparedHTMLCSSJS;
var i,i2:integer;html,css,js:array of string;langbuffer:string;alpha_memo:TTransparentMemo;am:Tmemo;delphi_value:string;PropInfo: PPropInfo;html_name:string;dnamebuf:Stringwitherror;returnlinker:PreparedHTMLCSSJS;c:ConversionPropertyDefinitions;
begin
c:=ConversionPropertyDefinition;
//TODO(sebastiaan):js support
  returnlinker.html_available:=false;returnlinker.css_available:=false;returnlinker.js_available:=false;
//mit component_reference.ClassName gibts den KlassenNamen
 //html_name:=gethtmlname_for(component_reference);


for i:=0 to length(c.properties)-1 do
begin
//setlength(returnlinker.html_innervar,length(returnlinker.html_innervar)+1);
//returnlinker.html_innervar[length(returnlinker.html_innervar)-1]:='';
for i2:=0 to length(c.properties[i])-1 do
begin
if(c.properties[i][i2].available)then   //if i2=0 ->html   i2=1-> css   TODO():i2=2->js
begin
//falls verfügbar
//main code
//hier spielt sich alles ab


dnamebuf:=ConversionManagerInstance.getvalue(component_reference,c.properties[i][i2].component_name);
if not dnamebuf.error then
begin
delphi_value:=dnamebuf.value;

if(component_reference.ClassName='TImage')AND ((c.properties[i][i2].lang_name='width')OR(c.properties[i][i2].lang_name='height'))then
begin

delphi_value:=delphi_value+'px';//sollte eigentlich da hinten irgendwo festgelegt werden
end
else if not(c.properties[i][i2].convert_function='')then //checke ob callback function in real existiert . real madrid
begin
          
delphi_value:=LangConvertFunction_Proxy(c.properties[i][i2].convert_function,delphi_value,c.properties[i][i2].lang_name,c.properties[i][i2].component_name);

end;//http://howtopress.blogspot.com/2011/12/how-to-replace-string-in-delphi.html
delphi_value:=StringReplace(delphi_value,'"','\"',[rfReplaceAll]);
//das  statement hiervon: http://www.swissdelphicenter.ch/torry/showcode.php?id=1084
if(i2=0)then
begin
//html case            //TODO(sebb):immer value durch funktion laufen lassen

langbuffer:=c.properties[i][i2].lang_name+'="'+c.properties[i][i2].lang_prefix+delphi_value+c.properties[i][i2].lang_suffix;
setlength(returnlinker.html_attrs,length(returnlinker.html_attrs)+1);
returnlinker.html_attrs[length(returnlinker.html_attrs)-1]:=langbuffer;
returnlinker.html_available:=true;
end
else if(i2=1)then
begin
//css case
  returnlinker.css_available:=true;
langbuffer:=c.properties[i][i2].lang_name+':'+c.properties[i][i2].lang_prefix+delphi_value+c.properties[i][i2].lang_suffix;

 setlength(returnlinker.css_values,length(returnlinker.css_values)+1);
returnlinker.css_values[length(returnlinker.css_values)-1]:=langbuffer;
end
else if(i2=3)then
begin//html inner

if not(component_reference.classname='TEdit')then
begin
setlength(returnlinker.html_innervar,length(returnlinker.html_innervar)+1);
returnlinker.html_innervar[length(returnlinker.html_innervar)-1]:=delphi_value;
end
else
begin
setlength(returnlinker.html_innervar,length(returnlinker.html_innervar)+1);
returnlinker.html_innervar[length(returnlinker.html_innervar)-1]:='';
setlength(returnlinker.html_attrs,length(returnlinker.html_attrs)+1);
returnlinker.html_attrs[length(returnlinker.html_attrs)-1]:='value="'+delphi_value+'"';
end
end
else
begin
showmessage('Fehler im Programm');
end;
end;
end;
end;

end;
if(component_reference.ClassName='TImage')then
begin
langbuffer:='src="file://'+ConversionManagerInstance.img_paths[TImage(component_reference).tag]+'"';
setlength(returnlinker.html_attrs,length(returnlinker.html_attrs)+1);
returnlinker.html_attrs[length(returnlinker.html_attrs)-1]:=langbuffer;
returnlinker.html_available:=true;
end;
if(length(returnlinker.html_innervar)=0)then
begin
setlength(returnlinker.html_innervar,1);
returnlinker.html_innervar[0]:='';
end;

if(component_reference.ClassName='TMemo')then
begin

  am:=TMemo(component_reference);

  returnlinker.html_innervar[0]:=StringReplace(am.Lines.Text,nl,'<br/>',[rfReplaceAll]);
end;
if(component_reference.ClassName='TTransparentMemo')then
begin

  alpha_memo:=TTransparentMemo(component_reference);

  returnlinker.html_innervar[0]:=StringReplace(alpha_memo.Lines.Text,nl,'<br/>',[rfReplaceAll]);
end;


returnlinker.html_available:=true;
result:=returnlinker;
end;


procedure TFOrm1.add_controls_bar_item(component:TComponentClass;desc:string;call_function:string='');
var obj:TControl;
begin
ConversionManagerInstance.pass_component_var(component,call_function,scrollbox1);
obj:=ConversionManagerInstance.createComponent(TButton,form1,'control_bar');
obj.Width:=90;
ConversionManagerInstance.setvalue(obj,'OnClick','controls_bar_handle_click');
ConversionManagerInstance.setvalue(obj,'Caption',desc);
cb_r_lw:=obj.width;
obj.left:=cbleft+(cb_last_width*cbpadding)+(cb_r_lw*cb_last_width);
obj.top:=cbtop;
cb_last_width:=cb_last_width+1;

obj.Parent:=form1;
end;
procedure TFOrm1.create_controls_bar();
var obj:TControl;
begin
cb_last_width:=1;
  
 cbleft:=170;// immer -10
 cbpadding:=10;cbtop:=50;
//obj:=ComponentCreatorInstance.createComponent(TButton,form1,'control_bar');
//ConversionManagerInstance.setvalue(obj,'OnClick','controls_bar_handle_click');
//obj.Parent:=form1;
 add_controls_bar_item(TLabel,'Text');
 add_controls_bar_item(TButton,'Button');
 add_controls_bar_item(TEdit,'Eingabe-Feld');
 add_controls_bar_item(TImage,'Bild einfügen');
 add_controls_bar_item(TMemo,'Textarea');
 add_controls_bar_item(TTransparentMemo,'Mehrzeiliger Text');
end;

procedure TForm1.FormCreate(Sender: TObject);
var lang:Langtype;
begin
nl:=#13#10;
FileOperationsInstance:=FileStorageFileOperation.Create();
LangConvertFunctionsInstance:=LangConvertFunctions.Create(ScrollBox1.Height,scrollbox1.Width,scrollbox1);
ConversionPropertyDefinition:=ConversionPropertyDefinitions.Create();
global_conversion_property_definitionsInstance:=global_conversion_property_definitions.Create(ConversionPropertyDefinition);
ConversionTypeTagDefinitionInstance:=ConversionTypeTagDefinition.Create();
Collection_ConversionTypeTag_DefinitionInstance:=Collection_ConversionTypeTag_Definition.Create(ConversionTypeTagDefinitionInstance);
ConversionManagerInstance:=ConversionManager.Create(scrollbox2,ConversionPropertyDefinition,openpicturedialog1);


//Conversion_AdditionalInstance:=Conversion_Additional.Create(ConversionManagerInstance);
//ComponentCreatorInstance:=ComponentCreator.Create(ConversionManagerInstance,Conversion_AdditionalInstance);
HTMLPARSERInstance:=htmlparse.create(ConversionTypeTagDefinitionInstance,ConversionManagerInstance,scrollbox1,ConversionPropertyDefinition,self);
//einfach nur schlecht:das type-passing geht auch net
 create_controls_bar();
//create

 __stuemperhaft_change:=false;
end;

function TFOrm1.finish_html(component:TObject;prepared:PreparedHTMLCSSJS;cssid:string):FinishWebTypes;
var i:integer;html_name:string;html,css:string;res:FinishWebTypes;
begin

   //html_name:=gethtmlname_for(component); //TODO:change mit anschluss an die andere collection
   html_name:=ConversionTypeTagDefinitionInstance.get(component.ClassName);//Placeholder-test
   html:='<'+html_name;

    html:=html+' '+'id="'+cssid+'"';
   if(prepared.html_available)then
   begin
   for i:=0 to length(prepared.html_attrs)-1 do
   begin

   html:=html+' '+prepared.html_attrs[i];
   end;
   end; //nach css muss nicht gecheckt werden,da vorhanden
//   showmessage('1.');
  // showmessage(prepared.html_innervar[i]);
  // showmessage('2.');
  html:=html+'>'+prepared.html_innervar[0]+'</'+html_name+'>';
  //css
  css:='#'+cssid+' {';

  for i:=0 to length(prepared.css_values)-1 do
  begin
   css:=css+prepared.css_values[i];
   if not(i=length(prepared.css_values)-1)then
   begin
    css:=css+';';
   end;
  end;
  css:=css+';position:absolute';
     css:=css+'}';

     //showmessage(html+css);
   //result:=html;
   res.CSS:=css;
   res.HTML:=html;
   result:=res;
end;
function createhtmlpage(langtypes:array of FinishWebTypes):string;
var html:string;i:integer;
begin
nl:='';
         //http://board.gulli.com/thread/113456-zeilenumbruch-in-delphi/
//crlf:=#13#10;
html:='<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">';
html:=html+nl+'<html xmlns="http://www.w3.org/1999/xhtml">';//Quelle:dreamweaver, ich gluab mit dem neuten HTML5 !doctype gehts einfacher
                                                                               //aber keinen suppport für ie6 und co.
html:=html+nl+'<head>';

//css
html:=html+nl+'<style>';
for i:=0 to length(langtypes)-1 do
begin
html:=html+nl+langtypes[i].CSS;
end;
html:=html+nl+'</style>';

//end head
html:=html+nl+'</head>';

html:=html+nl+'<body>';
//html added
for i:=0 to length(langtypes)-1 do
begin
html:=html+nl+langtypes[i].HTML;

end;
html:=html+nl+'</body>'+nl+'</html>';
result:=html;
end;

procedure TForm1.Button2Click(Sender: TObject);
var preparedhtml:PreparedHTMLCSSJS;langf:array of FinishWebTypes;i:integer;btn:Tbutton;
begin
for i:=0 to length(ConversionManagerInstance.store[strtoint(ConversionManagerInstance.storeHelperInstance.handler_getkey('created_components'))])-1 do
begin
preparedhtml:=createhtml(ConversionManagerInstance.store[strtoint(ConversionManagerInstance.storeHelperInstance.handler_getkey('created_components'))][i]);
setlength(langf,length(langf)+1);
langf[length(langf)-1]:=finish_html(ConversionManagerInstance.store[strtoint(ConversionManagerInstance.storeHelperInstance.handler_getkey('created_components'))][i],preparedhtml,'editor_'+inttostr(i));
end;


 SaveDialog1.FileName:='Website.html';//http://www.delphibasics.co.uk/RTL.asp?Name=TSaveDialog
if(SaveDialog1.Execute)then
begin
fcs:=savedialog1.filename;
FileOperationsInstance.write(savedialog1.filename,createhtmlpage(langf));
end;


end;





{procedure TForm1.Button4Click(Sender: TObject);
var i,i2:integer;passVar:arrayofarrayofLangType;at:arrayofstring;
begin            //TODO(seb):loop für alle deise Anwendungen machen(funktion)
ValueListEditor1.Strings.Clear;
for i:=0 to length(ConversionPropertyDefinition.properties)-1 do
begin
setlength(passVar,length(PassVar)+1);
for i2:=0 to length(ConversionPropertyDefinition.properties[i])-1 do
begin
//if(ConversionPropertyDefinition.properties[i][i2].available)then
//begin
setlength(passVar[i],length(PassVar[i])+1);
passVar[i][length(PassVar[i])-1]:=ConversionPropertyDefinition.properties[i][i2];
//end;
end;
end;

 }











//TODO








//at:=ConversionManagerInstance.getavailablepropertiesforComponent(ConversionManagerInstance.store[strtoint(ConversionManagerInstance.storeHelperInstance.handler_getkey('created_components'))][0],passVar);
{
for i:=0 to length(at)-1 do
begin
//showmessage(at[i]);//hier wird der eigentliche Wert bekommen
ValueListEditor1.Strings.add(at[i]+'='+ConversionManagerInstance.getvalue(ConversionManagerInstance.store[strtoint(ConversionManagerInstance.storeHelperInstance.handler_getkey('created_components'))][ConversionManagerInstance.selected_component.Tag],at[i]).value);
                                                                   //es muss noch gechekt werden ob var überhaupt gesetzt
end;
ValueListEditor1.Visible:=true;
end;

procedure TForm1.Button5Click(Sender: TObject);
var line,Wert,value:string;i:integer;
begin//http://www.delphipraxis.net/27720-valuelisteditor-eintraege-adden-lesen.html
for i:=0 to ValueListEditor1.rowcount-2 do
begin
Line := ValueListEditor1.Strings.Strings[i];
  if pos('=',Line) <> 0 then begin
    Wert := copy(Line,pos('=',Line)+1,length(Line));
    Value := copy(Line,1,pos('=',Line)-1);//abgeändert,da es sonst nicht geht
  end;
  ConversionManagerInstance.setvalue(ConversionManagerInstance.store[strtoint(ConversionManagerInstance.storeHelperInstance.handler_getkey('created_components'))][ConversionManagerInstance.selected_component.Tag],value,Wert);


end;
end;

}

procedure TForm1.Button3Click(Sender: TObject);
var f: TFileStream;l: Integer;result:ansistring; AFileName: string;//http://www.delphipraxis.net/148367-readfile.html
begin
//HTMLPARSERInstance.parseHTML(FileOperationsInstance.read('hi'));

OpenDialog1.FileName:='Website.html';
  if(OpenDialog1.Execute)then
  begin
 //AFileName:='test.html';
 AfileName:=OpenDialog1.FileName;
 result:=FileOperationsInstance.read(afilename);


 HTMLPARSERInstance.parseHTML(result);
end;
end;


procedure TForm1.Button1Click(Sender: TObject);
begin
Chromium1.Visible:=true;
chromium1.Load('file://'+fcs);
button1.Visible:=false;
button4.Visible:=true;
end;

procedure TForm1.Button4Click(Sender: TObject);
begin
Chromium1.Visible:=false;
button1.Visible:=true;
button4.Visible:=false;
end;

initialization

CefLibrary:=ExpandFileName('bin\libcef.dll'); //groups.google.com/delphichromiumebedded the problem with directory antwort von henry gourvest
end.
