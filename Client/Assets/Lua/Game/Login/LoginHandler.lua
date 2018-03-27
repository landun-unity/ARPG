-- 登录消息处理
local IOHandler = require("FrameWork/Game/IOHandler")

local LoginHandler = class("LoginHandler", IOHandler)
local LayerType = require("Game/Map/LayerType")
local TiledManage = require("Game/Map/TiledManage")
local LoadResourcesPrefab = require("Game/Util/LoadResourcesPrefab")
local Marker = require("Game/Map/Marker")
local TiledDurable = require("MessageCommon/Msg/L2C/Player/TiledDurable");

-- 构造函数
function LoginHandler:ctor()
    LoginHandler.super.ctor(self);
    self._drawLoadResourcesPrefab = LoadResourcesPrefab.new()
    self._UISignObject = nil;
    self._allLayerMap = { };
    self.tiled = nil;
    self._UISignMainObject = nil;
end

-- 注册所有消息
function LoginHandler:RegisterAllMessage()
    self:RegisterMessage(A2C_EhooLogin.EhooLoginRespond, self.HandleDoLogin, require("MessageCommon/Msg/A2C/EhooLogin/EhooLoginRespond"));
    self:RegisterMessage(A2C_EhooLogin.EhooRegisterRespond, self.HandleRegister, require("MessageCommon/Msg/A2C/EhooLogin/EhooRegisterRespond"));
    self:RegisterMessage(A2C_EhooLogin.LoginErrorPrompt, self.HandleLoginErrorPrompt, require("MessageCommon/Msg/A2C/EhooLogin/LoginErrorPrompt"));
    self:RegisterMessage(L2C_Account.GetPlayerListRespond, self.HandlePlayerList, require("MessageCommon/Msg/L2C/Account/GetPlayerListRespond"));
    self:RegisterMessage(L2C_Account.CreateRoleSuccess, self.HandleCreateRoleSuccess, require("MessageCommon/Msg/L2C/Account/CreateRoleSuccess"));
    self:RegisterMessage(L2C_Player.SyncServerTimeRespond, self.SyncServerTimeRespond, require("MessageCommon/Msg/L2C/Player/SyncServerTimeRespond"));
    self:RegisterMessage(L2C_Player.PlayerBaseInfo, self.HandlePlayerBaseInfo, require("MessageCommon/Msg/L2C/Player/PlayerBaseInfo"));
    self:RegisterMessage(L2C_Player.SyncLoginServerTime, self.SyncLoginServerTime, require("MessageCommon/Msg/L2C/Player/SyncLoginServerTime"));
    self:RegisterMessage(L2C_Player.SyncPlayerInfoEnd, self.HandleSyncPlayerInfoEnd, require("MessageCommon/Msg/L2C/Player/SyncPlayerInfoEnd"));
    self:RegisterMessage(L2C_Player.SyncPlayerBaseInfo, self.HandleSyncPlayerBaseInfo, require("MessageCommon/Msg/L2C/Player/SyncPlayerBaseInfo"));
    self:RegisterMessage(L2C_Player.LeagueBaseInfo, self.HandleLeagueBaseInfo, require("MessageCommon/Msg/L2C/Player/LeagueBaseInfo"));
    self:RegisterMessage(L2C_Player.SyncPlayerMarkerInfo, self.SyncPlayerMarkerInfo, require("MessageCommon/Msg/L2C/Player/SyncPlayerMarkerInfo"))
    self:RegisterMessage(L2C_Player.ReturnUnmarkResult, self.HandleReturnUnmarkResult, require("MessageCommon/Msg/L2C/Player/ReturnUnmarkResult"))
    self:RegisterMessage(L2C_Player.ReturnMarkResult, self.HandleReturnMarkResult, require("MessageCommon/Msg/L2C/Player/ReturnMarkResult"))
    self:RegisterMessage(L2C_Player.RevenueInfo, self.HandleSyncRevenueTimeInfo, require("MessageCommon/Msg/L2C/Player/RevenueInfo"))
    self:RegisterMessage(L2C_Player.SyncForced, self.HandleSyncForced, require("MessageCommon/Msg/L2C/Player/SyncForced"))
    self:RegisterMessage(L2C_Player.SyncImmediatelyFinish, self.HandleSyncImmediatelyFinish, require("MessageCommon/Msg/L2C/Player/SyncImmediatelyFinish"))
    self:RegisterMessage(L2C_Player.SyncOwnerCity, self.HandleSyncOwnerCity, require("MessageCommon/Msg/L2C/Player/SyncOwnerCity"))
    self:RegisterMessage(L2C_Player.SyncTiledIdList, self.HandleSyncTiledIdList, require("MessageCommon/Msg/L2C/Player/SyncTiledIdList"))
    self:RegisterMessage(L2C_Player.SyncTiledDurableList, self.HandleSyncTiledDurableList, require("MessageCommon/Msg/L2C/Player/SyncTiledDurableList"));
    self:RegisterMessage(L2C_Player.RevenueCountInfo, self.HandleSyncRevenueCountInfo, require("MessageCommon/Msg/L2C/Player/RevenueCountInfo"));
    self:RegisterMessage(L2C_Player.SyncRevenueAllInfo, self.HandleSyncRevenueAllInfo, require("MessageCommon/Msg/L2C/Player/SyncRevenueAllInfo"));
    self:RegisterMessage(L2C_Player.ReturnIntroductions, self.HandleReturnIntroductions, require("MessageCommon/Msg/L2C/Player/ReturnIntroductions"));
    self:RegisterMessage(L2C_Player.ResponseIsHavePlayerName, self.HandleIsHavePlayerName, require("MessageCommon/Msg/L2C/Player/ResponseIsHavePlayerName"));
    self:RegisterMessage(L2C_Map.SyncPlayerAllTiled, self.HandleSyncPlayerAllTiled, require("MessageCommon/Msg/L2C/Map/SyncPlayerAllTiled"));
    self:RegisterMessage(L2C_Map.SyncPlayerOneTiled, self.HandleSyncPlayerOneTiled, require("MessageCommon/Msg/L2C/Map/SyncPlayerOneTiled"));
    self:RegisterMessage(L2C_Map.RemovePlayerOneTiled, self.HandleRemovePlayerOneTiled, require("MessageCommon/Msg/L2C/Map/RemovePlayerOneTiled"));
    self:RegisterMessage(L2C_Player.PlayerGainNewTiled, self.HandlePlayerGainNewTiled, require("MessageCommon/Msg/L2C/Player/PlayerGainNewTiled"));
    self:RegisterMessage(L2C_Player.PlayerLostOldTiled, self.HandlePlayerLostOldTiled, require("MessageCommon/Msg/L2C/Player/PlayerLostOldTiled"));
    self:RegisterMessage(L2C_Player.SyncPlayerInfluence, self.HandleSyncPlayerInfluence, require("MessageCommon/Msg/L2C/Player/SyncPlayerInfluence"));
    self:RegisterMessage(L2C_Player.SyncChatTimes, self.HandleSyncChatTimes, require("MessageCommon/Msg/L2C/Player/SyncChatTimes"));
    self:RegisterMessage(L2C_Player.Disconnect, self.HandleDisconnect, require("MessageCommon/Msg/L2C/Player/Disconnect"));
