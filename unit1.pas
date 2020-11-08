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
    procedure ButtonSaveClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Grayscale();
    Procedure Biner();
    Procedure HighpassFiltering();
    Procedure DeteksiTepiKanan();
    Procedure DeteksiTepiKiri();
    Procedure Invers();
    Procedure AritmatikaOr();
    Procedure Closing();
    Procedure LowpassFiltering();
    Procedure AritmatikaPerkalian();
  private

  public

  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

{ TForm1 }

uses
  windows;
Var
  bitmapR1,bitmapG1,bitmapB1,bitmapR2,bitmapG2,bitmapB2,bitmapR3, bitmapG3, bitmapB3 :array [0..1000,0..1000]of integer;
  bitmapGray1,bitmapGray2 : array [0..1000,0..1000] of integer;
  bitmapRHPF1,bitmapGHPF1,bitmapBHPF1,bitmapRHPF2,bitmapGHPF2,bitmapBHPF2,bitmapGrayHPF1,bitmapGrayHPF2 :array [0..1000,0..1000]of integer;
  bitmapRLPF1,bitmapGLPF1,bitmapBLPF1,bitmapRLPF2,bitmapGLPF2,bitmapBLPF2,bitmapGrayLPF1,bitmapGrayLPF2 :array [0..1000,0..1000]of integer;
  bitmapRDilasi1, bitmapGDilasi1, bitmapBDilasi1,bitmapRDilasi2, bitmapGDilasi2, bitmapBDilasi2: array [0..1000, 0..1000] of Integer;
  bitmapRErosi1, bitmapGErosi1, bitmapBErosi1,bitmapRErosi2, bitmapGErosi2, bitmapBErosi2: array [0..1000, 0..1000] of Integer;
  bitmapRDki1,bitmapGDki1,bitmapBDki1,bitmapRDki2,bitmapGDki2,bitmapBDki2,bitmapGrayDki1,bitmapGrayDki2 :array [0..1000,0..1000]of integer;
  bitmapRDka1,bitmapGDka1,bitmapBDka1,bitmapRDka2,bitmapGDka2,bitmapBDka2,bitmapGrayDka1,bitmapGrayDka2 :array [0..1000,0..1000]of integer;
  bitmapRInvers1,bitmapGInvers1,bitmapBInvers1,bitmapRInvers2,bitmapGInvers2,bitmapBInvers2,bitmapGrayInvers2,bitmapGrayInvers1 :array [0..1000,0..1000]of integer;


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

procedure TForm1.ButtonConvertClick(Sender: TObject);
begin
 If (image1.Height=image2.Height) And (image1.Width = image2.Width) then
  begin
   Grayscale();
   Biner();
   //HighPassFiltering();
   //LowpassFiltering();
   //DeteksiTepiKanan();
   //DeteksiTepiKiri();
   //Invers();
   //AritmatikaOr();
   //AritmatikaPerkalian();
   //Closing();
  end
 else
  begin
   Showmessage('ukuran image harus sama');
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

procedure TForm1.ButtonSaveClick(Sender: TObject);
begin
  if savepictureDialog1.Execute then
   image3.Picture.SaveToFile(SavePictureDialog1.FileName);
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
      end;
    end;
   {for y:=1 to image1.Height do
    begin
     for x:=1 to image1.Width do
      begin
       image1.Canvas.Pixels[x,y]:=RGB(bitmapGray1[x,y],bitmapGray1[x,y],bitmapGray1[x,y]);
       image2.Canvas.Pixels[x,y]:=RGB(bitmapGray2[x,y],bitmapGray2[x,y],bitmapGray2[x,y]);
      end;
    end;}
end;
Procedure TForm1.Biner();
var
  x,y :Integer;
  bitmapBiner1,bitmapBiner2 : array [1..1000,1..1000] of boolean;
Begin
   for y:=1 to image1.Height do
    begin
     for x:=1 to image1.Width do
      begin
       if bitmapGray1[x,y] > 127 then bitmapBiner1[x,y] := true else bitmapBiner1[x,y]:=false;
        if bitmapBiner1[x,y] = FALSE then
         begin
          bitmapR1[x,y] := 255;
          bitmapG1[x,y] := 255;
          bitmapB1[x,y] := 255;
         end
         else
         begin
          bitmapR1[x,y] := 0;
          bitmapG1[x,y] := 0;
          bitmapB1[x,y] := 0;
         end;
       if bitmapGray2[x,y] > 127 then bitmapBiner2[x,y] := true else bitmapBiner2[x,y]:=false;
        if bitmapBiner2[x,y] = FALSE then
         begin
          bitmapR2[x,y] := 255;
          bitmapG2[x,y] := 255;
          bitmapB2[x,y] := 255;
         end
         else
         begin
          bitmapR2[x,y] := 0;
          bitmapG2[x,y] := 0;
          bitmapB2[x,y] := 0;
         end;
      end;
    end;
   for y:=1 to image1.Height do
    begin
     for x:=1 to image1.Width do
      begin
       image1.Canvas.Pixels[x,y]:=RGB(bitmapR1[x,y],bitmapG1[x,y],bitmapB1[x,y]);
       image2.Canvas.Pixels[x,y]:=RGB(bitmapR2[x,y],bitmapG2[x,y],bitmapB2[x,y]);
      end;
    end;
