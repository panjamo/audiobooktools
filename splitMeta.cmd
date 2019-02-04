REM @ECHO OFF
SETLOCAL
DEL 0*.m4a
DEL #*.m4a 
DEL cover.jpg

REM COVER
DEL cover.jpg
pushd %1
ffmpeg -i "%~1.m4a" -an -vcodec copy cover.jpg & copy cover.jpg ..
popd
start "" cover.jpg

REM Google Suche
start "" "https://www.google.com/search?esrch=BetaShortcuts&q=%~1"

REM edit METADATA
ECHO ARTIST#TITLE#date > %temp%\meta.txt
ECHO %~n1 >> %temp%\meta.txt
REM CALL code --new-window --wait . %temp%\meta.txt
CALL notepad %temp%\meta.txt

SET /p META=<%temp%\meta.txt
ECHO %META%
ECHO Everything ok? (presse ctrl+c to abort)
PAUSE

FOR /f "tokens=1,2,3 delims=#" %%x IN ("%META%") do (

    REM rename folder
    SET newFolderName=
    RENAME %1 "%%x - %%y - %%z"
    PUSHD "%%x - %%y - %%z"

    ffmpeg -i "%~1.m4a"^
    -threads 3^
    -acodec copy^
    -f segment^
    -segment_time 20:00^
    -segment_start_number 1^
    -reset_timestamps 1^
    "#%%03d#%%x#%%y#%%z.m4a"

    FOR /r %%n in (#*) do (
        FOR /f "tokens=1,2,3,4 delims=#" %%a IN ("%%~nn") do (
            ffmpeg -i "%%n"^
                -acodec copy^
                -max_muxing_queue_size 269655^
                -metadata TRACK="%%a"^
                -metadata TITLE="%%a"^
                -metadata ARTIST="%%b"^
                -metadata ALBUM="%%c"^
                -metadata date="%%d"^
                "%%a - %%b - %%c - %%d.m4a"
        )
    )
)
ECHO Everything ok? (presse ctrl+c to abort), other delete
ECHO %1 and the splits
PAUSE
DEL %1 
DEL #*.m4a