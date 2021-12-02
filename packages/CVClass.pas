unit CVClass;

{$POINTERMATH ON}

interface

Uses
  WinApi.Windows,
  WinApi.Messages,
  System.Types,
  System.SysUtils,
  System.Classes,
  System.Generics.Collections,
  System.SyncObjs,
  VCL.Controls,
  VCL.Graphics,
  opencv_world;

Type

  ICVDataReceiver = interface
    ['{7EBE0282-0731-45EB-8A1D-1097C2CBC680}']
    procedure TakeMat(const AMat: TMat);
    procedure SetSource(const Value: TObject);
  end;

  ICVDataSource = interface
    ['{03150528-1FB4-4677-9194-D63E38D0B67E}']
    procedure AddReceiver(const CVReceiver: ICVDataReceiver);
    procedure RemoveReceiver(const CVReceiver: ICVDataReceiver);

    function getEnabled: Boolean;
    procedure setEnabled(const Value: Boolean);
    // function getMat: TMat;
    // function GetName: string;
    // function getHeight: Integer;
    // function getWidth: Integer;
    // function GetFPS: double;

    property Enabled: Boolean Read getEnabled write setEnabled;
    // property Mat: TMat read getMat;
    // property Name: String read GetName;
    // property Width: Integer Read getWidth;
    // property Height: Integer Read getHeight;
    // property FPS: double read GetFPS;
  end;

  TCVReceiverList         = TThreadList<ICVDataReceiver>;
  TOnCVNotify             = procedure(Sender: TObject; const AMat: TMat) of object;
  TOnCVNotifyVar          = procedure(Sender: TObject; Var AMat: TMat) of object;
  TOnCVAfterPaint         = TOnCVNotify;
  TOnBeforeNotifyReceiver = TOnCVNotifyVar;

  TCVDataSource = class(TComponent, ICVDataSource)
  protected
    FCVReceivers: TCVReceiverList;
    FOnBeforeNotifyReceiver: TOnBeforeNotifyReceiver;
    FOnCVNotify: TOnCVNotifyVar;
    procedure NotifyReceiver(const AMat: TMat); virtual;

    function getEnabled: Boolean; virtual; abstract;
    procedure setEnabled(const Value: Boolean); virtual; abstract;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure AddReceiver(const CVReceiver: ICVDataReceiver); virtual;
    procedure RemoveReceiver(const CVReceiver: ICVDataReceiver); virtual;
    function getMat: TMat; virtual; abstract;
  published
    property Enabled: Boolean Read getEnabled write setEnabled;
    property OnBeforeNotifyReceiver: TOnBeforeNotifyReceiver read FOnBeforeNotifyReceiver write FOnBeforeNotifyReceiver;
    property OnCVNotify: TOnCVNotifyVar read FOnCVNotify write FOnCVNotify;
  end;

  TCVDataReceiver = class(TComponent, ICVDataReceiver)
  private
    [weak]
    FCVSource: ICVDataSource;
  protected
    procedure SetSource(const Value: TObject); virtual;
    procedure SetCVSource(const Value: ICVDataSource); virtual;
  public
    procedure TakeMat(const AMat: TMat); virtual; abstract;
    destructor Destroy; override;
    function isSourceEnabled: Boolean; virtual;
  published
    property Source: ICVDataSource Read FCVSource write SetCVSource;
  end;

  TCVDataProxy = class(TCVDataSource, ICVDataReceiver)
  private
    [weak]
    FCVSource: ICVDataSource;
  protected
    procedure SetSource(const Value: TObject); virtual;
    procedure SetCVSource(const Value: ICVDataSource); virtual;
  public
    procedure TakeMat(const AMat: TMat); virtual; abstract;
    destructor Destroy; override;
  published
    property Source: ICVDataSource Read FCVSource write SetCVSource;
  end;

  TCVView = class(TWinControl, ICVDataReceiver)
  private
    FMat: pMat; // Stored last received Mat
  protected
    [weak]
    FCVSource: ICVDataSource;
    FOnAfterPaint: TOnCVAfterPaint;
    FOnBeforePaint: TOnCVNotify;
    FCanvas: TCanvas;
    FStretch: Boolean;
    FProportional: Boolean;
    FCenter: Boolean;
    procedure WMEraseBkgnd(var Message: TWMEraseBkgnd); message WM_ERASEBKGND;
    procedure WMPaint(var Message: TWMPaint); message WM_PAINT;

    procedure SetSource(const Value: TObject);
    procedure SetCVSource(const Value: ICVDataSource);

    procedure TakeMat(const AMat: TMat);

    function isSourceEnabled: Boolean;
    function MatIsEmpty: Boolean;

    function PaintRect: System.Types.TRect;
  protected
    procedure ReleaseMat;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure DrawMat(const AMat: TMat);
    property Canvas: TCanvas read FCanvas;
  published
    property Source: ICVDataSource Read FCVSource write SetCVSource;
    property Proportional: Boolean read FProportional write FProportional default false;
    property Stretch: Boolean read FStretch write FStretch default True;
    property Center: Boolean read FCenter write FCenter default false;
    property Align;
    property OnAfterPaint: TOnCVAfterPaint read FOnAfterPaint write FOnAfterPaint;
    property OnBeforePaint: TOnCVNotify read FOnBeforePaint write FOnBeforePaint;
    property OnEnter;
    property OnExit;
    property OnKeyDown;
    property OnKeyPress;
    property OnKeyUp;
    property OnMouseDown;
    property OnMouseUp;
    property OnMouseMove;
    property OnMouseEnter;
    property OnMouseLeave;
    property OnMouseWheel;
    property OnMouseWheelUp;
    property OnMouseWheelDown;
  end;

  TOCVLock                   = TLightweightMREW;
  TPersistentAccessProtected = class(TPersistent);

  TCVCaptureThread = class(TThread)
  private type
    TSourceType = (stStream, stFile);
  private
    FSourceType: TSourceType;
  private
    FCapture: TVideoCapture;
    FOnNotifyData: TOnCVNotify;
    FOnNoData: TNotifyEvent;
    FThreadDelay: Cardinal;
  protected
    procedure TerminatedSet; override;
    procedure Execute; override;
  public
    constructor Create(const AFileName: string; const AThreadDelay: Cardinal = 1000 div 25; const VideoAPIs: VideoCaptureAPIs = CAP_ANY); overload;
    constructor Create(const ACameraIndex: Integer; const AThreadDelay: Cardinal = 1000 div 25; const VideoAPIs: VideoCaptureAPIs = CAP_ANY); overload;
    procedure SetResolution(const Width, Height: Double);
    property OnNoData: TNotifyEvent Read FOnNoData write FOnNoData;
    property OnNotifyData: TOnCVNotify Read FOnNotifyData write FOnNotifyData;
    property ThreadDelay: Cardinal read FThreadDelay Write FThreadDelay;
  end;

  TCVCustomResolution = class(TPersistent)
  private
    FWidth, FHeight: Cardinal;
  protected
    procedure AssignTo(Dest: TPersistent); override;
  public
    constructor Create;
  published
    property Width: Cardinal read FWidth write FWidth default 800;
    property Height: Cardinal read FHeight write FHeight default 600;
  end;

  {
    �������� ��������� ��� ���������� ������ TCVCaptureSource
  }
  TCVVideoCaptureAPIs = ( //
    ANY,                  // !< Auto detect == 0
    VFW,                  // !< Video For Windows (obsolete, removed)
    V4L,                  // !< V4L/V4L2 capturing support
    V4L2,                 // !< Same as CAP_V4L
    FIREWIRE,             // !< IEEE 1394 drivers
    FIREWARE,             // !< Same value as CAP_FIREWIRE
    IEEE1394,             // !< Same value as CAP_FIREWIRE
    DC1394,               // !< Same value as CAP_FIREWIRE
    CMU1394,              // !< Same value as CAP_FIREWIRE
    QT,                   // !< QuickTime (obsolete, removed)
    UNICAP,               // !< Unicap drivers (obsolete, removed)
    DSHOW,                // !< DirectShow (via videoInput)
    PVAPI,                // !< PvAPI, Prosilica GigE SDK
    OPENNI,               // !< OpenNI (for Kinect)
    OPENNI_ASUS,          // !< OpenNI (for Asus Xtion)
    ANDROID,              // !< Android - not used
    XIAPI,                // !< XIMEA Camera API
    AVFOUNDATION,         // !< AVFoundation framework for iOS (OS X Lion will have the same API)
    GIGANETIX,            // !< Smartek Giganetix GigEVisionSDK
    MSMF,                 // !< Microsoft Media Foundation (via videoInput)
    WINRT,                // !< Microsoft Windows Runtime using Media Foundation
    INTELPERC,            // !< RealSense (former Intel Perceptual Computing SDK)
    REALSENSE,            // !< Synonym for CAP_INTELPERC
    OPENNI2,              // !< OpenNI2 (for Kinect)
    OPENNI2_ASUS,         // !< OpenNI2 (for Asus Xtion and Occipital Structure sensors)
    OPENNI2_ASTRA,        // !< OpenNI2 (for Orbbec Astra)
    GPHOTO2,              // !< gPhoto2 connection
    GSTREAMER,            // !< GStreamer
    FFMPEG,               // !< Open and record video file or stream using the FFMPEG library
    IMAGES,               // !< OpenCV Image Sequence (e.g. img_%02d.jpg)
    ARAVIS,               // !< Aravis SDK
    OPENCV_MJPEG,         // !< Built-in OpenCV MotionJPEG codec
    INTEL_MFX,            // !< Intel MediaSDK
    XINE,                 // !< XINE engine (Linux)
    UEYE                  // !< uEye Camera API
    );

  TCVCustomSource = class(TComponent)
  protected
    procedure AssignTo(Dest: TPersistent); override;
  private
    FOwner: TPersistent;
    FNotifyChange: TNotifyEvent;
    FThreadDelay: Cardinal;
    FCaptureAPIs: TCVVideoCaptureAPIs;
    procedure setThreadDelay(const Value: Cardinal);
    procedure setCaptureAPIs(const Value: TCVVideoCaptureAPIs);
  protected
    function GetOwner: TPersistent; override;
    procedure DoNotifyChange;
    property OnNotifyChange: TNotifyEvent read FNotifyChange write FNotifyChange;
  public
    constructor Create(AOwner: TPersistent); reintroduce; virtual;
    function GetNamePath: string; override;
    property Name;
  published
    property Delay: Cardinal read FThreadDelay Write setThreadDelay default 0;
    property CaptureAPIs: TCVVideoCaptureAPIs read FCaptureAPIs write setCaptureAPIs default ANY;
  end;

  TCVWebCameraResolution = (r160x120, r176x144, r320x240, r352x288, r424x240, r640x360, r640x480, r800x448, r800x600, r960x544, r1280x720, rCustom);

  TCVWebCameraResolutionValue = record
    W, H: Double;
  end;