end;
Procedure Tform1.HighpassFiltering();   //HPF 0
var
   x,y,m,n,totalr1,totalg1,totalb1,lokalx,lokaly,totalr2,totalg2,totalb2,totalgray1,totalgray2: integer;
   kernel:array [1..3,1..3] of real = (
    (-1,-1,-1),
    (-1,8,-1),
    (-1,-1,-1)
  );
Begin
  for x:=1 to image1.Width do
   begin
    //1
    bitmapR1[x,0]:= bitmapR1[x,1];
    bitmapG1[x,0]:= bitmapG1[x,1];
    bitmapB1[x,0]:= bitmapB1[x,1];
    bitmapR1[x,image1.Height+1]:=bitmapR1[x,image1.Height];
    bitmapG1[x,image1.Height+1]:=bitmapG1[x,image1.Height];
    bitmapB1[x,image1.Height+1]:=bitmapB1[x,image1.Height];

    bitmapGray1[x,0]:=bitmapGray1[x,1];
    bitmapGray1[x,image1.Height+1]:=bitmapGray1[x,image1.Height];
    //2
    bitmapR2[x,0]:= bitmapR2[x,1];
    bitmapG2[x,0]:= bitmapG2[x,1];
    bitmapB2[x,0]:= bitmapB2[x,1];
    bitmapR2[x,image2.Height+1]:=bitmapR2[x,image2.Height];
    bitmapG2[x,image2.Height+1]:=bitmapG2[x,image2.Height];
    bitmapB2[x,image2.Height+1]:=bitmapB2[x,image2.Height];

    bitmapGray2[x,0]:=bitmapGray2[x,1];
    bitmapGray2[x,image2.Height+1]:=bitmapGray2[x,image2.Height];
   end;
    for y:=0 to image1.Height do
     begin
      //1
      bitmapR1[0,y]:= bitmapR1[1,y];
      bitmapG1[0,y]:= bitmapG1[1,y];
      bitmapB1[0,y]:= bitmapB1[1,y];
      bitmapR1[image1.Width+1,y]:=bitmapR1[image1.Width,y+1];
      bitmapG1[image1.Width+1,y]:=bitmapG1[image1.Width,y+1];
      bitmapB1[image1.Width+1,y]:=bitmapB1[image1.Width,y+1];

      bitmapGray1[0,y]:=bitmapGray1[1,y];
      bitmapGray1[image1.Width+1,y]:=bitmapGray1[image1.Width+1,y+1];

      //2
      bitmapR2[0,y]:= bitmapR2[1,y];
      bitmapG2[0,y]:= bitmapG2[1,y];
      bitmapB2[0,y]:= bitmapB2[1,y];
      bitmapR2[image2.Width+1,y]:=bitmapR2[image2.Width,y+1];
      bitmapG2[image2.Width+1,y]:=bitmapG2[image2.Width,y+1];
      bitmapB2[image2.Width+1,y]:=bitmapB2[image2.Width,y+1];

      bitmapGray2[0,y]:=bitmapGray2[1,y];
      bitmapGray2[image2.Width+1,y]:=bitmapGray2[image2.Width,y+1];

     end;
     for y:=1 to image1.Height do
      begin
       for x:=1 to image1.Width do
        begin
          totalr1:=0;
          totalg1:=0;
          totalb1:=0;
          totalr2:=0;
          totalg2:=0;
          totalb2:=0;
          totalgray1:=0;
          totalgray2:=0;
          for m:=1 to 3 do
           begin
            for n:=1 to 3 do
             begin
               lokalx:=x+n-2;
               lokaly:=y+m-2;
               totalr1:=totalr1+round(bitmapR1[lokalx,lokaly]*kernel[m][n]);
               totalg1:=totalg1+round(bitmapG1[lokalx,lokaly]*kernel[m][n]);
               totalb1:=totalb1+round(bitmapB1[lokalx,lokaly]*kernel[m][n]);
               totalr2:=totalr2+round(bitmapR2[lokalx,lokaly]*kernel[m][n]);
               totalg2:=totalg2+round(bitmapG2[lokalx,lokaly]*kernel[m][n]);
               totalb2:=totalb2+round(bitmapB2[lokalx,lokaly]*kernel[m][n]);
               totalgray1:=totalgray1+round(bitmapgray1[lokalx,lokaly]*kernel[m][n]);
               totalgray2:=totalgray2+round(bitmapgray2[lokalx,lokaly]*kernel[m][n]);
             end;
           end;
          bitmapRHPF1[x,y]:=totalr1;
          bitmapGHPF1[x,y]:=totalg1;
          bitmapBHPF1[x,y]:=totalb1;

          bitmapRHPF2[x,y]:=totalr2;
          bitmapGHPF2[x,y]:=totalg2;
          bitmapBHPF2[x,y]:=totalb2;

          bitmapGrayHPF1[x,y]:=totalgray1;
          bitmapGrayHPF2[x,y]:=totalgray2;

          if  bitmapRHPF1[x,y]<0 then  bitmapRHPF1[x,y]:=0;
          if  bitmapRHPF1[x,y]>255 then  bitmapRHPF1[x,y]:=255;
          if  bitmapGHPF1[x,y]<0 then  bitmapGHPF1[x,y]:=0;
          if  bitmapGHPF1[x,y]>255 then  bitmapGHPF1[x,y]:=255;
          if  bitmapBHPF1[x,y]<0 then  bitmapBHPF1[x,y]:=0;
          if  bitmapBHPF1[x,y]>255 then  bitmapBHPF1[x,y]:=255;

          if  bitmapRHPF2[x,y]<0 then  bitmapRHPF2[x,y]:=0;
          if  bitmapRHPF2[x,y]>255 then  bitmapRHPF2[x,y]:=255;
          if  bitmapGHPF2[x,y]<0 then  bitmapGHPF2[x,y]:=0;
          if  bitmapGHPF2[x,y]>255 then  bitmapGHPF2[x,y]:=255;
          if  bitmapBHPF2[x,y]<0 then  bitmapBHPF2[x,y]:=0;
          if  bitmapBHPF2[x,y]>255 then  bitmapBHPF2[x,y]:=255;

          if  bitmapGrayHPF1[x,y]<0 then  bitmapGrayHPF1[x,y]:=0;
          if  bitmapGrayHPF1[x,y]>255 then  bitmapGrayHPF1[x,y]:=255;

          if  bitmapGrayHPF2[x,y]<0 then  bitmapGrayHPF2[x,y]:=0;
          if  bitmapGrayHPF2[x,y]>255 then  bitmapGrayHPF2[x,y]:=255;
      end;
      end;
    for y:=1 to image1.Height do
    begin
     for x:=1 to image1.Width do
      begin
       image1.Canvas.Pixels[x,y]:=RGB(bitmapRHPF1[x,y],bitmapGHPF1[x,y],bitmapBHPF1[x,y]);
       image2.Canvas.Pixels[x,y]:=RGB(bitmapGrayHPF2[x,y],bitmapGrayHPF2[x,y],bitmapGrayHPF2[x,y]);
      end;
    end;