end

function LoginHandler:HandleLoginErrorPrompt(msg)
    UIService:Instance():ShowUI(UIType.UICueMessageBox,msg.tips);
end


function LoginHandler:HandleLeagueBaseInfo(msg)

    LoginService:Instance():EnterState(LoginStateType.RequestPlayerTiledInfo);
    PlayerService:Instance():SetPlayerTitle(msg.title);
    PlayerService:Instance():SetsuperiorLeagueId(msg.superiorLeagueId);
    PlayerService:Instance():SetLeagueId(msg.leagueId);
    PlayerService:Instance():SetLeagueLevel(msg.leagueLevel);
    PlayerService:Instance():SetLeagueName(msg.leagueName);
    PlayerService:Instance():SetsuperiorName(msg.superiorName);
    local bassClass = UIService:Instance():GetUIClass(UIType.UIGameMainView);
    if bassClass then
        bassClass:ChangeRebellState();
    end
    if bassClass and msg.isPlayerRed ==1 then
        bassClass:CanShoweLeagueRedImage(true);
        else
        bassClass:CanShoweLeagueRedImage(false);
    end
end

function LoginHandler:HandleDoLogin(msg)
    self._logicManage:LoginSuccess(msg:GetRelationId(), msg.certificate)
    CommonService:Instance():PlayBG("Audio/PointStart")
    --CommonService:Instance():Play("",0)
