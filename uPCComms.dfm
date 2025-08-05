object dmCommd: TdmCommd
  OnCreate = DataModuleCreate
  OnDestroy = DataModuleDestroy
  Height = 320
  Width = 306
  object PCCom: TApdWinsockPort
    WsLocalAddresses.Strings = (
      '192.168.26.1'
      '192.168.88.1'
      '192.168.1.103')
    WsLocalAddressIndex = 0
    WsPort = 'telnet'
    WsSocksServerInfo.Port = 0
    WsTelnet = False
    AutoOpen = False
    Baud = 9600
    BufferFull = 3686
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