const
  CVWebCameraResolutionValue: array [TCVWebCameraResolution] of TCVWebCameraResolutionValue = //
    ( //
    (W: 160; H: 120),  //
    (W: 176; H: 144),  //
    (W: 320; H: 240),  //
    (W: 352; H: 288),  //
    (W: 424; H: 240),  //
    (W: 640; H: 360),  //
    (W: 640; H: 480),  //
    (W: 800; H: 448),  //
    (W: 800; H: 600),  //
    (W: 960; H: 544),  //
    (W: 1280; H: 720), //
    (W: 0; H: 0)       //
    );

Type
  TCVWebCameraSource = class(TCVCustomSource)
  private
    FResolution: TCVWebCameraResolution;
    FCameraIndex: Integer;
    FCustomResolution: TCVCustomResolution;
    procedure setCameraIndex(const Value: Integer);
    procedure SetResolution(const Value: TCVWebCameraResolution);
  public
    constructor Create(AOwner: TPersistent); override;
    destructor Destroy; override;
  published
    property CameraIndex: Integer read FCameraIndex write setCameraIndex default 0;
    property Resolution: TCVWebCameraResolution read FResolution write SetResolution default r800x600;
    property CustomResolution: TCVCustomResolution read FCustomResolution write FCustomResolution;
  end;

  TCVFileSource = class(TCVCustomSource)
  private
    FFileName: TFileName;
    FLoop: Boolean;
    procedure SetFileName(const Value: TFileName);
  public
    constructor Create(AOwner: TPersistent); override;
  published
    property FileName: TFileName read FFileName write SetFileName;
    property Loop: Boolean read FLoop write FLoop default false;
  end;

  TCVSourceTypeClass = class of TCVCustomSource;

  ICVEditorPropertiesContainer = interface
    ['{418F88DD-E35D-4425-BF24-E753E83D35D6}']
    function GetProperties: TCVCustomSource;
    function GetPropertiesClass: TCVSourceTypeClass;
    procedure SetPropertiesClass(Value: TCVSourceTypeClass);
  end;

  TCVCaptureSource = class(TCVDataSource, ICVEditorPropertiesContainer)
  protected
    FSourceThread: TCVCaptureThread;

    FOperation: TCVCustomSource;
    FOperationClass: TCVSourceTypeClass;

    FEnabled: Boolean;

    // ������ �� ���������� ���������
    function GetPropertiesClassName: string;
    procedure SetProperties(const Value: TCVCustomSource);
    procedure SetPropertiesClassName(const Value: string);
    function GetProperties: TCVCustomSource;
    function GetPropertiesClass: TCVSourceTypeClass;
    procedure SetPropertiesClass(Value: TCVSourceTypeClass);
    // ��������/�����������/������������ ����������� ��������
    procedure CreateProperties;
    procedure DestroyProperties;
    procedure RecreateProperties;

    // ���������� ����� �������� ����������
    // ���� Enabled=true - ������ ������
    procedure Loaded; override;

    // ����� � ��������� ������
    procedure setEnabled(const Value: Boolean); override;
    function getEnabled: Boolean; override;

    // ������������ � ������ ��� ��������� ������
    procedure OnNotifyDataCaptureThread(Sender: TObject; const AMat: TMat);
    procedure OnNoDataCaptureThread(Sender: TObject);
    procedure OnTerminateCaptureThread(Sender: TObject);

    // ������� �� ��������� ���������� ����������� ��������
    procedure OnNotifyChange(Sender: TObject);

    // ��� ����������� ��������
    property SourceTypeClass: TCVSourceTypeClass read GetPropertiesClass write SetPropertiesClass;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    // ������� � ��������� �����
    procedure StartCapture;
    // ������������� � ���������� �����
    procedure StopCapture;
  published
    property SourceTypeClassName: string read GetPropertiesClassName write SetPropertiesClassName;
    property SourceType: TCVCustomSource read GetProperties write SetProperties;
  end;

