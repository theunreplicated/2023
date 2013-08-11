unit ConversionManager_u;

interface                  //RTTI wäre am besten
uses StringUtils_u,Typinfo, Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,Variants,
  StdCtrls,grrr,Store,Collection_UI_Apply_Modes,ConversionPropertyDefinitions_u,ExtCtrls,ExtDlgs,JPEG,GraphicEX,GraphicColor;

type
//arrayofarrayofTControl=array of array of TControl;
arrayofarrayofLangType=array of array of LangType;
arrayofstring=array of string;
Stringwitherror=record
value:string;
error:boolean;
end;
D_OBJ_PPROP=record
propinfo:PPropinfo;
obj:Tobject;
error:boolean;
end;
 ConversionManager=class
 selected_component:TControl;
 store:arrayofarrayofTControl;
storeHelperInstance:StoreHelper;
image_array:array of TPicture;
img_paths:array of string;
image_array_identifier:array of integer;
function getvalue(component_reference:Tobject;attribute_name:string):Stringwitherror;
function setvalue(component_reference:Tobject;attribute_name:string;set_value:String):boolean;
constructor Create(scrollbox2:TScrollbox;ConversionPropertyDefinitionsInst:ConversionPropertyDefinitions;openpicturedialog:Topenpicturedialog);//TODO(seb):besser machen,stringutils als argument
procedure setprop(component_reference:Tobject;Propinfo:Ppropinfo;value:string);
function getinfoprop(component_reference:Tobject;attribute_name:String):D_OBJ_PPROP;//vorher private
function IsStrANumber(const S: string): Boolean;
procedure set_store_inst(storeInst:arrayofarrayofTControl;storeHelperInst:StoreHelper);
procedure pass_component_var(component:TComponentClass;func_name:string;window_Draw:TWinControl);
procedure applyValuestoComponent(Component:Tobject;values:array of string);
function getavailablepropertiesforComponent(Component:Tobject;properties_copy:arrayofarrayofLangType):arrayofstring;
//delphi workaround:kann ich das in schon fast jede Datei schreiben?
procedure resizeTimagewithBitmapConversion(width:integer;height:integer;image:timage);
 function createComponent(class_ref:TcomponentClass;parent:TwinControl;component_group:string):TControl;
 procedure applyMode(obj:TControl;mode_name:string);
