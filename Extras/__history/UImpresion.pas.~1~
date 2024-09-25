{******************************************************************************}
 //AUTOR: DANIEL RODRIGUEZ HERNÁNDEZ
 //FECHA: 26/03/2022 - 27/03/2022
 //HORA: 04:00 A.M
 //DESCRIPCIÓN: IMPRESIÓN EN ANDROID CON PRINTMANAGER NATIVO
 //INFO1: https://developer.android.com/reference/android/print/PrintManager
 //INFO2: https://developer.android.com/training/printing?hl=es-419
{******************************************************************************}

unit UImpresion;

interface

uses
  Androidapi.JNI.Webkit,
  Androidapi.JNI.Print, System.Messaging,
  fmx.Platform.Android,
  Androidapi.jni,fmx.helpers.android, Androidapi.Jni.app,
  Androidapi.Jni.GraphicsContentViewText, Androidapi.JniBridge,
  Androidapi.JNI.Os, Androidapi.Jni.Telephony,
  Androidapi.JNI.JavaTypes,Androidapi.Helpers,
  Androidapi.JNI.Widget,System.Permissions,Androidapi.JNI.Embarcadero,
  FMX.DialogService,Androidapi.Jni.Provider,Androidapi.Jni.Net,
  fmx.TextLayout,AndroidAPI.JNI.Support;

  type
  //A OCUPAR:
  JPrintJob = interface; {****android/print/PrintJob****}
  JPrintManager = interface; {****android/print/PrintManager****}
  JPrintHelper = interface; {***android/support/v4/print/PrintHelper Delphi Sydney e inferiores***
  (	androidx.print.PrintHelper Delphi 11.0 en adelante según cambien las librerías de Android)}
  JPrintJobClass = interface(JObjectClass)
  ['{E2DEA889-5EBA-AE49-5EC8-5ACD432AE4C9}']
  end;

  //JPrintJob
  [JavaSignature('android/print/PrintJob')]
  JPrintJob = interface(JObject)
  ['{A54E8BA9-874E-3EA8-4E2A-4994EACC4398}']
  function isCompleted: Boolean; cdecl;
  procedure cancel; cdecl;
  procedure restart; cdecl;
  function isStarted: Boolean; cdecl;
  end;
  TJPrintJob = class(TJavaGenericImport<JPrintJobClass, JPrintJob>)
  end;

  //JPrintManager
  JPrintManagerClass = interface(JObjectClass)
  ['{BB34EF80-0E2D-8FA5-5CE6-6AAB5FD8EE9D}']
  end;
  [JavaSignature('android/print/PrintManager')]
  JPrintManager = interface(JObject)
  ['{AAE79EF1-0DEA-71EF-1E07-E4A00ACE0EAD}']
  function print(printJobName: JString; documentAdapter: JPrintDocumentAdapter; attributes: JPrintAttributes): JPrintJob; cdecl;
  end;
  TJPrintManager = class(TJavaGenericImport<JPrintManagerClass, JPrintManager>)
  end;

  //JPrintHelper
  JPrintHelperClass = interface(JObjectClass)
    ['{0DD0CE1A-DA89-EE08-0379-A00EFAA1897A}']
    function init(context: JContext): JPrintHelper; cdecl; //"Constructor"
  end;
  {Las Librerías Androidx se Incluyen en Alexandria
  https://developer.android.com/reference/androidx/print/PrintHelper}
  {$IFDEF VER350} //Delphi 11.0+ Alexandria
  [JavaSignature('androidx/print/PrintHelper')]
  {$ELSE}
  [JavaSignature('android/support/v4/print/PrintHelper')]
  {$ENDIF}
  JPrintHelper = interface(JObject)
  ['{EFD0A902-11AF-68FC-CA8E-90AAF33A006D}']
  function getColorMode: Integer; cdecl;
  function getOrientation: Integer; cdecl;
  function getScaleMode: Integer; cdecl;
  procedure printBitmap(jobName: JString; imageFile: Jnet_Uri); cdecl;
  procedure setOrientation(orientation: Integer); cdecl;
  procedure setScaleMode(scaleMode: Integer); cdecl;
  procedure setColorMode(colorMode: Integer); cdecl;
  end;

  TJPrintHelper = class(TJavaGenericImport<JPrintHelperClass, JPrintHelper>)
  const
  TJPrintHelper_SCALE_MODE_FILL = 2;
  TJPrintHelper_SCALE_MODE_FIT = 1;
  TJPrintHelper_COLOR_MODE_COLOR = 2;
  TJPrintHelper_COLOR_MODE_MONOCHROME = 1;
  TJPrintHelper_ORIENTATION_LANDSCAPE = 1;
  TJPrintHelper_ORIENTATION_PORTRAIT = 2;
  end;

  type
  TJOnWebViewListener = class(TJavaLocal, JOnWebViewListener)
  private
   NombreTrabajo: string;
  public
    procedure doUpdateVisitedHistory(view: JWebView; url: JString; isReload: Boolean); cdecl;
    procedure onFormResubmission(view: JWebView; dontResend: JMessage; resend: JMessage); cdecl;
    procedure onLoadResource(view: JWebView; url: JString); cdecl;
    procedure onPageFinished(view: JWebView; url: JString); cdecl;
    procedure onPageStarted(view: JWebView; url: JString; favicon: JBitmap); cdecl;
    procedure onReceivedError(view: JWebView; errorCode: Integer; description: JString; failingUrl: JString); cdecl;
    procedure onReceivedHttpAuthRequest(view: JWebView; handler: JHttpAuthHandler; host: JString; realm: JString); cdecl;
    procedure onReceivedSslError(view: JWebView; handler: JSslErrorHandler; error: JSslError); cdecl;
    procedure onScaleChanged(view: JWebView; oldScale: Single; newScale: Single); cdecl;
    procedure onUnhandledKeyEvent(view: JWebView; event: JKeyEvent); cdecl;
    function shouldOverrideKeyEvent(view: JWebView; event: JKeyEvent): Boolean; cdecl;
    function shouldOverrideUrlLoading(view: JWebView; url: JString): Boolean; cdecl;
    property JobName: string read NombreTrabajo write NombreTrabajo;
  end;
procedure ImprimirHTML(URL, NombreTrabajo: string);
procedure ImprimirImagen(Ruta,NombreTrabajo:string);
function VerificarSePuedeImprimir: boolean;
implementation
uses System.IOUtils, FMX.Dialogs, System.SysUtils;

{ OnWebViewListener }

procedure TJOnWebViewListener.doUpdateVisitedHistory(view: JWebView; url: JString;
  isReload: Boolean);
begin

end;
procedure TJOnWebViewListener.onFormResubmission(view: JWebView; dontResend,
  resend: JMessage);
begin

end;
procedure TJOnWebViewListener.onLoadResource(view: JWebView; url: JString);
begin

end;
procedure TJOnWebViewListener.onPageFinished(view: JWebView; url: JString);
var PrintManager:JPrintManager;
begin
 PrintManager:=TJPrintManager.Wrap((TAndroidHelper.Context.getSystemService(TJContext.JavaClass.PRINT_SERVICE)as ILocalObject).GetObjectID);
 PrintManager.print(StringToJString(NombreTrabajo), JPrintDocumentAdapter(View.createPrintDocumentAdapter), nil);
end;
procedure TJOnWebViewListener.onPageStarted(view: JWebView; url: JString;
favicon: JBitmap);
begin

end;
procedure TJOnWebViewListener.onReceivedError(view: JWebView; errorCode: Integer;
  description, failingUrl: JString);
begin

end;
procedure TJOnWebViewListener.onReceivedHttpAuthRequest(view: JWebView;
  handler: JHttpAuthHandler; host, realm: JString);
begin

end;
procedure TJOnWebViewListener.onReceivedSslError(view: JWebView;
  handler: JSslErrorHandler; error: JSslError);
begin

end;
procedure TJOnWebViewListener.onScaleChanged(view: JWebView; oldScale,
  newScale: Single);
begin

end;
procedure TJOnWebViewListener.onUnhandledKeyEvent(view: JWebView;
  event: JKeyEvent);
begin

end;
function TJOnWebViewListener.shouldOverrideKeyEvent(view: JWebView;
  event: JKeyEvent): Boolean;
begin
result:=false;
end;
function TJOnWebViewListener.shouldOverrideUrlLoading(view: JWebView;
  url: JString): Boolean;
begin
result:=false;
end;

var mWebView:JWebView;
WebClient:JWebClient;
OnWebViewListener: TJOnWebViewListener;
function doWebViewPrint:boolean;
begin
result:=false;
 try
  if not Assigned(mWebView)then mWebView:=TJWebView.JavaClass.init(TAndroidHelper.Context);
  if not Assigned(WebClient)then WebClient:=TJWebClient.JavaClass.init;
  if not Assigned(OnWebViewListener)then OnWebViewListener:=TJOnWebViewListener.Create;
 result:=true;
 except
 result:=false;
 end;
end;

procedure ImprimirHTML(URL, NombreTrabajo: string);
begin
 CallInUIThread(
 procedure
 begin
  if doWebViewPrint then
  begin
  OnWebViewListener.NombreTrabajo := NombreTrabajo;
  WebClient.SetWebViewListener(OnWebViewListener);
  mWebView.setWebViewClient(WebClient);
  mWebview.getSettings.setAllowFileAccess(true); //ANDROID NIVEL DE API 30+
  mWebview.getSettings.setAllowFileAccessFromFileURLs(true); //ANDROID NIVEL DE API 30+
  mWebView.loadUrl(StringToJString(URL));
  end;
 end);
end;

procedure ImprimirImagen(Ruta,NombreTrabajo:string);
var Impresor: JPrintHelper;
Uri:JNet_Uri;
arch:JFile;
begin
  if not TFile.Exists(Ruta) then
  begin
  ShowMessage('No hay imagen para imprimir');
  end else
  begin
    arch:=TJFile.JavaClass.init(StringToJString(Ruta));
    arch.setReadable(true,false);
    if TJBuild_VERSION.JavaClass.SDK_INT>=24 then //ANDROID 7.0+
     begin
     {Documentacion FileProvider:
     https://developer.android.com/reference/androidx/core/content/FileProvider}
     Uri:=
     {$IFDEF VER350} //DELPHI 11 ALEXANDRIA
     TJcontent_FileProvider.JavaClass.getUriForFile(TAndroidHelper.Context,
     StringToJString(System.Concat(JStringToString(TAndroidHelper.Context.getPackageName),
     '.fileprovider')),arch);
     {$ELSE}        //DELPHI VERSIONES ANTERIORES (DAR MANTENIMIENTO CADA QUE SALGA UNA NUEVA)
     TJFileProvider.JavaClass.getUriForFile(TAndroidHelper.Context,
     StringToJString(System.Concat(JStringToString(TAndroidHelper.Context.getPackageName),
     '.fileprovider')),arch);
     {$ENDIF}
     end else
     begin
     Uri:=TJnet_Uri.JavaClass.fromFile(arch);
     end;
    Impresor := TJPrintHelper.JavaClass.init(TAndroidHelper.Context);
    Impresor.setScaleMode(TJPrintHelper.TJPrintHelper_SCALE_MODE_FIT);
    Impresor.setColorMode(TJPrintHelper.TJPrintHelper_COLOR_MODE_COLOR);
    Impresor.setOrientation(TJPrintHelper.TJPrintHelper_ORIENTATION_PORTRAIT);
    Impresor.printBitmap(StringToJString(NombreTrabajo), Uri);
  end;
end;

function VerificarSePuedeImprimir: boolean;
begin
 if TJBuild_VERSION.JavaClass.SDK_INT>=23 then
 begin
 result:=true;
 end else result:=false;
end;

procedure RegistrarTipos;
begin
TRegTypes.RegisterType('UImpresion.JPrintJob', TypeInfo(UImpresion.JPrintJob));
TRegTypes.RegisterType('UImpresion.JPrintManager', TypeInfo(UImpresion.JPrintManager));
TRegTypes.RegisterType('UImpresion.JPrintHelper', TypeInfo(UImpresion.JPrintHelper));
end;

initialization
  RegistrarTipos;
end.
