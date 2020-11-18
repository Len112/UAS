unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, StdCtrls,
  ExtDlgs;

type

  { TForm1 }

  TForm1 = class(TForm)
    ButtonLoad1: TButton;
    ButtonLoad2: TButton;
    ButtonSave: TButton;
    ButtonConvert: TButton;
    Image1: TImage;
    Image2: TImage;
    Image3: TImage;
    ImageHasil: TImage;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    LabelResult: TLabel;
    LabelImage2: TLabel;
    LabelImage1: TLabel;
    OpenPictureDialog1: TOpenPictureDialog;
    OpenPictureDialog2: TOpenPictureDialog;
    SavePictureDialog1: TSavePictureDialog;
    ScrollBox1: TScrollBox;
    procedure ButtonConvertClick(Sender: TObject);
    procedure ButtonLoad1Click(Sender: TObject);
    procedure ButtonLoad2Click(Sender: TObject);
    procedure ButtonLoad3Click(Sender: TObject);
    procedure ButtonSaveClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Grayscale();
    Procedure Biner();
    Procedure HighpassFiltering();
    Procedure DeteksiTepiDiagonalKiri();
    Procedure DeteksiTepiDiagonalKanan();
    Procedure Invers();
    Procedure AritmatikaOr();
    Procedure Dislasi();
    Procedure Erosi();
    procedure Label2Click(Sender: TObject);
    Procedure LowpassFiltering();
    Procedure AritmatikaPerkalian();
    procedure TampilkanResult();
  private

  public

  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

{ TForm1 }

uses
  windows, math;
Var
  bitmapR1,bitmapG1,bitmapB1, bitmapR2,bitmapG2,bitmapB2, bitmapR3,bitmapG3,bitmapB3 :array [0..1000,0..1000]of integer;

  bitmapGray1,bitmapGray2,bitmapGray3 : array [0..1000,0..1000] of integer;

  bitmapBiner3 : array [0..1000,0..1000] of integer;
  bitmapInvert3 : array [0..1000,0..1000] of integer;

  bitmap_LPF_1 : array [0..1000,0..1000] of integer;
  bitmap_HPF_1 : array [0..1000,0..1000] of integer;

  bitmap_TKA_2 : array [0..1000,0..1000] of integer;
  bitmap_TKB_2 : array [0..1000,0..1000] of integer;

  bitmapDislasi3 : array [0..1000,0..1000] of integer;
  bitmapErosi3: array [0..1000, 0..1000] of Integer;

  bitmapOR23 : array [0..1000, 0..1000] of Integer;
  bitmapMultply : array[0..1000, 0..1000] of integer;

procedure TForm1.FormShow(Sender: TObject);
begin
  windowstate:=wsfullscreen;
end;

procedure TForm1.ButtonLoad1Click(Sender: TObject);
var
  x,y : Integer;
begin
  if OpenPictureDialog1.Execute then
   Begin
     Image1.Picture.LoadFromFile(OpenPictureDialog1.FileName);
     for y:=1 to image1.Height do
      begin
       for x:=1 to image1.Width do
        begin
         bitmapR1[x,y] := GetRValue(image1.Canvas.Pixels[x,y]);
         bitmapG1[x,y] := GetGValue(image1.Canvas.Pixels[x,y]);
         bitmapB1[x,y] := GetBValue(image1.Canvas.Pixels[x,y]);
        end;
      end;
   end;
end;

procedure TForm1.ButtonLoad2Click(Sender: TObject);
var
  x,y : Integer;
begin
  if OpenPictureDialog2.Execute then
   Begin
     Image2.Picture.LoadFromFile(OpenPictureDialog2.FileName);
     for y:=1 to image2.Height do
      begin
       for x:=1 to image2.Width do
        begin
         bitmapR2[x,y] := GetRValue(image2.Canvas.Pixels[x,y]);
         bitmapG2[x,y] := GetGValue(image2.Canvas.Pixels[x,y]);
         bitmapB2[x,y] := GetBValue(image2.Canvas.Pixels[x,y]);
        end;
      end;
   end;
end;

procedure TForm1.ButtonLoad3Click(Sender: TObject);
var
  x,y : Integer;
begin
  if OpenPictureDialog2.Execute then
   Begin
     image3.Picture.LoadFromFile(OpenPictureDialog2.FileName);
     for y:=1 to image2.Height do
      begin
       for x:=1 to image2.Width do
        begin
         bitmapR3[x,y] := GetRValue(image3.Canvas.Pixels[x,y]);
         bitmapG3[x,y] := GetGValue(image3.Canvas.Pixels[x,y]);
         bitmapB3[x,y] := GetBValue(image3.Canvas.Pixels[x,y]);
        end;
      end;
   end;
