-- 货币资源相关信息管理
local IOHandler = require("FrameWork/Game/IOHandler")
local CurrencyHandler = class("CurrencyHandler", IOHandler)

-- 构造函数
function CurrencyHandler:ctor()
    -- body
    CurrencyHandler.super.ctor(self);
end

-- 注册所有消息
function CurrencyHandler:RegisterAllMessage()
    self:RegisterMessage(L2C_Player.SyncResource, self.HandleSyncResourceInfo, require("MessageCommon/Msg/L2C/Player/SyncResource"));
    self:RegisterMessage(L2C_Player.RefreshCurrencyInfo, self.HandleRefreshCurrencyInfo, require("MessageCommon/Msg/L2C/Player/RefreshCurrencyInfo"));
    self:RegisterMessage(L2C_Player.SyncJade, self.HandleSyncOwnerJade, require("MessageCommon/Msg/L2C/Player/SyncJade"));
    self:RegisterMessage(L2C_Player.SyncGold, self.HandleSyncOwnerGoldAndJade, require("MessageCommon/Msg/L2C/Player/SyncGold"));
    self:RegisterMessage(L2C_Player.SyncDecree, self.HandleSyncOwnerDecree, require("MessageCommon/Msg/L2C/Player/SyncDecree"));
    self:RegisterMessage(L2C_Player.ResponseBuyDecree, self.HandleResponseBuyDecree, require("MessageCommon/Msg/L2C/Player/ResponseBuyDecree"));
    self:RegisterMessage(L2C_Player.ResponseBuyDecreeSuccess, self.HandleResponseBuyDecreeSuccess,require("MessageCommon/Msg/L2C/Player/ResponseBuyDecreeSuccess"));
    self:RegisterMessage(L2C_Player.SynchronizeWarfare, self.HandleSyncWarFare, require("MessageCommon/Msg/L2C/Player/SynchronizeWarfare"));
end

-- 同步资源信息
function CurrencyHandler:HandleSyncResourceInfo(msg)
    local wood = msg.wood;
    local iron = msg.iron;
    local stone = msg.stone;
    local grain = msg.grain;
    self._logicManage:SyncResourceInfo(wood, iron, stone, grain)
    if LoginService:Instance():IsLoginState(LoginStateType.RequestResourceInfo) then
        LoginService:Instance():EnterState(LoginStateType.RequestCurrencyInfo);
    end
    -- print(wood.."---"..iron)
end

-- 同步玩家货币信息
function CurrencyHandler:HandleRefreshCurrencyInfo(msg)
    local money = msg.money;
    local jade = msg.jadey;
    local rnown = msg.rnown;
    local decree = msg.decree;
    local warfare = msg.warfare;
    local arms = msg.arms;
    self._logicManage:HandleRefreshCurrencyInfo(money, jade, rnown, decree, warfare, arms)

    if LoginService:Instance():IsLoginState(LoginStateType.RequestCurrencyInfo) then
        LoginService:Instance():EnterState(LoginStateType.RequestBuildingInfo);
        LoginService:Instance():EnterState(LoginStateType.RequestSyncCreateFortTime);
    end
    local bassClass = UIService:Instance():GetUIClass(UIType.UITactis)
    if UIService:Instance():GetOpenedUI(UIType.UITactis) then
        bassClass:OnShow()
    end
end

function CurrencyHandler:HandleSyncOwnerJade(msg)
    -- print(msg.jadey)
    self._logicManage:HandleSyncOwnerJade(msg.jadey);
end

function CurrencyHandler:HandleSyncOwnerGoldAndJade(msg)

    self._logicManage:HandleSyncOwnerGoldAndJade(msg.gold,msg.jade);
    
    local baseClass = UIService:Instance():GetUIClass(UIType.UIChat);
    local isopen = UIService:Instance():GetOpenedUI(UIType.UIChat);
    if baseClass ~= nil and isopen == true then
        baseClass:SendChatMessage();
    end
end



function CurrencyHandler:HandleSyncOwnerDecree(msg)
    self._logicManage:HandleSyncOwnerDecree(msg.decree, msg.lastUpdateTime);
end

function CurrencyHandler:HandleSyncWarFare(msg)
    self._logicManage:HandleSyncWarFare(msg.warfarevalue);
end

function CurrencyHandler:HandleResponseBuyDecree(msg)
    -- body
    --print(msg.times);
    if msg == nil then
        return;
    end
    self._logicManage:HandleResponseBuyDecree(msg.days, msg.times);
end

function  CurrencyHandler:HandleResponseBuyDecreeSuccess(msg)
    -- body
    if msg == nil then
        return;
    end
    self._logicManage:HandleResponseBuyDecreeSuccess();
end


return CurrencyHandler;
