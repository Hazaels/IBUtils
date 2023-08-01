unit InstanceManager;

interface

{Notes: make InstanceManager the *very first* unit in your program's USES
clause.  To take advantage of the notification and launch-string, put a
method with no parameters in one of your forms and assign it to triggerProc.
Once triggerProc is called, rcvStr contains the command line of the launch
attempt.

If the only reaction you want is to bring the first instance to the front,
just put a method like the following in your main form, and in the form's
OnCreate set InstanceManager.triggerProc:=ToFront;

    procedure TForm1.ToFront;
    begin
      Application.Restore;
      Application.BringToFront;
    end;

If you don't have a dependable main form, make ToFront a class procedure of
any old class.}

{ Customize these constants before using }
const UniqueAppName = 'IBUtils - Model tool for IB/FB';
      AppNotifyValue: integer = 0;

var rcvStr: string;
    rcvValue: integer;
    ForbidOtherInstance: boolean = True;
    triggerProc: procedure of object;

implementation

uses Windows, SysUtils, Messages;

var mutex, thisWnd: HWND;
    IMWndClass: TWndClassA;
    mustHalt: boolean;
    copydata: TCOPYDATASTRUCT;

function IMWndProc(HWindow: HWnd; Message, WParam: Longint; LParam: Longint): Longint; stdcall;
begin
  if Message=WM_COPYDATA then
    begin
      rcvStr := StrPas(PCOPYDATASTRUCT(lParam).lpData);
      SetLength(rcvStr, Integer(PCOPYDATASTRUCT(lParam).cbData));
      rcvValue := PCOPYDATASTRUCT(lParam).dwData;
      if Assigned(triggerProc) then triggerProc;
      Result := Ord(ForbidOtherInstance);
    end
  else
    Result := DefWindowProc(hWindow, Message, WParam, LParam);
end;

initialization

  FillChar(IMWndClass, SizeOf(IMWndClass), 0);
  IMWndClass.lpfnWndProc := @IMWndProc;
  IMWndClass.hInstance := HINSTANCE;
  IMwndClass.lpszClassName := 'TInstanceManager';
  if Windows.RegisterClass(IMWndClass) = 0 then RaiseLastWin32Error;
  mutex := CreateMutex(nil, True, UniqueAppName);
  if GetLastError = ERROR_ALREADY_EXISTS then
    begin
      mustHalt := True;
      if WaitForSingleObject(mutex, 5000)=WAIT_OBJECT_0 then
        begin
          thisWnd := FindWindow(IMwndClass.lpszClassName, UniqueAppName);
          if thisWnd = 0 then RaiseLastWin32Error;
          CopyData.dwData := AppNotifyValue;
          CopyData.lpData := CmdLine;
          CopyData.cbData := StrLen(CmdLine);
          mustHalt := (SendMessage(thisWnd,WM_COPYDATA,0,Integer(@CopyData))>0);
        end;
      thisWnd := 0;
      ReleaseMutex(mutex);
      if mustHalt then Halt;
    end
  else
    begin
      thisWnd := CreateWindow(IMwndClass.lpszClassName,UniqueAppName,0,0,0,0,0,0,0,hInstance, nil);
      if thisWnd = 0 then RaiseLastWin32Error;
      ReleaseMutex(mutex);
    end;

finalization
  if thisWnd>0 then DestroyWindow(thisWnd);

end.

