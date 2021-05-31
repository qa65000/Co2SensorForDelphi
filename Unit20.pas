unit Unit20;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, WUni232c, Vcl.ExtCtrls, Vcl.StdCtrls;

type
  TForm20 = class(TForm)
    WUni232c1: TWUni232c;
    Timer1: TTimer;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
  private
    { Private 宣言 }
    ReadData: array [0..9] of byte;
  public
    { Public 宣言 }
  end;

var
  Form20: TForm20;

                                    {   0   1   2   3   4   5   6   7   8  }
const CMD_SensorON  : array [0..8] of BYTE = ( $ff,$01,$79,$A0,$00,$00,$00,$00,$E6 );
const CMD_SensorOFF : array [0..8] of BYTE = ( $ff,$01,$79,$00,$00,$00,$00,$00,$86 );
const CMD_SensorRead: array [0..8] of BYTE = ( $ff,$01,$86,$00,$00,$00,$00,$00,$79 );



implementation

{$R *.dfm}

procedure TForm20.FormCreate(Sender: TObject);
begin
    if WUni232c1.Open < 0 then
    begin
        Self.Caption := 'Comポートエラー';
        exit;
    end;
    Wuni232c1.Write(sizeof(CMD_SensorON),@CMD_SensorOn);
    Timer1.Enabled := True;
end;


procedure TForm20.Timer1Timer(Sender: TObject);
var
ReadCount : Byte;
Sum : Byte;
  i: Integer;
begin
    ReadCount :=   Wuni232c1.Read(10,@ReadData);
    Label3.Caption := IntToStr(ReadCount)+'/'+IntToStr(ReadData[2])+'/'+IntToStr(ReadData[3]);
    if(ReadCount = 9) then
    begin
      // sum Check
      sum := 0;
      for i := 0 to 7 do
          Sum := Sum+ ReadData[i];
      sum := $ff-Sum;
      if(Sum = ReadData[8] ) then
      begin
        Label2.Caption := IntToStr(ReadData[2]*256+ReadData[3])+'ppm';

      end;
    end
    else
    begin
        // あまりの受信データをすべて捨てる
      while(Wuni232c1.Read(10,@ReadData) <> 0) do;
    end;
    Wuni232c1.Write(sizeof(CMD_SensorRead),@CMD_SensorRead);

end;


end.
