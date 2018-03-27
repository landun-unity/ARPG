--
-- 逻辑服务器 --> 客户端
-- 卡包列表
-- @author czx
--
local List = require("common/List");

local RecruitPackage = require("MessageCommon/Msg/L2C/Recruit/RecruitPackage");

local GameMessage = require("common/Net/GameMessage");
local ReturnRecruitPackageList = class("ReturnRecruitPackageList", GameMessage);

--
-- 构造函数
--
function ReturnRecruitPackageList:ctor()
    ReturnRecruitPackageList.super.ctor(self);
    --
    -- 卡包列表
    --
    self.recruitPackageList = List.new();
end

--@Override
function ReturnRecruitPackageList:_OnSerial() 
    
    local recruitPackageListCount = self.recruitPackageList:Count();
    self:WriteInt32(recruitPackageListCount);
    for recruitPackageListIndex = 1, recruitPackageListCount, 1 do 
        local recruitPackageListValue = self.recruitPackageList:Get(recruitPackageListIndex);
        
        self:WriteInt64(recruitPackageListValue.recruitPackageId);
        self:WriteBoolean(recruitPackageListValue.isFree);
        self:WriteBoolean(recruitPackageListValue.isDiscount);
        self:WriteInt32(recruitPackageListValue.curRecruitTimes);
        self:WriteInt64(recruitPackageListValue.overTime);
        self:WriteInt64(recruitPackageListValue.lastFreeTime);
        self:WriteBoolean(recruitPackageListValue.openBatch);
        self:WriteInt32(recruitPackageListValue.cardLevel);
        self:WriteInt32(recruitPackageListValue.isNew);
        self:WriteInt32(recruitPackageListValue.tableId);
        self:WriteInt32(recruitPackageListValue.isMerge);
        self:WriteInt32(recruitPackageListValue.isOpen);
    end
end

--@Override
function ReturnRecruitPackageList:_OnDeserialize() 
    
    local recruitPackageListCount = self:ReadInt32();
    for i = 1, recruitPackageListCount, 1 do 
        local recruitPackageListValue = RecruitPackage.new();
        recruitPackageListValue.recruitPackageId = self:ReadInt64();
        recruitPackageListValue.isFree = self:ReadBoolean();
        recruitPackageListValue.isDiscount = self:ReadBoolean();
        recruitPackageListValue.curRecruitTimes = self:ReadInt32();
        recruitPackageListValue.overTime = self:ReadInt64();
        recruitPackageListValue.lastFreeTime = self:ReadInt64();
        recruitPackageListValue.openBatch = self:ReadBoolean();
        recruitPackageListValue.cardLevel = self:ReadInt32();
        recruitPackageListValue.isNew = self:ReadInt32();
        recruitPackageListValue.tableId = self:ReadInt32();
        recruitPackageListValue.isMerge = self:ReadInt32();
        recruitPackageListValue.isOpen = self:ReadInt32();
        self.recruitPackageList:Push(recruitPackageListValue);
    end
end

return ReturnRecruitPackageList;
