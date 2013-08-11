unit Collection_ConversionTypeTag_Definitions;

interface
uses ConversionTypeTagDefinitions,Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,Variants,
  StdCtrls,ExtCtrls,TMYControls,alphamemo;
type
Collection_ConversionTypeTag_Definition=class
constructor Create(c:ConversionTypeTagDefinition);
end;
implementation
constructor Collection_ConversionTypeTag_Definition.Create(c:ConversionTypeTagDefinition);
begin
//Hinweis:Bei COmponents ist groﬂ/Kleinschreibung egal(hab ich so gemacht)
c.add(TLabel,'a',[]);
c.add(TButton,'button',[]);
c.add(TEdit,'input',[]);
c.add(TImage,'img',[]);
c.add(TMemo,'textarea',[]);
c.add(TTransparentMemo,'div',[]);
end;
end.
