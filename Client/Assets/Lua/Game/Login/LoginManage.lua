-- 登录管理
local GamePart = require("FrameWork/Game/GamePart")
local UIType = require("Game/UI/UIType")
local registerAccount = nil
local registerPwd = nil
local EventType = require("Game/Util/EventType");
local EventService = require("Game/Util/EventService")
local LoginStateType = require("Game/Login/State/LoginStateType");
local LoginManage = class("LoginManage", GamePart)
local Client = require("Game/Client")

-- 构造函数
function LoginManage:ctor()
    LoginManage.super.ctor(self)
    self._relationId = nil
    -- 出生州id
    self._bornStateId = 0;
    -- 当前执行流程
    self.loginStateManage = require("Game/State/StateManage").new();
    self.roleId = -1;
    self.curLState = nil;
    self.exitGame = false
    -- 是否包含角色名称
    self._isHavePlayerName = false
end

-- 初始化
function LoginManage:_OnInit()
    self:RegisterAllState();
end

function LoginManage:SetExitGame(args)
    self.exitGame = args
end

function LoginManage:GetExitGame(args)
    return self.exitGame
end

-- 心跳
function LoginManage:_OnHeartBeat()
end

-- 停止
function LoginManage:_OnStop()
end

-- 登录状态管理
function LoginManage:RegisterAllState()

    self.loginStateManage:RegisterState(LoginStateType.RegisterAccount, "Game/Login/State/RegisterAccount");
    self.loginStateManage:RegisterState(LoginStateType.LoginAccount, "Game/Login/State/LoginAccount");
    self.loginStateManage:RegisterState(LoginStateType.LoginLogic, "Game/Login/State/LoginLogic");
    self.loginStateManage:RegisterState(LoginStateType.CreateRole, "Game/Login/State/CreateRole");
    self.loginStateManage:RegisterState(LoginStateType.SendCreateRole, "Game/Login/State/SendCreateRole");
    self.loginStateManage:RegisterState(LoginStateType.RequestPlayerInfo, "Game/Login/State/RequestPlayerInfo");
    self.loginStateManage:RegisterState(LoginStateType.RequestCurrencyInfo, "Game/Login/State/RequestCurrencyInfo");
    self.loginStateManage:RegisterState(LoginStateType.RequestResourceInfo, "Game/Login/State/RequestResourceInfo");
    self.loginStateManage:RegisterState(LoginStateType.CreateMap, "Game/Login/State/CreateMap");
    self.loginStateManage:RegisterState(LoginStateType.RequestBuildingInfo, "Game/Login/State/RequestBuildingInfo");
    self.loginStateManage:RegisterState(LoginStateType.RequestCardInfo, "Game/Login/State/RequestCardInfo");
    self.loginStateManage:RegisterState(LoginStateType.RequestSkillInfo, "Game/Login/State/RequestSkillInfo");
    self.loginStateManage:RegisterState(LoginStateType.RequestArmyInfo, "Game/Login/State/RequestArmyInfo");
    self.loginStateManage:RegisterState(LoginStateType.ServerTime, "Game/Login/State/ServerTime");
    self.loginStateManage:RegisterState(LoginStateType.EnterGame, "Game/Login/State/EnterGame");
    self.loginStateManage:RegisterState(LoginStateType.Empty, "Game/Login/State/Empty");
    self.loginStateManage:RegisterState(LoginStateType.OpenCityFacility, "Game/Login/State/OpenCityFacility");
    self.loginStateManage:RegisterState(LoginStateType.RequestRechargeInfo, "Game/Login/State/RequestRechargeInformations");
    self.loginStateManage:RegisterState(LoginStateType.RequestMailInfo, "Game/Login/State/RequestMailAllInfo");
    self.loginStateManage:RegisterState(LoginStateType.RequestWordTendencyInfo, "Game/Login/State/RequestWordTendencyInfo")
    self.loginStateManage:RegisterState(LoginStateType.SyncMarkerInfos, "Game/Login/State/SyncMarkerInfos");
    self.loginStateManage:RegisterState(LoginStateType.RequestRecruitInfo, "Game/Login/State/RequestRecruitInfo");
    self.loginStateManage:RegisterState(LoginStateType.RequestPlayerBuilding, "Game/Login/State/RequestPlayerBuilding");
    self.loginStateManage:RegisterState(LoginStateType.RequestSyncCreateFortTime, "Game/Login/State/RequestSyncCreateFortTime");
    self.loginStateManage:RegisterState(LoginStateType.OpenOwnWildBuildRequest, "Game/Login/State/OpenOwnWildBuildRequest");
    self.loginStateManage:RegisterState(LoginStateType.RequestTiledIdInfo, "Game/Login/State/RequestTiledIdInfo");
    self.loginStateManage:RegisterState(LoginStateType.RequestPlayerTiledInfo, "Game/Login/State/RequestPlayerTiledInfo");
    self.loginStateManage:RegisterState(LoginStateType.RequestSourceEvent, "Game/Login/State/RequestSourceEvent");
    self.loginStateManage:RegisterState(LoginStateType.RequestRevenueIdInfo, "Game/Login/State/SyncRevenueInfo")
    self.loginStateManage:RegisterState(LoginStateType.RequestOccupyWildCity, "Game/Login/State/RequestOccupyWildCity")
    self.loginStateManage:RegisterState(LoginStateType.RequestLeagueInfo, "Game/Login/State/RequestLeagueInfo")
    self.loginStateManage:RegisterState(LoginStateType.OpenDiplomacyLeagueRequest, "Game/Login/State/OpenDiplomacyLeagueRequest")
    -- 聊天
    -- print("注册聊天")
    self.loginStateManage:RegisterState(LoginStateType.JoinChannel, "Game/Login/State/JoinChannel");
    self.loginStateManage:RegisterState(LoginStateType.RequestPlayerInfluence, "Game/Login/State/RequestPlayerInfluence");
    -- 最后一个 EnterGame

