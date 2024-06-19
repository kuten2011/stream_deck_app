Set WshShell = CreateObject("WScript.Shell")
WshShell.Run "cmd.exe /c python server.py", 0
Set WshShell = Nothing
