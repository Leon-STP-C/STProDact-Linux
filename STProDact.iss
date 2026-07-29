; ST-PRO DACT Setup Script
;
; Change log
; - 2.2.0
;   * new App-package V2.2.0
;      * new App Name ST-PRO DACT
;      * added settings-page
;      * added input for variable poll intervall
;      * optimized strategy for updating daily tables depending on adjusted poll intervall
;      * optimized collection of data for trends taking variable poll intervall into account
;      * dark mode added
;      * added widgets to dashboard catalog
; - 2.0.0
;   * new App-package V2.0.0
;      * new dashboard and widget-plugin-system included in application
; - 1.0.7
;   * new App-package V1.0.2
;      * bug fix on chart creation in case of empty tbl_archiveconfig
;      * fix in browser - unit input for boolean variables disabled
; - 1.0.6
;   * Added maintenance page for install, reinstall, and uninstall actions per component
;   * Renamed visible UI text from HeidiSQL to ST-PRO DACT DB Manager
;   * Added optional removal of ProgramData application data during ST-PRO DACT uninstall
;   * Improved MySQL data-directory reuse on reinstall
;   * Improved core uninstall cleanup and registry cleanup
;   * Improved maintenance page layout and action button captions
;

#define MyAppName "ST-PRO DACT"
#define MyAppVersion "2.2.0"
#define MyAppPublisher "STP-Controls"

#define InstallerVersion "2.2.0"
#define CoreBaseVersion "1.0.1"
#define AppVersion "2.2.0"
#define NodeModulesVersion "1.0.1"
#define HeidiSQLVersion "12.8.0"

#define RegBaseKey "Software\STP-Controls\STProDact"

#define MySqlServiceName "MySQLSTProDact"
#define AppServiceUser "STProDactSvc"
#define AppServicePassword "DrSvc_2026_NodeOpcUa_9Kf4L2m7"