//  TCVMatOperation = class(TCVDataProxy, ICVEditorPropertiesContainer)
//  end;

  TRegisteredCaptureSource = class(TStringList)
  public
    function FindByClassName(const ClassName: String): TCVSourceTypeClass;
    function FindByName(const Name: String): TCVSourceTypeClass;
    function GetNameByClass(const IOClass: TClass): String;
    procedure RegisterIOClass(const IOClass: TClass; const ClassName: String);
  end;

function GetRegisteredCaptureSource: TRegisteredCaptureSource;

implementation

function ipDraw(dc: HDC; img: TMat; const rect: System.Types.TRect; const Stretch: Boolean = True): Boolean;

Type
  pCOLORREF         = ^COLORREF;
  pBITMAPINFOHEADER = ^BITMAPINFOHEADER;

Var
  // isrgb: Boolean;
  isgray: Boolean;
  buf: array [1 .. SizeOf(BITMAPINFOHEADER) + SizeOf(RGBQUAD) * 256] of byte;
  dibhdr: pBITMAPINFOHEADER;
  _dibhdr: TBitmapInfo ABSOLUTE buf;
  _rgb: pCOLORREF;
  i: Integer;
  iResult: Integer;
begin
  if img.empty then
    Exit(false);

  // isrgb := ('R' = upcase(img^.colorModel[0])) and ('G' = upcase(img^.colorModel[1])) and ('B' = upcase(img^.colorModel[2]));
  // isgray := 'G' = upcase(img^.colorModel[0]);
  isgray := img.channels = 1;
  // if (not isgray) and (not isrgb) then
  // Exit(false);
  // if (1 = img^.nChannels) and (not isgray) then
  // Exit(false);

  dibhdr := @buf;
  _rgb   := pCOLORREF(Integer(dibhdr) + SizeOf(BITMAPINFOHEADER));

  if (isgray) then
    for i     := 0 to 255 do
      _rgb[i] := rgb(i, i, i);

  dibhdr^.biSize  := SizeOf(BITMAPINFOHEADER);
  dibhdr^.biWidth := img.cols;
  // Check origin for display
  // if img^.Origin = 0 then
  dibhdr^.biHeight := -img.rows;
  // else
  // dibhdr^.biHeight := img^.Height;

  dibhdr^.biPlanes        := 1;
  dibhdr^.biBitCount      := 8 * img.channels;
  dibhdr^.biCompression   := BI_RGB;
  dibhdr^.biSizeImage     := 0; // img^.imageSize;
  dibhdr^.biXPelsPerMeter := 0;
  dibhdr^.biYPelsPerMeter := 0;
  dibhdr^.biClrUsed       := 0;
  dibhdr^.biClrImportant  := 0;

  if Stretch then
  begin
    SetStretchBltMode(dc, COLORONCOLOR);
    SetMapMode(dc, MM_TEXT);
    // Stretch the image to fit the rectangle
    iResult := StretchDIBits(dc, rect.Left, rect.Top, rect.Width, rect.Height, 0, 0, img.cols, img.rows, img.Data, _dibhdr, DIB_RGB_COLORS, SRCCOPY);
    Result  := (iResult > 0); // and (iResult <> GDI_ERROR);
  end
  else
  begin
    // Draw without scaling
    iResult := SetDIBitsToDevice(dc, rect.Left, rect.Top, img.cols, img.rows, 0, 0, 0, img.rows, img.Data, _dibhdr, DIB_RGB_COLORS);
    Result  := (iResult > 0); // and (iResult <> GDI_ERROR);
  end;