end

-- 进入状态
function LoginManage:EnterState(loginState, ...)
    if loginState == nil then
        return;
    end
    self.loginStateManage:EnterState(loginState, ...);
end

--[[ 登陆逻辑 ]]
function LoginManage:HandlePlayerList(roleId)
    -- print("玩家roleId == " .. roleId)
    if roleId > 0 then
        PlayerService:Instance():SetPlayerId(roleId)
    end
    self.roleId = roleId
    NetService:Instance():ConnectTCPServer();
end

function LoginManage:GoToEnterState()
    if self.roleId < 0 then
        self:EnterState(LoginStateType.CreateRole);
    else
        PlayerService:Instance():SetPlayerId(self.roleId)
        self.curLState = StateManage.Instance():GetCurState()
        GameResFactory.Instance():LoadLevel("Clear");
        -- self:GameStart();
        -- NetService:Instance():ConnectTCPServer();
    end
end

function LoginManage:GoToEnterStateConnect()
    print("链接成功开始发送消息");
    self:EnterState(LoginStateType.RequestPlayerInfo);
    self:EnterState(LoginStateType.RequestPlayerBuilding);
    self:EnterState(LoginStateType.OpenOwnWildBuildRequest);
    self:EnterState(LoginStateType.RequestTiledIdInfo);
    self:EnterState(LoginStateType.RequestRevenueIdInfo)
    self:EnterState(LoginStateType.RequestOccupyWildCity)
end

-- 发送注册消息
function LoginManage:SendRegisterMessage(account, password)
    registerAccount = account
    registerPwd = password
    self:EnterState(LoginStateType.RegisterAccount, account, password);
end

-- 登录成功ui
function LoginManage:LoginSuccess(accountId, certificate)

    PlayerService:Instance():SetAccountId(accountId)
    PlayerService:Instance():SetCertificate(certificate)
    UIService:Instance():HideUI(UIType.UIRegisterAccount);
    UIService:Instance():HideUI(UIType.UILoginGame)
    UIService:Instance():ShowUI(UIType.UIStartGame)
    -- self:EnterState(LoginStateType.LoginLogic, certificate);

