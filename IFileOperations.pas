unit IFileOperations;
//warum daraus n interface machen?:
//Verwendung f�r datei lokal,datei z.b. auf ftp-server,simulation �ber http(z.b. so was wie dann dropbox,box.net)



interface
type//@interface
IFileOperation=interface
procedure write(filename:String;text:string;mode:string='REWRITE');
function read(const AFileName: string):Ansistring;
end;
implementation

end.
 