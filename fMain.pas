//---------------------------------------------------------------------------
// This software is Copyright (c) 2012 Alan Fletcher.
// You may use thius software in any way you want and contribute back to the
// author with any improvements you may have made to it.
// You are also allowed to use this software or part of it for any purposes as long
// as you retain this message and credit the author for it's contribuition.
//---------------------------------------------------------------------------
unit fMain;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Rtti, System.Classes,
  System.Variants, FMX.Types, FMX.Controls, FMX.Forms, FMX.Dialogs,
  FMX.Media, FMX.Layouts, Data.Bind.EngExt, Fmx.Bind.DBEngExt, System.Bindings.Outputs, Fmx.Bind.Editors,
  Data.Bind.Components, fBase;

type
  TForm1 = class(TfrmBase)
    MediaPlayer1: TMediaPlayer;
    OpenDialog1: TOpenDialog;
    btnPlay1: TButton;
    tbVolume1: TTrackBar;
    pnlPlayer1: TPanel;
    btnLoad1: TButton;
    GridLayout1: TGridLayout;
    lblStatus1: TLabel;
    pnlPlayer2: TPanel;
    tbVolume2: TTrackBar;
    btnPlay2: TButton;
    btnLoad2: TButton;
    lblStatus2: TLabel;
    MediaPlayer2: TMediaPlayer;
    pnlPlayer3: TPanel;
    tbVolume3: TTrackBar;
    btnPlay3: TButton;
    btnLoad3: TButton;
    lblStatus3: TLabel;
    MediaPlayer3: TMediaPlayer;
    pnlPlayer4: TPanel;
    tbVolume4: TTrackBar;
    btnPlay4: TButton;
    btnLoad4: TButton;
    lblStatus4: TLabel;
    MediaPlayer4: TMediaPlayer;
    pnlPlayer5: TPanel;
    tbVolume5: TTrackBar;
    btnPlay5: TButton;
    Button11: TButton;
    lblStatus5: TLabel;
    MediaPlayer5: TMediaPlayer;
    pnlPlayer6: TPanel;
    tbVolume6: TTrackBar;
    btnPlay6: TButton;
    btnLoad6: TButton;
    lblStatus6: TLabel;
    MediaPlayer6: TMediaPlayer;
    pnlPlayer7: TPanel;
    tbVolume7: TTrackBar;
    btnPlay7: TButton;
    btnLoad7: TButton;
    lblStatus7: TLabel;
    MediaPlayer7: TMediaPlayer;
    pnlPlayer8: TPanel;
    tbVolume8: TTrackBar;
    btnPlay8: TButton;
    btnLoad8: TButton;
    lblStatus8: TLabel;
    MediaPlayer8: TMediaPlayer;
    lblVolumeLevel1: TLabel;
    lblVolumeLevel2: TLabel;
    lblVolumeLevel3: TLabel;
    lblVolumeLevel4: TLabel;
    lblVolumeLevel5: TLabel;
    lblVolumeLevel6: TLabel;
    lblVolumeLevel7: TLabel;
    lblVolumeLevel8: TLabel;
    BindingsList1: TBindingsList;
    VolumeLevel1: TBindExprItems;
    VolumeLevel2: TBindExprItems;
    VolumeLevel3: TBindExprItems;
    VolumeLevel4: TBindExprItems;
    VolumeLevel5: TBindExprItems;
    VolumeLevel6: TBindExprItems;
    VolumeLevel7: TBindExprItems;
    VolumeLevel8: TBindExprItems;
    MediaPlayerStatus1: TBindExprItems;
    MediaPlayerStatus2: TBindExprItems;
    MediaPlayerStatus3: TBindExprItems;
    MediaPlayerStatus4: TBindExprItems;
    MediaPlayerStatus5: TBindExprItems;
    MediaPlayerStatus6: TBindExprItems;
    MediaPlayerStatus7: TBindExprItems;
    MediaPlayerStatus8: TBindExprItems;
    Timer1: TTimer;
    procedure HandleLoadMedia(Sender: TObject);
    procedure btnPlayClick(Sender: TObject);
    procedure HandleVolumeChangesByTrackbar(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;
  FNotifying: Integer;

const
// Component name prefix - used to find components on the forms
MEDIA_PLAYER = 'MediaPlayer';
PLAY_BUTTON = 'btnPlay';
MEDIA_PLAYER_CONTROL ='MediaPlayerControl';

implementation

{$R *.fmx}

uses MediaPlayer.StateConversion, fScreens;

//------------------------------------------------------------------------------------------------------------
// Loads media into the media player
procedure TForm1.HandleLoadMedia(Sender: TObject);
var
  MediaPlayer: TComponent;
  PlayButton: TComponent;
begin
  // Only supported files
  OpenDialog1.Filter := TMediaCodecManager.GetFilterString;
  if (OpenDialog1.Execute) then
  begin
    // Tries to find the proper media player to load media onto
    MediaPlayer := GetObjectByName(MEDIA_PLAYER, (Sender as TComponent).Tag);
    // Makes sure it found a media player component
    if Assigned(MediaPlayer) and (MediaPlayer is TMediaPlayer) then
    begin
      // Attempts to load media
      (MediaPlayer as TMediaPlayer).FileName := OpenDialog1.FileName;
      if (MediaPlayer as TMediaPlayer).State = TMediaState.Stopped then
      begin
        // If media is recognized as valid then it enables the play button
        PlayButton := GetObjectByName(PLAY_BUTTON, (Sender as TComponent).Tag);
        if Assigned(PlayButton) and (PlayButton is TButton) then
        begin
          (PlayButton as TButton).Enabled := True;
        end;
      end;
    end;
  end;
end;

//------------------------------------------------------------------------------------------------------------
// Handles play button
procedure TForm1.btnPlayClick(Sender: TObject);
var
  MediaPlayer: TComponent;
begin
  // Tries to find the proper media player
  MediaPlayer := GetObjectByName(MEDIA_PLAYER, (Sender as TComponent).Tag);
  // Makes sure it found a media player component
  if Assigned(MediaPlayer) and (MediaPlayer is TMediaPlayer) then
  begin
  // Does it have a valid media attached?
  if (MediaPlayer as TMediaPlayer).State <> TMediaState.Unavailable  then
    // Figures if it needs to start or stop playback
    if (MediaPlayer as TMediaPlayer).State = TMediaState.Stopped  then
      (MediaPlayer as TMediaPlayer).Play
    else
      (MediaPlayer as TMediaPlayer).Stop;
  end;
end;

//------------------------------------------------------------------------------------------------------------
procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  // removes screens form
  if Assigned(fScreenWall) then
    fScreenWall.Release;
end;

//------------------------------------------------------------------------------------------------------------
procedure TForm1.FormCreate(Sender: TObject);
var
  MediaPlayer,
  MediaPlayerControl: TComponent;
  I: Integer;
begin
  // Creates screens form
  fScreenWall := TfScreenWall.Create(nil);
  // Assigns all playes to all media controls
  for I := 1 to 8 do
  begin
    MediaPlayer := GetObjectByName(MEDIA_PLAYER, I);
    if Assigned(MediaPlayer) and (MediaPlayer is TMediaPlayer) then
    begin
      MediaPlayerControl := fScreenWall.GetObjectByName(MEDIA_PLAYER_CONTROL, I);
      if Assigned(MediaPlayerControl) and (MediaPlayerControl is TMediaPlayerControl) then
      begin
        (MediaPlayerControl as TMediaPlayerControl).MediaPlayer := (MediaPlayer as TMediaPlayer);
      end;
    end;
  end;

  // Shows the form
  fScreenWall.Show;
end;

//------------------------------------------------------------------------------------------------------------
// Handles volume changes
procedure TForm1.HandleVolumeChangesByTrackbar(Sender: TObject);
var
  MediaPlayer: TComponent;
begin
  // Volume Commands can only come from TTrackbar
  if Sender is TTrackBar then
  begin
    MediaPlayer := GetObjectByName(MEDIA_PLAYER, (Sender as TComponent).Tag);

    if Assigned(MediaPlayer) and (MediaPlayer is TMediaPlayer) then
    begin
      (MediaPlayer as TMediaPlayer).Volume := (Sender as TTrackBar).Value/100;

      // Some controls send notifications when setting properties,
      // like TTrackBar
      if FNotifying = 0 then
      begin
        Inc(FNotifying);
        // Send notification to cause expression re-evaluation of dependent expressions
        try
          BindingsList1.Notify(Sender, '');
        finally
          Dec(FNotifying);
        end;
      end;
    end;
  end;
end;

//------------------------------------------------------------------------------------------------------------
// Maintains labels in synch with media players
procedure TForm1.Timer1Timer(Sender: TObject);
var
  I: Integer;
  MediaPlayer: TComponent;
begin
  for I := 1 to 8 do
  begin
    MediaPlayer := GetObjectByName(MEDIA_PLAYER, I);
    if Assigned(MediaPlayer) and (MediaPlayer is TMediaPlayer) then
    begin
      // Send notification to cause expression re-evaluation of dependent expressions
      BindingsList1.Notify(MediaPlayer, '');
    end;
  end;
end;

end.
