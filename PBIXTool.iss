; ========================================================
; PBIXConverter + Bulk Converter Installer
; Inno Setup script – tested with Inno Setup 6.x
; ========================================================

#define MyAppName "PBIXConverter with Bulk Processing"
#define MyAppVersion "1.0.0"
#define MyAppPublisher "nsdevaraj"
#define MyAppURL "https://github.com/nsdevaraj/PBIXConverter"
#define MyAppExeName "pbix.bat"
#define MyAppDescription "Convert Power BI files by modifying visual types and removing SecurityBindings"

[Setup]
AppId={{A1B2C3D4-E5F6-7890-ABCD-EF1234567890}
AppName={#MyAppName}
AppVersion={#MyAppVersion}
AppPublisher={#MyAppPublisher}
AppPublisherURL={#MyAppURL}
AppSupportURL={#MyAppURL}/issues
AppUpdatesURL={#MyAppURL}/releases
DefaultDirName={autopf}\PBIXConverter
DefaultGroupName=PBIXConverter
AllowNoIcons=yes
OutputDir=Output
OutputBaseFilename=PBIXConverter_Setup
SetupIconFile=
Compression=lzma
SolidCompression=yes
WizardStyle=modern
DisableProgramGroupPage=no
LicenseFile=
PrivilegesRequired=admin
PrivilegesRequiredOverridesAllowed=commandline dialog
ArchitecturesInstallIn64BitMode=x64

; Add to PATH (user choice)
ChangesEnvironment=yes

; Uninstall settings
UninstallDisplayIcon={app}\pbix.bat
UninstallDisplayName={#MyAppName}

[Tasks]
Name: "desktopicon"; Description: "Create a &desktop icon for Bulk Converter"; GroupDescription: "Additional icons:"
Name: "addtopath"; Description: "Add PBIXConverter to system PATH (recommended)"; GroupDescription: "Environment:"; Flags: unchecked

[Files]
; Main tool files (you must put these three files next to the .iss when compiling)
Source: "pbix.bat"; DestDir: "{app}"; Flags: ignoreversion
Source: "modify_layout.py"; DestDir: "{app}"; Flags: ignoreversion
Source: "create_pbix.py"; DestDir: "{app}"; Flags: ignoreversion
Source: "README.md"; DestDir: "{app}"; Flags: ignoreversion isreadme

; Bulk processing PowerShell helper (will be created by the installer)
Source: "{tmp}\BulkConvertPBIX.ps1"; DestDir: "{app}"; Flags: ignoreversion

[Icons]
Name: "{group}\PBIXConverter Command"; Filename: "{cmd}"; Parameters: "/k ""{app}\pbix.bat"""; WorkingDir: "{app}"; Comment: "Open command prompt in PBIXConverter directory"
Name: "{group}\Bulk Convert PBIX Files"; Filename: "powershell.exe"; Parameters: "-NoProfile -ExecutionPolicy Bypass -File ""{app}\BulkConvertPBIX.ps1"""; WorkingDir: "{app}"; Comment: "Select a folder and convert all .pbix files at once"
Name: "{group}\Read Me"; Filename: "{app}\README.md"; Comment: "View PBIXConverter documentation"
Name: "{group}\Uninstall {#MyAppName}"; Filename: "{uninstallexe}"; Comment: "Uninstall PBIXConverter"
Name: "{autodesktop}\Bulk Convert PBIX Files"; Filename: "powershell.exe"; Parameters: "-NoProfile -ExecutionPolicy Bypass -File ""{app}\BulkConvertPBIX.ps1"""; WorkingDir: "{app}"; Tasks: desktopicon; Comment: "Select a folder and convert all .pbix files at once"

[Registry]
; Add to PATH if user checked the task
Root: HKLM; Subkey: "SYSTEM\CurrentControlSet\Control\Session Manager\Environment"; ValueType: expandsz; ValueName: "Path"; ValueData: "{olddata};{app}"; Tasks: addtopath; Check: NeedsAddPath(ExpandConstant('{app}'))

[Code]
var
  FinishPage: TNewNotebookPage;

function NeedsAddPath(Param: string): boolean;
var
  OrigPath: string;
begin
  if not RegQueryStringValue(HKEY_LOCAL_MACHINE,
    'SYSTEM\CurrentControlSet\Control\Session Manager\Environment',
    'Path', OrigPath)
  then begin
    Result := True;
    exit;
  end;
  Result := Pos(';' + Param + ';', ';' + OrigPath + ';') = 0;
end;

procedure InitializeWizard;
var
  ScriptContent: String;
  AppPath: String;
begin
  // Get the installation directory path
  AppPath := ExpandConstant('{app}');
  
  // Create the BulkConvertPBIX.ps1 helper script in temp and it will be copied during installation
  ScriptContent :=
    'Add-Type -AssemblyName System.Windows.Forms' + #13#10 +
    '' + #13#10 +
    '$folderBrowser = New-Object -ComObject Shell.Application' + #13#10 +
    '$selectedFolder = $folderBrowser.BrowseForFolder(0, ''Select the folder that contains your .pbix files'', 0, 0)' + #13#10 +
    'if (-not $selectedFolder) { [Windows.Forms.MessageBox]::Show(''No folder selected. Exiting.'', ''Bulk PBIX Converter'', ''OK'', ''Information''); exit }' + #13#10 +
    '' + #13#10 +
    '$folder = $selectedFolder.Self.Path' + #13#10 +
    '[Windows.Forms.MessageBox]::Show(''Will convert all .pbix files in:'' + [char]10 + $folder, ''Bulk PBIX Converter'', ''OK'', ''Information'')' + #13#10 +
    '' + #13#10 +
    '$pbixFiles = Get-ChildItem -Path $folder -Filter *.pbix -File' + #13#10 +
    'if ($pbixFiles.Count -eq 0) { [Windows.Forms.MessageBox]::Show(''No .pbix files found in the selected folder.'', ''Bulk PBIX Converter'', ''OK'', ''Warning''); exit }' + #13#10 +
    '' + #13#10 +
    '$convertedCount = 0' + #13#10 +
    '$failedCount = 0' + #13#10 +
    '' + #13#10 +
    'foreach ($file in $pbixFiles) {' + #13#10 +
    '  $inputFile  = $file.FullName' + #13#10 +
    '  $outputFile = [IO.Path]::Combine($file.DirectoryName, [IO.Path]::GetFileNameWithoutExtension($file.Name) + ''_converted.pbix'')' + #13#10 +
    '  Write-Host "Converting: $($file.Name) -> $([IO.Path]::GetFileName($outputFile))"' + #13#10 +
    '  ' + #13#10 +
    '  $scriptPath = Split-Path -Parent $MyInvocation.MyCommand.Definition' + #13#10 +
    '  $batPath = Join-Path $scriptPath "pbix.bat"' + #13#10 +
    '  ' + #13#10 +
    '  & cmd.exe /c """$batPath"" ""$inputFile"" ""$outputFile"""' + #13#10 +
    '  ' + #13#10 +
    '  if ($LASTEXITCODE -eq 0) { ' + #13#10 +
    '    Write-Host "✓ Done" -ForegroundColor Green' + #13#10 +
    '    $convertedCount++' + #13#10 +
    '  } else { ' + #13#10 +
    '    Write-Warning "✗ Failed on $($file.Name)"' + #13#10 +
    '    $failedCount++' + #13#10 +
    '  }' + #13#10 +
    '}' + #13#10 +
    '' + #13#10 +
    '$message = "Bulk conversion finished!" + [char]10 + [char]10 +' + #13#10 +
    '           "Converted: $convertedCount" + [char]10 +' + #13#10 +
    '           "Failed: $failedCount" + [char]10 + [char]10 +' + #13#10 +
    '           "Check the folder for _converted.pbix files."' + #13#10 +
    '[Windows.Forms.MessageBox]::Show($message, ''Bulk PBIX Converter'', ''OK'', ''Information'')' + #13#10 +
    '' + #13#10 +
    'Read-Host "Press Enter to exit"';

  // Save the script to temp so [Files] section can copy it
  SaveStringToFile(ExpandConstant('{tmp}\BulkConvertPBIX.ps1'), ScriptContent, False);
end;

procedure CurStepChanged(CurStep: TSetupStep);
begin
  if CurStep = ssPostInstall then
  begin
    // Optional: show a final message
    MsgBox('PBIXConverter is now installed!' + #13#10#13#10 +
           'You can use the ''Bulk Convert PBIX Files'' shortcut to process entire folders at once.' + #13#10#13#10 +
           'Each file will be converted to <original>_converted.pbix in the same folder.' + #13#10#13#10 +
           'Note: Python 3.x and PowerShell 5.0+ are required to use this tool.',
           mbInformation, MB_OK);
  end;
end;

procedure CurUninstallStepChanged(CurUninstallStep: TUninstallStep);
var
  Path: string;
  AppDir: string;
begin
  if CurUninstallStep = usPostUninstall then
  begin
    AppDir := ExpandConstant('{app}');
    if RegQueryStringValue(HKEY_LOCAL_MACHINE,
      'SYSTEM\CurrentControlSet\Control\Session Manager\Environment',
      'Path', Path) then
    begin
      if Pos(';' + AppDir + ';', ';' + Path + ';') > 0 then
      begin
        StringChangeEx(Path, ';' + AppDir, '', True);
        StringChangeEx(Path, AppDir + ';', '', True);
        StringChangeEx(Path, AppDir, '', True);
        RegWriteStringValue(HKEY_LOCAL_MACHINE,
          'SYSTEM\CurrentControlSet\Control\Session Manager\Environment',
          'Path', Path);
      end;
    end;
  end;
end;