end;
Procedure Tform1.LowpassFiltering();   //LPF
var
   x,y,m,n,totalr1,totalg1,totalb1,lokalx,lokaly,totalr2,totalg2,totalb2,totalgray1,totalgray2: integer;
   kernel:array [1..3,1..3] of real = (
    (1/9.0,1/9.0,1/9.0),
    (1/9.0,1/9.0,1/9.0),
    (1/9.0,1/9.0,1/9.0)
  );
Begin
  for x:=1 to image1.Width do
   begin
    //1
    bitmapR1[x,0]:= bitmapR1[x,1];
    bitmapG1[x,0]:= bitmapG1[x,1];
    bitmapB1[x,0]:= bitmapB1[x,1];
    bitmapR1[x,image1.Height+1]:=bitmapR1[x,image1.Height];
    bitmapG1[x,image1.Height+1]:=bitmapG1[x,image1.Height];
    bitmapB1[x,image1.Height+1]:=bitmapB1[x,image1.Height];

    bitmapGray1[x,0]:=bitmapGray1[x,1];
    bitmapGray1[x,image1.Height+1]:=bitmapGray1[x,image1.Height];
    //2
    bitmapR2[x,0]:= bitmapR2[x,1];
    bitmapG2[x,0]:= bitmapG2[x,1];
    bitmapB2[x,0]:= bitmapB2[x,1];
    bitmapR2[x,image2.Height+1]:=bitmapR2[x,image2.Height];
    bitmapG2[x,image2.Height+1]:=bitmapG2[x,image2.Height];
    bitmapB2[x,image2.Height+1]:=bitmapB2[x,image2.Height];

    bitmapGray2[x,0]:=bitmapGray2[x,1];
    bitmapGray2[x,image2.Height+1]:=bitmapGray2[x,image2.Height];
   end;
    for y:=0 to image1.Height do
     begin
      //1
      bitmapR1[0,y]:= bitmapR1[1,y];
      bitmapG1[0,y]:= bitmapG1[1,y];
      bitmapB1[0,y]:= bitmapB1[1,y];
      bitmapR1[image1.Width+1,y]:=bitmapR1[image1.Width,y+1];
      bitmapG1[image1.Width+1,y]:=bitmapG1[image1.Width,y+1];
      bitmapB1[image1.Width+1,y]:=bitmapB1[image1.Width,y+1];

      bitmapGray1[0,y]:=bitmapGray1[1,y];
      bitmapGray1[image1.Width+1,y]:=bitmapGray1[image1.Width+1,y+1];

      //2
      bitmapR2[0,y]:= bitmapR2[1,y];
      bitmapG2[0,y]:= bitmapG2[1,y];
      bitmapB2[0,y]:= bitmapB2[1,y];
      bitmapR2[image2.Width+1,y]:=bitmapR2[image2.Width,y+1];
      bitmapG2[image2.Width+1,y]:=bitmapG2[image2.Width,y+1];
      bitmapB2[image2.Width+1,y]:=bitmapB2[image2.Width,y+1];

      bitmapGray2[0,y]:=bitmapGray2[1,y];
      bitmapGray2[image2.Width+1,y]:=bitmapGray2[image2.Width,y+1];

     end;
     for y:=1 to image1.Height do
      begin
       for x:=1 to image1.Width do
        begin
          totalr1:=0;
          totalg1:=0;
          totalb1:=0;
          totalr2:=0;
          totalg2:=0;
          totalb2:=0;
          totalgray1:=0;
          totalgray2:=0;
          for m:=1 to 3 do
           begin
            for n:=1 to 3 do
             begin
               lokalx:=x+n-2;
               lokaly:=y+m-2;
               totalr1:=totalr1+round(bitmapR1[lokalx,lokaly]*kernel[m][n]);
               totalg1:=totalg1+round(bitmapG1[lokalx,lokaly]*kernel[m][n]);
               totalb1:=totalb1+round(bitmapB1[lokalx,lokaly]*kernel[m][n]);
               totalr2:=totalr2+round(bitmapR2[lokalx,lokaly]*kernel[m][n]);
               totalg2:=totalg2+round(bitmapG2[lokalx,lokaly]*kernel[m][n]);
               totalb2:=totalb2+round(bitmapB2[lokalx,lokaly]*kernel[m][n]);
               totalgray1:=totalgray1+round(bitmapgray1[lokalx,lokaly]*kernel[m][n]);
               totalgray2:=totalgray2+round(bitmapgray2[lokalx,lokaly]*kernel[m][n]);
             end;
           end;
          bitmapRLPF1[x,y]:=totalr1;
          bitmapGLPF1[x,y]:=totalg1;
          bitmapBLPF1[x,y]:=totalb1;

          bitmapRLPF2[x,y]:=totalr2;
          bitmapGLPF2[x,y]:=totalg2;
          bitmapBLPF2[x,y]:=totalb2;

          bitmapGrayLPF1[x,y]:=totalgray1;
          bitmapGrayLPF2[x,y]:=totalgray2;

          if  bitmapRLPF1[x,y]<0 then  bitmapRLPF1[x,y]:=0;
          if  bitmapRLPF1[x,y]>255 then  bitmapRLPF1[x,y]:=255;
          if  bitmapGLPF1[x,y]<0 then  bitmapGLPF1[x,y]:=0;
          if  bitmapGLPF1[x,y]>255 then  bitmapGLPF1[x,y]:=255;
          if  bitmapBLPF1[x,y]<0 then  bitmapBLPF1[x,y]:=0;
          if  bitmapBLPF1[x,y]>255 then  bitmapBLPF1[x,y]:=255;

          if  bitmapRLPF2[x,y]<0 then  bitmapRLPF2[x,y]:=0;
          if  bitmapRLPF2[x,y]>255 then  bitmapRLPF2[x,y]:=255;
          if  bitmapGLPF2[x,y]<0 then  bitmapGLPF2[x,y]:=0;
          if  bitmapGLPF2[x,y]>255 then  bitmapGLPF2[x,y]:=255;
          if  bitmapBLPF2[x,y]<0 then  bitmapBLPF2[x,y]:=0;
          if  bitmapBLPF2[x,y]>255 then  bitmapBLPF2[x,y]:=255;

          if  bitmapGrayLPF1[x,y]<0 then  bitmapGrayLPF1[x,y]:=0;
          if  bitmapGrayLPF1[x,y]>255 then  bitmapGrayLPF1[x,y]:=255;

          if  bitmapGrayLPF2[x,y]<0 then  bitmapGrayLPF2[x,y]:=0;
          if  bitmapGrayLPF2[x,y]>255 then  bitmapGrayLPF2[x,y]:=255;
      end;
      end;
    for y:=1 to image1.Height do
    begin
     for x:=1 to image1.Width do
      begin
       image1.Canvas.Pixels[x,y]:=RGB(bitmapRLPF1[x,y],bitmapGLPF1[x,y],bitmapBLPF1[x,y]);
       image2.Canvas.Pixels[x,y]:=RGB(bitmapGrayLPF2[x,y],bitmapGrayLPF2[x,y],bitmapGrayLPF2[x,y]);
      end;
    end;
