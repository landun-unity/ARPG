--
-- 客户端 --> 逻辑服务器
-- 同步一张卡牌
-- @author czx
--
local List = require("common/List");

local C2LCityTitleModel = require("MessageCommon/Msg/C2L/Facility/C2LCityTitleModel");

local GameMessage = require("common/Net/GameMessage");
local CityExpandRequest = class("CityExpandRequest", GameMessage);

--
-- 构造函数
--
function CityExpandRequest:ctor()
    CityExpandRequest.super.ctor(self);
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
function CityExpandRequest:_OnSerial() 
    self:WriteInt64(self.buildingId);
    self:WriteInt32(self.titled);
    self:WriteInt32(self.canExpandTime);
    
    local listCount = self.list:Count();
    self:WriteInt32(listCount);
    for i = 1, listCount, 1 do 
        local listValue = self.list:Get(i);
        
        self:WriteInt32(listValue.index);
        self:WriteInt32(listValue.tableid);
        self:WriteInt32(listValue.level);
        self:WriteInt32(listValue.folkType);
    end
end

--@Override
function CityExpandRequest:_OnDeserialize() 
    self.buildingId = self:ReadInt64();
    self.titled = self:ReadInt32();
    self.canExpandTime = self:ReadInt32();
    
    local listCount = self:ReadInt32();
    for i = 1, listCount, 1 do 
        local listValue = C2LCityTitleModel.new();
        listValue.index = self:ReadInt32();
        listValue.tableid = self:ReadInt32();
        listValue.level = self:ReadInt32();
        listValue.folkType = self:ReadInt32();
        self.list:Push(listValue);
    end
end

return CityExpandRequest;
