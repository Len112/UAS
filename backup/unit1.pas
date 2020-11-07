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
    Procedure Filtering();
    Procedure DeteksiTepi();
    Procedure Invers();
    Procedure AritmatikaAnd();
    Procedure Opening();
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
  bitmapR1,bitmapG1,bitmapB1,bitmapR2,bitmapG2,bitmapB2 :array [0..1000,0..1000]of integer;
  bitmapGray1,bitmapGray2 : array [0..1000,0..1000] of integer;
  bitmapRF1,bitmapGF1,bitmapBF1,bitmapRF2,bitmapGF2,bitmapBF2 :array [0..1000,0..1000]of integer;
  bitmapRD1,bitmapGD1,bitmapBD1,bitmapRD2,bitmapGD2,bitmapBD2 :array [0..1000,0..1000]of integer;
  bitmapR3, bitmapG3, bitmapB3,bitmapR4, bitmapG4, bitmapB4: array [0..1000, 0..1000] of Integer;

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
   //Filtering();
   Biner();
   Filtering();
   DeteksiTepi();
   Invers();
   AritmatikaAnd();
   Opening();
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
   {for y:=1 to image1.Height do
    begin
     for x:=1 to image1.Width do
      begin
       image1.Canvas.Pixels[x,y]:=RGB(bitmapR1[x,y],bitmapG1[x,y],bitmapB1[x,y]);
       image2.Canvas.Pixels[x,y]:=RGB(bitmapR2[x,y],bitmapG2[x,y],bitmapB2[x,y]);
      end;
    end;}
