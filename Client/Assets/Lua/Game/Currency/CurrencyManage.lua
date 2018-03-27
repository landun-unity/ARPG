-- 货币管理
CurrencyEnum = require("Game/Player/CurrencyEnum");
local GamePart = require("FrameWork/Game/GamePart")
local EventType = require("Game/Util/EventType");
local EventService = require("Game/Util/EventService")
local DataGameConfig = require("Game/Table/model/DataGameConfig");
local DataCharacterInitial = require("Game/Table/model/DataCharacterInitial");
local CurrencyManage = class("CurrencyManage", GamePart)

-- 构造函数
function CurrencyManage:ctor( )
    CurrencyManage.super.ctor(self)
end

-- 初始化
function CurrencyManage:_OnInit()
end

-- 心跳
function CurrencyManage:_OnHeartBeat()
end

-- 停止
function CurrencyManage:_OnStop()
end

-- 同步资源信息
function CurrencyManage:SyncResourceInfo(wood, iron, stone, grain)
    PlayerService:Instance():GetCurrencyVarCalcByKey(CurrencyEnum.Wood):Init(wood, PlayerService:Instance():GetLocalTime())
    PlayerService:Instance():GetCurrencyVarCalcByKey(CurrencyEnum.Iron):Init(iron, PlayerService:Instance():GetLocalTime())
    PlayerService:Instance():GetCurrencyVarCalcByKey(CurrencyEnum.Stone):Init(stone, PlayerService:Instance():GetLocalTime())
    PlayerService:Instance():GetCurrencyVarCalcByKey(CurrencyEnum.Grain):Init(grain, PlayerService:Instance():GetLocalTime())
    EventService:Instance():TriggerEvent(EventType.Resource);
    EventService:Instance():TriggerEvent(EventType.Resources);
end

-- 请求同步玩家货币信息
function CurrencyManage:RequestCurrencyInfo()
    local msg = require("MessageCommon/Msg/C2L/Player/RequestCurrencyInfo").new()
    msg:SetMessageId(C2L_Player.RequestCurrencyInfo)
    NetService:Instance():SendMessage(msg)
end

-- 刷新货币信息
function CurrencyManage:HandleRefreshCurrencyInfo(money, jade, rnown, decree, warfare, arms)
    PlayerService:Instance():GetCurrencyVarCalcByKey(CurrencyEnum.Money):Init(money, PlayerService:Instance():GetLocalTime())
    PlayerService:Instance():GetCurrencyVarCalcByKey(CurrencyEnum.Jade):Init(jade, PlayerService:Instance():GetLocalTime())
    PlayerService:Instance():GetCurrencyVarCalcByKey(CurrencyEnum.Rnown):Init(rnown, PlayerService:Instance():GetLocalTime(),false)   
    -- print(rnown) ;
    -- print(DataCharacterInitial[1].FameLimit);
    -- PlayerService:Instance():GetCurrencyVarCalcByKey(CurrencyEnum.Rnown):SetMaxValue(DataCharacterInitial[1].FameLimit);
    -- PlayerService:Instance():GetCurrencyVarCalcByKey(CurrencyEnum.Rnown):SetValue(rnown);
    PlayerService:Instance():GetCurrencyVarCalcByKey(CurrencyEnum.Rnown):SetVariationSpace(DataGameConfig[515].OfficialData);
    PlayerService:Instance():GetCurrencyVarCalcByKey(CurrencyEnum.Rnown):SetVariationVal(1);
    -- PlayerService:Instance():GetCurrencyVarCalcByKey(CurrencyEnum.Decree):Init(decree, os.time())
    --print(PlayerService:Instance())
    --print(PlayerService:Instance():GetDecreeSystem())
    PlayerService:Instance():GetDecreeSystem():SetVariationVal(1);
    PlayerService:Instance():GetDecreeSystem():SetVariationSpace(DataGameConfig[514].OfficialData/1000);
    --PlayerService:Instance():GetDecreeSystem():SetMaxValue(DataCharacterInitial[1].CommandLimit+(PlayerService:Instance():GetCityInfoCount()-1)*DataGameConfig[324].OfficialData);
    PlayerService:Instance():GetDecreeSystem():UpdateCurValue(decree);


    
    PlayerService:Instance():GetCurrencyVarCalcByKey(CurrencyEnum.Warfare):Init(warfare, PlayerService:Instance():GetLocalTime())
    PlayerService:Instance():GetCurrencyVarCalcByKey(CurrencyEnum.Arms):Init(arms, PlayerService:Instance():GetLocalTime())
    local baseClass = UIService:Instance():GetUIClass(UIType.UIGameMainView);
    if baseClass ~= nil then
        baseClass:SetCurrencyEnum();
        baseClass:NewerPeriodListener();
    end