function create_standard_Component(class_ref:TComponentClass;parent:TwinControl):Tcontrol;
  procedure ChangeValue_in_editor_bar(Sender:TControl;vars:string);

  procedure set_selected_component(Sender:TControl;force:boolean=false);
 procedure loadImg(filename:String;obj2:TImage);
 published

  procedure DragDrop_on_MouseDown(Sender: TControl; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
  procedure DragDrop_on_MouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
  procedure DragDrop_on_MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
  procedure editor_bar_value_change(Sender:TControl);
  procedure controls_bar_handle_click(Sender:TControl);


private
 StringUtilsInstance:StringUtils;

end;
implementation
 var
 ConversionPropertyDefinitionsInstance:ConversionPropertyDefinitions;
 scrollbox2Instance:TScrollbox;
 storeComponentClass:array of TComponentClass;
  UIApplyModesInstance:UI_Apply_Modes;
 ConversionManagerInstance:ConversionManager;
  window_handle:TWinControl;
  openpicturedialoginst:Topenpicturedialog;

  P1:TPoint;
Move:boolean;
procedure ConversionManager.resizeTimagewithBitmapConversion(width:integer;height:integer;image:timage);
var bmp:Tbitmap;tag:integer;picture:Tpicture;
begin
tag:=image.Tag;
picture:=image_array[tag];

Bmp := TBitmap.Create;
  Bmp.PixelFormat := pf24bit;
Bmp.Width :=width;
Bmp.Height := height;//quelle:glaub ich swissdelphicenter
Bmp.Canvas.StretchDraw(Rect(0, 0,width,height),picture.Graphic); //image.Picture.Graphic);
// Copy BMP back to JPG
//Bmp.Free;
  image.Picture.Bitmap.Assign(bmp);
end;

procedure ConversionManager.editor_bar_value_change(Sender:TControl);
var store_nr:integer;component_reference:TControl;vars_name:string;val:string;oc:Timage;
begin

  store_nr:=strtoint(storeHelperInstance.get_key('properties_inspector_vars'));
  component_reference:=store[store_nr][Sender.tag];
   vars_name:=getvalue(component_reference,'Caption').value;
   if(Sender.ClassName='TColorBox')then
  begin
  val:=getvalue(Sender,'Selected').value;
  end
  else
  begin
    val:=getvalue(Sender,'Text').value;
    end;
    //if not(val='')then
    //begin                //TOD:verbessern
   setvalue(selected_component,vars_name,val);

   if(selected_component.ClassName='TImage')then
   begin
   oc:=Timage(selected_component);
   if(vars_name='width')AND not(getvalue(selected_component,'width').value='')then
   begin
      //showmessage(getvalue(selected_component,'height').value+'---'+val);
    resizeTimagewithBitmapConversion(strtoint(val),strtoint(getvalue(selected_component,'height').value),oc);
   end
   else if(vars_name='height')AND not(getvalue(selected_component,'height').value='')then
   begin


     resizeTimagewithBitmapConversion(strtoint(getvalue(selected_component,'width').value),strtoint(val),oc);

     //TODO:immer neues image verwenden
   end;
   //end;
   end;
   end;
procedure ConversionManager.ChangeValue_in_editor_bar(Sender:TControl;vars:string);
var store_nr:integer;component_reference:TControl;i,found_key:integer;
begin
store_nr:=strtoint(storeHelperInstance.get_key('properties_inspector_vars'));
for i:=0 to length(store[store_nr])-1 do//copy n paste
begin
if(getvalue(store[store_nr][i],'Caption').value=vars)then
begin
found_key:=i;

break;
end;

end;
store_nr:=strtoint(storeHelperInstance.get_key('properties_inspector_values'));
component_reference:=store[store_nr][found_key];
setvalue(component_reference,'Text',getvalue(Sender,vars).value);

end;
procedure ConversionManager.set_selected_component(Sender:TControl;force:boolean=false);
var current_parent:TwinControl;s1,s2:string;store_nr,store_nr2,padding_top,i,i2,padding_left,anfangswert_left_label,anfangswert_left,padding_top_edit,lasttop_count,lastleft_count:integer;obj:TControl;langtypes:arrayofarrayofLangType;prop_res:arrayofstring;
begin
if not(selected_component.tag =Sender.Tag)OR (force)then
begin
selected_component:=Sender;
//Werte setzen
lasttop_count:=0;
lastleft_count:=0;
padding_top:=25;
padding_left:=10;
padding_top_edit:=0;
anfangswert_left_label:=5;
anfangswert_left:=60;
//create bar
current_parent:=scrollbox2Instance;
//refactor


//cleanup
s1:=storeHelperInstance.get_key('properties_inspector_values');
s2:=storeHelperInstance.get_key('properties_inspector_vars');
if not(s1='')OR not(s2='')then
begin
store_nr:=strtoint(s1);
 store_nr2:=strtoint(s2);
for i:=0 to length(store[store_nr])-1 do
begin
store[store_nr][i].visible:=false;
store[store_nr2][i].visible:=false;
FreeAndNil(store[store_nr][i]);
freeandnil(store[store_nr2][i]); //http://stackoverflow.com/questions/120858/remove-and-replace-a-visual-component-at-runtime
end;
setlength(store[store_nr],0);
setlength(store[store_nr2],0);
end;
//end cleanup
for i:=0 to length(ConversionPropertyDefinitionsInstance.properties)-1 do
begin
setlength(langtypes,length(langtypes)+1);
for i2:=0 to length(ConversionPropertyDefinitionsInstance.properties[i])-1 do
begin
setlength(langtypes[length(langtypes)-1],length(langtypes[length(langtypes)-1])+1);
langtypes[length(langtypes)-1][i2]:=ConversionPropertyDefinitionsInstance.properties[i][i2];
end;
end; //end for
prop_res:=getavailablepropertiesforComponent(Sender,langtypes);

for i:=0 to length(prop_res)-1 do
begin
//CREATE COMPONENTS
obj:=createComponent(Tlabel,scrollbox2Instance,'properties_inspector_vars');
//padding_top:=obj.Height;
setvalue(obj,'Caption',prop_res[i]);
obj.Top:=(lasttop_count*obj.Height)+(lasttop_count*padding_top);
obj.left:=anfangswert_left_label;
obj.Parent:=scrollbox2Instance;
//create edit field for dingens

if(prop_res[i]='Font.Color')then

begin
obj:=createComponent(TColorBox,scrollbox2Instance,'properties_inspector_values');
setvalue(obj,'Selected',getvalue(Sender,prop_res[i]).value);
end
else
begin
obj:=createComponent(TEdit,scrollbox2Instance,'properties_inspector_values');
setvalue(obj,'Text',getvalue(Sender,prop_res[i]).value);
end;

if not(prop_res[i]='Font.Color')then
begin
padding_top_edit:=obj.Height;
end
else
begin
padding_top_edit:=13;
end;
obj.Top:=(lasttop_count*obj.Height)+(lasttop_count*padding_top_edit);//copy n paste
obj.left:=anfangswert_left;
setvalue(obj,'OnChange','editor_bar_value_change');
//lastleft_count:=lastleft_count+1;
lasttop_count:=lasttop_count+1;
obj.Parent:=scrollbox2Instance;

end;
end;
end;







procedure ConversionManager.loadImg(filename:String;obj2:TImage);
var my_picture:Tpicture;
begin

     setlength(img_paths,obj2.tag+1);
      img_paths[obj2.tag]:=filename;//showmessage('bfload');
      obj2.Picture.LoadFromFile(FileName);
      //obj2.Picture.Bitmap.LoadFromFile(openpicturedialoginst.FileName);
      //my_picture:=obj2.Picture;

      my_Picture:=TPicture.Create;
      my_picture.assign(obj2.Picture);
      setlength(image_array,obj2.tag+1);
      image_array[obj2.tag]:=my_picture;
      setlength(image_array_identifier,length(image_array_identifier)+1);
      image_array_identifier[length(image_array_identifier)-1]:=obj2.Tag;
end;
procedure ConversionManager.controls_bar_handle_click(Sender:TControl);
var tag_name:integer;obj:TControl;Start: DWORD;
  GraphicClass: TGraphicExGraphicClass;
      PNGProperties : TPNGGraphic;my_picture:Tpicture;
  Graphic: TGraphic;NewY,NewX:integer;picture:TPicture;BMP:Tbitmap;obj2:Timage;width,height:integer; size_richtwert:integer;bw,bh:integer;bwc,bhc:double;
begin
tag_name:=Sender.Tag;
if(storeComponentClass[tag_name]=TImage)then
begin
openpicturedialoginst.FileName:='Bild.jpg';
if(openpicturedialoginst.Execute)then
begin
size_richtwert:=150;
//obj2:=Timage.Create(window_handle);
 //GraphicClass := FileFormatList.GraphicFromContent(openpicturedialoginst.FileName);
 //if GraphicClass = nil then obj2.Picture.LoadFromFile(openpicturedialoginst.FileName)
   //                         else
    //                        begin
         // GraphicFromContent always returns TGraphicExGraphicClass
      //  Graphic := GraphicClass.Create;
        //Graphic.OnProgress := ImageLoadProgress;
        //Graphic.LoadFromFile(openpicturedialoginst.FileName);
       // Image.Picture.Graphic := Graphic;
     //quelle:graphicex
    // end;                //quelle:http://www.delphipages.com/forum/showthread.php?t=199705

    obj:=createComponent(TImage,window_handle,'created_components');
    obj2:=TImage(obj);
      //picture:=picture.Create;
      //picture.LoadFromFile(openpicturedialoginst.filename);

         loadImg(openpicturedialoginst.filename,obj2);
      //RESIZE:
      //1.dazu width und height bekommen
        //image.picture.height ist wohl das richtige, an einer datei getestet(aber .jpg)
        width:=obj2.picture.width;
         height:=obj2.picture.height;
         bwc:=width/size_richtwert;
         bhc:=height/size_richtwert;

       //2.
       //bw:=width div bwc;
       //bh:=width div bhc;
       bwc:=width/bwc;
       bhc:=height/bhc;
       //http://www.delphipraxis.net/39759-float-real-integer-casten.html
       bw:=trunc(bwc);
       bh:=TRUNC(bhc);
       //showmessage(inttostr(bw));
       obj2.Width:=bw;
       obj2.height:=bh;

       resizeTimagewithBitmapConversion(bw,bh,obj2);

     obj2.parent:=window_handle;
     //obj2.Picture.Graphic:=graphic;

applyMode(obj2,'DragDrop');
     selected_component:=obj2;
set_selected_component(obj2,true);
  //copy n paste

end;
end
else
begin //f�r alle anderen
obj:=createComponent(storeComponentClass[tag_name],window_handle,'created_components');
if(storeComponentClass[tag_name].ClassName='TLabel')then
 begin
 setvalue(obj,'Caption','Text');
 end;



applyMode(obj,'DragDrop');



selected_component:=obj;
set_selected_component(obj,true);

obj.Parent:=window_handle;
end;
end;



 procedure ConversionManager.DragDrop_on_MouseDown(Sender: TControl; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
Move:=true;
set_selected_component(Sender);

P1.x:=X;
P1.y:=Y;
end;


procedure ConversionManager.DragDrop_on_MouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
var obj:Tcontrol;calc_left,calc_top:integer;
begin
if(Move=true)then
begin
obj:=TControl(Sender);
if(Y>P1.y)then
       obj.top:=obj.top +(Y - P1.y);
if(Y<P1.y)then
        obj.top:=obj.top-(P1.y-Y);
if(X> P1.x)then
      obj.left:=obj.left+(X-P1.x);
if(X<P1.x)then
       obj.left:=obj.left-(P1.x-X);



 ChangeValue_in_editor_bar(obj,'top');
  ChangeValue_in_editor_bar(obj,'left');
end;

end;


procedure ConversionManager.DragDrop_on_MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
Move:=false;
end;

 procedure ConversionManager.pass_component_var(component:TComponentClass;func_name:string;window_Draw:TWinControl);
  begin
 //Conversion.receive_component_var(component,func_name,window_Draw);
 setlength(storeComponentClass,length(storeComponentClass)+1);
 storeComponentClass[length(storeComponentClass)-1]:=component;
 window_handle:=window_draw;
 end;
 
 procedure ConversionManager.set_store_inst(storeInst:arrayofarrayofTControl;storeHelperInst:StoreHelper);
 begin
 //Collection_UI_Method_HandlerInstance:= Collection_UI_Method_Handler.Create(storeInst,storeHelperInst);

 end;
 constructor ConversionManager.Create(scrollbox2:TScrollbox;ConversionPropertyDefinitionsInst:ConversionPropertyDefinitions;openpicturedialog:Topenpicturedialog);
begin
 StringUtilsInstance:=StringUtils.Create();
 storeHelperInstance:=StoreHelper.Create;
 UIApplyModesInstance:=UI_Apply_Modes.Create;
 scrollbox2instance:=scrollbox2;
 ConversionPropertyDefinitionsInstance:=ConversionPropertyDefinitionsInst;
 openpicturedialoginst:=openpicturedialog;
end;

function split(split_char:string;text:string):arrayofstring;
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
end;            //wieder einer der vielen Macken von Delphi:split muss in die Klasse eingesetzt werden,sonst schlägt der Call von
//einer anderen Klasse aus der es created wurde fehl


function ConversionManager.getinfoprop(component_reference:Tobject;attribute_name:String):D_OBJ_PPROP;
var propinfo:PPropinfo;i:integer;realstructure:arrayofstring;len:integer;cref:Tobject;res:D_OBJ_PPROP;
begin


res.error:=false;
cref:=component_reference;
//realstructure:=StringUtilsInstance.split('.',attribute_name);
realstructure:=split('.',attribute_name);
len:=length(realstructure);
//showmessage(inttostr(len));
propinfo:=getpropinfo(cref,realstructure[0]);
 if not Assigned (propinfo)then
 begin
 res.error:=true;
 end
 else
 begin
if (len>1)then
begin
//showmessage('fdsfd');
for i:=0 to len-1 do
begin
propinfo:=getpropinfo(cref,realstructure[i]);//wird hal 2 mal aufggerufen-egal
//propInfo := GetPropInfo(component_reference.classinfo,realstructure[i]);
if not Assigned (propinfo)then
 begin
 res.error:=true;
 end
 else
 begin
if not((len-1)=i)then
begin //if not lasz
cref:=Tobject(getordprop(cref,propInfo));
end
else
begin
//showmessage('last'+propinfo^.PropType^.Name);

end;
end;
end;
end;
end;
res.propinfo:=propinfo;
res.obj:=cref;

result:=res;
end;
function ConversionManager.getvalue(component_reference:Tobject;attribute_name:string):Stringwitherror;
var propinfos:D_OBJ_PPROP;delphi_value:string; res:Stringwitherror;
begin


propInfos:=getinfoprop(component_reference,attribute_name);
if(PropInfos.error)then
begin
res.error:=true;
end
else
begin
res.error:=false;
res.value := VarToStr(GetPropValue(propinfos.obj, propinfos.propinfo^.Name));
end;
result:=res;
end;
function ConversionManager.setvalue(component_reference:Tobject;attribute_name:string;set_value:String):boolean;
var propinfos:D_OBJ_PPROP;delphi_value:string;
begin


propInfos := GetInfoprop(component_reference,attribute_name);

//if(propinfos.error)then
//begin
  setprop(propinfos.obj,Propinfos.propinfo,set_value);
  result:=true;
//end
//else
//begin
//result:=false;
//end;
end;
function ConversionManager.IsStrANumber(const S: string): Boolean;
var
  P: PChar;
begin
  P      := PChar(S);
  Result := False;
  while P^ <> #0 do   //http://www.swissdelphicenter.ch/torry/showcode.php?id=58
  begin
    if not (P^ in ['0'..'9']) then Exit;
    Inc(P);
  end;
  Result := True;
end;
procedure ConversionManager.setprop(component_reference:Tobject;Propinfo:Ppropinfo;value:string);
var type_:string;PropOrEvent:string;method:Tmethod;                         //z.b. classinfo
begin

type_:=Propinfo^.PropType^.Name;                                //swissdelphicenter

if PropInfo^.PropType^.Kind in tkMethods then
begin
//aktuelles=event //funzt(sollte),hab es in einem andern Projekt getestet,sogar die richtigen Argumente gehen wie z.b. X bei onmousedown
method.Code := ConversionManager.MethodAddress(value); //schon öfters,von stackoverflow  //TODO(sebb):Convert into a reusable function with x.methodadress with x as argument(Tclass?,tobject?)
method.Data := pointer(Self); //store pointer to object instance

setMethodProp(component_reference,Propinfo,method);


end
else
begin
  //falls property (meistens)
if(type_='String')then             // string als else-behandlung,jedoch hier auch ,irgendow muss die performance ja herkommen,wenn es sonst ziemlich langsam sein sollte
begin
SetStrProp(component_reference,Propinfo,value);
end
else if(type_='Integer')then
begin
  if not(value='')then
  begin
  SetOrdProp(component_reference,Propinfo,strtoint(value));
  end;
end
else if(type_='TCaption')then
begin
setstrprop(component_reference,Propinfo,value);
end
else if(type_='TFont')then
begin if not(value='')then
  begin
  setordprop(component_reference,Propinfo,strtoint(value));
  end;
end
else
begin

 //ausnahmebehandlung am schluss,falls nichts zutrifft
if(IsStrANumber(value))then  //check on nr-convert möglich->number
begin
  if not(value='')then
  begin
  SetOrdProp(component_reference,Propinfo,strtoint(value));
  end;

end
else
begin
SetStrProp(component_reference,Propinfo,value);
end;



end;


end;
end;
function ConversionManager.create_standard_Component(class_ref:TComponentClass;parent:TWinControl):Tcontrol;//TODO(sebz):vielleicht parent als 2.arg noch
var cf:TControl;ctrl:TObject;
begin


 ctrl:=class_ref.Create(parent);           //aaaaufwendige Transformationen ,vorsicht:muss parent sein wegen window
 cf:=TControl(ctrl);
 //cf.parent:=parent;
result:=cf;
end;
function zahlgerade(zahl:integer):boolean; //TODO:intutils
begin
if(zahl mod 2=0)then//http://phpforum.de/archiv_38399_ungerade@oder@gerade@Zahl@feststellen_anzeigen.html
begin
result:=true;
end
else
begin
result:=false;
end;               //copy n paste
end;//copy unit1,TODO:eigene unit machen
procedure Conversionmanager.applyValuestoComponent(Component:Tobject;values:array of string);
var i:integer;buf_var:string;
begin

  for i:=0 to length(values)-1 do
        begin
        if(zahlgerade(i))then
        begin
        buf_var:=values[i];

        end
        else
        begin


        setvalue(Component,buf_var,values[i]);
        end;

        end;

end;
function ConversionManager.createComponent(class_ref:TcomponentClass;parent:TwinControl;component_group:string):Tcontrol;
var obj:Tcontrol;i:integer;store_nr:string;s1,s2:integer;                             //component_group= das wo es eingeordnet werden sollte,z.b. all_created_components
begin
//showmessage(class_Ref.ClassName);
obj:=create_standard_Component(class_ref,parent);


store_nr:=storeHelperInstance.handler_getkey(component_group);
if(strtoint(store_nr)>length(store)-1)then
begin
setlength(store,length(store)+1);
   // showmessage('fcs'+inttostr(length(store)));
end;
s1:=StrToInt(store_nr);

s2:=length(store[s1]);

SetLength(store[s1],s2+1);    
obj.tag:=s2;
store[s1][s2]:=obj;

set_store_inst(store,storeHelperInstance);




result:=obj;

end;
procedure ConversionManager.applyMode(obj:TControl;mode_name:string);
var i:integer;s_nr:string;store_nr:integer;buf_var:string;dc:array of string;
begin
s_nr:=UIApplyModesInstance.StoreHelperInstance.handler_getkey(mode_name);
  if not(s_nr='')then
    begin
      store_nr:=StrToInt(s_nr);


      applyValuestoComponent(obj,UIApplyModesInstance.store[store_nr]);

      end
  else
  begin
      ShowMessage('machtlos -programmierfehler');
  end;
end;
function ConversionManager.getavailablepropertiesforComponent(Component:Tobject;properties_copy:arrayofarrayofLangType):arrayofstring;
var i,i2:integer;res:arrayofstring;
begin
for i:=0 to length(properties_copy)-1 do//haten ma schonmal gehabt
begin
for i2:=0 to length(properties_copy[i2])-1 do
begin

 //check if exists
if not(properties_copy[i][i2].component_name='')then
begin
if( not getinfoprop(Component,properties_copy[i][i2].component_name).error)then
begin
setlength(res,length(res)+1);
res[length(res)-1]:=properties_copy[i][i2].component_name;
end;
end;
end;
end;
result:=res;
end;
end.
