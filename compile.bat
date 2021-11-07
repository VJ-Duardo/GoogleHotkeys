set dir_name="GoogleHotkeys-0.3.7"

set au3exe_path="C:\Program Files (x86)\AutoIt3\AutoIt3.exe"
set au3wr_path="C:\Program Files (x86)\AutoIt3\SciTE\AutoIt3Wrapper\AutoIt3Wrapper.au3"
set au2ex_path="C:\Program Files (x86)\AutoIt3\Aut2Exe\Aut2exe.exe"


if not exist %dir_name% (
mkdir %dir_name%/
)


%au3exe_path% %au3wr_path% /NoStatus /prod /in "GoogleHotkeys.au3"
%au3exe_path% %au3wr_path% /NoStatus /prod /in "GoogleHotkeysSettings.au3"