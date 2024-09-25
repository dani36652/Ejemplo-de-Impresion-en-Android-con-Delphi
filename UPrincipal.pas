unit UPrincipal;

interface

uses
  FMX.Memo,
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.Controls.Presentation, FMX.StdCtrls;

type
  TForm1 = class(TForm)
    Button1: TButton;
    Button2: TButton;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation
uses system.IOUtils,UImpresion;

{$R *.fmx}

procedure TForm1.Button1Click(Sender: TObject);
begin
 if VerificarSePuedeImprimir then
  begin
    ImprimirHTML(TPath.GetDocumentsPath+PathDelim+'Ticket.html', 'Impresion1');
    Self.Invalidate;
  end else ShowMessage('No es posible imprimir');
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
  if VerificarSePuedeImprimir then
  begin
    ImprimirImagen(TPath.GetDocumentsPath+PathDelim+'imagen.png','Impresion imagen');
    Self.Invalidate;
  end else ShowMessage('No es posible imprimir');
end;

end.