end;

procedure TForm1.ButtonConvertClick(Sender: TObject);
begin
 If (image1.Height=image2.Height) And (image1.Width = image2.Width) And (image2.Height=image3.Height) And (image2.Width = image3.Width) then
  begin
   // Image 1
   Grayscale();
   LowpassFiltering();
   HighpassFiltering();

   // Image 2
   DeteksiTepiDiagonalKiri();
   DeteksiTepiDiagonalKanan();

   // Image 3
   Biner();
   Invers();
   Dislasi();
   Erosi();

   // 2 | 3
   AritmatikaOr();

   // 1 * ( 2 | 3 )
   AritmatikaPerkalian();

   // Tampilkan ke Result
   TampilkanResult();
  end
 else
  begin
   Showmessage('ukuran image harus sama');
  end;
end;

procedure TForm1.ButtonSaveClick(Sender: TObject);
begin
  if savepictureDialog1.Execute then
   ImageHasil.Picture.SaveToFile(SavePictureDialog1.FileName);
end;


Procedure TForm1.Grayscale();
var
  x,y :Integer;
Begin
   for y:=1 to image1.Height do
    begin
     for x:=1 to image1.Width do
      begin
       bitmapGray1[x,y] := (bitmapR1[x,y] + bitmapG1[x,y] + bitmapB1[x,y]) div 3;
       bitmapGray2[x,y] := (bitmapR2[x,y] + bitmapG2[x,y] + bitmapB2[x,y]) div 3;
       bitmapGray3[x,y] := (bitmapR3[x,y] + bitmapG3[x,y] + bitmapB3[x,y]) div 3;
      end;
    end;
end;


Procedure TForm1.Biner();
var
  x,y :Integer;
Begin
  for y:=1 to image3.Height do
  begin
    for x:=1 to image3.Width do
    begin
      if bitmapGray3[x,y] > 178 then
      begin
        bitmapBiner3[x,y] := 255;
      end
      else
      begin
        bitmapBiner3[x,y] := 0;
       end;
    end;
  end;
end;

procedure TForm1.Invers();
var
  x,y :Integer;
Begin
  for y:=1 to image3.Height do
  begin
    for x:=1 to image3.Width do
    begin
      bitmapInvert3[x,y] := 255 - bitmapBiner3[x,y];
    end;
  end;
end;

Procedure Tform1.LowpassFiltering();   //LPF
var
   xKernel, yKernel, x, y, m, n: integer;
   total: integer;
   kernel:array [-1..1,-1..1] of real = (
    (1/9.0,1/9.0,1/9.0),
    (1/9.0,1/9.0,1/9.0),
    (1/9.0,1/9.0,1/9.0)
  );
Begin
  for xKernel := 1 to Image1.Width do
  begin
    for yKernel := 1 to Image1.Height do
    begin
      total := 0;

      for m := -1 to 1 do
      begin
        for n := -1 to 1 do
        begin
          x := xKernel + m;
          y := yKernel + n;

          if x < 1 then x := 1;
          if y < 1 then y := 1;
          if x > Image1.Width then x := Image1.Width;
          if y > Image1.Height then y := Image1.Height;

          total := total + Floor(kernel[m, n] * bitmapGray1[x,y]);
        end;
      end;

      if total > 255 then total := 255;
      if total < 0   then total := 0;

      bitmap_LPF_1[xKernel, yKernel] := total;
    end;
  end;
end;

Procedure Tform1.HighpassFiltering();   //HPF 1
var
   xKernel, yKernel, x, y, m, n: integer;
   total: integer;
   kernel:array [-1..1,-1..1] of real = (
    (-1,-1,-1),
    (-1, 9,-1),
    (-1,-1,-1)
  );
Begin
  for xKernel := 1 to Image1.Width do
  begin
    for yKernel := 1 to Image1.Height do
    begin
      total := 0;

      for m := -1 to 1 do
      begin
        for n := -1 to 1 do
        begin
          x := xKernel + m;
          y := yKernel + n;

          if x < 1 then x := 1;
          if y < 1 then y := 1;
          if x > Image1.Width then x := Image1.Width;
          if y > Image1.Height then y := Image1.Height;

          total := total + Floor(kernel[m, n] * bitmap_LPF_1[x,y]);
        end;
      end;

      if total > 255 then total := 255;
      if total < 0   then total := 0;

      bitmap_HPF_1[xKernel, yKernel] := total;
    end;
  end;
end;


Procedure TForm1.DeteksiTepiDiagonalKiri();
var
   xKernel, yKernel, x, y, m, n: integer;
   total : integer;
   kernel:array [-1..1,-1..1] of real = (
    ( 2,-1,-1),
    (-1, 2,-1),
    (-1,-1, 2)
  );