end

function LoginHandler:HandleRegister(msg)
    self._logicManage:RegisterSuccess(msg)

end

function LoginHandler:HandlePlayerList(msg)
    print(msg.roleId)
    self._logicManage:HandlePlayerList(msg.roleId)
end

function LoginHandler:HandleCreateRoleSuccess(msg)
    self._logicManage:_CreateRoleSuccess(msg.roleId)
end

function LoginHandler:HandleSyncPlayerInfoEnd(msg)
    self._logicManage:SyncPlayerInfoEnd()
end

-- 处理玩家基础信息同步
function LoginHandler:HandleSyncPlayerBaseInfo(msg)
    PlayerService:Instance():SetName(msg.name);

    PlayerService:Instance():SetMainCityTiledId(msg.mainCityTiledId);

    PlayerService:Instance():SetPlayerTitle(msg.title);

    PlayerService:Instance():SetmainCityId(msg.mainCityId);

    PlayerService:Instance():SetsuperiorLeagueId(msg.superiorLeagueId);

    PlayerService:Instance():SetLeagueId(msg.leagueId);

    PlayerService:Instance():SetLeagueName(msg.leagueName);

    PlayerService:Instance():SetLeagueLevel(msg.leagueLevel);

    PlayerService:Instance():SetProfile(msg.playerProfile);

    PlayerService:Instance():SetConstructionQueueMaxValue(msg.baseConstructQueueMax, msg.tempConstructQueueMax);

    if (PlayerService:Instance():GetPlayerLoginState() ~= true) then
        BuildingService:Instance():ClearAllBuilding();
    end
    HeroService:Instance():SetCardMaxLimit(msg.cardPackageMax);
end

function LoginHandler:HandlePlayerBaseInfo(msg)

    PlayerService:Instance():SetName(msg.name);

    PlayerService:Instance():SetMainCityTiledId(msg.mainCityTiledId);

    PlayerService:Instance():SetPlayerTitle(msg.title);
    PlayerService:Instance():SetmainCityId(msg.mainCityId);

    PlayerService:Instance():SetsuperiorLeagueId(msg.superiorLeagueId);

    PlayerService:Instance():SetLeagueId(msg.leagueId);

    PlayerService:Instance():SetLeagueLevel(msg.leagueLevel);

    PlayerService:Instance():SetLeagueName(msg.leagueName);

    PlayerService:Instance():SetProfile(msg.playerProfile);

    PlayerService:Instance():SetSpawnState(msg.spawnState);

    PlayerService:Instance():SetConstructionQueueMaxValue(msg.baseConstructQueueMax, msg.tempConstructQueueMax);

    GuideServcice:Instance():SetTotalStep(msg.guideStep);

    NewerPeriodService:Instance():SyncNewerPeriod(msg.curNewerPeriod, msg.newerPeriodEndTime);

    HeroService:Instance():SetCardMaxLimit(msg.cardPackageMax);
    print(msg.chatTimes)
    PlayerService:Instance():SetPlayerChatTimes(msg.chatTimes);

    if (PlayerService:Instance():GetPlayerLoginState() ~= true) then
        BuildingService:Instance():ClearAllBuilding();
        self._logicManage:EnterState(LoginStateType.CreateMap);
    end
end 

-- 同步服务器时间
function LoginHandler:SyncServerTimeRespond(msg)
    PlayerService:Instance():SetLocalTime(msg.time);
end

function LoginHandler:SyncLoginServerTime(msg)
    PlayerService:Instance():SetLocalTime(msg.time);
end