[Setup]
AppId={{B2AFAEB9-1A7E-49DD-9E08-2D61B65A1A11}
AppName={#MyAppName}
AppVersion={#MyAppVersion}
AppPublisher={#MyAppPublisher}
DefaultDirName={autopf}\{#MyAppName}
PrivilegesRequired=admin
ArchitecturesAllowed=x64compatible
ArchitecturesInstallIn64BitMode=x64compatible
Compression=lzma2
SolidCompression=yes
DisableProgramGroupPage=yes
SetupLogging=yes
UsePreviousSetupType=no
OutputDir={#SourcePath}\output
OutputBaseFilename=ST-PRO-DACT-Setup-{#MyAppVersion}_x64

[Languages]
Name: "en"; MessagesFile: "compiler:Default.isl"

[Types]
Name: "full"; Description: "Full installation"
Name: "custom"; Description: "Custom installation"; Flags: iscustom

[Components]
Name: "core"; Description: "ST-PRO DACT (App, MySQL, Caddy, Services)"; Types: full custom
Name: "heidisql"; Description: "Install DB manager (optional for database maintenance)"; Types: custom; Flags: disablenouninstallwarning

[Dirs]
Name: "{commonappdata}\{#MyAppName}\config"
Name: "{commonappdata}\{#MyAppName}\logs"
Name: "{commonappdata}\{#MyAppName}\mysql"
Name: "{commonappdata}\{#MyAppName}\mysql-data"
Name: "{commonappdata}\{#MyAppName}\caddy"
Name: "{commonappdata}\{#MyAppName}\caddy\config"
Name: "{commonappdata}\{#MyAppName}\caddy\data"
Name: "{commonappdata}\{#MyAppName}\appdata"
Name: "{commonappdata}\{#MyAppName}\appdata\Roaming"
Name: "{commonappdata}\{#MyAppName}\appdata\Local"
Name: "{commonappdata}\{#MyAppName}\profile"
Name: "{commonappdata}\{#MyAppName}\tmp"
Name: "{commonappdata}\{#MyAppName}\HeidiSQL"; Permissions: users-modify

[Files]
; Core runtime and tools
Source: "..\thirdparty\vc_redist.x64.exe"; DestDir: "{tmp}"; Flags: deleteafterinstall; Components: core; Check: ShouldInstallCoreFiles
Source: "..\thirdparty\7za.exe"; DestDir: "{tmp}"; Flags: deleteafterinstall; Components: core; Check: ShouldInstallCoreFiles

Source: "..\packages\app-package.zip"; DestDir: "{tmp}"; Flags: deleteafterinstall; Components: core; Check: ShouldInstallCoreFiles
Source: "..\packages\node-modules-package.zip"; DestDir: "{tmp}"; Flags: deleteafterinstall; Components: core; Check: ShouldInstallCoreFiles

Source: "..\runtime\node\node.exe"; DestDir: "{app}\node"; Flags: ignoreversion; Components: core; Check: ShouldInstallCoreFiles
Source: "..\runtime\caddy\caddy.exe"; DestDir: "{app}\caddy"; Flags: ignoreversion; Components: core; Check: ShouldInstallCoreFiles
Source: "..\runtime\mysql\*"; DestDir: "{app}\mysql"; Flags: recursesubdirs ignoreversion; Components: core; Check: ShouldInstallCoreFiles

Source: "..\config\Caddyfile"; DestDir: "{commonappdata}\{#MyAppName}\config"; Flags: onlyifdoesntexist ignoreversion; Components: core; Check: ShouldInstallCoreFiles

Source: "..\service\winsw.exe"; DestDir: "{app}\service"; DestName: "STProDactAppSvc.exe"; Flags: ignoreversion; Components: core; Check: ShouldInstallCoreFiles
Source: "..\service\STProDactApp.xml"; DestDir: "{app}\service"; DestName: "STProDactAppSvc.xml"; Flags: ignoreversion; Components: core; Check: ShouldInstallCoreFiles

Source: "..\service\winsw.exe"; DestDir: "{app}\service"; DestName: "STProDactProxySvc.exe"; Flags: ignoreversion; Components: core; Check: ShouldInstallCoreFiles
Source: "..\service\STProDactProxy.xml"; DestDir: "{app}\service"; DestName: "STProDactProxySvc.xml"; Flags: ignoreversion; Components: core; Check: ShouldInstallCoreFiles

; HeidiSQL
Source: "..\thirdparty\heidisql\*"; DestDir: "{app}\tools\HeidiSQL"; Flags: recursesubdirs createallsubdirs ignoreversion; Components: heidisql
Source: "..\thirdparty\heidisql-config\portable_settings.txt"; DestDir: "{commonappdata}\{#MyAppName}\HeidiSQL"; Flags: onlyifdoesntexist ignoreversion; Components: heidisql

[InstallDelete]
Type: files; Name: "{app}\tools\HeidiSQL\portable.lock"; Components: heidisql
Type: files; Name: "{app}\tools\HeidiSQL\portable_settings.txt"; Components: heidisql
Type: files; Name: "{app}\tools\HeidiSQL\tabs.ini"; Components: heidisql
Type: files; Name: "{app}\tools\HeidiSQL\heidisql.ini"; Components: heidisql

[Icons]
Name: "{group}\ST-PRO DACT DB Manager"; Filename: "{app}\tools\HeidiSQL\HeidiSQL.exe"; Parameters: "--psettings=""{commonappdata}\{#MyAppName}\HeidiSQL\portable_settings.txt"" --description=""OPCUA"" -h=""127.0.0.1"" -u=""opcua"" -p=""opcua"" -P=3306 -n=0 -l=""libmariadb.dll"""; Components: heidisql

[UninstallRun]
Filename: "{app}\service\STProDactProxySvc.exe"; Parameters: "stop"; Flags: runhidden waituntilterminated skipifdoesntexist; RunOnceId: "stop_proxy"
Filename: "{app}\service\STProDactAppSvc.exe"; Parameters: "stop"; Flags: runhidden waituntilterminated skipifdoesntexist; RunOnceId: "stop_app"
Filename: "{app}\service\STProDactProxySvc.exe"; Parameters: "uninstall"; Flags: runhidden waituntilterminated skipifdoesntexist; RunOnceId: "uninstall_proxy"
Filename: "{app}\service\STProDactAppSvc.exe"; Parameters: "uninstall"; Flags: runhidden waituntilterminated skipifdoesntexist; RunOnceId: "uninstall_app"
Filename: "{sys}\net.exe"; Parameters: "stop {#MySqlServiceName}"; Flags: runhidden waituntilterminated; RunOnceId: "stop_mysql"
Filename: "{app}\mysql\bin\mysqld.exe"; Parameters: "--remove {#MySqlServiceName}"; Flags: runhidden waituntilterminated skipifdoesntexist; RunOnceId: "remove_mysql"
Filename: "{sys}\netsh.exe"; Parameters: "advfirewall firewall delete rule name=""ST-PRO DACT HTTP"""; Flags: runhidden waituntilterminated; RunOnceId: "fw_delete"


[Code]
type
  TDrComponentState = (dcsNotInstalled, dcsInstalled, dcsBroken);
  TDrComponentAction = (dcaNoChange, dcaInstall, dcaReinstall, dcaUninstall);

var
  InstallCoreThisRun: Boolean;
  HeidiSelectedThisRun: Boolean;
  ExistingInstallDetected: Boolean;
  RepairDetected: Boolean;
  CorePreviouslyInstalled: Boolean;
  HeidiPreviouslyInstalled: Boolean;
  RemoveHeidiThisRun: Boolean;
  RemoveCoreThisRun: Boolean;
  ReinstallCoreThisRun: Boolean;
  ReinstallHeidiThisRun: Boolean;

  MaintenancePage: TWizardPage;
  CoreStatusLabel: TNewStaticText;
  HeidiStatusLabel: TNewStaticText;
  CoreActionLabel: TNewStaticText;
  HeidiActionLabel: TNewStaticText;
  CoreActionCombo: TNewComboBox;
  HeidiActionCombo: TNewComboBox;
  MaintenanceIntroLabel: TNewStaticText;
  RemoveDataCheck: TNewCheckBox;
  RemoveDataHintLabel: TNewStaticText;
  RemoveAppDataThisRun: Boolean;

  CoreState: TDrComponentState;
  HeidiState: TDrComponentState;
  CoreAction: TDrComponentAction;
  HeidiAction: TDrComponentAction;
  MaintenanceInitializedForDir: String;

procedure UpdateActionButtonCaptions(); forward;
procedure LayoutMaintenancePage(); forward;
function DrDirHasAnyEntries(const DirPath: String): Boolean; forward;

function BoolText(const B: Boolean): String;
begin
  if B then
    Result := 'True'
  else
    Result := 'False';
end;

function CombinePath(const BaseDir, RelPath: String): String;
begin
  Result := AddBackslash(BaseDir) + RelPath;
end;

procedure LogMsg(const S: String);
begin
  Log('[ST-PRO DACT] ' + S);
end;

function LogDir(): String;
begin
  Result := ExpandConstant('{commonappdata}\{#MyAppName}\logs');
end;

function MySqlIniPath(): String;
begin
  Result := ExpandConstant('{commonappdata}\{#MyAppName}\mysql\my.ini');
end;

function MySqlDataDir(): String;
begin
  Result := ExpandConstant('{commonappdata}\{#MyAppName}\mysql-data');
end;

function MySqlInitializedMarker(): String;
begin
  Result := ExpandConstant('{commonappdata}\{#MyAppName}\mysql-data\.initialized');
end;

function MySqlNotInitialized(): Boolean;
begin
  Result := not FileExists(MySqlInitializedMarker());
end;

function MySqlDataDirLooksInitialized(): Boolean;
begin
  Result :=
    DrDirHasAnyEntries(MySqlDataDir()) and
    (
      FileExists(AddBackslash(MySqlDataDir()) + 'auto.cnf') or
      DirExists(AddBackslash(MySqlDataDir()) + 'mysql') or
      FileExists(AddBackslash(MySqlDataDir()) + 'ibdata1') or
      FileExists(AddBackslash(MySqlDataDir()) + 'ib_logfile0') or
      FileExists(AddBackslash(MySqlDataDir()) + 'ibtmp1') or
      FileExists(AddBackslash(MySqlDataDir()) + 'undo_001') or
      FileExists(AddBackslash(MySqlDataDir()) + 'undo_002')
    );
end;

function ShouldInitializeMySqlDataDir(): Boolean;
begin
  Result := MySqlNotInitialized() and (not MySqlDataDirLooksInitialized());
end;

function ShouldInstallCoreFiles(): Boolean;
begin
  Result := InstallCoreThisRun;
end;

function DrDirHasAnyEntries(const DirPath: String): Boolean;
var
  FindRec: TFindRec;
begin
  Result := False;

  if not DirExists(DirPath) then
    Exit;

  if FindFirst(AddBackslash(DirPath) + '*', FindRec) then
  begin
    try
      repeat
        if (FindRec.Name <> '.') and (FindRec.Name <> '..') then
        begin
          Result := True;
          Exit;
        end;
      until not FindNext(FindRec);
    finally
      FindClose(FindRec);
    end;
  end;
end;

function CoreBaseInstalledAtDir(const BaseDir: String): Boolean;
begin
  Result :=
    FileExists(CombinePath(BaseDir, 'service\STProDactAppSvc.exe')) and
    FileExists(CombinePath(BaseDir, 'service\STProDactAppSvc.xml')) and
    FileExists(CombinePath(BaseDir, 'service\STProDactProxySvc.exe')) and
    FileExists(CombinePath(BaseDir, 'service\STProDactProxySvc.xml')) and
    FileExists(CombinePath(BaseDir, 'mysql\bin\mysqld.exe')) and
    FileExists(CombinePath(BaseDir, 'node\node.exe')) and
    FileExists(CombinePath(BaseDir, 'caddy\caddy.exe'));
end;

function AppPayloadInstalledAtDir(const BaseDir: String): Boolean;
begin
  Result :=
    FileExists(CombinePath(BaseDir, 'app\server.js')) and
    FileExists(CombinePath(BaseDir, 'app\package.json'));
end;

function NodeModulesInstalledAtDir(const BaseDir: String): Boolean;
begin
  Result := DrDirHasAnyEntries(CombinePath(BaseDir, 'app\node_modules'));
end;

function HeidiSqlInstalledAtDir(const BaseDir: String): Boolean;
begin
  Result := FileExists(CombinePath(BaseDir, 'tools\HeidiSQL\HeidiSQL.exe'));
end;

function CompleteInstallAtDir(const BaseDir: String): Boolean;
begin
  Result :=
    CoreBaseInstalledAtDir(BaseDir) and
    AppPayloadInstalledAtDir(BaseDir) and
    NodeModulesInstalledAtDir(BaseDir);
end;

function RegistryIndicatesInstallAtDir(const BaseDir: String): Boolean;
var
  InstalledValue: Cardinal;
  InstallPath: String;
begin
  Result := False;

  if not RegQueryStringValue(HKLM, '{#RegBaseKey}', 'InstallPath', InstallPath) then
    Exit;
  if not RegQueryDWordValue(HKLM, '{#RegBaseKey}', 'Installed', InstalledValue) then
    Exit;

  Result :=
    (InstalledValue = 1) and
    (CompareText(RemoveBackslashUnlessRoot(InstallPath), RemoveBackslashUnlessRoot(BaseDir)) = 0);
end;

function RepairRequiredAtDir(const BaseDir: String): Boolean;
var
  HasCoreBase: Boolean;
  HasAppPayload: Boolean;
  HasNodeModules: Boolean;
  HasAnyEvidence: Boolean;
begin
  HasCoreBase := CoreBaseInstalledAtDir(BaseDir);
  HasAppPayload := AppPayloadInstalledAtDir(BaseDir);
  HasNodeModules := NodeModulesInstalledAtDir(BaseDir);

  if CompleteInstallAtDir(BaseDir) then
  begin
    Result := False;
    Exit;
  end;

  HasAnyEvidence :=
    HasCoreBase or
    HasAppPayload or
    HasNodeModules or
    DirExists(CombinePath(BaseDir, 'service')) or
    DirExists(CombinePath(BaseDir, 'app')) or
    DirExists(CombinePath(BaseDir, 'mysql')) or
    DirExists(CombinePath(BaseDir, 'node')) or
    DirExists(CombinePath(BaseDir, 'caddy')) or
    RegistryIndicatesInstallAtDir(BaseDir);

  Result := HasAnyEvidence;
end;

function CoreAlreadyInstalled(): Boolean;
begin
  Result := CoreBaseInstalledAtDir(ExpandConstant('{app}'));
end;

function StateText(const State: TDrComponentState): String;
begin
  case State of
    dcsNotInstalled: Result := 'Not installed';
    dcsInstalled: Result := 'Installed';
    dcsBroken: Result := 'Incomplete / repair required';
  end;
end;

function ActionText(const Action: TDrComponentAction): String;
begin
  case Action of
    dcaNoChange: Result := 'Do not change';
    dcaInstall: Result := 'Install';
    dcaReinstall: Result := 'Reinstall / replace';
    dcaUninstall: Result := 'Uninstall';
  end;
end;

procedure UpdateRemoveDataOptionVisibility();
begin
  if RemoveDataCheck = nil then
    Exit;

  RemoveDataCheck.Visible := RemoveCoreThisRun;
  RemoveDataHintLabel.Visible := RemoveCoreThisRun;

  if not RemoveCoreThisRun then
    RemoveDataCheck.Checked := False;

  LayoutMaintenancePage();
end;

function AppDataActionText(): String;
begin
  if not RemoveCoreThisRun then
    Result := 'Not applicable'
  else if RemoveAppDataThisRun then
    Result := 'Will be removed'
  else
    Result := 'Will be kept';
end;

function CurrentTargetInstallModeText(): String;
begin
  if CompleteInstallAtDir(WizardDirValue()) then
    Result := 'Existing'
  else if RepairRequiredAtDir(WizardDirValue()) then
    Result := 'Repair'
  else
    Result := 'Fresh';
end;

function GetComboAction(const Combo: TNewComboBox): TDrComponentAction;
var
  S: String;
begin
  if Combo.ItemIndex < 0 then
  begin
    Result := dcaNoChange;
    Exit;
  end;

  S := Combo.Items[Combo.ItemIndex];
  if CompareText(S, ActionText(dcaInstall)) = 0 then
    Result := dcaInstall
  else if CompareText(S, ActionText(dcaReinstall)) = 0 then
    Result := dcaReinstall
  else if CompareText(S, ActionText(dcaUninstall)) = 0 then
    Result := dcaUninstall
  else
    Result := dcaNoChange;
end;

procedure SelectComboAction(const Combo: TNewComboBox; const Action: TDrComponentAction);
var
  I: Integer;
  S: String;
begin
  S := ActionText(Action);
  for I := 0 to Combo.Items.Count - 1 do
    if CompareText(Combo.Items[I], S) = 0 then
    begin
      Combo.ItemIndex := I;
      Exit;
    end;

  if Combo.Items.Count > 0 then
    Combo.ItemIndex := 0
  else
    Combo.ItemIndex := -1;
end;

procedure DetectInstalledStates();
begin
  if CompleteInstallAtDir(WizardDirValue()) then
    CoreState := dcsInstalled
  else if RepairRequiredAtDir(WizardDirValue()) then
    CoreState := dcsBroken
  else
    CoreState := dcsNotInstalled;

  if HeidiSqlInstalledAtDir(WizardDirValue()) then
    HeidiState := dcsInstalled
  else
    HeidiState := dcsNotInstalled;

  ExistingInstallDetected := (CoreState = dcsInstalled);
  RepairDetected := (CoreState = dcsBroken);

  LogMsg(
    'DetectInstalledStates: Mode=' + CurrentTargetInstallModeText() +
    ', CoreState=' + StateText(CoreState) +
    ', HeidiState=' + StateText(HeidiState) +
    ', TargetDir=' + WizardDirValue()
  );
end;

procedure PopulateActionCombos();
begin
  CoreActionCombo.Items.Clear;
  case CoreState of
    dcsNotInstalled:
      begin
        CoreActionCombo.Items.Add(ActionText(dcaInstall));
        CoreAction := dcaInstall;
      end;
    dcsInstalled:
      begin
        CoreActionCombo.Items.Add(ActionText(dcaNoChange));
        CoreActionCombo.Items.Add(ActionText(dcaReinstall));
        CoreActionCombo.Items.Add(ActionText(dcaUninstall));
        CoreAction := dcaNoChange;
      end;
    dcsBroken:
      begin
        CoreActionCombo.Items.Add(ActionText(dcaReinstall));
        CoreActionCombo.Items.Add(ActionText(dcaUninstall));
        CoreAction := dcaReinstall;
      end;
  end;
  SelectComboAction(CoreActionCombo, CoreAction);

  HeidiActionCombo.Items.Clear;
  case HeidiState of
    dcsNotInstalled:
      begin
        HeidiActionCombo.Items.Add(ActionText(dcaNoChange));
        HeidiActionCombo.Items.Add(ActionText(dcaInstall));
        HeidiAction := dcaNoChange;
      end;
    dcsInstalled:
      begin
        HeidiActionCombo.Items.Add(ActionText(dcaNoChange));
        HeidiActionCombo.Items.Add(ActionText(dcaReinstall));
        HeidiActionCombo.Items.Add(ActionText(dcaUninstall));
        HeidiAction := dcaNoChange;
      end;
    dcsBroken:
      begin
        HeidiActionCombo.Items.Add(ActionText(dcaNoChange));
        HeidiActionCombo.Items.Add(ActionText(dcaInstall));
        HeidiAction := dcaNoChange;
      end;
  end;
  SelectComboAction(HeidiActionCombo, HeidiAction);
end;

function DetermineWizardActionCaption(): String;
begin
  if RemoveCoreThisRun and (not InstallCoreThisRun) and RemoveHeidiThisRun and (not HeidiSelectedThisRun) then
    Result := '&Uninstall'
  else if RemoveCoreThisRun and (not InstallCoreThisRun) and (not HeidiSelectedThisRun) and (not RemoveHeidiThisRun) then
    Result := '&Uninstall'
  else if RemoveHeidiThisRun and (not HeidiSelectedThisRun) and (not InstallCoreThisRun) and (not RemoveCoreThisRun) then
    Result := '&Uninstall'
  else if (InstallCoreThisRun or HeidiSelectedThisRun) and (RemoveCoreThisRun or RemoveHeidiThisRun) then
    Result := '&Apply'
  else
    Result := SetupMessage(msgButtonInstall);
end;

procedure UpdateMaintenancePageLabels();
begin
  CoreStatusLabel.Caption := 'ST-PRO DACT - Status: ' + StateText(CoreState);
  HeidiStatusLabel.Caption := 'ST-PRO DACT DB Manager - Status: ' + StateText(HeidiState);
end;

procedure RefreshSelectionState();
begin
  DetectInstalledStates();

  if MaintenancePage <> nil then
  begin
    UpdateMaintenancePageLabels();
    CoreAction := GetComboAction(CoreActionCombo);
    HeidiAction := GetComboAction(HeidiActionCombo);
  end;

  InstallCoreThisRun := (CoreAction = dcaInstall) or (CoreAction = dcaReinstall);
  ReinstallCoreThisRun := (CoreAction = dcaReinstall);
  RemoveCoreThisRun := (CoreAction = dcaUninstall);

  HeidiSelectedThisRun := (HeidiAction = dcaInstall) or (HeidiAction = dcaReinstall);
  ReinstallHeidiThisRun := (HeidiAction = dcaReinstall);
  RemoveHeidiThisRun := (HeidiAction = dcaUninstall);

  if RemoveDataCheck <> nil then
    RemoveAppDataThisRun := RemoveCoreThisRun and RemoveDataCheck.Checked
  else
    RemoveAppDataThisRun := False;

  UpdateRemoveDataOptionVisibility();
  UpdateActionButtonCaptions();

  LogMsg(
    'RefreshSelectionState: CoreAction=' + ActionText(CoreAction) +
    ', HeidiAction=' + ActionText(HeidiAction) +
    ', InstallCoreThisRun=' + BoolText(InstallCoreThisRun) +
    ', RemoveCoreThisRun=' + BoolText(RemoveCoreThisRun) +
    ', HeidiSelectedThisRun=' + BoolText(HeidiSelectedThisRun) +
    ', RemoveHeidiThisRun=' + BoolText(RemoveHeidiThisRun) +
    ', RemoveAppDataThisRun=' + BoolText(RemoveAppDataThisRun)
  );
end;

procedure ApplyWizardComponentsFromActions();
begin
  if InstallCoreThisRun then
  begin
    if HeidiSelectedThisRun then
      WizardSelectComponents('core,heidisql')
    else
      WizardSelectComponents('core');
  end
  else
  begin
    if HeidiSelectedThisRun then
      WizardSelectComponents('heidisql')
    else
      WizardSelectComponents('');
  end;

  LogMsg('ApplyWizardComponentsFromActions executed.');
end;

procedure RebuildMaintenanceDefaults();
begin
  DetectInstalledStates();
  PopulateActionCombos();
  UpdateMaintenancePageLabels();
  MaintenanceInitializedForDir := RemoveBackslashUnlessRoot(WizardDirValue());
  RefreshSelectionState();
end;

procedure SetStepText(const Msg: String);
begin
  WizardForm.StatusLabel.Caption := Msg;
  WizardForm.Repaint;
  LogMsg('STATUS: ' + Msg);
end;

procedure FailStep(const Msg: String);
begin
  LogMsg('FAIL: ' + Msg);
  MsgBox(Msg, mbError, MB_OK);
  RaiseException(Msg);
end;

procedure LogFileTailIfExists(const FilePath, Title: String; MaxLines: Integer);
var
  Lines: TArrayOfString;
  I: Integer;
  StartIndex: Integer;
begin
  if not FileExists(FilePath) then
  begin
    LogMsg(Title + ': file not found -> ' + FilePath);
    Exit;
  end;

  if not LoadStringsFromFile(FilePath, Lines) then
  begin
    LogMsg(Title + ': could not read file');
    Exit;
  end;

  StartIndex := GetArrayLength(Lines) - MaxLines;
  if StartIndex < 0 then
    StartIndex := 0;

  LogMsg('----- BEGIN ' + Title + ' -----');
  for I := StartIndex to GetArrayLength(Lines) - 1 do
    LogMsg(Lines[I]);
  LogMsg('----- END ' + Title + ' -----');
end;

procedure LogServiceState(const ServiceName: String);
var
  ResultCode: Integer;
  TmpFile: String;
begin
  TmpFile := ExpandConstant('{tmp}\svc_' + ServiceName + '.log');

  Exec(
    ExpandConstant('{sys}\cmd.exe'),
    '/C sc query "' + ServiceName + '" > "' + TmpFile + '" 2>&1',
    '',
    SW_HIDE,
    ewWaitUntilTerminated,
    ResultCode
  );

  LogMsg('sc query ' + ServiceName + ' -> exit code ' + IntToStr(ResultCode));
  LogFileTailIfExists(TmpFile, 'Service state: ' + ServiceName, 50);
end;

procedure LogServiceDiagnostics(const ServiceId, ServiceExePath, ServiceXmlPath: String);
begin
  LogMsg('Service diagnostics for ' + ServiceId);
  LogMsg('EXE exists: ' + BoolText(FileExists(ServiceExePath)) + ' -> ' + ServiceExePath);
  LogMsg('XML exists: ' + BoolText(FileExists(ServiceXmlPath)) + ' -> ' + ServiceXmlPath);
  LogServiceState(ServiceId);
  LogFileTailIfExists(LogDir() + '\' + ServiceId + '.out.log', ServiceId + ' OUT LOG', 80);
  LogFileTailIfExists(LogDir() + '\' + ServiceId + '.err.log', ServiceId + ' ERR LOG', 80);
end;

procedure ExecChecked(const FileName, Params, VisibleMsg, ErrorContext, AcceptCodes: String);
var
  ResultCode: Integer;
  Ok: Boolean;
  CodeText: String;
begin
  SetStepText(VisibleMsg);
  LogMsg('EXEC: "' + FileName + '" ' + Params);

  Ok := Exec(FileName, Params, '', SW_HIDE, ewWaitUntilTerminated, ResultCode);
  LogMsg('EXEC RESULT: ok=' + BoolText(Ok) + ', code=' + IntToStr(ResultCode));

  if not Ok then
    FailStep(ErrorContext + #13#10 + 'The process could not be started.');

  CodeText := ',' + IntToStr(ResultCode) + ',';
  if Pos(CodeText, ',' + AcceptCodes + ',') = 0 then
    FailStep(ErrorContext + #13#10 + 'Return code: ' + IntToStr(ResultCode));
end;

procedure ExecServiceChecked(
  const FileName, Params, VisibleMsg, ErrorContext, AcceptCodes, ServiceId, ServiceExePath, ServiceXmlPath: String);
var
  ResultCode: Integer;
  Ok: Boolean;
  CodeText: String;
begin
  SetStepText(VisibleMsg);
  LogMsg('SERVICE EXEC: "' + FileName + '" ' + Params);

  Ok := Exec(FileName, Params, '', SW_HIDE, ewWaitUntilTerminated, ResultCode);
  LogMsg('SERVICE EXEC RESULT: ok=' + BoolText(Ok) + ', code=' + IntToStr(ResultCode));

  if not Ok then
  begin
    LogServiceDiagnostics(ServiceId, ServiceExePath, ServiceXmlPath);
    FailStep(ErrorContext + #13#10 + 'The process could not be started.');
  end;

  CodeText := ',' + IntToStr(ResultCode) + ',';
  if Pos(CodeText, ',' + AcceptCodes + ',') = 0 then
  begin
    LogServiceDiagnostics(ServiceId, ServiceExePath, ServiceXmlPath);
    FailStep(ErrorContext + #13#10 + 'Return code: ' + IntToStr(ResultCode));
  end;
end;

procedure WaitSeconds(const Seconds: Integer);
var
  ResultCode: Integer;
begin
  if Seconds <= 0 then
    Exit;

  Exec(
    ExpandConstant('{sys}\cmd.exe'),
    '/C timeout /t ' + IntToStr(Seconds) + ' /nobreak >nul',
    '',
    SW_HIDE,
    ewWaitUntilTerminated,
    ResultCode
  );

  LogMsg('WaitSeconds(' + IntToStr(Seconds) + ') result: ' + IntToStr(ResultCode));
end;

function ServiceStateContains(const ServiceName, ExpectedState: String): Boolean;
var
  ResultCode: Integer;
  TmpFile: String;
  Lines: TArrayOfString;
  I: Integer;
  ULine: String;
  UExpected: String;
begin
  Result := False;
  TmpFile := ExpandConstant('{tmp}\svc_state_' + ServiceName + '.log');
  UExpected := Uppercase(ExpectedState);

  Exec(
    ExpandConstant('{sys}\cmd.exe'),
    '/C sc query "' + ServiceName + '" > "' + TmpFile + '" 2>&1',
    '',
    SW_HIDE,
    ewWaitUntilTerminated,
    ResultCode
  );

  LogMsg('ServiceStateContains: sc query ' + ServiceName + ' -> exit code ' + IntToStr(ResultCode));

  if not FileExists(TmpFile) then
  begin
    LogMsg('ServiceStateContains: output file not found -> ' + TmpFile);
    Exit;
  end;

  if not LoadStringsFromFile(TmpFile, Lines) then
  begin
    LogMsg('ServiceStateContains: could not read output file -> ' + TmpFile);
    Exit;
  end;

  for I := 0 to GetArrayLength(Lines) - 1 do
  begin
    ULine := Uppercase(Trim(Lines[I]));
    if Pos(UExpected, ULine) > 0 then
    begin
      Result := True;
      Exit;
    end;
  end;
end;

function WaitForServiceState(const ServiceName, ExpectedState: String; Attempts, DelaySeconds: Integer): Boolean;
var
  I: Integer;
begin
  Result := False;

  for I := 1 to Attempts do
  begin
    LogMsg(
      'WaitForServiceState: service=' + ServiceName +
      ', expected=' + ExpectedState +
      ', attempt=' + IntToStr(I) + '/' + IntToStr(Attempts)
    );

    if ServiceStateContains(ServiceName, ExpectedState) then
    begin
      Result := True;
      Exit;
    end;

    if I < Attempts then
      WaitSeconds(DelaySeconds);
  end;
end;

procedure EnsureServiceRunning(
  const ServiceName, FriendlyName, ServiceExePath, ServiceXmlPath: String;
  Attempts, DelaySeconds: Integer);
begin
  SetStepText('Verifying ' + FriendlyName + ' service health...');

  if not WaitForServiceState(ServiceName, 'RUNNING', Attempts, DelaySeconds) then
  begin
    LogServiceDiagnostics(ServiceName, ServiceExePath, ServiceXmlPath);
    FailStep(
      FriendlyName + ' service did not reach the RUNNING state.' + #13#10 +
      'See the setup log and service logs for details.'
    );
  end;

  LogMsg(FriendlyName + ' service is RUNNING.');
end;

function ServiceExists(const ServiceName: String): Boolean;
var
  ResultCode: Integer;
begin
  Result := Exec(
    ExpandConstant('{sys}\sc.exe'),
    'query "' + ServiceName + '"',
    '',
    SW_HIDE,
    ewWaitUntilTerminated,
    ResultCode
  ) and (ResultCode = 0);

  LogMsg('ServiceExists(' + ServiceName + ')=' + BoolText(Result));
end;

function GetServiceState(const ServiceName: String): String;
var
  ResultCode: Integer;
  TmpFile: String;
  Lines: TArrayOfString;
  I: Integer;
  ULine: String;
begin
  Result := '';
  TmpFile := ExpandConstant('{tmp}\svc_state_current_' + ServiceName + '.log');

  Exec(
    ExpandConstant('{sys}\cmd.exe'),
    '/C sc query "' + ServiceName + '" > "' + TmpFile + '" 2>&1',
    '',
    SW_HIDE,
    ewWaitUntilTerminated,
    ResultCode
  );

  if not FileExists(TmpFile) then
    Exit;

  if not LoadStringsFromFile(TmpFile, Lines) then
    Exit;

  for I := 0 to GetArrayLength(Lines) - 1 do
  begin
    ULine := Uppercase(Trim(Lines[I]));

    if Pos('STOPPED', ULine) > 0 then
    begin
      Result := 'STOPPED';
      Exit;
    end;

    if Pos('RUNNING', ULine) > 0 then
    begin
      Result := 'RUNNING';
      Exit;
    end;

    if Pos('STOP_PENDING', ULine) > 0 then
    begin
      Result := 'STOP_PENDING';
      Exit;
    end;

    if Pos('START_PENDING', ULine) > 0 then
    begin
      Result := 'START_PENDING';
      Exit;
    end;

    if Pos('PAUSED', ULine) > 0 then
    begin
      Result := 'PAUSED';
      Exit;
    end;
  end;
end;

function ExtractDigits(const S: String): String;
var
  I: Integer;
begin
  Result := '';
  for I := 1 to Length(S) do
    if (S[I] >= '0') and (S[I] <= '9') then
      Result := Result + S[I];
end;

function GetServicePid(const ServiceName: String): Integer;
var
  ResultCode: Integer;
  TmpFile: String;
  Lines: TArrayOfString;
  I: Integer;
  ULine: String;
  Digits: String;
begin
  Result := 0;
  TmpFile := ExpandConstant('{tmp}\svc_pid_' + ServiceName + '.log');

  Exec(
    ExpandConstant('{sys}\cmd.exe'),
    '/C sc queryex "' + ServiceName + '" > "' + TmpFile + '" 2>&1',
    '',
    SW_HIDE,
    ewWaitUntilTerminated,
    ResultCode
  );

  if not FileExists(TmpFile) then
    Exit;

  if not LoadStringsFromFile(TmpFile, Lines) then
    Exit;

  for I := 0 to GetArrayLength(Lines) - 1 do
  begin
    ULine := Uppercase(Trim(Lines[I]));
    if Pos('PID', ULine) > 0 then
    begin
      Digits := ExtractDigits(ULine);
      if Digits <> '' then
      begin
        Result := StrToIntDef(Digits, 0);
        Exit;
      end;
    end;
  end;
end;

procedure ForceKillServiceProcessTree(const ServiceName, FriendlyName: String);
var
  Pid: Integer;
  ResultCode: Integer;
  Ok: Boolean;
begin
  Pid := GetServicePid(ServiceName);
  LogMsg('ForceKillServiceProcessTree: ' + FriendlyName + ', pid=' + IntToStr(Pid));

  if Pid <= 0 then
    Exit;

  Ok := Exec(
    ExpandConstant('{sys}\taskkill.exe'),
    '/PID ' + IntToStr(Pid) + ' /T /F',
    '',
    SW_HIDE,
    ewWaitUntilTerminated,
    ResultCode
  );

  LogMsg(
    'taskkill result for ' + FriendlyName +
    ': ok=' + BoolText(Ok) +
    ', code=' + IntToStr(ResultCode)
  );
end;

procedure StopServiceRobust(
  const ServiceName, FriendlyName, ServiceExePath, ServiceXmlPath: String;
  StopAttempts, StopDelaySeconds: Integer);
var
  ResultCode: Integer;
  Ok: Boolean;
begin
  if not ServiceExists(ServiceName) then
  begin
    LogMsg('StopServiceRobust: service not installed -> ' + ServiceName);
    Exit;
  end;

  if GetServiceState(ServiceName) = 'STOPPED' then
  begin
    LogMsg('StopServiceRobust: already stopped -> ' + ServiceName);
    Exit;
  end;

  SetStepText('Stopping ' + FriendlyName + ' service...');
  LogMsg('Stopping service via sc stop: ' + ServiceName);

  Ok := Exec(
    ExpandConstant('{sys}\sc.exe'),
    'stop "' + ServiceName + '"',
    '',
    SW_HIDE,
    ewWaitUntilTerminated,
    ResultCode
  );

  LogMsg(
    'sc stop result for ' + FriendlyName +
    ': ok=' + BoolText(Ok) +
    ', code=' + IntToStr(ResultCode)
  );

  if WaitForServiceState(ServiceName, 'STOPPED', StopAttempts, StopDelaySeconds) then
  begin
    LogMsg(FriendlyName + ' stopped cleanly.');
    Exit;
  end;

  LogMsg(FriendlyName + ' did not stop in time. Escalating with taskkill.');
  ForceKillServiceProcessTree(ServiceName, FriendlyName);

  if WaitForServiceState(ServiceName, 'STOPPED', 8, 1) then
  begin
    LogMsg(FriendlyName + ' stopped after taskkill.');
    Exit;
  end;

  LogServiceDiagnostics(ServiceName, ServiceExePath, ServiceXmlPath);
  FailStep(
    FriendlyName + ' service could not be stopped.' + #13#10 +
    'See the setup log and service logs for details.'
  );
end;

procedure UninstallExistingServiceIfPresent(
  const ServiceName, ExePath, FriendlyName, ServiceXmlPath: String);
var
  ResultCode: Integer;
  Ok: Boolean;
begin
  if not FileExists(ExePath) then
  begin
    LogMsg('UninstallExistingServiceIfPresent: wrapper not found -> ' + ExePath);
    Exit;
  end;

  if ServiceExists(ServiceName) then
    StopServiceRobust(ServiceName, FriendlyName, ExePath, ServiceXmlPath, 15, 2);

  SetStepText('Removing existing ' + FriendlyName + ' service...');
  LogMsg('Uninstalling wrapper for ' + FriendlyName);

  Ok := Exec(
    ExePath,
    'uninstall',
    '',
    SW_HIDE,
    ewWaitUntilTerminated,
    ResultCode
  );

  LogMsg(
    'Wrapper uninstall result for ' + FriendlyName +
    ': ok=' + BoolText(Ok) +
    ', code=' + IntToStr(ResultCode)
  );

  WaitSeconds(1);
end;

procedure DeleteFileIfExists(const FilePath, FriendlyName: String);
begin
  if FileExists(FilePath) then
  begin
    LogMsg('Deleting file: ' + FriendlyName + ' -> ' + FilePath);
    if not DeleteFile(FilePath) then
      LogMsg('WARNING: Could not delete file -> ' + FilePath);
  end;
end;

procedure DeleteDirTreeIfExists(const DirPath, FriendlyName: String);
begin
  if DirExists(DirPath) then
  begin
    LogMsg('Deleting directory tree: ' + FriendlyName + ' -> ' + DirPath);
    if not DelTree(DirPath, True, True, True) then
      FailStep('Could not remove ' + FriendlyName + '.' + #13#10 + DirPath);
  end;
end;

procedure RemoveCoreDataDirectories(const RemoveHeidiData: Boolean);
var
  BaseDataDir: String;
begin
  SetStepText('Removing application data...');

  BaseDataDir := ExpandConstant('{commonappdata}\{#MyAppName}');

  DeleteDirTreeIfExists(AddBackslash(BaseDataDir) + 'config', 'configuration directory');
  DeleteDirTreeIfExists(AddBackslash(BaseDataDir) + 'logs', 'log directory');
  DeleteDirTreeIfExists(AddBackslash(BaseDataDir) + 'mysql', 'MySQL configuration directory');
  DeleteDirTreeIfExists(AddBackslash(BaseDataDir) + 'mysql-data', 'MySQL data directory');
  DeleteDirTreeIfExists(AddBackslash(BaseDataDir) + 'caddy', 'Caddy data directory');
  DeleteDirTreeIfExists(AddBackslash(BaseDataDir) + 'appdata', 'application data directory');
  DeleteDirTreeIfExists(AddBackslash(BaseDataDir) + 'profile', 'profile directory');
  DeleteDirTreeIfExists(AddBackslash(BaseDataDir) + 'tmp', 'temp directory');

  if RemoveHeidiData then
    DeleteDirTreeIfExists(AddBackslash(BaseDataDir) + 'HeidiSQL', 'HeidiSQL settings directory');

  if DirExists(BaseDataDir) then
  begin
    LogMsg('Attempting to remove base application data directory if empty: ' + BaseDataDir);
    RemoveDir(BaseDataDir);
  end;
end;

procedure ClearHeidiRegistryState();
begin
  LogMsg('Clearing HeidiSQL registry state...');
  RegDeleteValue(HKLM, '{#RegBaseKey}', 'HeidiInstalled');
  RegDeleteValue(HKLM, '{#RegBaseKey}', 'HeidiSQLVersion');
end;

procedure ClearCoreRegistryState();
begin
  LogMsg('Clearing core registry state...');
  RegDeleteValue(HKLM, '{#RegBaseKey}', 'Installed');
  RegDeleteValue(HKLM, '{#RegBaseKey}', 'CoreInstalled');
  RegDeleteValue(HKLM, '{#RegBaseKey}', 'InstallState');
  RegDeleteValue(HKLM, '{#RegBaseKey}', 'InstallPath');
  RegDeleteValue(HKLM, '{#RegBaseKey}', 'InstallerVersion');
  RegDeleteValue(HKLM, '{#RegBaseKey}', 'CoreBaseVersion');
  RegDeleteValue(HKLM, '{#RegBaseKey}', 'AppVersion');
  RegDeleteValue(HKLM, '{#RegBaseKey}', 'NodeModulesVersion');
end;

procedure ClearAllRegistryState();
begin
  LogMsg('Clearing full installer registry state...');
  RegDeleteKeyIncludingSubkeys(HKLM, '{#RegBaseKey}');
end;

procedure CleanupRegistryAfterComponentChange();
var
  HeidiInstalledValue: Cardinal;
  CoreInstalledValue: Cardinal;
begin
  if not RegQueryDWordValue(HKLM, '{#RegBaseKey}', 'CoreInstalled', CoreInstalledValue) then
    CoreInstalledValue := 0;

  if not RegQueryDWordValue(HKLM, '{#RegBaseKey}', 'HeidiInstalled', HeidiInstalledValue) then
    HeidiInstalledValue := 0;

  if (CoreInstalledValue = 0) and (HeidiInstalledValue = 0) then
  begin
    LogMsg('No component registry state remains. Removing registry base key...');
    RegDeleteKeyIncludingSubkeys(HKLM, '{#RegBaseKey}');
  end;
end;

procedure RemoveHeidiSqlIfPresent();
begin
  SetStepText('Removing HeidiSQL component...');
  DeleteFileIfExists(ExpandConstant('{group}\ST-PRO DACT DB Manager.lnk'), 'HeidiSQL shortcut');
  if DirExists(ExpandConstant('{app}\tools\HeidiSQL')) then
  begin
    LogMsg('Deleting HeidiSQL program directory...');
    if not DelTree(ExpandConstant('{app}\tools\HeidiSQL'), True, True, True) then
      FailStep(
        'The HeidiSQL component could not be removed.' + #13#10 +
        ExpandConstant('{app}\tools\HeidiSQL')
      );
  end;
  ClearHeidiRegistryState();
  CleanupRegistryAfterComponentChange();
end;

procedure StopMySqlServiceIfPresent();
var
  ResultCode: Integer;
begin
  Exec(
    ExpandConstant('{sys}\net.exe'),
    'stop {#MySqlServiceName}',
    '',
    SW_HIDE,
    ewWaitUntilTerminated,
    ResultCode
  );
  LogMsg('net stop {#MySqlServiceName} result: ' + IntToStr(ResultCode));
end;

procedure StopExistingCoreServicesForUpgrade();
begin
  SetStepText('Stopping existing services for core update...');

  StopServiceRobust(
    'STProDactProxy',
    'ST-PRO DACT Proxy',
    ExpandConstant('{app}\service\STProDactProxySvc.exe'),
    ExpandConstant('{app}\service\STProDactProxySvc.xml'),
    15,
    2
  );

  StopServiceRobust(
    'STProDactApp',
    'ST-PRO DACT App',
    ExpandConstant('{app}\service\STProDactAppSvc.exe'),
    ExpandConstant('{app}\service\STProDactAppSvc.xml'),
    15,
    2
  );

  StopMySqlServiceIfPresent();
end;

function WaitForServiceRemoval(const ServiceName: String; Attempts, DelaySeconds: Integer): Boolean;
var
  I: Integer;
begin
  Result := False;

  for I := 1 to Attempts do
  begin
    LogMsg('WaitForServiceRemoval: service=' + ServiceName + ', attempt=' + IntToStr(I) + '/' + IntToStr(Attempts));
    if not ServiceExists(ServiceName) then
    begin
      Result := True;
      Exit;
    end;

    if I < Attempts then
      WaitSeconds(DelaySeconds);
  end;
end;

procedure RemoveMySqlServiceIfPresent();
var
  ResultCode: Integer;
  Ok: Boolean;
  Pid: Integer;
begin
  if not ServiceExists('{#MySqlServiceName}') then
  begin
    LogMsg('RemoveMySqlServiceIfPresent: MySQL service is not installed.');
    Exit;
  end;

  SetStepText('Removing MySQL Windows service...');

  Ok := Exec(
    ExpandConstant('{sys}\sc.exe'),
    'stop "{#MySqlServiceName}"',
    '',
    SW_HIDE,
    ewWaitUntilTerminated,
    ResultCode
  );
  LogMsg('sc stop {#MySqlServiceName}: ok=' + BoolText(Ok) + ', code=' + IntToStr(ResultCode));

  if not WaitForServiceState('{#MySqlServiceName}', 'STOPPED', 15, 2) then
  begin
    Pid := GetServicePid('{#MySqlServiceName}');
    LogMsg('MySQL service did not stop in time. PID=' + IntToStr(Pid));

    if Pid > 0 then
    begin
      Ok := Exec(
        ExpandConstant('{sys}\taskkill.exe'),
        '/PID ' + IntToStr(Pid) + ' /T /F',
        '',
        SW_HIDE,
        ewWaitUntilTerminated,
        ResultCode
      );
      LogMsg('taskkill MySQL service: ok=' + BoolText(Ok) + ', code=' + IntToStr(ResultCode));
      WaitSeconds(2);
    end;
  end;

  Ok := Exec(
    ExpandConstant('{sys}\sc.exe'),
    'delete "{#MySqlServiceName}"',
    '',
    SW_HIDE,
    ewWaitUntilTerminated,
    ResultCode
  );
  LogMsg('sc delete {#MySqlServiceName}: ok=' + BoolText(Ok) + ', code=' + IntToStr(ResultCode));

  if not WaitForServiceRemoval('{#MySqlServiceName}', 15, 2) then
    FailStep('The MySQL Windows service could not be removed.');
end;

procedure RemoveCoreIfPresent();
var
  ResultCode: Integer;
begin
  SetStepText('Removing ST-PRO DACT component...');

  UninstallExistingServiceIfPresent(
    'STProDactProxy',
    ExpandConstant('{app}\service\STProDactProxySvc.exe'),
    'ST-PRO DACT Proxy',
    ExpandConstant('{app}\service\STProDactProxySvc.xml')
  );

  UninstallExistingServiceIfPresent(
    'STProDactApp',
    ExpandConstant('{app}\service\STProDactAppSvc.exe'),
    'ST-PRO DACT App',
    ExpandConstant('{app}\service\STProDactAppSvc.xml')
  );

  RemoveMySqlServiceIfPresent();

  Exec(
    ExpandConstant('{sys}\netsh.exe'),
    'advfirewall firewall delete rule name="ST-PRO DACT HTTP"',
    '',
    SW_HIDE,
    ewWaitUntilTerminated,
    ResultCode
  );
  LogMsg('Deleted firewall rule result: ' + IntToStr(ResultCode));

  DeleteDirTreeIfExists(ExpandConstant('{app}\service'), 'service directory');
  DeleteDirTreeIfExists(ExpandConstant('{app}\app'), 'application directory');
  DeleteDirTreeIfExists(ExpandConstant('{app}\node'), 'node runtime directory');
  DeleteDirTreeIfExists(ExpandConstant('{app}\mysql'), 'mysql runtime directory');
  DeleteDirTreeIfExists(ExpandConstant('{app}\caddy'), 'caddy runtime directory');
  DeleteFileIfExists(MySqlInitializedMarker(), 'MySQL initialized marker');

  if RemoveAppDataThisRun then
    RemoveCoreDataDirectories(RemoveHeidiThisRun);

  ClearCoreRegistryState();
  CleanupRegistryAfterComponentChange();
end;

function IsPort80InUse(): Boolean;
var
  ResultCode: Integer;
begin
  Result := Exec(
    ExpandConstant('{sys}\cmd.exe'),
    '/C netstat -ano | findstr /R /C:":80 .*LISTENING"',
    '',
    SW_HIDE,
    ewWaitUntilTerminated,
    ResultCode
  ) and (ResultCode = 0);
end;

function IsVCRedistInstalled(): Boolean;
var
  Value: Cardinal;
begin
  Result :=
    RegQueryDWordValue(
      HKLM,
      'SOFTWARE\Microsoft\VisualStudio\14.0\VC\Runtimes\x64',
      'Installed',
      Value
    ) and (Value = 1);
end;

function MySqlServiceNotInstalled(): Boolean;
var
  ResultCode: Integer;
begin
  Result := not Exec(
    ExpandConstant('{sys}\sc.exe'),
    'query {#MySqlServiceName}',
    '',
    SW_HIDE,
    ewWaitUntilTerminated,
    ResultCode
  ) or (ResultCode <> 0);
end;

function AppServiceUserExists(): Boolean;
var
  ResultCode: Integer;
begin
  Result := Exec(
    ExpandConstant('{sys}\net.exe'),
    'user "{#AppServiceUser}"',
    '',
    SW_HIDE,
    ewWaitUntilTerminated,
    ResultCode
  ) and (ResultCode = 0);
end;

procedure WriteMySqlIni();
var
  Ini: TStringList;
begin
  ForceDirectories(ExtractFileDir(MySqlIniPath()));
  ForceDirectories(MySqlDataDir());

  Ini := TStringList.Create;
  try
    Ini.Add('[mysqld]');
    Ini.Add('basedir=' + ExpandConstant('{app}\mysql'));
    Ini.Add('datadir=' + MySqlDataDir());
    Ini.Add('port=3306');
    Ini.Add('bind-address=127.0.0.1');
    Ini.Add('mysqlx=0');
    Ini.Add('character-set-server=utf8mb4');
    Ini.Add('collation-server=utf8mb4_0900_ai_ci');
    Ini.Add('sql_mode=STRICT_TRANS_TABLES,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION');
    Ini.Add('');
    Ini.Add('[client]');
    Ini.Add('port=3306');
    Ini.Add('host=127.0.0.1');
    Ini.SaveToFile(MySqlIniPath());
    LogMsg('Wrote MySQL config: ' + MySqlIniPath());
  finally
    Ini.Free;
  end;
end;

procedure EnsureAppServiceUser();
var
  ResultCode: Integer;
  Ok: Boolean;
  Params: String;
begin
  if AppServiceUserExists() then
  begin
    LogMsg('Service user already exists: {#AppServiceUser}');
    Exit;
  end;

  Params :=
    'user "{#AppServiceUser}" "{#AppServicePassword}" /add ' +
    '/fullname:"ST-PRO DACT Service User" /passwordchg:no /expires:never /y';

  SetStepText('Creating local service user...');

  Ok := Exec(
    ExpandConstant('{sys}\net.exe'),
    Params,
    '',
    SW_HIDE,
    ewWaitUntilTerminated,
    ResultCode
  );

  LogMsg('net user result: ok=' + BoolText(Ok) + ', code=' + IntToStr(ResultCode));

  if not Ok then
    FailStep(
      'The service user "{#AppServiceUser}" could not be created.' + #13#10 +
      'net.exe could not be started.'
    );

  if ResultCode <> 0 then
    FailStep(
      'The service user "{#AppServiceUser}" could not be created.' + #13#10 +
      'Return code from net.exe: ' + IntToStr(ResultCode) + #13#10 + #13#10 +
      'Possible cause: password policy, reserved user name, or local security policy.'
    );

  if not AppServiceUserExists() then
    FailStep(
      'The service user "{#AppServiceUser}" does not seem to exist after creation.'
    );
end;

function GetExistingServiceLogonRightValue(): String;
var
  ExportInf: String;
  Lines: TArrayOfString;
  I: Integer;
  P: Integer;
  Line: String;
begin
  Result := '';
  ExportInf := ExpandConstant('{tmp}\secpol_export.inf');

  ExecChecked(
    ExpandConstant('{sys}\secedit.exe'),
    '/export /cfg "' + ExportInf + '" /areas USER_RIGHTS',
    'Exporting local security policy...',
    'The local security policy could not be exported.',
    '0'
  );

  if not LoadStringsFromFile(ExportInf, Lines) then
    FailStep('The exported security policy could not be read.');

  for I := 0 to GetArrayLength(Lines) - 1 do
  begin
    Line := Trim(Lines[I]);
    P := Pos('=', Line);
    if P > 0 then
      if CompareText(Trim(Copy(Line, 1, P - 1)), 'SeServiceLogonRight') = 0 then
      begin
        Result := Trim(Copy(Line, P + 1, MaxInt));
        Exit;
      end;
  end;
end;

procedure EnsureServiceLogonRight();
var
  ImportInf: String;
  ImportDb: String;
  Lines: TStringList;
  ExistingValue: String;
  NewValue: String;
begin
  SetStepText('Granting "Log on as a service"...');

  ExistingValue := GetExistingServiceLogonRightValue();

  if ExistingValue = '' then
    NewValue := '{#AppServiceUser}'
  else
  begin
    if Pos(Lowercase('{#AppServiceUser}'), Lowercase(ExistingValue)) > 0 then
    begin
      LogMsg('"Log on as a service" already contains {#AppServiceUser}');
      Exit;
    end;
    NewValue := ExistingValue + ',{#AppServiceUser}';
  end;

  ImportInf := ExpandConstant('{tmp}\secpol_import.inf');
  ImportDb := ExpandConstant('{tmp}\secpol_import.sdb');

  Lines := TStringList.Create;
  try
    Lines.Add('[Unicode]');
    Lines.Add('Unicode=yes');
    Lines.Add('[Version]');
    Lines.Add('signature="$CHICAGO$"');
    Lines.Add('Revision=1');
    Lines.Add('[Privilege Rights]');
    Lines.Add('SeServiceLogonRight = ' + NewValue);
    Lines.SaveToFile(ImportInf);
  finally
    Lines.Free;
  end;

  ExecChecked(
    ExpandConstant('{sys}\secedit.exe'),
    '/configure /db "' + ImportDb + '" /cfg "' + ImportInf + '" /areas USER_RIGHTS',
    'Granting "Log on as a service"...',
    'The "Log on as a service" right could not be assigned.',
    '0'
  );
end;

procedure CleanupAppPayload();
begin
  SetStepText('Cleaning existing application payload...');
  DeleteDirTreeIfExists(ExpandConstant('{app}\app'), 'application directory');
  ForceDirectories(ExpandConstant('{app}\app'));
  LogMsg('Prepared clean application directory: ' + ExpandConstant('{app}\app'));
end;

procedure CleanupNodeModulesPayload();
begin
  SetStepText('Cleaning existing node_modules payload...');
  DeleteDirTreeIfExists(ExpandConstant('{app}\app\node_modules'), 'node_modules directory');
  ForceDirectories(ExpandConstant('{app}\app\node_modules'));
  LogMsg('Prepared clean node_modules directory: ' + ExpandConstant('{app}\app\node_modules'));
end;

procedure ExtractZipTo(const ZipPath, TargetDir, VisibleMsg, ErrorContext: String);
var
  Params: String;
begin
  ForceDirectories(TargetDir);
  Params := 'x "' + ZipPath + '" -o"' + TargetDir + '" -y';
  ExecChecked(
    ExpandConstant('{tmp}\7za.exe'),
    Params,
    VisibleMsg,
    ErrorContext,
    '0'
  );
end;

procedure WriteCoreRegistryState();
begin
  LogMsg('Writing core registry state...');
  RegWriteDWordValue(HKLM, '{#RegBaseKey}', 'Installed', 1);
  RegWriteDWordValue(HKLM, '{#RegBaseKey}', 'CoreInstalled', 1);
  RegWriteStringValue(HKLM, '{#RegBaseKey}', 'InstallState', 'Complete');
  RegWriteStringValue(HKLM, '{#RegBaseKey}', 'InstallPath', ExpandConstant('{app}'));
  RegWriteStringValue(HKLM, '{#RegBaseKey}', 'InstallerVersion', '{#InstallerVersion}');
  RegWriteStringValue(HKLM, '{#RegBaseKey}', 'CoreBaseVersion', '{#CoreBaseVersion}');
  RegWriteStringValue(HKLM, '{#RegBaseKey}', 'AppVersion', '{#AppVersion}');
  RegWriteStringValue(HKLM, '{#RegBaseKey}', 'NodeModulesVersion', '{#NodeModulesVersion}');
end;

procedure WriteHeidiRegistryState();
begin
  LogMsg('Writing HeidiSQL registry state...');
  RegWriteDWordValue(HKLM, '{#RegBaseKey}', 'HeidiInstalled', 1);
  RegWriteStringValue(HKLM, '{#RegBaseKey}', 'HeidiSQLVersion', '{#HeidiSQLVersion}');
end;

procedure MaintenanceControlChanged(Sender: TObject);
begin
  RefreshSelectionState();
end;

procedure LayoutMaintenancePage();
var
  Gap: Integer;
  BottomMargin: Integer;
  HintTop: Integer;
  CheckTop: Integer;
  ComboBottom: Integer;
  AvailableWidth: Integer;
begin
  if MaintenancePage = nil then
    Exit;

  Gap := ScaleY(8);
  BottomMargin := ScaleY(8);
  AvailableWidth := MaintenancePage.SurfaceWidth;

  MaintenanceIntroLabel.Left := 0;
  MaintenanceIntroLabel.Top := ScaleY(0);
  MaintenanceIntroLabel.Width := AvailableWidth;
  MaintenanceIntroLabel.Height := ScaleY(42);

  CoreStatusLabel.Left := 0;
  CoreStatusLabel.Top := MaintenanceIntroLabel.Top + MaintenanceIntroLabel.Height + ScaleY(10);
  CoreStatusLabel.Width := AvailableWidth;

  CoreActionLabel.Left := 0;
  CoreActionLabel.Top := CoreStatusLabel.Top + ScaleY(22);

  CoreActionCombo.Left := 0;
  CoreActionCombo.Top := CoreActionLabel.Top + ScaleY(20);
  CoreActionCombo.Width := ScaleX(320);

  HeidiStatusLabel.Left := 0;
  HeidiStatusLabel.Top := CoreActionCombo.Top + CoreActionCombo.Height + ScaleY(16);
  HeidiStatusLabel.Width := AvailableWidth;

  HeidiActionLabel.Left := 0;
  HeidiActionLabel.Top := HeidiStatusLabel.Top + ScaleY(22);

  HeidiActionCombo.Left := 0;
  HeidiActionCombo.Top := HeidiActionLabel.Top + ScaleY(20);
  HeidiActionCombo.Width := ScaleX(320);

  RemoveDataCheck.Left := 0;
  RemoveDataCheck.Width := AvailableWidth;
  RemoveDataCheck.Height := ScaleY(18);

  RemoveDataHintLabel.Left := ScaleX(18);
  RemoveDataHintLabel.Width := AvailableWidth - ScaleX(18);
  RemoveDataHintLabel.Height := ScaleY(28);

  ComboBottom := HeidiActionCombo.Top + HeidiActionCombo.Height;
  CheckTop := ComboBottom + ScaleY(18);
  HintTop := CheckTop + RemoveDataCheck.Height + Gap;

  if HintTop + RemoveDataHintLabel.Height > MaintenancePage.SurfaceHeight - BottomMargin then
    HintTop := MaintenancePage.SurfaceHeight - RemoveDataHintLabel.Height - BottomMargin;

  if HintTop < CheckTop + RemoveDataCheck.Height + Gap then
    HintTop := CheckTop + RemoveDataCheck.Height + Gap;

  RemoveDataCheck.Top := CheckTop;
  RemoveDataHintLabel.Top := HintTop;
end;

procedure UpdateActionButtonCaptions();
var
  CaptionText: String;
begin
  if WizardForm = nil then
    Exit;

  if Assigned(WizardForm.NextButton) then
  begin
    if (WizardForm.CurPageID = MaintenancePage.ID) or (WizardForm.CurPageID = wpReady) then
      CaptionText := DetermineWizardActionCaption()
    else
      CaptionText := SetupMessage(msgButtonNext);

    WizardForm.NextButton.Caption := CaptionText;
  end;
end;

procedure InitializeMaintenancePage();
begin
  MaintenancePage := CreateCustomPage(
    wpSelectDir,
    'Manage components',
    'Choose the action to perform for each component.'
  );

  MaintenanceIntroLabel := TNewStaticText.Create(MaintenancePage);
  MaintenanceIntroLabel.Parent := MaintenancePage.Surface;
  MaintenanceIntroLabel.WordWrap := True;
  MaintenanceIntroLabel.Caption :=
    'For a fresh installation, ST-PRO DACT is installed by default and ST-PRO DACT DB Manager remains optional. ' +
    'For existing installations, components can be left unchanged, reinstalled, or uninstalled.';

  CoreStatusLabel := TNewStaticText.Create(MaintenancePage);
  CoreStatusLabel.Parent := MaintenancePage.Surface;

  CoreActionLabel := TNewStaticText.Create(MaintenancePage);
  CoreActionLabel.Parent := MaintenancePage.Surface;
  CoreActionLabel.Caption := 'ST-PRO DACT - Action:';

  CoreActionCombo := TNewComboBox.Create(MaintenancePage);
  CoreActionCombo.Parent := MaintenancePage.Surface;
  CoreActionCombo.Style := csDropDownList;

  HeidiStatusLabel := TNewStaticText.Create(MaintenancePage);
  HeidiStatusLabel.Parent := MaintenancePage.Surface;

  HeidiActionLabel := TNewStaticText.Create(MaintenancePage);
  HeidiActionLabel.Parent := MaintenancePage.Surface;
  HeidiActionLabel.Caption := 'ST-PRO DACT DB Manager - Action:';

  HeidiActionCombo := TNewComboBox.Create(MaintenancePage);
  HeidiActionCombo.Parent := MaintenancePage.Surface;
  HeidiActionCombo.Style := csDropDownList;

  RemoveDataCheck := TNewCheckBox.Create(MaintenancePage);
  RemoveDataCheck.Parent := MaintenancePage.Surface;
  RemoveDataCheck.Caption := 'Remove application data (MySQL databases, logs, configuration)';
  RemoveDataCheck.Checked := False;
  RemoveDataCheck.Visible := False;

  RemoveDataHintLabel := TNewStaticText.Create(MaintenancePage);
  RemoveDataHintLabel.Parent := MaintenancePage.Surface;
  RemoveDataHintLabel.WordWrap := True;
  RemoveDataHintLabel.Caption := 'Warning: This permanently deletes ST-PRO DACT data stored under ProgramData.';
  RemoveDataHintLabel.Visible := False;

  CoreActionCombo.OnChange := @MaintenanceControlChanged;
  HeidiActionCombo.OnChange := @MaintenanceControlChanged;
  RemoveDataCheck.OnClick := @MaintenanceControlChanged;

  LayoutMaintenancePage();
  RebuildMaintenanceDefaults();
end;

function InitializeSetup(): Boolean;
begin
  InstallCoreThisRun := False;
  HeidiSelectedThisRun := False;
  ExistingInstallDetected := False;
  RepairDetected := False;
  CorePreviouslyInstalled := False;
  HeidiPreviouslyInstalled := False;
  RemoveHeidiThisRun := False;
  RemoveCoreThisRun := False;
  ReinstallCoreThisRun := False;
  ReinstallHeidiThisRun := False;
  RemoveAppDataThisRun := False;
  MaintenanceInitializedForDir := '';
  Result := True;
end;

procedure InitializeWizard();
begin
  InitializeMaintenancePage();
  UpdateActionButtonCaptions();
end;

function ShouldSkipPage(PageID: Integer): Boolean;
begin
  Result := (PageID = wpSelectComponents);
end;

procedure CurPageChanged(CurPageID: Integer);
begin
  if CurPageID = MaintenancePage.ID then
  begin
    if CompareText(MaintenanceInitializedForDir, RemoveBackslashUnlessRoot(WizardDirValue())) <> 0 then
      RebuildMaintenanceDefaults()
    else
      RefreshSelectionState();
  end;

  if CurPageID = wpReady then
  begin
    RefreshSelectionState();
    ApplyWizardComponentsFromActions();
  end;

  UpdateActionButtonCaptions();
end;

function NextButtonClick(CurPageID: Integer): Boolean;
begin
  Result := True;

  if CurPageID = MaintenancePage.ID then
  begin
    RefreshSelectionState();

    if (CoreState = dcsNotInstalled) and (CoreAction <> dcaInstall) then
    begin
      MsgBox(
        'For a fresh installation, ST-PRO DACT must be installed.',
        mbError,
        MB_OK
      );
      Result := False;
      Exit;
    end;

    if (CoreState = dcsBroken) and (CoreAction = dcaNoChange) then
    begin
      MsgBox(
        'The existing ST-PRO DACT installation is incomplete. Please choose "Reinstall / replace" or "Uninstall".',
        mbError,
        MB_OK
      );
      Result := False;
      Exit;
    end;

    if RemoveAppDataThisRun then
      if MsgBox(
        'This will permanently delete all ST-PRO DACT data stored under ProgramData.' + #13#10 +
        'Do you want to continue?',
        mbConfirmation,
        MB_YESNO
      ) <> IDYES then
      begin
        Result := False;
        Exit;
      end;
  end;
end;

function UpdateReadyMemo(Space, NewLine, MemoUserInfoInfo, MemoDirInfo, MemoTypeInfo,
  MemoComponentsInfo, MemoGroupInfo, MemoTasksInfo: String): String;
begin
  RefreshSelectionState();

  Result :=
    'Component status:' + NewLine +
    Space + 'ST-PRO DACT: ' + StateText(CoreState) + NewLine +
    Space + 'ST-PRO DACT DB Manager: ' + StateText(HeidiState) + NewLine + NewLine +
    'Planned actions:' + NewLine +
    Space + 'ST-PRO DACT: ' + ActionText(CoreAction) + NewLine +
    Space + 'ST-PRO DACT DB Manager: ' + ActionText(HeidiAction) + NewLine +
    Space + 'Application data: ' + AppDataActionText() + NewLine + NewLine +
    MemoDirInfo + NewLine;
end;

procedure CurStepChanged(CurStep: TSetupStep);
var
  AppSvcInstallParams: String;
  ResultCode: Integer;
begin
  if CurStep = ssInstall then
  begin
    RefreshSelectionState();
    ApplyWizardComponentsFromActions();

    CorePreviouslyInstalled := CoreAlreadyInstalled();
    HeidiPreviouslyInstalled := HeidiSqlInstalledAtDir(ExpandConstant('{app}'));

    LogMsg('CorePreviouslyInstalled=' + BoolText(CorePreviouslyInstalled));
    LogMsg('HeidiPreviouslyInstalled=' + BoolText(HeidiPreviouslyInstalled));
    LogMsg('RemoveCoreThisRun=' + BoolText(RemoveCoreThisRun));
    LogMsg('RemoveHeidiThisRun=' + BoolText(RemoveHeidiThisRun));
    LogMsg('ReinstallCoreThisRun=' + BoolText(ReinstallCoreThisRun));
    LogMsg('ReinstallHeidiThisRun=' + BoolText(ReinstallHeidiThisRun));
    LogMsg('RemoveAppDataThisRun=' + BoolText(RemoveAppDataThisRun));

    if RemoveHeidiThisRun then
      RemoveHeidiSqlIfPresent();

    if RemoveCoreThisRun then
      RemoveCoreIfPresent();

    if InstallCoreThisRun then
    begin
      if CorePreviouslyInstalled then
      begin
        StopExistingCoreServicesForUpgrade();
      end
      else
      begin
        if IsPort80InUse() then
          FailStep(
            'Port 80 is already in use.' + #13#10 +
            'Please stop the service currently using port 80 and run setup again.'
          );

        WriteMySqlIni();
      end;
    end
    else
      LogMsg('Core action does not require installation. Core file copy and service actions will be skipped.');
  end;

  if CurStep = ssPostInstall then
  begin
    if InstallCoreThisRun then
    begin
      if not IsVCRedistInstalled() then
        ExecChecked(
          ExpandConstant('{tmp}\vc_redist.x64.exe'),
          '/install /quiet /norestart',
          'Installing Microsoft Visual C++ Runtime...',
          'Microsoft Visual C++ Runtime could not be installed.',
          '0,1638,3010'
        );

      if not FileExists(MySqlIniPath()) then
        WriteMySqlIni();

      if ShouldInitializeMySqlDataDir() then
        ExecChecked(
          ExpandConstant('{app}\mysql\bin\mysqld.exe'),
          '--defaults-file="' + MySqlIniPath() + '" --initialize-insecure',
          'Initializing MySQL data directory...',
          'MySQL could not be initialized.',
          '0'
        )
      else
      begin
        if MySqlDataDirLooksInitialized() and MySqlNotInitialized() then
          LogMsg('Existing MySQL data directory detected. Initialization will be skipped and the existing data will be reused.')
        else if not MySqlNotInitialized() then
          LogMsg('MySQL data directory is already marked as initialized. Initialization will be skipped.');
      end;

      if MySqlServiceNotInstalled() then
        ExecChecked(
          ExpandConstant('{app}\mysql\bin\mysqld.exe'),
          '--install {#MySqlServiceName} --defaults-file="' + MySqlIniPath() + '"',
          'Registering MySQL Windows service...',
          'The MySQL service could not be registered.',
          '0'
        );

      ExecChecked(
        ExpandConstant('{sys}\net.exe'),
        'start {#MySqlServiceName}',
        'Starting MySQL service...',
        'The MySQL service could not be started.',
        '0,2'
      );

      ExecChecked(
        ExpandConstant('{sys}\cmd.exe'),
        '/C timeout /t 3 /nobreak >nul',
        'Waiting for MySQL startup...',
        'The MySQL wait step could not be executed.',
        '0'
      );

      ExecChecked(
        ExpandConstant('{app}\mysql\bin\mysql.exe'),
        '-u root -h 127.0.0.1 -P 3306 -e "CREATE DATABASE IF NOT EXISTS opcua CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci; CREATE USER IF NOT EXISTS ''opcua''@''localhost'' IDENTIFIED BY ''opcua''; GRANT ALL PRIVILEGES ON opcua.* TO ''opcua''@''localhost''; FLUSH PRIVILEGES;"',
        'Creating database and MySQL user opcua...',
        'The database and MySQL user could not be created.',
        '0'
      );

      if MySqlNotInitialized() then
      begin
        SaveStringToFile(MySqlInitializedMarker(), 'ok', False);
        LogMsg('Created MySQL initialized marker: ' + MySqlInitializedMarker());
      end;

      EnsureAppServiceUser();
      EnsureServiceLogonRight();

      ExecChecked(
        ExpandConstant('{sys}\icacls.exe'),
        '"' + ExpandConstant('{commonappdata}\{#MyAppName}\logs') + '" /grant "{#AppServiceUser}:(OI)(CI)M" /T /C',
        'Setting write permissions on logs...',
        'Permissions on logs could not be set.',
        '0'
      );

      ExecChecked(
        ExpandConstant('{sys}\icacls.exe'),
        '"' + ExpandConstant('{commonappdata}\{#MyAppName}\appdata') + '" /grant "{#AppServiceUser}:(OI)(CI)M" /T /C',
        'Setting write permissions on app data...',
        'Permissions on app data could not be set.',
        '0'
      );

      ExecChecked(
        ExpandConstant('{sys}\icacls.exe'),
        '"' + ExpandConstant('{commonappdata}\{#MyAppName}\profile') + '" /grant "{#AppServiceUser}:(OI)(CI)M" /T /C',
        'Setting write permissions on profile directory...',
        'Permissions on profile directory could not be set.',
        '0'
      );

      ExecChecked(
        ExpandConstant('{sys}\icacls.exe'),
        '"' + ExpandConstant('{commonappdata}\{#MyAppName}\tmp') + '" /grant "{#AppServiceUser}:(OI)(CI)M" /T /C',
        'Setting write permissions on temp directory...',
        'Permissions on temp directory could not be set.',
        '0'
      );

      CleanupAppPayload();
      CleanupNodeModulesPayload();

      ExtractZipTo(
        ExpandConstant('{tmp}\app-package.zip'),
        ExpandConstant('{app}\app'),
        'Extracting application package...',
        'The application package could not be extracted.'
      );

      ExtractZipTo(
        ExpandConstant('{tmp}\node-modules-package.zip'),
        ExpandConstant('{app}\app\node_modules'),
        'Extracting node_modules package...',
        'The node_modules package could not be extracted.'
      );

      UninstallExistingServiceIfPresent(
        'STProDactApp',
        ExpandConstant('{app}\service\STProDactAppSvc.exe'),
        'ST-PRO DACT App',
        ExpandConstant('{app}\service\STProDactAppSvc.xml')
      );

      AppSvcInstallParams :=
        'install --username .\{#AppServiceUser} --password "{#AppServicePassword}"';

      ExecServiceChecked(
        ExpandConstant('{app}\service\STProDactAppSvc.exe'),
        AppSvcInstallParams,
        'Registering ST-PRO DACT App Windows service...',
        'The ST-PRO DACT App service could not be registered.',
        '0',
        'STProDactApp',
        ExpandConstant('{app}\service\STProDactAppSvc.exe'),
        ExpandConstant('{app}\service\STProDactAppSvc.xml')
      );

      ExecChecked(
        ExpandConstant('{sys}\sc.exe'),
        'config STProDactApp depend= MySQLSTProDact',
        'Setting MySQL service dependency...',
        'The MySQL service dependency could not be set.',
        '0'
      );

      ExecServiceChecked(
        ExpandConstant('{app}\service\STProDactAppSvc.exe'),
        'start',
        'Starting ST-PRO DACT App service...',
        'The ST-PRO DACT App service could not be started.',
        '0',
        'STProDactApp',
        ExpandConstant('{app}\service\STProDactAppSvc.exe'),
        ExpandConstant('{app}\service\STProDactAppSvc.xml')
      );

      EnsureServiceRunning(
        'STProDactApp',
        'ST-PRO DACT App',
        ExpandConstant('{app}\service\STProDactAppSvc.exe'),
        ExpandConstant('{app}\service\STProDactAppSvc.xml'),
        5,
        2
      );

      UninstallExistingServiceIfPresent(
        'STProDactProxy',
        ExpandConstant('{app}\service\STProDactProxySvc.exe'),
        'ST-PRO DACT Proxy',
        ExpandConstant('{app}\service\STProDactProxySvc.xml')
      );

      ExecServiceChecked(
        ExpandConstant('{app}\service\STProDactProxySvc.exe'),
        'install',
        'Registering ST-PRO DACT Proxy Windows service...',
        'The proxy service could not be registered.',
        '0',
        'STProDactProxy',
        ExpandConstant('{app}\service\STProDactProxySvc.exe'),
        ExpandConstant('{app}\service\STProDactProxySvc.xml')
      );

      ExecServiceChecked(
        ExpandConstant('{app}\service\STProDactProxySvc.exe'),
        'start',
        'Starting ST-PRO DACT Proxy service...',
        'The proxy service could not be started.',
        '0',
        'STProDactProxy',
        ExpandConstant('{app}\service\STProDactProxySvc.exe'),
        ExpandConstant('{app}\service\STProDactProxySvc.xml')
      );

      EnsureServiceRunning(
        'STProDactProxy',
        'ST-PRO DACT Proxy',
        ExpandConstant('{app}\service\STProDactProxySvc.exe'),
        ExpandConstant('{app}\service\STProDactProxySvc.xml'),
        5,
        2
      );

      Exec(
        ExpandConstant('{sys}\netsh.exe'),
        'advfirewall firewall delete rule name="ST-PRO DACT HTTP"',
        '',
        SW_HIDE,
        ewWaitUntilTerminated,
        ResultCode
      );
      LogMsg('Deleted existing firewall rule result: ' + IntToStr(ResultCode));

      ExecChecked(
        ExpandConstant('{sys}\netsh.exe'),
        'advfirewall firewall add rule name="ST-PRO DACT HTTP" dir=in action=allow protocol=TCP localport=80',
        'Creating firewall rule for port 80...',
        'The firewall rule for port 80 could not be created.',
        '0'
      );

      WriteCoreRegistryState();
    end
    else if RemoveCoreThisRun then
    begin
      ClearCoreRegistryState();
      CleanupRegistryAfterComponentChange();
    end;

    if HeidiSelectedThisRun then
    begin
      LogMsg('HeidiSQL component selected for this run.');
      WriteHeidiRegistryState();
    end
    else if RemoveHeidiThisRun then
    begin
      ClearHeidiRegistryState();
      CleanupRegistryAfterComponentChange();
    end;

    SetStepText('Installation completed.');
  end;
end;

procedure CurUninstallStepChanged(CurUninstallStep: TUninstallStep);
begin
  if CurUninstallStep = usPostUninstall then
    ClearAllRegistryState();
end;
