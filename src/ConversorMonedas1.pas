//~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~
//
// Unidad: ConversorMonedas1.pas
//
// Propósito:
//    Un pequeño componente de conversión de divisas.
//
//
// Autor:          José Manuel Navarro (www.lawebdejm.com)
//
// Fecha:          01/02/2004
//
// Observaciones:  Unidad creada en Delphi 5 para la revista Todo Programación, editada por
//                 Studio Press, S.L. (www.iberprensa.com)
//
// Copyright:      Este código es de dominio público y se puede utilizar y/o mejorar siempre que
//                 SE HAGA REFERENCIA AL AUTOR ORIGINAL, ya sea a través de estos comentarios
//                 o de cualquier otro modo.
//
//~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~
unit ConversorMonedas1;

interface

uses classes;

type
	TTipoMoneda = (tmEuro, tmDolar, tmYen,	tmPeseta);

	TConversorMonedas = class(TComponent)
	private
		FValorConvertir:  Currency;
		FValorConvertido: Currency;

		FMonedaConvertir:  TTipoMoneda;
		FMonedaConvertido: TTipoMoneda;

	protected
		procedure SetValorConvertir(value: Currency);
		procedure SetMonedaConvertir(value: TTipoMoneda);
		procedure SetMonedaConvertido(value: TTipoMoneda);

	public
		constructor Create(AOwner: TComponent); override;

		procedure Convertir();

	published
		property ValorConvertir:  Currency read FValorConvertir write SetValorConvertir;
		property ValorConvertido: Currency read FValorConvertido;

		property MonedaConvertir:  TTipoMoneda read FMonedaConvertir  write SetMonedaConvertir;
		property MonedaConvertido: TTipoMoneda read FMonedaConvertido write SetMonedaConvertido;
	end;


procedure Register;


implementation


procedure Register;
begin
	RegisterComponents('La web de JM', [TConversorMonedas]);
end;


constructor TConversorMonedas.Create(AOwner: TComponent);
begin
	inherited;

	FValorConvertir := 1;
	FMonedaConvertido := tmPeseta;

	Convertir;
end;


procedure TConversorMonedas.Convertir();
const
	// factores de conversión falsos
	FACTOR_EURO: array[TTipoMoneda] of Currency = (
			1,
			2,
			0.5,
			166.386
	);
var
	aux: Currency;
begin
	// se calcula utilizando el euro como referencia.
	aux := FValorConvertir / FACTOR_EURO[FMonedaConvertir];

	// ahora aux contiene el valor origen en euros. Se pasa a la moneda destino
	aux := aux * FACTOR_EURO[FMonedaConvertido];

	FValorConvertido := aux;
end;


procedure TConversorMonedas.SetValorConvertir(value: Currency);
begin
	if FValorConvertir <> value then
	begin
		FValorConvertir := value;
		Convertir;
	end;
end;


procedure TConversorMonedas.SetMonedaConvertir(value: TTipoMoneda);
begin
	if FMonedaConvertir <> value then
	begin
		FMonedaConvertir := value;
		Convertir;
	end;
end;


procedure TConversorMonedas.SetMonedaConvertido(value: TTipoMoneda);
begin
	if FMonedaConvertido <> value then
	begin
		FMonedaConvertido := value;
		Convertir;
	end;
end;


end.