end;
Procedure TForm1.DeteksiTepiKanan();
var
kernelDKa:array [1..3,1..3] of real = (
 (-1,-1,2),
 (-1,2,-1),
 (2,-1,-1)
);
x,y,m,n,totalr2,totalg2,totalb2,lokalx,lokaly,totalr1,totalg1,totalb1,totalgray1,totalgray2 : integer;
Begin
 for x:=1 to image1.Width do
   begin
    //1
    bitmapR1[x,0]:= bitmapR1[x,1];
    bitmapG1[x,0]:= bitmapG1[x,1];
    bitmapB1[x,0]:= bitmapB1[x,1];
    bitmapR1[x,image1.Height+1]:=bitmapR1[x,image1.Height];
    bitmapG1[x,image1.Height+1]:=bitmapG1[x,image1.Height];
    bitmapB1[x,image1.Height+1]:=bitmapB1[x,image1.Height];

    bitmapGray1[x,0]:=bitmapGray1[x,1];
    bitmapGray1[x,image1.Height+1]:=bitmapGray1[x,image1.Height];
    //2
    bitmapR2[x,0]:= bitmapR2[x,1];
    bitmapG2[x,0]:= bitmapG2[x,1];
    bitmapB2[x,0]:= bitmapB2[x,1];
    bitmapR2[x,image2.Height+1]:=bitmapR2[x,image2.Height];
    bitmapG2[x,image2.Height+1]:=bitmapG2[x,image2.Height];
    bitmapB2[x,image2.Height+1]:=bitmapB2[x,image2.Height];

    bitmapGray2[x,0]:=bitmapGray2[x,1];
    bitmapGray2[x,image2.Height+1]:=bitmapGray2[x,image2.Height];
   end;
    for y:=0 to image1.Height do
     begin
      //1
      bitmapG1[0,y]:= bitmapR1[1,y];
      bitmapG1[0,y]:= bitmapG1[1,y];
      bitmapB1[0,y]:= bitmapB1[1,y];
      bitmapR1[image1.Width+1,y]:=bitmapR1[image1.Width,y+1];
      bitmapG1[image1.Width+1,y]:=bitmapG1[image1.Width,y+1];
      bitmapB1[image1.Width+1,y]:=bitmapB1[image1.Width,y+1];

      bitmapGray1[0,y]:=bitmapGray1[1,y];
      bitmapGray1[image1.Width+1,y]:=bitmapGray1[image1.Width,y+1];
      //2
      bitmapR2[0,y]:= bitmapR2[1,y];
      bitmapG2[0,y]:= bitmapG2[1,y];
      bitmapB2[0,y]:= bitmapB2[1,y];
      bitmapR2[image2.Width+1,y]:=bitmapR2[image2.Width,y+1];
      bitmapG2[image2.Width+1,y]:=bitmapG2[image2.Width,y+1];
      bitmapB2[image2.Width+1,y]:=bitmapB2[image2.Width,y+1];

      bitmapGray2[0,y]:=bitmapGray2[1,y];
      bitmapGray2[image2.Width+1,y]:=bitmapGray2[image2.Width,y+1];

     end;

     for y:=1 to image1.Height do
      begin
       for x:=1 to image1.Width do
        begin
          totalr1:=0;
          totalg1:=0;
          totalb1:=0;
          totalr2:=0;
          totalg2:=0;
          totalb2:=0;
          totalgray1:=0;
          totalgray2:=0;
          for m:=1 to 3 do
           begin
            for n:=1 to 3 do
             begin
               lokalx:=x+n-2;
               lokaly:=y+m-2;
               totalr1:=totalr1+round(bitmapR1[lokalx,lokaly]*kerneldka[4-m][4-n]);
               totalg1:=totalg1+round(bitmapG1[lokalx,lokaly]*kerneldka[4-m][4-n]);
               totalb1:=totalb1+round(bitmapB1[lokalx,lokaly]*kerneldka[4-m][4-n]);

               totalr2:=totalr2+round(bitmapR2[lokalx,lokaly]*kerneldka[4-m][4-n]);
               totalg2:=totalg2+round(bitmapG2[lokalx,lokaly]*kerneldka[4-m][4-n]);
               totalb2:=totalb2+round(bitmapB2[lokalx,lokaly]*kerneldka[4-m][4-n]);

               totalgray1:=totalgray1+round(bitmapGray1[lokalx,lokaly]*kerneldka[4-m][4-n]);
               totalgray2:=totalgray2+round(bitmapGray2[lokalx,lokaly]*kerneldka[4-m][4-n]);
             end;
           end;
          bitmapRDka1[x,y]:=totalr1;
          bitmapGDka1[x,y]:=totalg1;
          bitmapBDka1[x,y]:=totalb1;

          bitmapRDka2[x,y]:=totalr2;
          bitmapGDka2[x,y]:=totalg2;
          bitmapBDka2[x,y]:=totalb2;

          bitmapGrayDka1[x,y]:=totalgray1;
          bitmapGrayDka2[x,y]:=totalgray2;



          if  bitmapRDka1[x,y]<0 then  bitmapRDka1[x,y]:=0;
          if  bitmapRDka1[x,y]>255 then  bitmapRDka1[x,y]:=255;
          if  bitmapGDka1[x,y]<0 then  bitmapGDka1[x,y]:=0;
          if  bitmapGDka1[x,y]>255 then  bitmapGDka1[x,y]:=255;
          if  bitmapBDka1[x,y]<0 then  bitmapBDka1[x,y]:=0;
          if  bitmapBDka1[x,y]>255 then  bitmapBDka1[x,y]:=255;

          if  bitmapRDka2[x,y]<0 then  bitmapRDka2[x,y]:=0;
          if  bitmapRDka2[x,y]>255 then  bitmapRDka2[x,y]:=255;
          if  bitmapGDka2[x,y]<0 then  bitmapGDka2[x,y]:=0;
          if  bitmapGDka2[x,y]>255 then  bitmapGDka2[x,y]:=255;
          if  bitmapBDka2[x,y]<0 then  bitmapBDka2[x,y]:=0;
          if  bitmapBDka2[x,y]>255 then  bitmapBDka2[x,y]:=255;

          if  bitmapGrayDka1[x,y]<0 then  bitmapGrayDka1[x,y]:=0;
          if  bitmapGrayDka1[x,y]>255 then  bitmapGrayDka1[x,y]:=255;
          if  bitmapGrayDka2[x,y]<0 then  bitmapGrayDka2[x,y]:=0;
          if  bitmapGrayDka2[x,y]>255 then  bitmapGrayDka2[x,y]:=255;
      end;
   end;

    for y:=1 to image1.Height do
    begin
     for x:=1 to image1.Width do
      begin
       image1.Canvas.Pixels[x,y]:=RGB(bitmapRDka1[x,y],bitmapGDka1[x,y],bitmapBDka1[x,y]);
       image2.Canvas.Pixels[x,y]:=RGB(bitmapGrayDka2[x,y],bitmapGrayDka2[x,y],bitmapGrayDka2[x,y]);
      end;
    end;

