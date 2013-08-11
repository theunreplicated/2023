unit Collection_Global_conversion_property_definitions;


interface
uses ConversionPropertyDefinitions_u;
type

global_conversion_property_definitions=class

constructor Create(ConversionPropertyDefinition:ConversionPropertyDefinitions);


end;
implementation
constructor global_conversion_property_definitions.Create(ConversionPropertyDefinition:ConversionPropertyDefinitions);
var c:ConversionPropertyDefinitions;
begin
c:=ConversionPropertyDefinition;
c.add('CSS',c.langTypeBuilder('width','width','','','convert_px_sizeto_percentWidth'));  //short variable name syntax
c.add('CSS',c.langTypeBuilder('height','height','','','convert_px_sizeto_percentHeight'));
c.add('CSS',c.langTypeBuilder('top','top','','','convert_px_sizeto_percentHeight'));
c.add('CSS',c.langTypeBuilder('left','left','','','convert_px_sizeto_percentWidth'));
c.add('CSS',c.langTypeBuilder('Font.size','font-size','px'));
c.add('CSS',c.langTypeBuilder('Font.Color','font-color','','','convert_color'));
c.add('HTML',c.langTypeBuilder('link','href'));
//c.add('CSS',c.langTypeBuilder('Color','color','','','convert_color'));
c.add('HTML_INNER_VAR',c.langTypeBuilder('Caption',''));
c.add('HTML_INNER_VAR',c.langTypeBuilder('Text',''));


end;
end.
 