unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, sSkinProvider, sSkinManager, ComCtrls, acProgressBar, StdCtrls,
  sButton, sLabel, sComboBox, sCheckBox, sGroupBox, sEdit, sSpinEdit,
  ExtCtrls, sBevel, sRadioButton, Tlhelp32, INIfiles, Menus;

type
  TFormA = class(TForm)
    sSkinManager1: TsSkinManager;
    sSkinProvider1: TsSkinProvider;
    GB1: TsGroupBox;
    CB1: TsCheckBox;
    LB1: TsComboBox;
    sLabel1: TsLabel;
    sLabel2: TsLabel;
    boff1: TsButton;
    PB1: TsProgressBar;
    SE1: TsSpinEdit;
    sLabel3: TsLabel;
    sLabelFX1: TsLabelFX;
    GB2: TsGroupBox;
    sLabel4: TsLabel;
    sLabel5: TsLabel;
    sLabel6: TsLabel;
    CB2: TsCheckBox;
    LB2: TsComboBox;
    boff2: TsButton;
    PB2: TsProgressBar;
    SE2: TsSpinEdit;
    GB3: TsGroupBox;
    sLabel7: TsLabel;
    sLabel8: TsLabel;
    sLabel9: TsLabel;
    CB3: TsCheckBox;
    LB3: TsComboBox;
    boff3: TsButton;
    PB3: TsProgressBar;
    SE3: TsSpinEdit;
    GB4: TsGroupBox;
    sLabel10: TsLabel;
    sLabel11: TsLabel;
    sLabel12: TsLabel;
    CB4: TsCheckBox;
    LB4: TsComboBox;
    boff4: TsButton;
    PB4: TsProgressBar;
    SE4: TsSpinEdit;
    bStart: TsButton;
    bStop: TsButton;
    bExit: TsButton;
    bPro: TsButton;
    sBevel1: TsBevel;
    T1: TTimer;
    T2: TTimer;
    T3: TTimer;
    T4: TTimer;
    sLabel13: TsLabel;
    RB1: TsRadioButton;
    Timer: TTimer;
    sBevel2: TsBevel;
    PIddER: TComboBox;
    HotKey1: THotKey;
    HotKey2: THotKey;
    HotKey3: THotKey;
    HotKey4: THotKey;
    procedure HotKey4Change(Sender: TObject);
    procedure HotKey3Change(Sender: TObject);
    procedure HotKey2Change(Sender: TObject);
    procedure HotKey1Change(Sender: TObject);
    procedure PIddERDropDown(Sender: TObject);
    procedure PIddERClick(Sender: TObject);
    procedure bExitClick(Sender: TObject);
    procedure bProClick(Sender: TObject);
    procedure T1Timer(Sender: TObject);
    procedure bStartClick(Sender: TObject);
    procedure TimerTimer(Sender: TObject);
    procedure boff1Click(Sender: TObject);
    procedure T2Timer(Sender: TObject);
    procedure T3Timer(Sender: TObject);
    procedure T4Timer(Sender: TObject);
    procedure bStopClick(Sender: TObject);
    procedure boff2Click(Sender: TObject);
    procedure boff3Click(Sender: TObject);
    procedure boff4Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
    Procedure WMHotkey( Var msg: TWMHotkey ); message WM_HOTKEY;
  public
    { Public declarations }
  end;

var
  FormA: TFormA;
  GameTitle: String = 'World of Warcraft';
  H: HWND = 0;
  HHH: Array of Integer;

implementation

{$R *.dfm}

procedure ShortCutToHotKey(HotKey: TShortCut; var Key : Word; var Modifiers: Uint);
var
  Shift: TShiftState;
begin
  ShortCutToKey(HotKey, Key, Shift);
  Modifiers := 0;
  if (ssShift in Shift) then
  Modifiers := Modifiers or MOD_SHIFT;
  if (ssAlt in Shift) then
  Modifiers := Modifiers or MOD_ALT;
  if (ssCtrl in Shift) then
  Modifiers := Modifiers or MOD_CONTROL;