end;

Var
  _RegisteredCaptureSource: TRegisteredCaptureSource = nil;

function GetRegisteredCaptureSource: TRegisteredCaptureSource;
begin
  if not Assigned(_RegisteredCaptureSource) then
    _RegisteredCaptureSource := TRegisteredCaptureSource.Create;
  Result                     := _RegisteredCaptureSource;
end;

{ TCVDataSource }

procedure TCVDataSource.AddReceiver(const CVReceiver: ICVDataReceiver);
begin
  FCVReceivers.Add(CVReceiver);
end;

constructor TCVDataSource.Create(AOwner: TComponent);
begin
  inherited;
  FCVReceivers := TCVReceiverList.Create;
end;

destructor TCVDataSource.Destroy;
begin
  FCVReceivers.Free;
  inherited;
end;

procedure TCVDataSource.NotifyReceiver(const AMat: TMat);
Var
  R: ICVDataReceiver;
  LockList: TList<ICVDataReceiver>;
  M: TMat;
begin
  M := AMat.Clone;
  if Assigned(FOnBeforeNotifyReceiver) then
    FOnBeforeNotifyReceiver(Self, M);
  LockList := FCVReceivers.LockList;
  try
    for R in LockList do
      R.TakeMat(M);
  finally
    FCVReceivers.UnlockList;
  end;
  if Assigned(FOnCVNotify) then
    FOnCVNotify(Self, M);
end;

procedure TCVDataSource.RemoveReceiver(const CVReceiver: ICVDataReceiver);
begin
  FCVReceivers.Remove(CVReceiver);
end;

{ TCVDataReceiver }

destructor TCVDataReceiver.Destroy;
begin
  if Assigned(FCVSource) then
    FCVSource.RemoveReceiver(Self);
  inherited;
end;

function TCVDataReceiver.isSourceEnabled: Boolean;
begin
  Result := Assigned(FCVSource) and FCVSource.Enabled;
end;

procedure TCVDataReceiver.SetCVSource(const Value: ICVDataSource);
begin
  if (FCVSource <> Value) then
  begin
    if Assigned(FCVSource) then
      FCVSource.RemoveReceiver(Self);
    FCVSource := Value;
    if Assigned(FCVSource) then
      FCVSource.AddReceiver(Self);
  end;
end;

procedure TCVDataReceiver.SetSource(const Value: TObject);
begin
  if (Value <> Self) then
    Source := Value as TCVDataSource;
end;

{ TCVDataProxy }

