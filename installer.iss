[Setup]
AppName=RestBuddy
AppVersion=1.0.0
AppPublisher=RestBuddy
AppPublisherURL=https://github.com/restbuddy
DefaultDirName={pf}\RestBuddy
DefaultGroupName=RestBuddy
AllowNoIcons=yes
OutputDir=D:\WorkBuddy\CC_software
OutputBaseFilename=RestBuddy-Setup
Compression=lzma2
SolidCompression=yes
WizardStyle=modern
PrivilegesRequired=admin
ArchitecturesAllowed=x64compatible
ArchitecturesInstallIn64BitMode=x64compatible

[Languages]
Name: "english"; MessagesFile: "compiler:Default.isl"

[Tasks]
Name: "desktopicon"; Description: "{cm:CreateDesktopIcon}"; GroupDescription: "{cm:AdditionalIcons}"
Name: "quicklaunchicon"; Description: "{cm:CreateQuickLaunchIcon}"; GroupDescription: "{cm:AdditionalIcons}"; Flags: unchecked

[Files]
Source: "D:\WorkBuddy\CC_software\RestBuddy-Windows\*"; DestDir: "{app}"; Flags: ignoreversion recursesubdirs createallsubdirs

[Icons]
Name: "{group}\RestBuddy"; Filename: "{app}\restbuddy.exe"
Name: "{group}\{cm:UninstallProgram,RestBuddy}"; Filename: "{uninstallexe}"
Name: "{autodesktop}\RestBuddy"; Filename: "{app}\restbuddy.exe"; Tasks: desktopicon
Name: "{userappdata}\Microsoft\Internet Explorer\Quick Launch\RestBuddy"; Filename: "{app}\restbuddy.exe"; Tasks: quicklaunchicon

[Run]
Filename: "{app}\restbuddy.exe"; Description: "{cm:LaunchProgram,RestBuddy}"; Flags: nowait postinstall skipifsilent
