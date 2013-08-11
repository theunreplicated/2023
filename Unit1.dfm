object Form1: TForm1
  Left = 261
  Top = 310
  Width = 1137
  Height = 783
  Caption = '2023'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Button2: TButton
    Left = 848
    Top = 208
    Width = 193
    Height = 65
    Caption = 'Website erstellen'
    TabOrder = 0
    OnClick = Button2Click
  end
  object ScrollBox1: TScrollBox
    Left = 272
    Top = 104
    Width = 569
    Height = 569
    TabOrder = 1
  end
  object Button3: TButton
    Left = 848
    Top = 320
    Width = 193
    Height = 65
    Caption = 'einlesen'
    TabOrder = 2
    OnClick = Button3Click
  end
  object ScrollBox2: TScrollBox
    Left = 32
    Top = 104
    Width = 225
    Height = 369
    TabOrder = 3
  end
  object Chromium1: TChromium
    Left = 272
    Top = 104
    Width = 569
    Height = 569
    DefaultUrl = 'about:blank'
    TabOrder = 4
    Visible = False
  end
  object Button1: TButton
    Left = 112
    Top = 40
    Width = 75
    Height = 25
    Caption = 'Vorschau'
    TabOrder = 5
    OnClick = Button1Click
  end
  object Button4: TButton
    Left = 192
    Top = 40
    Width = 75
    Height = 25
    Caption = 'Ende'
    TabOrder = 6
    Visible = False
    OnClick = Button4Click
  end
  object SaveDialog1: TSaveDialog
    DefaultExt = '.html'
    Left = 40
    Top = 8
  end
  object OpenDialog1: TOpenDialog
    Left = 8
    Top = 8
  end
  object OpenPictureDialog1: TOpenPictureDialog
    Left = 72
    Top = 8
  end
end