destructor TCVDataProxy.Destroy;
begin
  if Assigned(FCVSource) then
    FCVSource.RemoveReceiver(Self);
  inherited;
end;

procedure TCVDataProxy.SetCVSource(const Value: ICVDataSource);
begin
  if (FCVSource <> Value) then
  begin
    if Assigned(FCVSource) then
      FCVSource.RemoveReceiver(Self);
    FCVSource := Value;
    if Assigned(FCVSource) then
      FCVSource.AddReceiver(Self);
  end;
end;

procedure TCVDataProxy.SetSource(const Value: TObject);
begin
  if (Value <> Self) then
    Source := Value as TCVDataSource;
end;

{ TOpenCVView }

constructor TCVView.Create(AOwner: TComponent);
begin
  inherited;
  FCanvas                         := TControlCanvas.Create;
  TControlCanvas(FCanvas).Control := Self;
  Stretch                         := True;
  Proportional                    := false;
  Center                          := false;
end;

destructor TCVView.Destroy;
begin
  ReleaseMat;
  Source := nil;
  FCanvas.Free;
  inherited;
end;

procedure TCVView.SetCVSource(const Value: ICVDataSource);
begin
  if FCVSource <> Value then
  begin
    if Assigned(FCVSource) and (not(csDesigning in ComponentState)) then
      FCVSource.RemoveReceiver(Self);
    FCVSource := Value;
    if Assigned(FCVSource) and (not(csDesigning in ComponentState)) then
      FCVSource.AddReceiver(Self);
  end;
end;

procedure TCVView.SetSource(const Value: TObject);
begin
  Source := Value as TCVDataSource;
end;

procedure TCVView.DrawMat(const AMat: TMat);
begin
  if not Assigned(FMat) then
    New(FMat);
  FMat^ := AMat;
  Invalidate;
end;

procedure TCVView.TakeMat(const AMat: TMat);
begin
  if not(csDestroying in ComponentState) then
    DrawMat(AMat);
end;

function TCVView.PaintRect: System.Types.TRect;
var
  ViewWidth, ViewHeight, CliWidth, CliHeight: Integer;
  AspectRatio: Double;
begin
  if MatIsEmpty then
    Exit(System.Types.rect(0, 0, 0, 0));

  ViewWidth  := FMat^.cols;
  ViewHeight := FMat^.rows;
  CliWidth   := ClientWidth;
  CliHeight  := ClientHeight;
  if (Proportional and ((ViewWidth > CliWidth) or (ViewHeight > CliHeight))) or Stretch then
  begin
    if Proportional and (ViewWidth > 0) and (ViewHeight > 0) then
    begin
      AspectRatio := ViewWidth / ViewHeight;
      if ViewWidth > ViewHeight then
      begin
        ViewWidth  := CliWidth;
        ViewHeight := Trunc(CliWidth / AspectRatio);
        if ViewHeight > CliHeight then
        begin
          ViewHeight := CliHeight;
          ViewWidth  := Trunc(CliHeight * AspectRatio);
        end;
      end
      else
      begin
        ViewHeight := CliHeight;
        ViewWidth  := Trunc(CliHeight * AspectRatio);
        if ViewWidth > CliWidth then
        begin
          ViewWidth  := CliWidth;
          ViewHeight := Trunc(CliWidth / AspectRatio);
        end;
      end;
    end
    else
    begin
      ViewWidth  := CliWidth;
      ViewHeight := CliHeight;
    end;
  end;

  with Result do
  begin
    Left   := 0;
    Top    := 0;
    Right  := ViewWidth;
    Bottom := ViewHeight;
  end;

  if Center then
    OffsetRect(Result, (CliWidth - ViewWidth) div 2, (CliHeight - ViewHeight) div 2);
end;

procedure TCVView.ReleaseMat;
begin
  if Assigned(FMat) then
  begin
    Dispose(FMat);
    FMat := nil;
  end;
end;

function TCVView.isSourceEnabled: Boolean;
begin
  Result := Assigned(Source) and (Source.Enabled);
end;

function TCVView.MatIsEmpty: Boolean;
begin
  Result := not(Assigned(FMat) and (not FMat^.empty));
end;

procedure TCVView.WMEraseBkgnd(var Message: TWMEraseBkgnd);
begin
  if (csDesigning in ComponentState) or (not isSourceEnabled) then
    inherited;
end;

procedure TCVView.WMPaint(var Message: TWMPaint);
Var
  dc: HDC;
  lpPaint: TPaintStruct;
