unit FileStorageFileOperations;

interface
uses IFileOperations,Windows,SysUtils,Classes;
type
FileStorageFileOperation=class(TInterfacedObject,IFileOperation)//http://de.wikibooks.org/wiki/Programmierkurs:_Delphi:_Pascal:_Interfaces
procedure write(filename:String;text:string;mode:string='REWRITE');
function read(const AFileName: string): AnsiString;
end;
implementation
           //es gab noch andere funktionen,aber eher nicht verwenden wegen blockread denk ich mal
function FileStorageFileOperation.read(const AFileName: string): AnsiString;
var
  f: TFileStream;                          //http://www.delphipraxis.net/148367-readfile.html
  l: Integer;
begin
  Result := '';
  f := TFileStream.Create(AFileName, fmOpenRead or fmShareDenyWrite);
  try
    l := f.Size;
    if L > 0 then
    begin
      SetLength(Result, l);
      F.ReadBuffer(Result[1], l);
    end;
  finally
    F.Free;
  end;
end;


procedure FileStorageFileOperation.write(filename:String;text:string;mode:string='REWRITE');
var f:textfile;
begin   //http://www.swissdelphicenter.ch/torry/showcode.php?id=176
AssignFile(f, filename); {Assigns the Filename}
if(mode='REWRITE')then
begin

  ReWrite(f); {Create a new file named ek.txt}
  Writeln(f, text);
  end
  else
  begin
      //showmessage('Fehler');
  end;
  Closefile(f);

end;



end.
