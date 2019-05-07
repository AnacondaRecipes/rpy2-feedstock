:: Mixing MS CRT headers and mingw-w64 headers doesn't work
:: so build the whole thing with mingw-w64 instead.
echo [build]              > setup.cfg
echo compiler = mingw32  >> setup.cfg
set CFLAGS=-D__USE_MINGW_ANSI_STDIO
gendef %PREFIX%\python%CONDA_PY%.dll - > python%CONDA_PY%.def
dlltool -d python%CONDA_PY%.def -l %CONDA_DEFAULT_ENV%\libs\libpython%CONDA_PY%.dll.a

:: Create an empty library for msvcrt??? since CygwinCCompiler seems to
:: think that linking to that is a good idea (it is not).
<<<<<<< HEAD
if "%CONDA_PY%" == "37" (
  ar cru %CONDA_DEFAULT_ENV%\libs\libmsvcr140.dll.a
else (
  if "%CONDA_PY%" == "36" (
    ar cru %CONDA_DEFAULT_ENV%\libs\libmsvcr140.dll.a
  ) else (
    if "%CONDA_PY%" == "35" (
      ar cru %CONDA_DEFAULT_ENV%\libs\libmsvcr140.dll.a
    ) else (
      if "%CONDA_PY%" == "34" (
        ar cru %CONDA_DEFAULT_ENV%\libs\libmsvcr120.dll.a
      ) else (
        ar cru %CONDA_DEFAULT_ENV%\libs\libmsvcr90.dll.a
      )
    )
  )
)
=======
ar cru %PREFIX%\libs\libmsvcr140.dll.a
ar cru %PREFIX%\libs\libmsvcr120.dll.a
ar cru %PREFIX%\libs\libmsvcr90.dll.a
>>>>>>> 3e26bf3d833872943556fc5abbe1a0c68e6f9e85

gendef %PREFIX%\python%CONDA_PY%.dll - > python%CONDA_PY%.def
dlltool -d python%CONDA_PY%.def -l %PREFIX%\lib\libpython%CONDA_PY%.dll.a

"%PYTHON%" setup.py install
if errorlevel 1 exit 1

:: Cleanup the libs we made:
del %CONDA_DEFAULT_ENV%\libs\libpython%CONDA_PY%.dll.a
del %CONDA_DEFAULT_ENV%\libs\libmsvcr140.dll.a
del %CONDA_DEFAULT_ENV%\libs\libmsvcr120.dll.a
del %CONDA_DEFAULT_ENV%\libs\libmsvcr90.dll.a