end

function LoginManage:_OnHeartBeat()
--    if UIService:Instance():GetOpenedUI(UIType.LoadingUI) and UIService:Instance():GetUIClass(UIType.LoadingUI) ~= nil then
--        UIService:Instance():GetUIClass(UIType.LoadingUI):OnBeat()
--    end
end


-- 创建角色成功跳转到游戏主界面
function LoginManage:_CreateRoleSuccess(roleId)
    if roleId >= 0 then
        self.roleId = roleId;
        PlayerService:Instance():SetPlayerId(roleId)
        self.curLState = StateManage.Instance():GetCurState()
        NetService:Instance():ConnectTCPServer();
    end
end

function LoginManage:RegisterSuccess()
    self:EnterState(LoginStateType.LoginAccount, registerAccount, registerPwd);
end

-- 同步玩家结束
function LoginManage:SyncPlayerInfoEnd()
    -- self:RequestMainCityFacility();
    -- SyncService:Instance():StartSyncInfo();
end

function LoginManage:SyncTiledInfo()
    -- body
end

-- 设置玩家的出生州
function LoginManage:SetBornStateId(stateId)
    self._bornStateId = stateId;
end

-- 获取玩家的出生州
function LoginManage:GetBornStateId()
    return self._bornStateId;
end

function LoginManage:HandleSyncGold(gold, jade)
    PlayerService:Instance():GetCurrencyVarCalcByKey(CurrencyEnum.Money):Init(gold, os.time())
    PlayerService:Instance():GetCurrencyVarCalcByKey(CurrencyEnum.Jade):Init(jade, os.time())
    EventService:Instance():TriggerEvent(EventType.ResourceJadeGold);
end

-- 检查登录状态 
function LoginManage:IsLoginState(loginState)
    return self.loginStateManage:IsState(loginState);
end


function LoginManage:GameStart()
    StateManage.Instance():SetCurState(self.curLState)
    UIService:Instance():ShowUI(UIType.LoadingUI)
    self:EnterState(LoginStateType.RequestPlayerInfo);
    self:EnterState(LoginStateType.RequestPlayerBuilding);
    self:EnterState(LoginStateType.OpenOwnWildBuildRequest);
    self:EnterState(LoginStateType.RequestTiledIdInfo);
    self:EnterState(LoginStateType.RequestRevenueIdInfo)
    self:EnterState(LoginStateType.RequestOccupyWildCity)
    self:EnterState(LoginStateType.RequestWordTendencyInfo)
end

-- 是否包含角色名称
function LoginManage:_IsHavePlayerName(signNum)
    if signNum < 0 then
        self._isHavePlayerName = false
        return
    end
    self._isHavePlayerName = true
end

-- 是否包含角色名称
function LoginManage:IsHavePlayerName()
    return self._isHavePlayerName
end

-- 处理断线
function LoginManage:HandleDisconnect(disConnectAdapterId)
    self:SendExitGame(disConnectAdapterId)
    self:ExitGame()
end

-- 退出游戏
function LoginManage:ExitGame()

    PlayerService:Instance():StopAllTimers()
    NetService:Instance():CloseTcpServer()
    PlayerService:Instance():SetOutofGame()
    LoginService:Instance():SetExit(true)
    UIService:Instance():ClearcommonBlackBg()
    EffectsService:Instance():RemoveAllEffect()
    CommonService:Instance():RemoveAllTimeDownInfo()
    UIService:Instance():RemoveUI(UIType.UIBreathingFrame)
    Client:Instance():ClearData()
    UIService:Instance():ClearClickUI()
    MessageService:Instance():RemoveAllNotice()
    GameResFactory.Instance():LoadLevel("Login")

end

function LoginManage:SendExitGame(disConnectAdapterId)
    local msg = require("MessageCommon/Msg/C2L/Player/ExitGame").new()
    msg:SetMessageId(C2L_Player.ExitGame)
    msg.disConnectAdapterId = disConnectAdapterId
    NetService:Instance():SendMessage(msg, false)
end

return LoginManage;
