unit Collection_LangConvertFunctions;

interface
uses Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,Variants,
  StdCtrls,TypINfo,Math;
type
LangConvertFunction = function(value:string;lang_name:string;component_name:string):String
                         of object;//http://www.delphi-central.com/callback.aspx


LangConvertFunctions=class
published function convert_color(value:string;lang_name:string;component_name:string):String;
 published function convert_px_sizeto_percentHeight(value:string;lang_name:string;component_name:string):String;
   published function convert_px_sizeto_percentWidth(value:string;lang_name:string;component_name:string):String;

   //back
   published function convert_color_back(value:string;lang_name:string;component_name:string):String;
 published function convert_px_sizeto_percentHeight_back(value:string;lang_name:string;component_name:string):String;
   published function convert_px_sizeto_percentWidth_back(value:string;lang_name:string;component_name:string):String;

   function convertpercent(total:integer;current:integer):double;
   constructor Create(clHeight:integer;clWidth:integer;scrollbox1:Tscrollbox);


end;
implementation
var
clientHeight:integer;
clientWidth:integer;
scrollb:Tscrollbox;
constructor LangConvertFunctions.Create(clHeight:integer;clWidth:integer;scrollbox1:Tscrollbox);
begin
scrollb:=scrollbox1;
clientHeight:=clHeight;
clientWidth:=clWidth;
end;

function LangConvertFunctions.convert_color(value:string;lang_name:string;component_name:string):String;
var color:integer;
begin
color:=StrToInt(value);
                        //quelle:internet

result:='#'+IntToHex(GetRValue(Color), 2) +
     IntToHex(GetGValue(Color), 2) +
     IntToHex(GetBValue(Color), 2) ;
end;

function LangConvertFunctions.convertpercent(total:integer;current:integer):double;
var calc_percent:double;
begin
  calc_percent:= current / (total / 100);  //http://www.delphipraxis.net/129444-wie-auf-x-nachkommastellen-runden.html
   calc_percent:=Round(calc_percent * IntPower(10, 0)) / IntPower(10, 0); //http://www.hashbangcode.com/blog/get-percentage-number-php-172.html
result:=calc_percent;
end;

function LangConvertFunctions.convert_px_sizeto_percentWidth(value:string;lang_name:string;component_name:string):String;
var clWidth,pxvalue:integer;calc_percent:double;res_value:string;
begin
clWidth:=clientWidth;
pxvalue:=strtoint(value);  //GROES PROBLEm TODO(fIX):ist delphi weirklich so schlecht ,gelöst,Eigenart von Delphi,muss in var deklariert sein,sonst spinnt es völlig
calc_percent:=convertpercent(clWidth,pxvalue);
res_value:=floattostr(calc_percent);
result:=res_value+'%';
end;

function LangConvertFunctions.convert_px_sizeto_percentHeight(value:string;lang_name:string;component_name:string):String;
var clHeight,pxvalue,comma_pos:integer;convertbuffer,res_value,int_buffer,prefix:string;calc_percent:double;cp:string;
begin
clHeight:=clientHeight; //TODO(sebbbb):Am besten wäre es das basevalue als Objekt zu machen->copy von form1,aber ressourcenlastig
pxvalue:=strtoint(value);
  calc_percent:=convertpercent(clHeight,pxvalue);  //eigene Impl verworfen,da zu fehleranfällig

res_value:=floattostr(calc_percent);
result:=res_value+'%';
end;





//BACK
function LangConvertFunctions.convert_px_sizeto_percentWidth_back(value:string;lang_name:string;component_name:string):String;
var clWidth,pxvalue,comma_pos:integer;convertbuffer,res_value,int_buffer,prefix,newstr:string;calc_percent,px2:double;toadd,cp:string;i:integer;
begin
clWidth:=clientWidth;
  delete(value,length(value),length(value));
 toadd:='';
 if(length(value)=1)then
 begin
 toadd:='0,0';
 end
 else if(length(value)=2)then
 begin
 toadd:='0,';
 end
 else
 begin
  toadd:=value[1]+',';
  delete(value,1,1);
 end;

px2:=strtofloat(toadd+value);
calc_percent:=clWidth*px2;
res_value:=floattostr(calc_percent);


newstr:='';
for i:=1 to length(res_value)do
begin
if(res_value[i]=',')then
begin
break;
end;
newstr:=newstr+res_value[i];

end;

result:=newstr;
end;
function LangConvertFunctions.convert_px_sizeto_percentHeight_back(value:string;lang_name:string;component_name:string):String;
var clHeight,pxvalue,comma_pos:integer;convertbuffer,res_value,int_buffer,prefix,toadd,newstr:string;calc_percent,px2:double;cp:string;i:integer;
begin
clHeight:=clientHeight; //TODO(sebbbb):Am besten wäre es das basevalue als Objekt zu machen->copy von form1,aber ressourcenlastig

  //calc_percent:=convertpercent(clHeight,pxvalue);  //eigene Impl verworfen,da zu fehleranfällig

  delete(value,length(value),length(value));

   toadd:='';
 if(length(value)=1)then
 begin
 toadd:='0,0';
 end
 else if(length(value)=2)then
 begin
 toadd:='0,';
 end
 else
 begin
  toadd:=value[1]+',';
  delete(value,1,1);
 end;
px2:=strtofloat(toadd+value);
calc_percent:=clHeight*px2;
res_value:=floattostr(calc_percent);


newstr:='';
for i:=1 to length(res_value)do
begin
if(res_value[i]=',')then
begin
break;
end;
newstr:=newstr+res_value[i];

end;

result:=newstr;
end;

function LangConvertFunctions.convert_color_back(value:string;lang_name:string;component_name:string):String;
var scolor:string;
begin
     scolor:=value;
    delete(scolor,1,1);

   Result :=inttostr(
    RGB(
       StrToInt('$'+Copy(sColor, 1, 2)),
       StrToInt('$'+Copy(sColor, 3, 2)),
       StrToInt('$'+Copy(sColor, 5, 2))
     ));

end;
end.
 