end;

procedure ReadHot;
Var
  IniFile:TIniFile;
begin
  IniFile := TIniFile.Create(ChangeFileExt(ParamStr(0),'.ini'));
  FormA.HotKey1.HotKey :=
    IniFile.ReadInteger('√ар€ч≥ клав≥ш≥','є1',FormA.HotKey1.HotKey);
  FormA.HotKey2.HotKey :=
    IniFile.ReadInteger('√ар€ч≥ клав≥ш≥','є2',FormA.HotKey2.HotKey);
  FormA.HotKey3.HotKey :=
    IniFile.ReadInteger('√ар€ч≥ клав≥ш≥','є3',FormA.HotKey3.HotKey);
  FormA.HotKey4.HotKey :=
    IniFile.ReadInteger('√ар€ч≥ клав≥ш≥','є4',FormA.HotKey4.HotKey);
  IniFile.Free; 
end; 

procedure WriteHot;
Var
  IniFile:TIniFile;
begin
  IniFile := TIniFile.Create(ChangeFileExt(ParamStr(0),'.ini'));
  IniFile.WriteInteger('√ар€ч≥ клав≥ш≥','є1',FormA.HotKey1.HotKey);
  IniFile.WriteInteger('√ар€ч≥ клав≥ш≥','є2',FormA.HotKey2.HotKey);
  IniFile.WriteInteger('√ар€ч≥ клав≥ш≥','є3',FormA.HotKey3.HotKey);
  IniFile.WriteInteger('√ар€ч≥ клав≥ш≥','є4',FormA.HotKey4.HotKey);
  IniFile.Free;
end;

procedure EmulateKey(Wnd: HWND; VKey: Integer);
asm
   push 0
   push edx
   push 0101H //WM_KEYUP
   push eax
   push 0
   push edx
   push 0100H //WM_KEYDOWN
   push eax
   call PostMessage
   call PostMessage
end;
{procedure EmulateKey(Wnd: HWND; VKey: Integer);
asm
   push 0
   push edx
   push 0100H
   push eax
   call PostMessage
   push 0
   push edx
   push 0101H
   push eax
   call PostMessage
end;          }

Procedure HookA();
Var
//  J: DWORD;
  ContinueLoop: BOOL; 
  FSnapshotHandle: THandle; 
  FProcessEntry32: TProcessEntry32;
Begin
  ////
  SetLength(HHH,0);
  ////
  FSnapshotHandle:=CreateToolhelp32Snapshot(TH32CS_SNAPPROCESS,0);
  FProcessEntry32.dwSize:=Sizeof(FProcessEntry32);
  ContinueLoop:=Process32First(FSnapshotHandle,FProcessEntry32);
  while Integer(ContinueLoop) <> 0 do
  begin

    if FProcessEntry32.szExeFile = 'Wow.exe' then
    Begin
      SetLength(HHH,Length(HHH)+1);
      HHH[Length(HHH)-1] := FProcessEntry32.th32ProcessID;
    end;

    ContinueLoop:=Process32Next(FSnapshotHandle,FProcessEntry32); 
  end; 
  CloseHandle(FSnapshotHandle); 
end;


procedure TFormA.TimerTimer(Sender: TObject);
Var
  tH: HWND;
begin
  //oldH:=H;
  tH:=Findwindow(NIL,PChar(GameTitle));
  //If oldH = H then Exit;
  If (tH = 0) or (H = 0) then
  begin
    bStop.Click;
    GB1.Enabled:=False;
    GB2.Enabled:=False;
    GB3.Enabled:=False;
    GB4.Enabled:=False;
    bStart.Enabled:=False;
    bStop.Enabled:=False;
    RB1.Checked:=False;
  end
  else
  Begin
    GB1.Enabled:=True;
    GB2.Enabled:=True;
    GB3.Enabled:=True;
    GB4.Enabled:=True;
    bStart.Enabled:=True;
    bStop.Enabled:=True;
    RB1.Checked:=True;
  End;
