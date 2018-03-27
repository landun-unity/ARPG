--
-- 逻辑服务器 --> 客户端
-- 同步一张卡牌
-- @author czx
--
local List = require("common/List");

local SingleFacilityModel = require("MessageCommon/Msg/L2C/Facility/SingleFacilityModel");

local GameMessage = require("common/Net/GameMessage");
local SingleCityFacilityMsg = class("SingleCityFacilityMsg", GameMessage);

--
-- 构造函数
--
function SingleCityFacilityMsg:ctor()
    SingleCityFacilityMsg.super.ctor(self);
    --
    -- 建筑物id
    --
    self.buildId = 0;
    
    --
    -- 格子list
    --
    self.list = List.new();
end

--@Override
function SingleCityFacilityMsg:_OnSerial() 
    self:WriteInt64(self.buildId);
    
    local listCount = self.list:Count();
    self:WriteInt32(listCount);
    for listIndex = 1, listCount, 1 do 
        local listValue = self.list:Get(listIndex);
        
        self:WriteInt64(listValue.id);
        self:WriteInt32(listValue.level);
        self:WriteInt32(listValue.tableid);
        self:WriteInt64(listValue.nextUpgradeTime);
    end
end

--@Override
function SingleCityFacilityMsg:_OnDeserialize() 
print("SingleCityFacilityMsg:_OnDeserialize");
    self.buildId = self:ReadInt64();
    
    local listCount = self:ReadInt32();
    for i = 1, listCount, 1 do 
        local listValue = SingleFacilityModel.new();
        listValue.id = self:ReadInt64();
        listValue.level = self:ReadInt32();
        listValue.tableid = self:ReadInt32();
        listValue.nextUpgradeTime = self:ReadInt64();
        self.list:Push(listValue);
    end
end

return SingleCityFacilityMsg;
