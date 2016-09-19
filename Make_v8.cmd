@set name=PhotoArrow

@set MS=c:\win32app\ustation.v8\Program\MicroStation
@set INCLUDE=%MS%\mdl\include;%INCLUDE%
@set LIB=%MS%\mdl\library
@set MDL_COMP=-i%MS%\mdl\include -i%cd% -i%cd%\%lang% -i%MS%\mdl\include\stdlib
@set BMAKE_OPT=-I%MS%\mdl\include
@set PATH=;%MS%;%MS%\mdl\bin\;%PATH%
@set MLINK_STDLIB=%MS%\mdl\library\builtin.dlo %MS%\mdl\library\dgnfileio.dlo %MS%\mdl\library\toolsubs.dlo %MS%\mdl\library\ditemlib.dlo %MS%\mdl\library\mdllib.dlo %MS%\mdl\library\mtg.dlo %MS%\mdl\library\rdbmslib.dlo

@if exist %name%.ma del %name%.ma

@echo -a%name%.mp>mlink.txt
@echo Compiling app\*.mc
@cd app
@for %%g in (*.mc) do @echo app\%%~ng.mo>>..\mlink.txt && mcomp -b %%g
@cd ..
@echo Compiling core\*.mc
@cd core
@for %%g in (*.mc) do @echo core\%%~ng.mo>>..\mlink.txt && mcomp -b %%g
@cd ..

@rem rsctype ui-cfg.mt

@echo Compiling resources *.r
@rcomp -fwinNT %mdl_comp% -h ui-cmd.r
@rcomp -fwinNT %mdl_comp% ui.r
@rem rcomp -fwinNT %mdl_comp% ui-cfg.r

@echo Compiling *.mc
@for %%f in (*.mc) do @echo %%~nf.mo>>mlink.txt && mcomp -b %%f
@rem echo %MS%\mdl\library\rdbmslib.ml>>mlink.txt
@rem echo %MS%\mdl\library\mdllib.ml>>mlink.txt

@echo Linking
@mlink @mlink.txt
@rlib -fwinNT -o%name%.ma %name%.mp ui.rsc ui-cmd.rsc
@rem ui-cmd.rsc
@rem ui-cfg.rsc

@echo Build and autoinstall mdl
@if not exist build mkdir build
@if not exist build\v8 mkdir build\v8
@if exist %name%.ma copy /Y %name%.ma %MS%\mdlapps\%name%.ma
@if exist %name%.ma move /Y %name%.ma build\v8\%name%.ma
@if exist %name%.config @copy /Y %name%.config build\v8\%name%.config
@if exist README.md @copy /Y README.md build\v8\README.md

@echo Removing temporary files
@for /R %%f in (*.mo) do @del "%%f"
@for %%f in (*.rsc) do @del %%f
@del mlink.txt
@del %name%.mp

@cd app
@for %%f in (*.mo) do @del %%f
@cd ..
@cd core
@for %%f in (*.mo) do @del %%f
@cd ..

@pause