Begin
  for xKernel := 1 to Image1.Width do
  begin
    for yKernel := 1 to Image1.Height do
    begin
      total := 0;

      for m := -1 to 1 do
      begin
        for n := -1 to 1 do
        begin
          x := xKernel + m;
          y := yKernel + n;

          if x < 1 then x := 1;
          if y < 1 then y := 1;
          if x > Image1.Width then x := Image1.Width;
          if y > Image1.Height then y := Image1.Height;

          total := total + Floor(kernel[m, n] * bitmapGray2[x,y]);
        end;
      end;

      if total > 255 then total := 255;
      if total < 0   then total := 0;

      bitmap_TKA_2[xKernel, yKernel] := total;
    end;
  end;
end;

Procedure TForm1.DeteksiTepiDiagonalKanan();
var
   xKernel, yKernel, x, y, m, n: integer;
   total : integer;
   kernel:array [-1..1,-1..1] of real = (
    (-1,-1, 2),
    (-1, 2,-1),
    ( 2,-1,-1)
  );
Begin
  for xKernel := 1 to Image1.Width do
  begin
    for yKernel := 1 to Image1.Height do
    begin
      total := 0;

      for m := -1 to 1 do
      begin
        for n := -1 to 1 do
        begin
          x := xKernel + m;
          y := yKernel + n;

          if x < 1 then x := 1;
          if y < 1 then y := 1;
          if x > Image1.Width then x := Image1.Width;
          if y > Image1.Height then y := Image1.Height;

          total := total + Floor(kernel[m, n] * bitmapGray2[x,y]);
        end;
      end;

      if total > 255 then total := 255;
      if total < 0   then total := 0;

      bitmap_TKB_2[xKernel, yKernel] := total;
    end;
  end;
end;

procedure TForm1.Dislasi();
var
   xKernel, yKernel, x, y, m, n: integer;
   total : integer;
Begin
  for xKernel := 1 to Image1.Width do
  begin
    for yKernel := 1 to Image1.Height do
    begin
      total := 0;

      for m := -1 to 1 do
      begin
        for n := -1 to 1 do
        begin
          x := xKernel + m;
          y := yKernel + n;

          if x < 1 then x := 1;
          if y < 1 then y := 1;
          if x > Image1.Width then x := Image1.Width;
          if y > Image1.Height then y := Image1.Height;

          total := total OR bitmapInvert3[x,y];
        end;
      end;

      bitmapDislasi3[xKernel, yKernel] := total;
    end;
  end;
end;

procedure TForm1.Erosi();
var
   xKernel, yKernel, x, y, m, n: integer;
   total : integer;
Begin
  for xKernel := 1 to Image1.Width do
  begin
    for yKernel := 1 to Image1.Height do
    begin
      total := 255;

      for m := -1 to 1 do
      begin
        for n := -1 to 1 do
        begin
          x := xKernel + m;
          y := yKernel + n;

          if x < 1 then x := 1;
          if y < 1 then y := 1;
          if x > Image1.Width then x := Image1.Width;
          if y > Image1.Height then y := Image1.Height;

          total := total AND bitmapDislasi3[x,y];
        end;
      end;

      bitmapErosi3[xKernel, yKernel] := total;
    end;
  end;
end;

procedure TForm1.Label2Click(Sender: TObject);
begin

end;

Procedure TForm1.AritmatikaOR();
Var
 x, y : integer;
Begin
  for y:=1 to image1.Height do
  begin
    for x:=1 to image1.Width do
    begin
      bitmapOR23[x][y] := bitmap_TKA_2[x][y] OR bitmap_TKB_2[x][y] OR bitmapErosi3[x][y];
    end;
  end;
end;

Procedure TForm1.AritmatikaPerkalian();
Var
 x, y : integer;
 ratio1, ratio2 : real;
 hasil: real;
Begin
  for y:=1 to image1.Height do
  begin
    for x:=1 to image1.Width do
    begin
       ratio1 := bitmap_HPF_1[x,y] / 255.0;
       ratio2 := bitmapOR23[x,y] / 255.0;

       hasil := ratio1 * ratio2;

       bitmapMultply[x,y] :=  Floor(hasil * 255);
    end;
  end;
end;

procedure TForm1.TampilkanResult();
var
  x,y : Integer;
begin
   for y:=1 to ImageHasil.Height do
   begin
     for x:=1 to ImageHasil.Width do
     begin
       ImageHasil.Canvas.Pixels[x,y] := RGB(bitmapMultply[x,y], bitmapMultply[x,y], bitmapMultply[x,y]);
     end;
   end;
end;

end.