end;

Procedure TForm1.DeteksiTepiKiri();
var
kerneldki:array [1..3,1..3] of real = (
 (2,-1,-1),
 (-1,2,-1),
 (-1,-1,2)
);
x,y,m,n,totalr2,totalg2,totalb2,lokalx,lokaly,totalr1,totalg1,totalb1,totalgray1,totalgray2 : integer;
Begin
  for x:=1 to image1.Width do
   begin
    //1
    bitmapR1[x,0]:= bitmapR1[x,1];
    bitmapG1[x,0]:= bitmapG1[x,1];
    bitmapB1[x,0]:= bitmapB1[x,1];
    bitmapR1[x,image1.Height+1]:=bitmapR1[x,image1.Height];
    bitmapG1[x,image1.Height+1]:=bitmapG1[x,image1.Height];
    bitmapB1[x,image1.Height+1]:=bitmapB1[x,image1.Height];
    //2
    bitmapR2[x,0]:= bitmapR2[x,1];
    bitmapG2[x,0]:= bitmapG2[x,1];
    bitmapB2[x,0]:= bitmapB2[x,1];
    bitmapR2[x,image2.Height+1]:=bitmapR2[x,image2.Height];
    bitmapG2[x,image2.Height+1]:=bitmapG2[x,image2.Height];
    bitmapB2[x,image2.Height+1]:=bitmapB2[x,image2.Height];
   end;
    for y:=0 to image1.Height do
     begin
      //1
      bitmapG1[0,y]:= bitmapR1[1,y];
      bitmapG1[0,y]:= bitmapG1[1,y];
      bitmapB1[0,y]:= bitmapB1[1,y];
      bitmapR1[image1.Width+1,y]:=bitmapR1[image1.Width,y+1];
      bitmapG1[image1.Width+1,y]:=bitmapG1[image1.Width,y+1];
      bitmapB1[image1.Width+1,y]:=bitmapB1[image1.Width,y+1];

      bitmapGray1[0,y]:=bitmapGray1[0,y];
      bitmapGray1[0,y]:=bitmapGray1[image1.Width,y+1];
      //2
      bitmapR2[0,y]:= bitmapR2[1,y];
      bitmapG2[0,y]:= bitmapG2[1,y];
      bitmapB2[0,y]:= bitmapB2[1,y];
      bitmapR2[image2.Width+1,y]:=bitmapR2[image2.Width,y+1];
      bitmapG2[image2.Width+1,y]:=bitmapG2[image2.Width,y+1];
      bitmapB2[image2.Width+1,y]:=bitmapB2[image2.Width,y+1];

      bitmapGray2[0,y]:=bitmapGray2[0,y];
      bitmapGray2[0,y]:=bitmapGray2[image1.Width,y+1];

     end;

     for y:=1 to image1.Height do
      begin
       for x:=1 to image1.Width do
        begin
          totalr1:=0;
          totalg1:=0;
          totalb1:=0;
          totalr2:=0;
          totalg2:=0;
          totalb2:=0;
          totalgray1:=0;
          totalgray2:=0;
          for m:=1 to 3 do
           begin
            for n:=1 to 3 do
             begin
               lokalx:=x+n-2;
               lokaly:=y+m-2;
               totalr1:=totalr1+round(bitmapR1[lokalx,lokaly]*kerneldki[4-m][4-n]);
               totalg1:=totalg1+round(bitmapG1[lokalx,lokaly]*kerneldki[4-m][4-n]);
               totalb1:=totalb1+round(bitmapB1[lokalx,lokaly]*kerneldki[4-m][4-n]);

               totalr2:=totalr2+round(bitmapR2[lokalx,lokaly]*kerneldki[4-m][4-n]);
               totalg2:=totalg2+round(bitmapG2[lokalx,lokaly]*kerneldki[4-m][4-n]);
               totalb2:=totalb2+round(bitmapB2[lokalx,lokaly]*kerneldki[4-m][4-n]);

               totalgray1:=totalgray1+round(bitmapGray1[lokalx,lokaly]*kerneldki[4-m][4-n]);
               totalgray2:=totalgray2+round(bitmapGray2[lokalx,lokaly]*kerneldki[4-m][4-n]);
             end;
           end;
          bitmapRDki1[x,y]:=totalr1;
          bitmapGDki1[x,y]:=totalg1;
          bitmapBDki1[x,y]:=totalb1;

          bitmapRDki2[x,y]:=totalr2;
          bitmapGDki2[x,y]:=totalg2;
          bitmapBDki2[x,y]:=totalb2;

          bitmapGrayDki1[x,y]:=totalgray1;
          bitmapGrayDki2[x,y]:=totalgray2;



          if  bitmapRDki1[x,y]<0 then  bitmapRDki1[x,y]:=0;
          if  bitmapRDki1[x,y]>255 then  bitmapRDki1[x,y]:=255;
          if  bitmapGDki1[x,y]<0 then  bitmapGDki1[x,y]:=0;
          if  bitmapGDki1[x,y]>255 then  bitmapGDki1[x,y]:=255;
          if  bitmapBDki1[x,y]<0 then  bitmapBDki1[x,y]:=0;
          if  bitmapBDki1[x,y]>255 then  bitmapBDki1[x,y]:=255;

          if  bitmapRDki2[x,y]<0 then  bitmapRDki2[x,y]:=0;
          if  bitmapRDki2[x,y]>255 then  bitmapRDki2[x,y]:=255;
          if  bitmapGDki2[x,y]<0 then  bitmapGDki2[x,y]:=0;
          if  bitmapGDki2[x,y]>255 then  bitmapGDki2[x,y]:=255;
          if  bitmapBDki2[x,y]<0 then  bitmapBDki2[x,y]:=0;
          if  bitmapBDki2[x,y]>255 then  bitmapBDki2[x,y]:=255;

          if  bitmapGrayDki1[x,y]<0 then  bitmapGrayDki1[x,y]:=0;
          if  bitmapGrayDki1[x,y]>255 then  bitmapGrayDki1[x,y]:=255;
          if  bitmapGrayDki2[x,y]<0 then  bitmapGrayDki2[x,y]:=0;
          if  bitmapGrayDki2[x,y]>255 then  bitmapGrayDki2[x,y]:=255;
      end;
   end;

    for y:=1 to image1.Height do
    begin
     for x:=1 to image1.Width do
      begin
       image1.Canvas.Pixels[x,y]:=RGB(bitmapRDki1[x,y],bitmapGDki1[x,y],bitmapBDki1[x,y]);
       image2.Canvas.Pixels[x,y]:=RGB(bitmapGrayDki2[x,y],bitmapGrayDki2[x,y],bitmapGrayDki2[x,y]);
      end;
    end;

