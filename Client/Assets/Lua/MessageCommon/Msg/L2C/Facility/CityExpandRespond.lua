--
-- 逻辑服务器 --> 客户端
-- 同步一张卡牌
-- @author czx
--
local List = require("common/List");

local L2CCityTitleModel = require("MessageCommon/Msg/L2C/Facility/L2CCityTitleModel");

local GameMessage = require("common/Net/GameMessage");
local CityExpandRespond = class("CityExpandRespond", GameMessage);

--
-- 构造函数
--
function CityExpandRespond:ctor()
    CityExpandRespond.super.ctor(self);
    --
    -- 建筑id
    --
    self.buildingId = 0;
    
    --
    -- 格子id
    --
    self.titled = 0;
    
    --
    -- 能够扩建次数
    --
    self.canExpandTime = 0;
    
    --
    -- 格子list
    --
    self.list = List.new();
end

--@Override
function CityExpandRespond:_OnSerial() 
    self:WriteInt64(self.buildingId);
    self:WriteInt32(self.titled);
    self:WriteInt32(self.canExpandTime);
    
    local listCount = self.list:Count();
    self:WriteInt32(listCount);
    for listIndex = 1, listCount, 1 do 
        local listValue = self.list:Get(listIndex);
        
        self:WriteInt32(listValue.index);
        self:WriteInt32(listValue.tableid);
        self:WriteInt32(listValue.level);
        self:WriteInt32(listValue.folkType);
    end
end

--@Override
function CityExpandRespond:_OnDeserialize() 
    self.buildingId = self:ReadInt64();
    self.titled = self:ReadInt32();
    self.canExpandTime = self:ReadInt32();
    
    local listCount = self:ReadInt32();
    for i = 1, listCount, 1 do 
        local listValue = L2CCityTitleModel.new();
        listValue.index = self:ReadInt32();
        listValue.tableid = self:ReadInt32();
        listValue.level = self:ReadInt32();
        listValue.folkType = self:ReadInt32();
        self.list:Push(listValue);
    end
end

return CityExpandRespond;