begin
  Canvas.Lock;
  dc := BeginPaint(Handle, lpPaint);
  try
    Canvas.Handle := dc;
    if (csDesigning in ComponentState) or MatIsEmpty then
    begin
      inherited;

      Canvas.Font.Color := clWindowText;

      var
        Text: string := Name + ': ' + ClassName;
      var
        TextOneHeight: Integer := Canvas.TextHeight(Text) + 5;
      var
        TextHeight: Integer := TextOneHeight * 2 - 5;
      if not Assigned(Source) then
        TextHeight := TextHeight + TextOneHeight;

      Var
        x: Integer := (ClientWidth - Canvas.TextWidth(Text)) div 2;
      Var
        y: Integer := (ClientHeight - TextHeight) div 2;
      Canvas.TextOut(x, y, Text);

      Text := '(' + ClientWidth.ToString + ',' + ClientHeight.ToString + ')';
      x    := (ClientWidth - Canvas.TextWidth(Text)) div 2;
      y    := y + TextOneHeight;
      Canvas.TextOut(x, y, Text);
      if not Assigned(Source) then
      begin
        Text              := 'Source not defined';
        x                 := (ClientWidth - Canvas.TextWidth(Text)) div 2;
        y                 := y + TextOneHeight;
        Canvas.Font.Color := clRed;
        Canvas.TextOut(x, y, Text);
      end;
    end
    else
    begin
      if not MatIsEmpty then
      begin
        try
          if Assigned(OnBeforePaint) then
            OnBeforePaint(Self, FMat^);
          if ipDraw(dc, FMat^, PaintRect) then
            if Assigned(OnAfterPaint) then
              OnAfterPaint(Self, FMat^);
        finally
          Canvas.Handle := 0;
        end;
      end
      else
        DefaultHandler(Message);
    end;
  finally
    EndPaint(Handle, lpPaint);
    Canvas.Unlock;
  end;
end;

{ TCVCaptureSource }

Var
  CVVideoCaptureAPIs: array [TCVVideoCaptureAPIs] of VideoCaptureAPIs = //
    ( //
    CAP_ANY,           // !< Auto detect == 0
    CAP_VFW,           // !< Video For Windows obsolete, removed)
    CAP_V4L,           // !< V4L/V4L2 capturing support
    CAP_V4L2,          // !< Same as CAP_V4L
    CAP_FIREWIRE,      // !< IEEE 1394 drivers
    CAP_FIREWARE,      // !< Same value as CAP_FIREWIRE
    CAP_IEEE1394,      // !< Same value as CAP_FIREWIRE
    CAP_DC1394,        // !< Same value as CAP_FIREWIRE
    CAP_CMU1394,       // !< Same value as CAP_FIREWIRE
    CAP_QT,            // !< QuickTime obsolete, removed)
    CAP_UNICAP,        // !< Unicap drivers obsolete, removed)
    CAP_DSHOW,         // !< DirectShow via videoInput)
    CAP_PVAPI,         // !< PvAPI, Prosilica GigE SDK
    CAP_OPENNI,        // !< OpenNI for Kinect)
    CAP_OPENNI_ASUS,   // !< OpenNI for Asus Xtion)
    CAP_ANDROID,       // !< Android - not used
    CAP_XIAPI,         // !< XIMEA Camera API
    CAP_AVFOUNDATION,  // !< AVFoundation framework for iOS OS X Lion will have the same API)
    CAP_GIGANETIX,     // !< Smartek Giganetix GigEVisionSDK
    CAP_MSMF,          // !< Microsoft Media Foundation via videoInput)
    CAP_WINRT,         // !< Microsoft Windows Runtime using Media Foundation
    CAP_INTELPERC,     // !< RealSense former Intel Perceptual Computing SDK)
    CAP_REALSENSE,     // !< Synonym for CAP_INTELPERC
    CAP_OPENNI2,       // !< OpenNI2 for Kinect)
    CAP_OPENNI2_ASUS,  // !< OpenNI2 for Asus Xtion and Occipital Structure sensors)
    CAP_OPENNI2_ASTRA, // !< OpenNI2 for Orbbec Astra)
    CAP_GPHOTO2,       // !< gPhoto2 connection
    CAP_GSTREAMER,     // !< GStreamer
    CAP_FFMPEG,        // !< Open and record video file or stream using the FFMPEG library
    CAP_IMAGES,        // !< OpenCV Image Sequence e.g. img_%02d.jpg)
    CAP_ARAVIS,        // !< Aravis SDK
    CAP_OPENCV_MJPEG,  // !< Built-in OpenCV MotionJPEG codec
    CAP_INTEL_MFX,     // !< Intel MediaSDK
    CAP_XINE,          // !< XINE engine Linux)
    CAP_UEYE           // !< uEye Camera API
  );

constructor TCVCaptureSource.Create(AOwner: TComponent);
begin
  inherited;
  FEnabled := false;
end;

procedure TCVCaptureSource.setEnabled(const Value: Boolean);
begin
  if FEnabled <> Value then
  begin
    if csDesigning in ComponentState then
      FEnabled := Value
    else
    begin
      if not Value then
        StopCapture;
      if Value then
        StartCapture;
      FEnabled := Value;
    end;
  end;
end;

procedure TCVCaptureSource.CreateProperties;
begin
  if FOperationClass <> nil then
  begin
    FOperation                := FOperationClass.Create(Self);
    FOperation.OnNotifyChange := OnNotifyChange;
  end;
end;

destructor TCVCaptureSource.Destroy;
begin
  StopCapture;
  inherited;
end;

procedure TCVCaptureSource.DestroyProperties;
begin
  StopCapture;
  FreeAndNil(FOperation);
end;

function TCVCaptureSource.getEnabled: Boolean;
begin
  Result := FEnabled;
end;

function TCVCaptureSource.GetProperties: TCVCustomSource;
begin
  if not Assigned(FOperation) then
    FOperation := TCVWebCameraSource.Create(Self);
  Result       := FOperation;
end;

function TCVCaptureSource.GetPropertiesClass: TCVSourceTypeClass;
begin
  Result := TCVSourceTypeClass(SourceType.ClassType);
