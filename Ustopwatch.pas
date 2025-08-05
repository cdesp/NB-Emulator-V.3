{
    Grundy NewBrain Emulator Pro Made by Despsoft
    Copyright (c) 2004-Today , Despoinidis Chris

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <https://www.gnu.org/licenses/>.

}
unit Ustopwatch;

interface

uses Windows, SysUtils, DateUtils;

type TStopWatch = class
  private
    fFrequency : TLargeInteger;
    fIsRunning: boolean;
    fIsHighResolution: boolean;
    fStartCount, fStopCount : TLargeInteger;
    procedure SetTickStamp(var lInt : TLargeInteger) ;
    function GetElapsedTicks: TLargeInteger;
    function GetElapsedMilliseconds: TLargeInteger;
    function GetElapsed: string;
  public
    constructor Create(const startOnCreate : boolean = false) ;
    procedure Start;
    procedure Stop;
    property IsHighResolution : boolean read fIsHighResolution;
    property ElapsedTicks : TLargeInteger read GetElapsedTicks;
    property ElapsedMilliseconds : TLargeInteger read GetElapsedMilliseconds;
    property Elapsed : string read GetElapsed;
    property IsRunning : boolean read fIsRunning;
  end;

implementation

constructor TStopWatch.Create(const startOnCreate : boolean = false) ;
begin
  inherited Create;

  fIsRunning := false;

  fIsHighResolution := QueryPerformanceFrequency(fFrequency) ;
  if NOT fIsHighResolution then fFrequency := MSecsPerSec;

  if startOnCreate then Start;
end;

function TStopWatch.GetElapsedTicks: TLargeInteger;
begin
  result := fStopCount - fStartCount;
end;

procedure TStopWatch.SetTickStamp(var lInt : TLargeInteger) ;
begin
  if fIsHighResolution then
    QueryPerformanceCounter(lInt)
  else
    lInt := MilliSecondOf(Now) ;
end;

function TStopWatch.GetElapsed: string;
var
  dt : TDateTime;
begin
  dt := ElapsedMilliseconds / MSecsPerSec / SecsPerDay;
  result := Format('%d days, %s', [trunc(dt), FormatDateTime('hh:nn:ss.z', Frac(dt))]) ;
end;

function TStopWatch.GetElapsedMilliseconds: TLargeInteger;
begin
  result := (MSecsPerSec * (fStopCount - fStartCount)) div fFrequency;
end;

procedure TStopWatch.Start;
begin
  SetTickStamp(fStartCount) ;
  fIsRunning := true;
end;

procedure TStopWatch.Stop;
begin
  SetTickStamp(fStopCount) ;
  fIsRunning := false;
end;
end.
Here's an example of usage:

 var
  sw : TStopWatch;
  elapsedMilliseconds : cardinal;
begin
  sw := TStopWatch.Create() ;
  try
    sw.Start;
    //TimeOutThisFunction()
    sw.Stop;

    elapsedMilliseconds := sw.ElapsedMilliseconds;
  finally
    sw.Free;
  end;
end;
