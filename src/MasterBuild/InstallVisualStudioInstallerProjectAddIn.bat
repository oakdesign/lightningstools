@ECHO OFF
:start

SET MASTERBUILDDIR=%~dp0
CALL %MASTERBUILDDIR%GetVsWhere.bat
for /f "usebackq tokens=*" %%i in (`%MASTERBUILDDIR%vswhere.exe -all -latest -products * -requires Microsoft.Component.MSBuild -property installationPath`) do (
  set InstallDir=%%i
)
for /f "usebackq tokens=*" %%i in (`%MASTERBUILDDIR%vswhere.exe -all -latest -products * -requires Microsoft.Component.MSBuild -property instanceId`) do (
  set InstanceId=%%i
)

IF NOT EXIST "%MASTERBUILDDIR%InstallerProjects.vsix" bitsadmin /transfer VisualStudioInstallerProjectsAddIn /dynamic /download /priority HIGH "https://visualstudioclient.gallerycdn.vsassets.io/extensions/visualstudioclient/microsoftvisualstudio2017installerprojects/0.9.9/1600189601218/InstallerProjects.vsix" "%MASTERBUILDDIR%InstallerProjects.vsix" 
IF ERRORLEVEL 1 GOTO END

IF ERRORLEVEL 1 GOTO END
ECHO Installing Visual Studio Installer Project add-in...
"%InstallDir%\Common7\IDE\VsixInstaller.exe" /a /q "%MASTERBUILDDIR%InstallerProjects.vsix"
IF ERRORLEVEL 1 GOTO END

"%InstallDir%\Common7\IDE\CommonExtensions\Microsoft\VSI\bin\regcap.exe"
IF NOT EXIST "%WINDIR%\Microsoft.NET\Framework\URTInstallPath_GAC\" MD "%WINDIR%\Microsoft.NET\Framework\URTInstallPath_GAC\" 

:END