end;
Procedure Tform1.Filtering();
var
   x,y,m,n,totalr1,totalg1,totalb1,lokalx,lokaly,totalr2,totalg2,totalb2 : integer;
   kernel:array [1..3,1..3] of real = (
    (11,-1,-1),
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
      bitmapR1[0,y]:= bitmapR1[1,y];
      bitmapG1[0,y]:= bitmapG1[1,y];
      bitmapB1[0,y]:= bitmapB1[1,y];
      bitmapR1[image1.Width+1,y]:=bitmapR1[image1.Width,y+1];
      bitmapG1[image1.Width+1,y]:=bitmapG1[image1.Width,y+1];
      bitmapB1[image1.Width+1,y]:=bitmapB1[image1.Width,y+1];
      //2
      bitmapR2[0,y]:= bitmapR2[1,y];
      bitmapG2[0,y]:= bitmapG2[1,y];
      bitmapB2[0,y]:= bitmapB2[1,y];
      bitmapR2[image2.Width+1,y]:=bitmapR2[image2.Width,y+1];
      bitmapG2[image2.Width+1,y]:=bitmapG2[image2.Width,y+1];
      bitmapB2[image2.Width+1,y]:=bitmapB2[image2.Width,y+1];

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
             end;
           end;
          bitmapRF1[x,y]:=totalr1;
          bitmapGF1[x,y]:=totalg1;
          bitmapBF1[x,y]:=totalb1;
          bitmapRF2[x,y]:=totalr2;
          bitmapGF2[x,y]:=totalg2;
          bitmapBF2[x,y]:=totalb2;
          if  bitmapRF1[x,y]<0 then  bitmapRF1[x,y]:=0;
          if  bitmapRF1[x,y]>255 then  bitmapRF1[x,y]:=255;
          if  bitmapGF1[x,y]<0 then  bitmapGF1[x,y]:=0;
          if  bitmapGF1[x,y]>255 then  bitmapGF1[x,y]:=255;
          if  bitmapBF1[x,y]<0 then  bitmapBF1[x,y]:=0;
          if  bitmapBF1[x,y]>255 then  bitmapBF1[x,y]:=255;

          if  bitmapRF2[x,y]<0 then  bitmapRF2[x,y]:=0;
          if  bitmapRF2[x,y]>255 then  bitmapRF2[x,y]:=255;
          if  bitmapGF2[x,y]<0 then  bitmapGF2[x,y]:=0;
          if  bitmapGF2[x,y]>255 then  bitmapGF2[x,y]:=255;
          if  bitmapBF2[x,y]<0 then  bitmapBF2[x,y]:=0;
          if  bitmapBF2[x,y]>255 then  bitmapBF2[x,y]:=255;
      end;
      end;
    {for y:=1 to image1.Height do
    begin
     for x:=1 to image1.Width do
      begin
       image1.Canvas.Pixels[x,y]:=RGB(bitmapRF1[x,y],bitmapGF1[x,y],bitmapBF1[x,y]);
       image2.Canvas.Pixels[x,y]:=RGB(bitmapRF2[x,y],bitmapGF2[x,y],bitmapBF2[x,y]);
      end;
    end;  }
end;
var
   x,y,m,n,totalr2,totalg2,totalb2,lokalx,lokaly,totalr1,totalg1,totalb1 : integer;
   bitmapRDki1,bitmapGDki1,bitmapBDki1,bitmapRDki2,bitmapGDki2,bitmapBDki2 :array [0..1000,0..1000]of integer;
   kerneldki:array [1..3,1..3] of real = (
    (2,-1,-1),
    (-1,2,-1),
    (-1,-1,2)
  );
   kernelDKa:array [1..3,1..3] of real = (
    (-1,-1,2),
    (-1,2,-1),
    (2,-1,-1)
  );
Procedure TForm1.DeteksiTepi();

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
      bitmapR1[0,y]:= bitmapR1[1,y];
      bitmapG1[0,y]:= bitmapG1[1,y];
      bitmapB1[0,y]:= bitmapB1[1,y];
      bitmapR1[image1.Width+1,y]:=bitmapR1[image1.Width,y+1];
      bitmapG1[image1.Width+1,y]:=bitmapG1[image1.Width,y+1];
      bitmapB1[image1.Width+1,y]:=bitmapB1[image1.Width,y+1];
      //2
      bitmapR2[0,y]:= bitmapR2[1,y];
      bitmapG2[0,y]:= bitmapG2[1,y];
      bitmapB2[0,y]:= bitmapB2[1,y];
      bitmapR2[image2.Width+1,y]:=bitmapR2[image2.Width,y+1];
      bitmapG2[image2.Width+1,y]:=bitmapG2[image2.Width,y+1];
      bitmapB2[image2.Width+1,y]:=bitmapB2[image2.Width,y+1];

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
          for m:=1 to 3 do
           begin
            for n:=1 to 3 do
             begin
               lokalx:=x+n-2;
               lokaly:=y+m-2;
               totalr1:=totalr1+round(bitmapRF1[lokalx,lokaly]*kerneldki[4-m][4-n]);
               totalg1:=totalg1+round(bitmapGF1[lokalx,lokaly]*kerneldki[4-m][4-n]);
               totalb1:=totalb1+round(bitmapBF1[lokalx,lokaly]*kerneldki[4-m][4-n]);
               totalr2:=totalr2+round(bitmapRF2[lokalx,lokaly]*kerneldki[4-m][4-n]);
               totalg2:=totalg2+round(bitmapGF2[lokalx,lokaly]*kerneldki[4-m][4-n]);
               totalb2:=totalb2+round(bitmapBF2[lokalx,lokaly]*kerneldki[4-m][4-n]);
             end;
           end;
          bitmapRDki1[x,y]:=totalr1;
          bitmapGDki1[x,y]:=totalg1;
          bitmapBDki1[x,y]:=totalb1;
          bitmapRDki2[x,y]:=totalr2;
          bitmapGDki2[x,y]:=totalg2;
          bitmapBDki2[x,y]:=totalb2;
          if  bitmapRDki1[x,y]<0 then  bitmapRDki1[x,y]:=0;
          if  bitmapRDki1[x,y]>255 then  bitmapRDki1[x,y]:=255;
          if  bitmapGDki1[x,y]<0 then  bitmapGDki1[x,y]:=0;
          if  bitmapGDki1[x,y]>255 then  bitmapGDki1[x,y]:=255;
          if  bitmapBDki1[x,y]<0 then  bitmapGDki1[x,y]:=0;
          if  bitmapBDki1[x,y]>255 then  bitmapGDki1[x,y]:=255;

          if  bitmapRDki2[x,y]<0 then  bitmapRDki2[x,y]:=0;
          if  bitmapRDki2[x,y]>255 then  bitmapRDki2[x,y]:=255;
          if  bitmapGDki2[x,y]<0 then  bitmapGDki2[x,y]:=0;
          if  bitmapGDki2[x,y]>255 then  bitmapGDki2[x,y]:=255;
          if  bitmapBDki2[x,y]<0 then  bitmapGDki2[x,y]:=0;
          if  bitmapBDki2[x,y]>255 then  bitmapGDki2[x,y]:=255;
      end;
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
          for m:=1 to 3 do
           begin
            for n:=1 to 3 do
             begin
               lokalx:=x+n-2;
               lokaly:=y+m-2;
               totalr1:=totalr1+round(bitmapRDki1[lokalx,lokaly]*kerneldka[4-m][4-n]);
               totalg1:=totalg1+round(bitmapGDki1[lokalx,lokaly]*kerneldka[4-m][4-n]);
               totalb1:=totalb1+round(bitmapBDki1[lokalx,lokaly]*kerneldka[4-m][4-n]);
               totalr2:=totalr2+round(bitmapRDki2[lokalx,lokaly]*kerneldka[4-m][4-n]);
               totalg2:=totalg2+round(bitmapGDki2[lokalx,lokaly]*kerneldka[4-m][4-n]);
               totalb2:=totalb2+round(bitmapBDki2[lokalx,lokaly]*kerneldka[4-m][4-n]);
             end;
           end;
          bitmapRD1[x,y]:=totalr1;
          bitmapGD1[x,y]:=totalg1;
          bitmapBD1[x,y]:=totalb1;
          bitmapRD2[x,y]:=totalr2;
          bitmapGD2[x,y]:=totalg2;
          bitmapBD2[x,y]:=totalb2;
          if  bitmapRD1[x,y]<0 then  bitmapRD1[x,y]:=0;
          if  bitmapRD1[x,y]>255 then  bitmapRD1[x,y]:=255;
          if  bitmapGD1[x,y]<0 then  bitmapGD1[x,y]:=0;
          if  bitmapGD1[x,y]>255 then  bitmapGD1[x,y]:=255;
          if  bitmapBD1[x,y]<0 then  bitmapGD1[x,y]:=0;
          if  bitmapBD1[x,y]>255 then  bitmapGD1[x,y]:=255;

          if  bitmapRD2[x,y]<0 then  bitmapRD2[x,y]:=0;
          if  bitmapRD2[x,y]>255 then  bitmapRD2[x,y]:=255;
          if  bitmapGD2[x,y]<0 then  bitmapGD2[x,y]:=0;
          if  bitmapGD2[x,y]>255 then  bitmapGD2[x,y]:=255;
          if  bitmapBD2[x,y]<0 then  bitmapGD2[x,y]:=0;
          if  bitmapBD2[x,y]>255 then  bitmapGD2[x,y]:=255;
      end;
   end;

    {for y:=1 to image1.Height do
    begin
     for x:=1 to image1.Width do
      begin
       image1.Canvas.Pixels[x,y]:=RGB(bitmapRD1[x,y],bitmapGD1[x,y],bitmapBD1[x,y]);
       image2.Canvas.Pixels[x,y]:=RGB(bitmapRD2[x,y],bitmapGD2[x,y],bitmapBD2[x,y]);
      end;
    end;}

end;
Procedure TForm1.Invers();
var
   x,y: integer;
begin
   for y:=1 to image1.Height do
    begin
     for x:=1 to image1.Width do
      begin
       bitmapR1[x,y]:= 255-bitmapRD1[x,y];
       bitmapG1[x,y]:= 255-bitmapGD1[x,y];
       bitmapB1[x,y]:= 255-bitmapBD1[x,y];
       bitmapR2[x,y]:= 255-bitmapRD2[x,y];
       bitmapG2[x,y]:= 255-bitmapGD2[x,y];
       bitmapB2[x,y]:= 255-bitmapBD2[x,y];
          if  bitmapR1[x,y]<0 then  bitmapR1[x,y]:=0;
          if  bitmapR1[x,y]>255 then  bitmapR1[x,y]:=255;
          if  bitmapG1[x,y]<0 then  bitmapG1[x,y]:=0;
          if  bitmapG1[x,y]>255 then  bitmapG1[x,y]:=255;
          if  bitmapB1[x,y]<0 then  bitmapB1[x,y]:=0;
          if  bitmapB1[x,y]>255 then  bitmapB1[x,y]:=255;

          if  bitmapR2[x,y]<0 then  bitmapR2[x,y]:=0;
          if  bitmapR2[x,y]>255 then  bitmapR2[x,y]:=255;
          if  bitmapG2[x,y]<0 then  bitmapG2[x,y]:=0;
          if  bitmapG2[x,y]>255 then  bitmapG2[x,y]:=255;
          if  bitmapB2[x,y]<0 then  bitmapB2[x,y]:=0;
          if  bitmapB2[x,y]>255 then  bitmapB2[x,y]:=255;
       image1.Canvas.Pixels[x,y]:=RGB(bitmapR1[x,y],bitmapG1[x,y],bitmapB1[x,y]);
       image2.Canvas.Pixels[x,y]:=RGB(bitmapR2[x,y],bitmapG2[x,y],bitmapB2[x,y]);
      end;
    end;
end;
Procedure TForm1.AritmatikaAnd();
Var
 x, y : integer;
Begin
 for y:=1 to image1.Height do
    begin
     for x:=1 to image1.Width do
      begin

     bitmapR3[x][y]:=bitmapR1[x][y] AND bitmapR2[x][y];
     bitmapG3[x][y]:=bitmapG1[x][y] AND bitmapG2[x][y];
     bitmapB3[x][y]:=bitmapB1[x][y] AND bitmapB2[x][y];

   end;
  end;
  image3.Height:=image1.Height;
  image3.Width:=image1.Width;
 {for y:=1 to image1.Height do
    begin
     for x:=1 to image1.Width do
      begin
     image3.Canvas.Pixels[x,y]:=RGB(bitmapR3[x][y],bitmapG3[x][y],bitmapB3[x][y]);
   end;
  end;}
end;

Procedure TForm1.Opening();
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
  x,y,m,n,totalr,totalg,totalb,lokalx,lokaly: integer;
begin
 image3.Height:=image1.Height;
  image3.Width:=image1.Width;
  //EROSI
     for y:=1 to image1.Height do
     begin
      for x:=1 to image1.Width do
       begin
         totalr:=0;
         totalg:=0;
         totalb:=0;
         for m:=1 to 3 do
          begin
           for n:=1 to 3 do
            begin
              lokalx:=x+n-2;
              lokaly:=y+m-2;
              totalr:=totalr OR (bitmapR1[lokalx,lokaly] OR SE0[4-m][4-n]);
              totalg:=totalg OR (bitmapG1[lokalx,lokaly] OR SE0[4-m][4-n]);
              totalb:=totalb OR (bitmapB1[lokalx,lokaly] OR SE0[4-m][4-n]);
            end;
          end;
         bitmapR3[x,y]:=totalr;
         bitmapG3[x,y]:=totalg;
         bitmapB3[x,y]:=totalb;
       end;
     end;
     //DILASI
     for y:=1 to image1.Height do
     begin
      for x:=1 to image1.Width do
       begin
         totalr:=255;
         totalg:=255;
         totalb:=255;
         for m:=1 to 3 do
          begin
           for n:=1 to 3 do
            begin
              lokalx:=x+n-2;
              lokaly:=y+m-2;
              totalr:=totalr AND (bitmapR3[lokalx,lokaly] AND SE1[4-m][4-n]);
              totalg:=totalg AND (bitmapG3[lokalx,lokaly] AND SE1[4-m][4-n]);
              totalb:=totalb AND (bitmapB3[lokalx,lokaly] AND SE1[4-m][4-n]);
            end;
          end;
         bitmapR4[x,y]:=totalr;
         bitmapG4[x,y]:=totalg;
         bitmapB4[x,y]:=totalb;
       end;
     end;

     for y:=1 to image1.Height do
    begin
     for x:=1 to image1.Width do
      begin
     image3.Canvas.Pixels[x,y]:=RGB(bitmapR4[x][y],bitmapG4[x][y],bitmapB4[x][y]);
   end;
  end;
end;

end.

