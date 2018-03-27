--
-- 逻辑服务器 --> 客户端
-- 同步玩家城池信息
-- @author czx
--
local List = require("common/List");

local CityModel = require("MessageCommon/Msg/L2C/Player/CityModel");

local GameMessage = require("common/Net/GameMessage");
local SyncOwnerCity = class("SyncOwnerCity", GameMessage);

--
-- 构造函数
--
function SyncOwnerCity:ctor()
    SyncOwnerCity.super.ctor(self);
    --
    -- 城池列表
    --
    self.allCity = List.new();
end

--@Override
function SyncOwnerCity:_OnSerial() 
    
    local allCityCount = self.allCity:Count();
    self:WriteInt32(allCityCount);
    for allCityIndex = 1, allCityCount, 1 do 
        local allCityValue = self.allCity:Get(allCityIndex);
        
        self:WriteInt64(allCityValue.id);
        self:WriteString(allCityValue.name);
        self:WriteInt32(allCityValue.tableId);
        self:WriteInt32(allCityValue.tiledId);
    end
end

--@Override
function SyncOwnerCity:_OnDeserialize() 
    
    local allCityCount = self:ReadInt32();
    for i = 1, allCityCount, 1 do 
        local allCityValue = CityModel.new();
        allCityValue.id = self:ReadInt64();
        allCityValue.name = self:ReadString();
        allCityValue.tableId = self:ReadInt32();
        allCityValue.tiledId = self:ReadInt32();
        self.allCity:Push(allCityValue);
    end
end

return SyncOwnerCity;
