unit Unit2;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Grids, tlhelp32;

type
  TForm1 = class(TForm)
    Memo1: TMemo;
    procedure FormCreate(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;
  pe32:tProcessEntry32;
  pe32Child:tProcessEntry32;
  hProcess:THandle;
  hProcessChild:THandle;

implementation

procedure TForm1.FormCreate(Sender: TObject);
VAR
  code:Integer;
  s, childs:String;
begin
  pe32.dwSize:=SizeOf(tProcessEntry32);
  hProcess:=CreateToolhelp32SnapShot(TH32CS_SNAPPROCESS,0);
  Process32First(hProcess,pe32);
  str(pe32.th32ProcessID,s);
  val(s,pe32.th32ProcessID,code);
  Memo1.clear;
  Repeat
    Memo1.lines.add('Процесс');
    Memo1.lines.add(pe32.szExeFile);
    pe32Child.dwSize:=SizeOf(tProcessEntry32);
    hProcessChild:=CreateToolhelp32SnapShot(TH32CS_SNAPPROCESS,0);
    Process32First(hProcessChild,pe32Child);
    Repeat
        if pe32Child.th32ParentProcessID = pe32.th32ProcessID
        then childs:= childs + pe32Child.szExeFile + ' ';
    Until Process32Next(hProcessChild,pe32Child)=False;
    Memo1.lines.add('Дочерние процессы:');
    Memo1.lines.add(childs);
    childs:= '';
    Memo1.lines.add('');
  until Process32Next(hProcess,pe32)=False;
end;

{$R *.dfm}

procedure TForm1.Button2Click(Sender: TObject);
begin
  Form1.onCreate(Sender);
end;

end.
