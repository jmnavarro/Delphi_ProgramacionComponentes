//~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~
//
// Unidad: ComponenteCombinado.pas
//
// Propósito:
//    Un pequeño componente combinado de ejemplo.
//
//
// Autor:          José Manuel Navarro (www.lawebdejm.com)
//
// Fecha:          01/05/2004
//
// Observaciones:  Unidad creada en Delphi 5 para la revista Todo Programación, editada por
//                 Studio Press, S.L. (www.iberprensa.com)
//
// Copyright:      Este código es de dominio público y se puede utilizar y/o mejorar siempre que
//                 SE HAGA REFERENCIA AL AUTOR ORIGINAL, ya sea a través de estos comentarios
//                 o de cualquier otro modo.
//
//~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~
unit ComponenteCombinado;

interface

uses Controls, StdCtrls, Classes;

type
	TComponenteCombinado = class(TCustomControl)
	private
		FLabel: TLabel;
		FBoton: TButton;
		FCampo: TEdit;

		procedure OnBotonClick(Sender: TObject);

	public
		constructor Create(AOwner: TComponent); override;

	end;


procedure Register;


implementation

uses Dialogs;


procedure Register;
begin
	RegisterComponents('La web de JM', [TComponenteCombinado]);
end;



constructor TComponenteCombinado.Create(AOwner: TComponent);
begin
	inherited;

	Width := 200;
	Height := 100;

	FLabel := TLabel.Create(Self);
	FLabel.SetBounds(0, 4, 30, 13);
	FLabel.Caption := 'Texto: ';
	FLabel.Visible := true;
	FLabel.Parent := Self;

	FBoton := TButton.Create(Self);
	FBoton.SetBounds(83, 27, 75, 20);
	FBoton.Caption := 'Haz clic!';
	FBoton.Visible := true;
	FBoton.Parent := Self;
	FBoton.OnClick := OnBotonClick;

	FCampo := TEdit.Create(Self);
	FCampo.SetBounds(37, 0, 121, 21);
	FCampo.Text := 'el valor';
	FCampo.Visible := true;
	FCampo.Parent := Self;
end;


procedure TComponenteCombinado.OnBotonClick(Sender: TObject);
begin
	ShowMessage('El valor del campo de edición es "' + FCampo.Text + '".');
end;


end.