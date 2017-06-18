object dmCommd: TdmCommd
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  OnDestroy = DataModuleDestroy
  Height = 320
  Width = 306
  object PCCom: TApdWinsockPort
    WsLocalAddresses.Strings = (
      '192.168.1.78')
    WsLocalAddressIndex = 0
    WsPort = 'telnet'
    WsSocksServerInfo.Port = 0
    WsTelnet = False
    AutoOpen = False
    Baud = 9600
    BufferFull = 14000
    BufferResume = 1024
    ComNumber = 1
    HWFlowOptions = [hwfUseRTS, hwfRequireCTS]
    InSize = 16384
    TraceName = 'APRO.TRC'
    LogName = 'APRO.LOG'
    TapiMode = tmNone
    UseEventWord = False
    Left = 48
    Top = 40
  end
end