end;
Procedure TForm1.Invers();
var
   x,y: integer;
begin
   for y:=1 to image1.Height do
    begin
     for x:=1 to image1.Width do
      begin
       bitmapRInvers1[x,y]:= 255-bitmapR1[x,y];
       bitmapGInvers1[x,y]:= 255-bitmapG1[x,y];
       bitmapBInvers1[x,y]:= 255-bitmapB1[x,y];
       bitmapRInvers2[x,y]:= 255-bitmapR2[x,y];
       bitmapGInvers2[x,y]:= 255-bitmapG2[x,y];
       bitmapBInvers2[x,y]:= 255-bitmapB2[x,y];

       bitmapGrayInvers1[x,y]:= 255-bitmapGray1[x,y];
       bitmapGrayInvers2[x,y]:= 255-bitmapGray2[x,y];

          if  bitmapRInvers1[x,y]<0 then  bitmapRInvers1[x,y]:=0;
          if  bitmapRInvers1[x,y]>255 then  bitmapRInvers1[x,y]:=255;
          if  bitmapGInvers1[x,y]<0 then  bitmapGInvers1[x,y]:=0;
          if  bitmapGInvers1[x,y]>255 then  bitmapGInvers1[x,y]:=255;
          if  bitmapBInvers1[x,y]<0 then  bitmapBInvers1[x,y]:=0;
          if  bitmapBInvers1[x,y]>255 then  bitmapBInvers1[x,y]:=255;

          if  bitmapRInvers2[x,y]<0 then  bitmapRInvers2[x,y]:=0;
          if  bitmapRInvers2[x,y]>255 then  bitmapRInvers2[x,y]:=255;
          if  bitmapGInvers2[x,y]<0 then  bitmapGInvers2[x,y]:=0;
          if  bitmapGInvers2[x,y]>255 then  bitmapGInvers2[x,y]:=255;
          if  bitmapBInvers2[x,y]<0 then  bitmapBInvers2[x,y]:=0;
          if  bitmapBInvers2[x,y]>255 then  bitmapBInvers2[x,y]:=255;

          if  bitmapGrayInvers1[x,y]<0 then  bitmapGrayInvers1[x,y]:=0;
          if  bitmapGrayInvers1[x,y]>255 then  bitmapGrayInvers1[x,y]:=255;

          if  bitmapGrayInvers2[x,y]<0 then  bitmapGrayInvers2[x,y]:=0;
          if  bitmapGrayInvers2[x,y]>255 then  bitmapGrayInvers2[x,y]:=255;
      end;
    end;
   for y:=1 to image1.Height do
    begin
     for x:=1 to image1.Width do
      begin
       image1.Canvas.Pixels[x,y]:=RGB(bitmapRInvers1[x,y],bitmapGInvers1[x,y],bitmapBInvers1[x,y]);
       image2.Canvas.Pixels[x,y]:=RGB(bitmapGrayInvers2[x,y],bitmapGrayInvers2[x,y],bitmapGrayInvers2[x,y]);
      end;
    end;

