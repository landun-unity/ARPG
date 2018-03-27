-- 建筑物消息处理
local IOHandler = require("FrameWork/Game/IOHandler")
local L2C_Facility = require("MessageCommon/Handler/L2C/L2C_Facility");
local UIService = require("Game/UI/UIService")
require("Game/Facility/FacilityOperationType");
local FacilityHandler = class("FacilityHandler", IOHandler)

-- 构造函数
function FacilityHandler:ctor()
    -- body
    FacilityHandler.super.ctor(self);
end

-- 注册所有消息
function FacilityHandler:RegisterAllMessage()
    self:RegisterMessage(L2C_Facility.OpenCityFacilityRespond, self.HandleSyncOwnerOpenCityFacilityRespond, require("MessageCommon/Msg/L2C/Facility/OpenCityFacilityRespond"));
    self:RegisterMessage(L2C_Facility.UpgradeFacilityRespond, self.HandleSyncOwnerUpgradeFacilityRespond, require("MessageCommon/Msg/L2C/Facility/UpgradeFacilityRespond"));
    self:RegisterMessage(L2C_Facility.FacilityOperationMsg, self.HandleSyncOwnerFacilityOperation, require("MessageCommon/Msg/L2C/Facility/FacilityOperationMsg"));

    self:RegisterMessage(L2C_Facility.OnBuildingFacility, self.HandleConstructionQueue, require("MessageCommon/Msg/L2C/Facility/OnBuildingFacility"));
    self:RegisterMessage(L2C_Facility.SingleCityFacilityMsg, self.HandleSyncOwnerSingleCityFacilityRespond, require("MessageCommon/Msg/L2C/Facility/SingleCityFacilityMsg"));
end

-- id
function FacilityHandler:HandleSyncOwnerFacilityOperation(msg)
    print(msg.operType);
    if msg.operType == FacilityOperationType[CanNotUpgradeAddition] then
        print("未达到升级条件"..msg.operType);
    end
    --self._logicManage:RequestPlayId(msg.operType);
end

--打开界面
function FacilityHandler:HandleSyncOwnerOpenCityFacilityRespond(msg)
    --print("FacilityHandler:HandleSyncOwnerOpenCityFacilityRespond   "..msg.bList:Count());
    -- for index = 1, msg.list:Count() do
    --     local Facility = require("Game/Facility/Facility").new();
    --     local mFacility = msg.list:Get(index);
    --     Facility._id = mFacility.id;
    --     Facility._level = mFacility.level;
    --     Facility._tableId = mFacility.tableid;
    --     --print(mFacility.nextUpgradeTime)
    --     Facility._nextUpgradeTime = mFacility.nextUpgradeTime;

    --     self._logicManage:RequestAllFacility(Facility);
    -- end
    --print(msg.buildId);
    for index = 1, msg.bList:Count() do
        local buildId = msg.bList:Get(index).buildId;
        local building = BuildingService:Instance():GetBuilding(buildId);
        building:AllFacilityClear();
        local count = msg.bList:Get(index).list:Count();
        for i=1,count do
            local Facility = require("Game/Facility/Facility").new();
            local mFacility = msg.bList:Get(index).list:Get(i);
            Facility._id = mFacility.id;
            Facility._level = mFacility.level;
            Facility._tableId = mFacility.tableid;
            --print(mFacility.nextUpgradeTime)
            Facility._nextUpgradeTime = mFacility.nextUpgradeTime;
            --print(Facility)
            building:SetAllFacility(Facility);
        end
        building:InitCityProperty();
        building:AddRedifCount();
    end
    --UIService:Instance():InitUI(UIType.UIFacility);
--    LoginService:Instance():EnterState(LoginStateType.EnterGame);

    LoginService:Instance():EnterState(LoginStateType.RequestRechargeInfo);   --发送充值的消息
end

-- 创建完分城同步分城设施
function FacilityHandler:HandleSyncOwnerSingleCityFacilityRespond(msg)
    --print("FacilityHandler:HandleSyncOwnerSingleCityFacilityRespond   "..msg.list:Count());
    local building = BuildingService:Instance():GetBuilding(msg.buildId);
    building:AllFacilityClear();
    local count = msg.list:Count();
    for i=1,count do
        local Facility = require("Game/Facility/Facility").new();
        local mFacility = msg.list:Get(i);
        Facility._id = mFacility.id;
        Facility._level = mFacility.level;
        Facility._tableId = mFacility.tableid;
        --print(mFacility.nextUpgradeTime)
        Facility._nextUpgradeTime = mFacility.nextUpgradeTime;
        --print(Facility)
        building:SetAllFacility(Facility);
    end
    building:InitCityProperty();
end

--升级
function FacilityHandler:HandleSyncOwnerUpgradeFacilityRespond(msg)    
    self._logicManage:RequestUpgradeFacility(msg.buildingId, msg.id, msg.level, msg.upgradeTime);
    local baseClass = UIService:Instance():GetUIClass(UIType.UIFacilityProperty);
    local isOpen =  UIService:Instance():GetOpenedUI(UIType.UIFacilityProperty);
    if baseClass ~= nil and isOpen == true then
        baseClass:SetUpBtnClicked(true);
        baseClass:SetImmediatelyUpBtnClicked(true);
    end
    local baseClass=UIService:Instance():GetUIClass(UIType.UIMainCity);
    local isOpen=UIService:Instance():GetOpenedUI(UIType.UIMainCity);
    if baseClass ~=nil and isOpen==true then
        --下面两个都可以我选的是第二个只调一个小方法 
        --baseClass:OnShow(msg);
        baseClass:SetRedif();
    end
end

--建造队列
function FacilityHandler:HandleConstructionQueue(msg)
    --print("msg.buildingId:"..msg.buildingId.." count1: "..msg.baseQueueList:Count().."  count2:  "..msg.tempQueueList:Count());
    local building = BuildingService:Instance():GetBuilding(msg.buildingId);
    if building~= nil then 
        building:SetConstructionQueues(msg.baseQueueList,msg.tempQueueList);
    else
        --print("can't find building which id is "..msg.buildingId);
    end

    --界面刷新建造队列
    local baseClass = UIService:Instance():GetUIClass(UIType.UIMainCity);
    local isOpen =  UIService:Instance():GetOpenedUI(UIType.UIMainCity);
    if baseClass ~= nil and isOpen == true then
        baseClass:RefreshBuildQueues();
    end
end

return FacilityHandler;