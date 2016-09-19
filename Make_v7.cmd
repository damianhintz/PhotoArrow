@set name=PhotoArrow

@echo Configuring environment
@set MS=c:\win32app\ustation
@set INCLUDE=%MS%\mdl\include;%INCLUDE%
@set LIB=%MS%\mdl\library;
@set MDL_COMP=-i%MS%\mdl\include -i%cd% -i%cd%\%lang% -i%MS%\mdl\include\stdlib
@set BMAKE_OPT=-I%MS%\mdl\include
@set PATH=;%MS%;%MS%\mdl\bin;%PATH%

@echo Cleaning environment
@if exist %name%.ma del %name%.ma

@echo Compiling app\*.mc
@echo -a%name%.mp>mlink.txt
@cd app
@for %%g in (*.mc) do @echo app\%%~ng.mo>>..\mlink.txt && mcomp -b %%g
@cd ..

@echo Compiling core\*.mc
@rem echo -a%name%.mp>mlink.txt
@cd core
@for %%g in (*.mc) do @echo core\%%~ng.mo>>..\mlink.txt && mcomp -b %%g
@cd ..

@echo Compiling *.r
@rcomp -fwinNT %mdl_comp% -h ui-cmd.r
@rcomp -fwinNT %mdl_comp% ui.r

@echo Compiling *.mc
@for %%f in (*.mc) do @echo %%~nf.mo>>mlink.txt && mcomp -b %%f
@echo %MS%\mdl\library\rdbmslib.ml>>mlink.txt
@echo %MS%\mdl\library\mdllib.ml>>mlink.txt

@echo Linking
@mlink @mlink.txt
@rlib -fwinNT -o%name%.ma %name%.mp ui.rsc ui-cmd.rsc

@echo Build and autoinstall mdl
@if not exist build mkdir build
@if not exist build\v7 mkdir build\v7
@if exist %name%.ma @copy /Y %name%.ma %MS%\mdlapps\%name%.ma
@if exist %name%.config @copy /Y %name%.config %MS%\mdlapps\%name%.config
@if exist %name%.ma @move /Y %name%.ma build\v7\%name%.ma
@if exist %name%.config @copy /Y %name%.config build\v7\%name%.config
@if exist README.md @copy /Y README.md build\v7\README.md

@for /R %%f in (*.mo) do @del "%%f"
@for %%f in (*.rsc) do @del %%f
@del mlink.txt
@del %name%.mp

@echo Remove temporary files
@cd app
@for %%f in (*.mo) do @del %%f
@cd ..
@cd core
@for %%f in (*.mo) do @del %%f
@cd ..

@pause