end;
Procedure TForm1.AritmatikaOR();
Var
 x, y : integer;
Begin
 for y:=1 to image1.Height do
    begin
     for x:=1 to image1.Width do
      begin

     bitmapR3[x][y]:=bitmapR1[x][y] OR bitmapR2[x][y];
     bitmapG3[x][y]:=bitmapG1[x][y] OR bitmapG2[x][y];
     bitmapB3[x][y]:=bitmapB1[x][y] OR bitmapB2[x][y];

          if  bitmapR3[x,y]<0 then  bitmapR3[x,y]:=0;
          if  bitmapR3[x,y]>255 then  bitmapR3[x,y]:=255;
          if  bitmapG3[x,y]<0 then  bitmapG3[x,y]:=0;
          if  bitmapG3[x,y]>255 then  bitmapG3[x,y]:=255;
          if  bitmapB3[x,y]<0 then  bitmapB3[x,y]:=0;
          if  bitmapB3[x,y]>255 then  bitmapB3[x,y]:=255;

   end;
  end;
  image3.Height:=image1.Height;
  image3.Width:=image1.Width;
 for y:=1 to image1.Height do
    begin
     for x:=1 to image1.Width do
      begin
     image3.Canvas.Pixels[x,y]:=RGB(bitmapR3[x][y],bitmapG3[x][y],bitmapB3[x][y]);
   end;
  end;
end;

Procedure TForm1.AritmatikaPerkalian();
Var
 x, y : integer;