end

function CurrencyManage:HandleSyncOwnerJade(Jade)
    PlayerService:Instance():GetCurrencyVarCalcByKey(CurrencyEnum.Jade):Init(Jade, PlayerService:Instance():GetLocalTime())    
end

function CurrencyManage:HandleSyncOwnerGoldAndJade(glod,jade)
    PlayerService:Instance():GetCurrencyVarCalcByKey(CurrencyEnum.Jade):Init(jade, PlayerService:Instance():GetLocalTime())
    PlayerService:Instance():GetCurrencyVarCalcByKey(CurrencyEnum.Money):Init(glod, PlayerService:Instance():GetLocalTime())    
end

function CurrencyManage:HandleSyncOwnerDecree(Decree,lastUpdateTime)
    -- PlayerService:Instance():GetCurrencyVarCalcByKey(CurrencyEnum.Decree):ChangeValue(Decree)
    -- PlayerService:Instance():GetCurrencyVarCalcByKey(CurrencyEnum.Decree):SetLastUpdateTime(lastUpdateTime/1000);
    -- PlayerService:Instance():GetCurrencyVarCalcByKey(CurrencyEnum.Decree):SetVariationVal(1);
    -- PlayerService:Instance():GetCurrencyVarCalcByKey(CurrencyEnum.Decree):SetVariationSpace(3600);
    --print(PlayerService:Instance():GetCurrencyVarCalcByKey(CurrencyEnum.Decree):GetValue())
    PlayerService:Instance():GetDecreeSystem():UpdateCurValue(Decree);
    PlayerService:Instance():GetDecreeSystem():SetLastUpdateTime(lastUpdateTime/1000);
    PlayerService:Instance():GetDecreeSystem():SetVariationVal(1);
    PlayerService:Instance():GetDecreeSystem():SetVariationSpace(DataGameConfig[514].OfficialData/1000);
    local baseClass = UIService:Instance():GetUIClass(UIType.UIGameMainView);
    if baseClass == nil then
        UIService:Instance():ShowUI(UIType.UIGameMainView)
    else
        baseClass:SetOrderTimer();
    end
end

function CurrencyManage:HandleSyncWarFare(WarFare)
    local oldvalue = PlayerService:Instance():GetCurrencyVarCalcByKey(CurrencyEnum.Warfare):GetValue();
    PlayerService:Instance():GetCurrencyVarCalcByKey(CurrencyEnum.Warfare):ChangeValue(WarFare - oldvalue)
end

function CurrencyManage:HandleResponseBuyDecree( days,times )
    -- body
    --print(times);
    --PlayerService:Instance():GetDecreeSystem():SetOverValue(days);
    PlayerService:Instance():SetBuyDecreeTimes(times);
    
end

function CurrencyManage:HandleResponseBuyDecreeSuccess()
    -- body
    PlayerService:Instance():GetDecreeSystem():ChangeCurValue(DataGameConfig[513].OfficialData);
    PlayerService:Instance():GetCurrencyVarCalcByKey(CurrencyEnum.Jade):ChangeValue(-60);
    local itemData = DataItem[CurrencyEnum.Decree+1]
    local param = {};
    param.name = itemData.Name;
    param.count = DataGameConfig[513].OfficialData;
    UIService:Instance():ShowUI(UIType.UIGetItemManage, param);
    local baseClass = UIService:Instance():GetUIClass(UIType.UIGameMainView);
    if baseClass ~= nil then
        baseClass:SetOrderTimer();
        baseClass:SetCurrencyEnum();
    end
end

return CurrencyManage;