-- 同步标记回复
function LoginHandler:SyncPlayerMarkerInfo(msg)
    local markerCount = msg.allTiledIndexList:Count();
    -- print(markerCount)
    LoginService:Instance():EnterState(LoginStateType.RequestRecruitInfo);
    for i = 1, markerCount do
        self._Marker = Marker.new()
        local tiledIndex = msg.allTiledIndexList:Get(i).tiledIndex;
        local name = msg.allTiledIndexList:Get(i).name;
        self._Marker.name = name
        self._Marker.tiledIndex = tiledIndex
        PlayerService:Instance():InsertMarkerList(tiledIndex);
        PlayerService:Instance():SetMarker(self._Marker);
        PlayerService:Instance():SetMarkerMap(tiledIndex, self._Marker)
        local parent = MapService:Instance():GetLayerParent(LayerType.Army);
        self._drawLoadResourcesPrefab:SetResPath("UIPrefab/UISign")
        self._drawLoadResourcesPrefab:Load(parent, function(UISignObject)
            self._UISignObject = UISignObject
            PlayerService:Instance():InsertMakrerIconMap(tiledIndex, UISignObject)
            self:_OnShowMarkSign(UISignObject, parent, tiledIndex)
        end )
    end
end



-- 请求取消标记回复
function LoginHandler:HandleReturnUnmarkResult(msg)
    local tiledIndex = msg.tiledIndex
    local marker = PlayerService:Instance():GetMarkerMap(tiledIndex);
    PlayerService:Instance():DeleteMarkers(marker);
    PlayerService:Instance():RemoveMarkerMap(tiledIndex)
    PlayerService:Instance():DeleteMarker(tiledIndex);
    local UISignObject = PlayerService:Instance():GetMarkerIconMap(tiledIndex);
    self._drawLoadResourcesPrefab:Recovery(UISignObject);
    self.UISignObject = nil
    UIService:Instance():ShowUI(UIType.UICueMessageBox, UICueMessageType.CancelMarker);
end

-- 请求标记回复
function LoginHandler:HandleReturnMarkResult(msg)
    self._Marker = Marker.new()
    self._Marker.name = msg.name;
    self._Marker.tiledIndex = msg.tiledIndex
    -- Marker.type = msg.type;
    PlayerService:Instance():SetMarker(self._Marker);
    local tiledIndex = msg.tiledIndex
    PlayerService:Instance():InsertMarkerList(tiledIndex)
    PlayerService:Instance():SetMarkerMap(tiledIndex, self._Marker)
    local parent = MapService:Instance():GetLayerParent(LayerType.Army);
    self._drawLoadResourcesPrefab:SetResPath("UIPrefab/UISign")
    self._drawLoadResourcesPrefab:Load(parent, function(UISignObject)
        self._UISignObject = UISignObject
        PlayerService:Instance():InsertMakrerIconMap(tiledIndex, UISignObject)
          local x, y = MapService:Instance():GetTiledCoordinate(tiledIndex)
    -- tiled:SetTiledImage(LayerType.Line, UISignObject.transform);
    local pos= MapService:Instance():GetTiledPositionSign(x, y);
    UISignObject.transform.localPosition  = Vector3.New(pos.x,pos.y+200,0);
    UISignObject.transform:DOLocalMove(pos,.6)
    UISignObject.transform.localScale = Vector3.one;
    end )
    UIService:Instance():ShowUI(UIType.UICueMessageBox, UICueMessageType.MarkerSucceed);
end

function LoginHandler:_OnShowMarkSign(UISignObject, parent, tiledIndex)
    local x, y = MapService:Instance():GetTiledCoordinate(tiledIndex)
    -- tiled:SetTiledImage(LayerType.Line, UISignObject.transform);
    UISignObject.transform.localPosition = MapService:Instance():GetTiledPositionSign(x, y);
    UISignObject.transform.localScale = Vector3.one;
end


function LoginHandler:HandleSyncRevenueTimeInfo(msg)
    local gold = msg.gold
    local count = msg.count
    local time = msg.time
    local finishTime = msg.finishTime
    local forceCount = msg.forceCount
    PlayerService:Instance():SetClickRevenueGold(gold)
    PlayerService:Instance():SetRevenueCount(count)
    PlayerService:Instance():SetRevenuefinishTime(finishTime)
    PlayerService:Instance():SetForceRevenueCount(forceCount)
end

function LoginHandler:HandleSyncRevenueCountInfo(msg)
    local count = msg.count
    PlayerService:Instance():SetRevenueCount(count)
end

