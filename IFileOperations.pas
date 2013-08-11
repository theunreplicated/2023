unit IFileOperations;
//warum daraus n interface machen?:
//Verwendung für datei lokal,datei z.b. auf ftp-server,simulation über http(z.b. so was wie dann dropbox,box.net)



interface
type//@interface
IFileOperation=interface
procedure write(filename:String;text:string;mode:string='REWRITE');
function read(const AFileName: string):Ansistring;
end;
implementation

end.
 