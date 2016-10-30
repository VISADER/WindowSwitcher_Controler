unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Buttons, sBitBtn, StdCtrls, sEdit, sSpinEdit, ScktComp, sButton,
  sSkinManager, sLabel, ComCtrls, sStatusBar, ExtCtrls;

type
  TForm1 = class(TForm)
    sSkinManager1: TsSkinManager;
    sButton1: TsButton;
    sButton2: TsButton;
    ClientSocket1: TClientSocket;
    sSpinEdit1: TsSpinEdit;
    sBitBtn1: TsBitBtn;
    sEdit1: TsEdit;
    sEdit2: TsEdit;
    sLabel1: TsLabel;
    sLabel2: TsLabel;
    sLabel3: TsLabel;
    sButton3: TsButton;
    sStatusBar1: TsStatusBar;
    sButton4: TsButton;
    sLabel4: TsLabel;
    Timer1: TTimer;
    procedure sBitBtn1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure sButton1Click(Sender: TObject);
    procedure sButton2Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure sButton3Click(Sender: TObject);
    procedure sButton4Click(Sender: TObject);
    procedure ClientSocket1Read(Sender: TObject; Socket: TCustomWinSocket);
    procedure ClientSocket1Error(Sender: TObject; Socket: TCustomWinSocket;
      ErrorEvent: TErrorEvent; var ErrorCode: Integer);
    procedure Timer1Timer(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    function WCenter(wcntr: string): String;
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.sBitBtn1Click(Sender: TObject);
begin
  if Form1.Height=120 then begin
    Form1.Height:=220;
  end
  else begin
    Form1.Height:=120;
  end;
end;

procedure TForm1.FormCreate(Sender: TObject);
var
wcntr:string;
i,sc:Integer;
begin
Form1.Height:=120;
ClientSocket1.Close;
ClientSocket1.Active:=False;
Sleep(1000);
Application.ProcessMessages;
try
  ClientSocket1.Address:=sEdit1.Text;
  ClientSocket1.Port:=StrToInt(sEdit2.Text);
  ClientSocket1.Active:=True;
  Sleep(1000);
  Application.ProcessMessages;
  ClientSocket1.Open;
except
  sStatusBar1.SimpleText:=WCenter('Не подключен')+'Не подключен';
end;
wcntr:='Подключен к '+sEdit1.Text;
sStatusBar1.SimpleText:=WCenter(wcntr)+wcntr;
end;

procedure TForm1.sButton1Click(Sender: TObject);
begin
ClientSocket1.Socket.SendText('Edit1');
end;

procedure TForm1.sButton2Click(Sender: TObject);
begin
ClientSocket1.Socket.SendText('Edit2');
end;

procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
begin
ClientSocket1.Active:=False;
end;

procedure TForm1.sButton3Click(Sender: TObject);
begin
  ClientSocket1.Close;
  ClientSocket1.Active:=False;
  Sleep(1000);
  Application.ProcessMessages;
try
  ClientSocket1.Address:=sEdit1.Text;
  ClientSocket1.Port:=StrToInt(sEdit2.Text);
  ClientSocket1.Active:=True;
  sStatusBar1.SimpleText:=WCenter('Подключен к '+sEdit1.Text)+'Подключен к '+sEdit1.Text;
except
  sStatusBar1.SimpleText:=WCenter('Не подключен')+'Не подключен';
end;
end;

procedure TForm1.sButton4Click(Sender: TObject);
begin
ClientSocket1.Socket.SendText('WS#'+(IntToStr(sSpinEdit1.Value)));
end;


function TForm1.WCenter(wcntr: String): String;
var
  sb,wc: string;
  ws: Integer;
begin
  if (Length(wcntr))>=70 then begin
  wc:='';
  end
  else begin
  ws:=Round((70-(Length(wcntr)))/2);
  repeat
  Insert(' ',wc,ws);
  Dec(ws);
  until ws=0;
  end;
  WCenter:=wc;
end;

procedure TForm1.ClientSocket1Read(Sender: TObject;
  Socket: TCustomWinSocket);
  var
    text,st,sp:string;
    index,sti:Integer;
begin
  sp:='WS';
  st:=Socket.ReceiveText;
  index:=Pos('#', st);
  text:=st;
  if sp=Copy(text, 1, index-1) then begin
  sti:=Round(StrToInt((copy(text, index + 1, length(text) - index)))/60000);
  sStatusBar1.SimpleText:=WCenter('Время изменено на '+IntToStr(sti)+' минут')+'Время изменено на '+IntToStr(sti)+' минут';
  //ShowMessage(text);
  end;
end;

procedure TForm1.ClientSocket1Error(Sender: TObject;
  Socket: TCustomWinSocket; ErrorEvent: TErrorEvent;
  var ErrorCode: Integer);
begin
 if ErrorCode = 10061 then
    begin
      ClientSocket1.Active := False;
      sStatusBar1.SimpleText:=WCenter('Не подключен ')+'Не подключен ';
      ErrorCode := 0;
    end;
end;

procedure TForm1.Timer1Timer(Sender: TObject);
var
  text:String;
begin
text:=sStatusBar1.SimpleText;
sStatusBar1.SimpleText:=copy(text,2,Length(text)-1)+copy(text,1,1);
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
ClientSocket1.Close;
ClientSocket1.Active:=False;
end;

end.