end;

function TCVCaptureSource.GetPropertiesClassName: string;
begin
  Result := SourceType.ClassName;
end;

procedure TCVCaptureSource.Loaded;
begin
  inherited;
  if not(csDesigning in ComponentState) then
    if Enabled then
      StartCapture;
end;

procedure TCVCaptureSource.OnNoDataCaptureThread(Sender: TObject);
begin
  if FOperationClass = TCVFileSource then
  begin
    Var
      FileSource: TCVFileSource := FOperation as TCVFileSource;
    if FileSource.Loop then
      FSourceThread.FCapture.&set(CAP_PROP_POS_FRAMES, 0);
  end;
end;

procedure TCVCaptureSource.OnNotifyChange(Sender: TObject);
begin
  StopCapture;
  StartCapture;
end;

procedure TCVCaptureSource.OnNotifyDataCaptureThread(Sender: TObject; const AMat: TMat);
begin
  NotifyReceiver(AMat);
end;

procedure TCVCaptureSource.OnTerminateCaptureThread(Sender: TObject);
begin
  FreeAndNil(FSourceThread);
  FEnabled := false;
end;

procedure TCVCaptureSource.RecreateProperties;
begin
  DestroyProperties;
  CreateProperties;
end;

procedure TCVCaptureSource.SetProperties(const Value: TCVCustomSource);
begin
  if (FOperation <> nil) and (Value <> nil) then
    FOperation.Assign(Value);
end;

procedure TCVCaptureSource.SetPropertiesClass(Value: TCVSourceTypeClass);
begin
  if FOperationClass <> Value then
  begin
    FOperationClass := Value;
    RecreateProperties;
  end;
end;

procedure TCVCaptureSource.SetPropertiesClassName(const Value: string);
begin
  SourceTypeClass := TCVSourceTypeClass(GetRegisteredCaptureSource.FindByClassName(Value));
end;

procedure TCVCaptureSource.StartCapture;
begin
  if Assigned(FSourceThread) or (csDesigning in ComponentState) then
    Exit;

  if FOperationClass = TCVWebCameraSource then
  begin
    Var
      WebCameraSource: TCVWebCameraSource := FOperation as TCVWebCameraSource;

    FSourceThread := TCVCaptureThread.Create( //
      WebCameraSource.CameraIndex,            //
      WebCameraSource.Delay,                  //
      CVVideoCaptureAPIs[WebCameraSource.CaptureAPIs]);
    if WebCameraSource.Resolution <> rCustom then
      with CVWebCameraResolutionValue[WebCameraSource.Resolution] do
        FSourceThread.SetResolution(W, H)
    else
      FSourceThread.SetResolution(WebCameraSource.CustomResolution.Width, WebCameraSource.CustomResolution.Height);

    FSourceThread.OnNoData     := OnNoDataCaptureThread;
    FSourceThread.OnNotifyData := OnNotifyDataCaptureThread;
    FSourceThread.OnTerminate  := OnTerminateCaptureThread;
    FSourceThread.Start;
    FEnabled := True;

  end
  else if FOperationClass = TCVFileSource then
  begin
    Var
      FileSource: TCVFileSource := FOperation as TCVFileSource;
    FSourceThread               := TCVCaptureThread.Create( //
      FileSource.FileName, //
      FileSource.Delay, //
      CVVideoCaptureAPIs[FileSource.CaptureAPIs]);

    FSourceThread.OnNoData     := OnNoDataCaptureThread;
    FSourceThread.OnNotifyData := OnNotifyDataCaptureThread;
    FSourceThread.OnTerminate  := OnTerminateCaptureThread;
    FSourceThread.Start;
    FEnabled := True;
  end;
end;

procedure TCVCaptureSource.StopCapture;
begin
  if Assigned(FSourceThread) then
  begin
    FSourceThread.OnNoData     := nil;
    FSourceThread.OnNotifyData := nil;
    FSourceThread.OnTerminate  := nil;
    FreeAndNil(FSourceThread);
  end;
end;

{ TRegisteredCaptureSource }

function TRegisteredCaptureSource.FindByClassName(const ClassName: String): TCVSourceTypeClass;
Var
  i: Integer;
begin
  Result := nil;
  for i  := 0 to Count - 1 do
    if TCVSourceTypeClass(Objects[i]).ClassName = ClassName then
      Exit(TCVSourceTypeClass(Objects[i]));
end;

function TRegisteredCaptureSource.FindByName(const Name: String): TCVSourceTypeClass;
Var
  i: Integer;
begin
  i := IndexOf(Name);
  if i <> -1 then
    Result := TCVSourceTypeClass(Objects[i])
  else
    Result := Nil;
end;

function TRegisteredCaptureSource.GetNameByClass(const IOClass: TClass): String;
Var
  i: Integer;
begin
  Result := '';
  for i  := 0 to Count - 1 do
    if Integer(Objects[i]) = Integer(IOClass) then
    begin
      Result := Self[i];
      Break;
    end;
end;

procedure TRegisteredCaptureSource.RegisterIOClass(const IOClass: TClass; const ClassName: String);
begin
  AddObject(ClassName, TObject(IOClass));
  RegisterClass(TPersistentClass(IOClass));