end;

Procedure T1P;
Begin
  EmulateKey(H,VkKeyScan(FormA.LB1.Text[1]));
end;

Procedure T2P;
Begin
  EmulateKey(H,VkKeyScan(FormA.LB2.Text[1]));
end;

Procedure T3P;
Begin
  EmulateKey(H,VkKeyScan(FormA.LB3.Text[1]));
end;

Procedure T4P;
Begin
  EmulateKey(H,VkKeyScan(FormA.LB4.Text[1]));
end;

procedure TFormA.T1Timer(Sender: TObject);
begin
  If PB1.Position = 1 then
    PB1.Position:=0
  else
    PB1.Position:=1;
  T1P;
end;

procedure TFormA.T2Timer(Sender: TObject);
begin
  If PB2.Position = 1 then
    PB2.Position:=0
  else
    PB2.Position:=1;
  T2P;
end;

procedure TFormA.T3Timer(Sender: TObject);
begin
  If PB3.Position = 1 then
    PB3.Position:=0
  else
    PB3.Position:=1;
  T3P;
end;

procedure TFormA.T4Timer(Sender: TObject);
begin
  If PB4.Position = 1 then
    PB4.Position:=0
  else
    PB4.Position:=1;
  T4P;
end;

procedure TFormA.bStartClick(Sender: TObject);
begin
  if CB1.Checked then
  Begin
    T1.Enabled:=False;
    T1.Interval:=SE1.Value;
    T1.Enabled:=True;
  end;
  if CB2.Checked then
  Begin
    T2.Enabled:=False;
    T2.Interval:=SE2.Value;
    T2.Enabled:=True;
  end;
  if CB3.Checked then
  Begin
    T3.Enabled:=False;
    T3.Interval:=SE3.Value;
    T3.Enabled:=True;
  end;
  if CB4.Checked then
  Begin
    T4.Enabled:=False;
    T4.Interval:=SE4.Value;
    T4.Enabled:=True;
  end;
end;

procedure TFormA.bStopClick(Sender: TObject);
begin
  T1.Enabled:=False;
  T2.Enabled:=False;
  T3.Enabled:=False;
  T4.Enabled:=False;
  PB1.Position:=0;
  PB2.Position:=0;
  PB3.Position:=0;
  PB4.Position:=0;
end;

procedure TFormA.boff1Click(Sender: TObject);
begin
  T1.Enabled:=False;
  PB1.Position:=0;
end;

procedure TFormA.boff2Click(Sender: TObject);
begin
  T2.Enabled:=False;
  PB2.Position:=0;
end;

procedure TFormA.boff3Click(Sender: TObject);
begin
  T3.Enabled:=False;
  PB3.Position:=0;
end;

procedure TFormA.boff4Click(Sender: TObject);
begin
  T4.Enabled:=False;
  PB4.Position:=0;
end;

procedure TFormA.bProClick(Sender: TObject);
begin
  Application.MessageBox('ѕрограмма дл€ натисканн€ клав≥ш в гр≥ World of Warcraft'+
                          #10#13+'≈ксклюзивкна верс≥€ дл€ сог≥льд≥йц≥в'+#10#13+
                          #10#13+'√ар€ч≥ клав≥ш≥:'+#10#13+
                          '[Alt]+T - јктивац≥€ вибраних блок≥в'+#10#13+
                          '[Alt]+S - «упинка вс≥х блок≥в','≤нформац≥€');
end;

procedure TFormA.bExitClick(Sender: TObject);
begin
  FormA.Close;
end;

procedure TFormA.FormCreate(Sender: TObject);
var
  Key : Word;
  Modifiers: UINT;