Begin
 for y:=1 to image1.Height do
    begin
     for x:=1 to image1.Width do
      begin

     bitmapR3[x][y]:=bitmapR1[x][y] * bitmapR2[x][y];
     bitmapG3[x][y]:=bitmapG1[x][y] * bitmapG2[x][y];
     bitmapB3[x][y]:=bitmapB1[x][y] * bitmapB2[x][y];
          if  bitmapR3[x,y]<0 then  bitmapR3[x,y]:=0;
          if  bitmapR3[x,y]>255 then  bitmapR3[x,y]:=255;
          if  bitmapG3[x,y]<0 then  bitmapG3[x,y]:=0;
          if  bitmapG3[x,y]>255 then  bitmapG3[x,y]:=255;
          if  bitmapB3[x,y]<0 then  bitmapB3[x,y]:=0;
          if  bitmapB3[x,y]>255 then  bitmapB3[x,y]:=255;


   end;
  end;
  image3.Height:=image1.Height;
  image3.Width:=image1.Width;
 for y:=1 to image1.Height do
    begin
     for x:=1 to image1.Width do
      begin
     image3.Canvas.Pixels[x,y]:=RGB(bitmapR3[x][y],bitmapG3[x][y],bitmapB3[x][y]);
   end;
  end;
end;

Procedure TForm1.Closing();
Var
 SE1:array [1..3,1..3] of Integer = (
    (255,255,255),
    (255,255,255),
    (255,255,255)
  );
 SE0:array [1..3,1..3] of Integer = (
    (0,0,0),
    (0,0,0),
    (0,0,0)
  );
  x,y,m,n,totalr1,totalg1,totalb1,totalr2,totalg2,totalb2,lokalx,lokaly: integer;
begin
 image3.Height:=image1.Height;
 image3.Width:=image1.Width;
     //DILASI
     for y:=1 to image1.Height do
     begin
      for x:=1 to image1.Width do
       begin
         totalr1:=0;
         totalg1:=0;
         totalb1:=0;
         totalr2:=0;
         totalg2:=0;
         totalb2:=0;
         for m:=1 to 3 do
          begin
           for n:=1 to 3 do
            begin
              lokalx:=x+n-2;
              lokaly:=y+m-2;
              totalr1:=totalr1 OR (bitmapR1[lokalx,lokaly] OR SE0[4-m][4-n]);
              totalg1:=totalg1 OR (bitmapG1[lokalx,lokaly] OR SE0[4-m][4-n]);
              totalb1:=totalb1 OR (bitmapB1[lokalx,lokaly] OR SE0[4-m][4-n]);
              totalr2:=totalr2 OR (bitmapR2[lokalx,lokaly] OR SE0[4-m][4-n]);
              totalg2:=totalg2 OR (bitmapG2[lokalx,lokaly] OR SE0[4-m][4-n]);
              totalb2:=totalb2 OR (bitmapB2[lokalx,lokaly] OR SE0[4-m][4-n]);
            end;
          end;
         bitmapRDilasi1[x,y]:=totalr1;
         bitmapGDilasi1[x,y]:=totalg1;
         bitmapBDilasi1[x,y]:=totalb1;
         bitmapRDilasi2[x,y]:=totalr2;
         bitmapGDilasi2[x,y]:=totalg2;
         bitmapBDilasi2[x,y]:=totalb2;
       end;
     end;
      //EROSI
     for y:=1 to image1.Height do
     begin
      for x:=1 to image1.Width do
       begin
         totalr1:=255;
         totalg1:=255;
         totalb1:=255;
         totalr2:=255;
         totalg2:=255;
         totalb2:=255;
         for m:=1 to 3 do
          begin
           for n:=1 to 3 do
            begin
              lokalx:=x+n-2;
              lokaly:=y+m-2;
              totalr1:=totalr1 AND (bitmapRDilasi1[lokalx,lokaly] AND SE1[4-m][4-n]);
              totalg1:=totalg1 AND (bitmapGDilasi1[lokalx,lokaly] AND SE1[4-m][4-n]);
              totalb1:=totalb1 AND (bitmapBDilasi1[lokalx,lokaly] AND SE1[4-m][4-n]);
              totalr2:=totalr2 AND (bitmapRDilasi2[lokalx,lokaly] AND SE1[4-m][4-n]);
              totalg2:=totalg2 AND (bitmapGDilasi2[lokalx,lokaly] AND SE1[4-m][4-n]);
              totalb2:=totalb2 AND (bitmapBDilasi2[lokalx,lokaly] AND SE1[4-m][4-n]);
            end;
          end;
         bitmapRErosi1[x,y]:=totalr1;
         bitmapGErosi1[x,y]:=totalg1;
         bitmapBErosi1[x,y]:=totalb1;
         bitmapRErosi2[x,y]:=totalr2;
         bitmapGErosi2[x,y]:=totalg2;
         bitmapBErosi2[x,y]:=totalb2;
       end;
     end;
   for y:=1 to image1.Height do
    begin
     for x:=1 to image1.Width do
      begin
       image1.Canvas.Pixels[x,y]:=RGB(bitmapRErosi1[x][y],bitmapGErosi1[x][y],bitmapBErosi1[x][y]);
       image2.Canvas.Pixels[x,y]:=RGB(bitmapRErosi2[x][y],bitmapGErosi2[x][y],bitmapBErosi2[x][y]);
      end;
    end;
end;

end.