-- 强征
function LoginHandler:HandleSyncForced(msg)
    local gold = msg.gold;
    local time = msg.time;
    local ForcedCount = msg.forcedCount;
    PlayerService:Instance():SetClickRevenueGold(gold);
    PlayerService:Instance():SetForceRevenueCount(ForcedCount)
end
-- 立即完成税收
function LoginHandler:HandleSyncImmediatelyFinish(msg)
    local gold = msg.gold;
    local time = msg.time;
    local surplusReceiveCount = msg.surplusReceiveCount;
    PlayerService:Instance():SetClickRevenueGold(gold)
    PlayerService:Instance():SetRevenueCount(surplusReceiveCount)
end

function LoginHandler:HandleSyncRevenueAllInfo(msg)
    local oneGold = msg.oneGold
    local twoGold = msg.twoGold
    local threeGold = msg.threeGold
    local oneTime = msg.oneTime
    local twoTime = msg.twoTime
    local threeTime = msg.threeTime
    local forcedCount = msg.forcedCount
    local secondCanClaimTime = msg.secondCanClaimTime
    local thirdCanClaimTime = msg.thirdCanClaimTime
    local surplusReceiveCount = msg.surplusReceiveCount
    PlayerService:Instance():SetOneGold(oneGold);
    PlayerService:Instance():SetTwoGold(twoGold);
    PlayerService:Instance():SetThreeGold(threeGold);
    PlayerService:Instance():SetOneTime(oneTime);
    PlayerService:Instance():SetTwoTime(twoTime);
    PlayerService:Instance():SetThreeTime(threeTime);
    PlayerService:Instance():SetForcedCount(forcedCount)
    PlayerService:Instance():SetSecondCanClaimTime(secondCanClaimTime)
    PlayerService:Instance():SetthirdCanClaimTime(thirdCanClaimTime)
    PlayerService:Instance():SetSurplusReceiveCount(surplusReceiveCount)

    -- print(oneGold .."------".. oneTime)
    -- print(twoGold .."------"..twoTime)
    -- -- print(threeGold .."------".. threeTime);
    -- print(forcedCount)
    -- -- print(secondCanClaimTime.."-----"..thirdCanClaimTime)
    -- print(surplusReceiveCount)
end

function LoginHandler:HandleReturnIntroductions(msg)
    local revenueGold = msg.revenueGold
    local wildCityRevenueGold = msg.wildCityRevenueGold
    PlayerService:Instance():SetIntroductionsRevenueGold(revenueGold);
    PlayerService:Instance():SetWildCityRevenueGold(wildCityRevenueGold);
end


-- 同步玩家建筑物信息
function LoginHandler:HandleSyncOwnerCity(msg)
    local cityCount = msg.allCity:Count()
    -- print(cityCount .. "------------------------------")
    for i = 1, cityCount, 1 do
        local cityInfo = msg.allCity:Get(i)
        -- print("id=========" .. cityInfo.id)
        -- print("name=========" .. cityInfo.name)
        -- print("tableId=========" .. cityInfo.tableId)
        -- print("tiledId=========" .. cityInfo.tiledId)
        PlayerService:Instance():AddCityToPlayerCityInfoList(cityInfo)
    end
end

function LoginHandler:HandleSyncTiledIdList(msg)
    -- body
    PlayerService:Instance():ClearAllTiledIdFromTiledList();
    if msg == nil then
        print("SyncTiledIdListMsg  is  nil");
    end
    local TiledCount = msg.tiledId:Count();
    for i = 1, TiledCount do
        local TiledId = msg.tiledId:Get(i);
        PlayerService:Instance():AddTiledIdToPlayerTiledList(TiledId);
    end
    local bassClass = UIService:Instance():GetUIClass(UIType.UIMinMap)
    if bassClass ~= nil then
        bassClass:OnShow()
        bassClass:OnShow()
    end
    LoginService:Instance():EnterState(LoginStateType.RequestRevenueIdInfo);
end

