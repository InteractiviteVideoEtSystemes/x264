rem convert path and script to unix format
echo on
for /f %%a in ('c:\msys64\usr\bin\cygpath.exe %1') do set CMDFILE=%%a
for /f %%a in ('c:\msys64\usr\bin\cygpath.exe %CD%') do set PWD=%%a

rem setup visual studio 2017 env then launch msys2
set MSYSTEM=MINGW32
set MSYS2_PATH_TYPE=inherit
FOR /F "tokens=* USEBACKQ" %%F IN (`"C:\Program Files (x86)\Microsoft Visual Studio\Installer\vswhere.exe" -property installationPath`) DO (SET vsInstallationPath=%%F)
CALL "%vsInstallationPath%\VC\Auxiliary\Build\vcvars32.bat"
c:\msys64\usr\bin\bash.exe -l -x -c "cd %PWD% ; %CMDFILE%"