end;

{ TCVFileSource }

constructor TCVFileSource.Create(AOwner: TPersistent);
begin
  inherited;
  FThreadDelay := 1000 div 25;
end;

procedure TCVFileSource.SetFileName(const Value: TFileName);
begin
  if FFileName <> Value then
  begin
    FFileName := Value;
    DoNotifyChange;
  end;
end;

{ TCVCustomSource }

procedure TCVCustomSource.AssignTo(Dest: TPersistent);
begin
  inherited;

end;

constructor TCVCustomSource.Create(AOwner: TPersistent);
begin
  if AOwner is TComponent then
    inherited Create(AOwner as TComponent)
  else
    inherited Create(nil);
  SetSubComponent(True);
  FOwner := AOwner;
end;

procedure TCVCustomSource.DoNotifyChange;
begin
  if Assigned(FNotifyChange) then
    FNotifyChange(Self);
end;


function TCVCustomSource.GetNamePath: string;
var
  S: string;
  lOwner: TPersistent;
begin
  Result := inherited GetNamePath;
  lOwner := GetOwner;
  if
  { } (lOwner <> nil) and
  { } (
    { } (csSubComponent in TComponent(lOwner).ComponentStyle) or
    { } (TPersistentAccessProtected(lOwner).GetOwner <> nil)
    { } ) then
  begin
    S := lOwner.GetNamePath;
    if S <> '' then
      Result := S + '.' + Result;
  end;
end;

function TCVCustomSource.GetOwner: TPersistent;
begin
  Result := FOwner;
end;

procedure TCVCustomSource.setCaptureAPIs(const Value: TCVVideoCaptureAPIs);
begin
  if FCaptureAPIs <> Value then
  begin
    FCaptureAPIs := Value;
    DoNotifyChange;
  end;
end;

procedure TCVCustomSource.setThreadDelay(const Value: Cardinal);
begin
  if FThreadDelay <> Value then
  begin
    FThreadDelay := Value;
    DoNotifyChange;
  end;
end;

{ TCVWebCameraSource }

constructor TCVWebCameraSource.Create(AOwner: TPersistent);
begin
  inherited;
  FCustomResolution := TCVCustomResolution.Create;
  FResolution       := r800x600;
  FThreadDelay      := 0;
end;

destructor TCVWebCameraSource.Destroy;
begin
  FCustomResolution.Free;
  inherited;
end;

procedure TCVWebCameraSource.setCameraIndex(const Value: Integer);
begin
  if FCameraIndex <> Value then
  begin
    FCameraIndex := Value;
    DoNotifyChange;
  end;
end;

procedure TCVWebCameraSource.SetResolution(const Value: TCVWebCameraResolution);
begin
  if FResolution <> Value then
  begin
    FResolution := Value;
    DoNotifyChange;
  end;
end;

{ TCVCaptureThread }

constructor TCVCaptureThread.Create(const AFileName: string; const AThreadDelay: Cardinal; const VideoAPIs: VideoCaptureAPIs);
begin
  Inherited Create(True);
  FThreadDelay := AThreadDelay;
  FSourceType  := stFile;
  FCapture.open(AFileName, VideoAPIs);
end;

constructor TCVCaptureThread.Create(const ACameraIndex: Integer; const AThreadDelay: Cardinal; const VideoAPIs: VideoCaptureAPIs);
begin
  Inherited Create(True);
  FThreadDelay := AThreadDelay;
  FSourceType  := stStream;
  FCapture.open(ACameraIndex, VideoAPIs);
end;

procedure TCVCaptureThread.Execute;
Var
  frame: TMat;
begin
  while not Terminated do
    try
      FCapture.Read(frame);
      if not Terminated then
      begin
        if not frame.empty then
        begin
          if Assigned(OnNotifyData) then
          begin
            OnNotifyData(Self, frame);
            if FThreadDelay <> 0 then
              Sleep(FThreadDelay);
          end;
        end
        else if Assigned(OnNoData) then
          OnNoData(Self);
      end;
    except
      Break;
    end;
end;

procedure TCVCaptureThread.SetResolution(const Width, Height: Double);
begin
  if FCapture.isOpened then
  begin
    FCapture.&set(CAP_PROP_FRAME_WIDTH, Width);
    FCapture.&set(CAP_PROP_FRAME_HEIGHT, Height);
  end;
end;

procedure TCVCaptureThread.TerminatedSet;
begin
  inherited;
  FCapture.Release;
end;

{ TCVCustomResolution }

procedure TCVCustomResolution.AssignTo(Dest: TPersistent);
begin
  if Dest is TCVCustomResolution then
    with TCVCustomResolution(Dest) do
    begin
      FWidth  := Self.FWidth;
      FHeight := Self.FHeight;
    end
  else
    inherited AssignTo(Dest);
end;

constructor TCVCustomResolution.Create;
begin
  inherited;
  FWidth  := 800;
  FHeight := 600;
end;

initialization

GetRegisteredCaptureSource.RegisterIOClass(TCVWebCameraSource, 'Web camera');
GetRegisteredCaptureSource.RegisterIOClass(TCVFileSource, 'From file or stream');

finalization

if Assigned(_RegisteredCaptureSource) then
  FreeAndNil(_RegisteredCaptureSource);

end.