--玩家新获得一块地
function LoginHandler:HandlePlayerGainNewTiled(msg)
    -- body
    if msg == nil then
        print("HandlePlayerGainNewTiled  is nil");
    end

    local TiledId = msg.tiledId;
    local tiledDurableInfo=TiledDurable.new();
    tiledDurableInfo.tiledId=TiledId;
    tiledDurableInfo.tiledCurDurable = msg.tiledCurDurable;
    tiledDurableInfo.tiledMaxDurable =msg.tiledMaxDurable;
    PlayerService:Instance():AddTiledIdToPlayerTiledList(TiledId);
    PlayerService:Instance():AddTiledDurableInfoToList(tiledDurableInfo);
    local bassClass = UIService:Instance():GetUIClass(UIType.UIMinMap);
    if bassClass ~= nil then
        bassClass:OnShow()
        bassClass:OnShow()
    end
end

--玩家失去一块地
function LoginHandler:HandlePlayerLostOldTiled(msg)
    -- body
    if msg == nil then
        print("HandlePlayerLostOldTiled  is  nil");
    end

    local TiledId = msg.tiledId;
        
    PlayerService:Instance():RemoveTiledIdToPlayerTiledList(TiledId);
    PlayerService:Instance():RemoveTiledDurableInfoToList(TiledId);
    local bassClass = UIService:Instance():GetUIClass(UIType.UIMinMap);
    if bassClass ~= nil then
        bassClass:OnShow()
        bassClass:OnShow()
    end
end

function LoginHandler:HandleSyncTiledDurableList(msg)
    -- body
    PlayerService:Instance():ClearAllTiledDurableFromTiledList();
    local infoCount = msg.tiledDuarble:Count();
    for i = 1, infoCount do
        local tiledDurableInfo = msg.tiledDuarble:Get(i)
        -- print("TiledId=========" .. tiledDurableInfo.tiledId)
        -- print("TiledCurDurable=========" .. tiledDurableInfo.tiledCurDurable)
        -- print("TiledMaxDurable=========" .. tiledDurableInfo.tiledMaxDurable)
        -- print(tiledDurableInfo.tiledMaxDurable);
        PlayerService:Instance():AddTiledDurableInfoToList(tiledDurableInfo);
    end
end

-- 是否包含角色名称
function LoginHandler:HandleIsHavePlayerName(msg)
    local signNum = msg.isHaveName
    self._logicManage:_IsHavePlayerName(signNum)
end

function LoginHandler:HandleSyncPlayerAllTiled(msg)
    -- body
    -- PlayerService:Instance():ClearAllTiledInfoFromTiledList();
    for i = 1,msg.playerAllTiledList:Count() do
        local TiledInfo = msg.playerAllTiledList:Get(i);
        PlayerService:Instance():AddTiledInfoToList(TiledInfo);   
        MapService:Instance():UpdateMyTiledDura(TiledInfo);
    end
    LoginService:Instance():EnterState(LoginStateType.RequestPlayerInfluence);
end

-- 玩家势力
function LoginHandler:HandleSyncPlayerInfluence(msg)
    PlayerService:Instance():SetPlayerInfluence(msg.influence)
    LoginService:Instance():EnterState(LoginStateType.EnterGame);
end

function LoginHandler:HandleSyncPlayerOneTiled(msg)
    -- -- body
    -- print("add");
    -- print(msg.buildingId);
    -- print(BuildingService:Instance():GetBuilding(msg.buildingId))
    PlayerService:Instance():AddTiledInfoToList(msg);
    MapService:Instance():UpdateMyTiledDura(msg);
end

function LoginHandler:HandleRemovePlayerOneTiled(msg)
    -- body
    -- print("remove")
    PlayerService:Instance():RemoveOneTiledInfoFromTiledList(msg.tiledId);
end

--聊天次数
function LoginHandler:HandleSyncChatTimes(msg)
    PlayerService:Instance():SetPlayerChatTimes(msg.chatTimes);

    local baseClass = UIService:Instance():GetUIClass(UIType.UIChat);
    local isopen = UIService:Instance():GetOpenedUI(UIType.UIChat);
    if baseClass ~= nil and isopen == true then
        baseClass:SendChatMessage();
    end
end

-- 断线消息
function LoginHandler:HandleDisconnect(msg)
    print("这里是断线发回的消息。。。" .. msg.disConnectAdapterId)
    self._logicManage:HandleDisconnect(msg.disConnectAdapterId)
end

return LoginHandler;
