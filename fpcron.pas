{$mode objfpc}{$H+}

uses
  Classes,SysUtils,DateUtils,Process;

var
  CheckIntervalMilliSeconds,IntervalSeconds: Int64;
  InputFilePath,TaskCommand: String;
  TaskList: TStringList;
  i: Integer;
  LastExecTime: TDateTime;
begin
  if ParamCount = 2 then begin
    try
      CheckIntervalMilliSeconds := StrToInt64(ParamStr(1));
      InputFilePath := ParamStr(2);
      TaskList := TStringList.Create;
      while true do begin
        Sleep(CheckIntervalMilliSeconds);
        try
          TaskList.LoadFromFile(InputFilePath);
          for i := 0 to TaskList.Count - 1 do begin
            ReadStr(TaskList[i],LastExecTime,IntervalSeconds,TaskCommand);
            TaskCommand := Trim(TaskCommand);
            if IncSecond(LastExecTime,IntervalSeconds) <= Now then begin
              with TProcess.Create(nil) do begin
                Options := [];
                CommandLine := TaskCommand;
                Execute;
                Free;
              end;
              TaskList[i] := Format('%.16f %d %s',[Now,IntervalSeconds,TaskCommand]);
            end;
          end;
          TaskList.SaveToFile(InputFilePath);
        except
          on e: Exception do begin
            WriteLn(StdErr,e.Message);
          end;
        end;
      end;
    except
      on e: Exception do begin
        WriteLn(StdErr,e.Message);
      end;
    end;
  end else begin
    WriteLn('Usage: ' + ExtractFileName(ParamStr(0)) + ' <check interval in milliseconds> <input file path>')
  end;
end.