begin
  ReadHot;
  If not RegisterHotkey(Handle,619,MOD_ALT,84)
  then
  Application.MessageBox('Ќе можу встановити гар€чу клав≥шу [Win]+T','ѕомилка');
  If not RegisterHotkey(Handle,629,MOD_ALT,83)
  then
  Application.MessageBox('Ќе можу встановити гар€чу клав≥шу [Win]+S','ѕомилка');
  //////
    ShortCutToHotKey(HotKey1.HotKey, Key, Modifiers);
  RegisterHotKey(Handle, 169, Modifiers, Key);
    ShortCutToHotKey(HotKey2.HotKey, Key, Modifiers);
  RegisterHotKey(Handle, 269, Modifiers, Key);
    ShortCutToHotKey(HotKey3.HotKey, Key, Modifiers);
  RegisterHotKey(Handle, 369, Modifiers, Key);
    ShortCutToHotKey(HotKey4.HotKey, Key, Modifiers);
  RegisterHotKey(Handle, 469, Modifiers, Key);
end;

procedure TFormA.HotKey1Change(Sender: TObject);
var
  Key : Word;
  Modifiers: UINT;
begin
  UnRegisterHotKey(Handle, 169);
    ShortCutToHotKey(HotKey1.HotKey, Key, Modifiers);
  RegisterHotKey(Handle, 169, Modifiers, Key);
end;

procedure TFormA.HotKey2Change(Sender: TObject);
var
  Key : Word;
  Modifiers: UINT;
begin
  UnRegisterHotKey(Handle, 269);
    ShortCutToHotKey(HotKey2.HotKey, Key, Modifiers);
  RegisterHotKey(Handle, 269, Modifiers, Key);
end;

procedure TFormA.HotKey3Change(Sender: TObject);
var
  Key : Word;
  Modifiers: UINT;
begin
  UnRegisterHotKey(Handle, 369);
    ShortCutToHotKey(HotKey3.HotKey, Key, Modifiers);
  RegisterHotKey(Handle, 369, Modifiers, Key);
end;

procedure TFormA.HotKey4Change(Sender: TObject);
var
  Key : Word;
  Modifiers: UINT;
begin
  UnRegisterHotKey(Handle, 469);
    ShortCutToHotKey(HotKey4.HotKey, Key, Modifiers);
  RegisterHotKey(Handle, 469, Modifiers, Key);
end;

procedure TFormA.PIddERClick(Sender: TObject);
var
  hWnd: DWORD;
  pid: Dword;
  dwTheardId: Dword;
  mid: Dword;
begin
  if PIddER.Items.Strings[PIddER.ItemIndex][1] = '<' then Exit;
  mid := StrToInt(PIddER.Items.Strings[PIddER.ItemIndex]);
  hWnd := GetTopWindow(0);
  //
  while hWnd <> 0 do
  begin
    dwTheardId := GetWindowThreadProcessId(hWnd, &pid);
    if pid = mid then // your process id;
    begin
      if GetParent(hWnd) = 0 then
      begin
        H := hWnd;
        break;
      end;
    end;
    hWnd := GetNextWindow(hWnd, GW_HWNDNEXT);
  end;
  
end;

procedure TFormA.PIddERDropDown(Sender: TObject);
Var
  I: integer;
begin
  HooKA();
  if Length(HHH) <= 0 then  Exit;
  
  PIddER.Items.Clear;
  for I := 0 to Length(HHH) - 1 do
  begin
    PIddER.Items.Add( IntToStr(HHH[I]) );
  end;
end;

Procedure TFormA.WMHotkey( Var msg: TWMHotkey );
Begin
   If msg.hotkey = 619 then bStart.Click;
   If msg.hotkey = 629 then bStop.Click;
   ////
   If msg.hotkey = 169 then T1P;
   If msg.hotkey = 269 then T2P;
   If msg.hotkey = 369 then T3P;
   If msg.hotkey = 469 then T4P;
End;

procedure TFormA.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  WriteHot;
  UnRegisterHotkey( Handle, 619 );
  UnRegisterHotkey( Handle, 629 );
  ////
  UnRegisterHotkey( Handle, 169 );
  UnRegisterHotkey( Handle, 269 );
  UnRegisterHotkey( Handle, 369 );
  UnRegisterHotkey( Handle, 469 );
end;

end.
