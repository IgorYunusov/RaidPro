program Project1;

uses
  Forms,
  Unit1 in 'Unit1.pas' {FormA};

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'Професійний рейд';
  Application.CreateForm(TFormA, FormA);
  Application.Run;
end.
