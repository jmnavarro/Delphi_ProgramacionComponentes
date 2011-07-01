//~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~
//
// Unidad: TableroAjedrez.pas
//
// Propósito:
//    Un componente gráfico que muestra un tablero de ajedrez con ciertos datos (como colores
//    y bordes) configurables.
//
//
// Autor:          José Manuel Navarro (www.lawebdejm.com)
//
// Fecha:          01/06/2004
//
// Observaciones:  Unidad creada en Delphi 5 para la revista Todo Programación, editada por
//                 Studio Press, S.L. (www.iberprensa.com)
//
// Copyright:      Este código es de dominio público y se puede utilizar y/o mejorar siempre que
//                 SE HAGA REFERENCIA AL AUTOR ORIGINAL, ya sea a través de estos comentarios
//                 o de cualquier otro modo.
//
//~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~
unit TableroAjedrez;

interface

uses Controls, Graphics, Classes;

type
	TTablero = class;


	TColoresCasillas = class(TPersistent)
	private
		FTablero: TTablero;

		FCasillasBlancas: TColor;
		FCasillasNegras: TColor;

		procedure SetCasillasBlancas(value: TColor);
		procedure SetCasillasNegras(value: TColor);

	public
		constructor Create(tablero: TTablero);

	published
		property CasillasBlancas: TColor read FCasillasBlancas write SetCasillasBlancas default clWhite;
		property CasillasNegras:  TColor read FCasillasNegras  write SetCasillasNegras  default clBlack;
	end;



	TBordeTablero = class(TPersistent)
	private
		FTablero: TTablero;

		FMostrar: boolean;
		FColor: TColor;

		procedure SetMostrar(value: boolean);
		procedure SetColor(value: TColor);

	public
		constructor Create(tablero: TTablero);

	published
		property Mostrar: boolean read FMostrar write SetMostrar default true;
		property Color: TColor read FColor write SetColor default clBlack;
	end;



	TTablero = class(TGraphicControl)
	private
		FColores: TColoresCasillas;
		FBorde: TBordeTablero;

	protected
		procedure Limpiar(color: TColor);
		procedure DibujarTablero(filas, columnas: integer; color1, color2: TColor);
		procedure DibujarBorde(color: TColor);

		function CanResize(var NewWidth, NewHeight: Integer): Boolean; override;
		procedure Paint; override;

	public
		constructor Create(AOwner: TComponent); override;
		destructor Destroy; override;

	published
		property Colores: TColoresCasillas read FColores;
		property Borde: TBordeTablero read FBorde;

		// propiedades heradadas
		property Align;
		property Anchors;
	end;


procedure Register;


implementation

uses windows;


const
	CASILLAS_X = 8;
	CASILLAS_Y = 8;


procedure Register;
begin
	RegisterComponents('La web de JM', [TTablero]);
end;


{ TColoresCasillas }

constructor TColoresCasillas.Create(tablero: TTablero);
begin
	inherited Create;

	FTablero := tablero;

	FCasillasBlancas := clWhite;
	FCasillasNegras  := clBlack;
end;


procedure TColoresCasillas.SetCasillasBlancas(value: TColor);
begin
	if value <> FCasillasBlancas then
	begin
		FCasillasBlancas := value;
		FTablero.Invalidate;
	end;
end;


procedure TColoresCasillas.SetCasillasNegras(value: TColor);
begin
	if value <> FCasillasNegras then
	begin
		FCasillasNegras := value;
		FTablero.Invalidate;
	end;
end;



{ TBordeTablero }
constructor TBordeTablero.Create(tablero: TTablero);
begin
	inherited Create;

	FTablero := tablero;

	FMostrar := true;
	FColor   := clBlack;
end;

procedure TBordeTablero.SetMostrar(value: boolean);
begin
	if value <> FMostrar then
	begin
		FMostrar := value;

		if FMostrar then
			FTablero.DibujarBorde(FColor) // sólo se dibuja el borde
		else
			FTablero.Invalidate; // se dibuja todo
	end;
end;

procedure TBordeTablero.SetColor(value: TColor);
begin
	if value <> FColor then
	begin
		FColor := value;
		if FMostrar then
			FTablero.DibujarBorde(FColor); // sólo se dibuja el borde
	end;
end;




{ TTablero }

constructor TTablero.Create(AOwner: TComponent);
begin
	inherited;

	Height := 100;
	Width  := 100;

	FColores := TColoresCasillas.Create(Self);
	FBorde   := TBordeTablero.Create(Self);
end;


destructor TTablero.Destroy;
begin
	FBorde.Free;
	FColores.Free;

	inherited;
end;


function TTablero.CanResize(var NewWidth, NewHeight: Integer): Boolean;
begin
	result := inherited CanResize(NewWidth, NewHeight);

	if result then
	begin
		if NewWidth < CASILLAS_X then
			NewWidth := CASILLAS_X;

		if NewHeight < CASILLAS_Y then
			NewHeight := CASILLAS_Y;
	end;
end;


procedure TTablero.Paint;
begin
	DibujarTablero(CASILLAS_Y, CASILLAS_X, FColores.CasillasNegras, FColores.CasillasBlancas);
	if FBorde.Mostrar then
		DibujarBorde(FBorde.Color);
end;


procedure TTablero.Limpiar(color: TColor);
begin
	Canvas.Brush.Color := color;
	Canvas.Brush.Style := bsSolid;
	Canvas.FillRect(Rect(0, 0, Width, Height));
end;


procedure TTablero.DibujarBorde(color: TColor);
begin
	Canvas.Pen.Color := color;
	Canvas.Pen.Style := psSolid;
	Canvas.Brush.Style := bsClear;
	Canvas.Rectangle(0, 0, Width, Height);
end;


procedure TTablero.DibujarTablero(filas, columnas: integer; color1, color2: TColor);
var
	ancho, alto, i, j, x, y: integer;
	margenX, margenY, margenAcumX, margenAcumY: integer;
	sobraX, sobraY: integer;
	filaPar, columnaPar: boolean;
begin
	Canvas.Brush.Style := bsSolid;

	ancho := Width  div columnas;
	alto  := Height div filas;

	sobraX := Width mod columnas;
	margenX := 1;
	margenAcumX := 0;

	for i:=1 to columnas do
	begin
		columnaPar := (i mod 2 = 0);

		if sobraX = 0 then
			margenX := 0;

		x := (i-1) * ancho + margenX + margenAcumX;

		sobraY  := Height mod filas;
		margenY := 1;
		margenAcumY := 0;

		for j:=1 to filas do
		begin
			filaPar := (j mod 2 = 0);

			if (filaPar and columnaPar) or (not filaPar and not columnaPar) then
				Canvas.Brush.Color := color2
			else
				Canvas.Brush.Color := color1;

			if sobraY = 0 then
				margenY := 0;

			y := (j-1) * alto + margenY + margenAcumY;

			Canvas.FillRect(Rect(x, y, ancho + margenX + x, alto + margenY + y));

			if sobraY > 0 then
				Dec(sobraY);
			Inc(margenAcumY, margenY);
		end;

		Inc(margenAcumX, margenX);
		if sobraX > 0 then
			Dec(sobraX);
	end;
end;



end.