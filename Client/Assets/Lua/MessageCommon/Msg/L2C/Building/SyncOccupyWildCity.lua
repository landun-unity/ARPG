--
-- 逻辑服务器 --> 客户端
-- 同步已占领野城信息
-- @author czx
--
local List = require("common/List");

local OccupyWildCityModel = require("MessageCommon/Msg/L2C/Building/OccupyWildCityModel");

local GameMessage = require("common/Net/GameMessage");
local SyncOccupyWildCity = class("SyncOccupyWildCity", GameMessage);

--
-- 构造函数
--
function SyncOccupyWildCity:ctor()
    SyncOccupyWildCity.super.ctor(self);
    --
    -- 已占领野城
    --
    self.list = List.new();
end

--@Override
function SyncOccupyWildCity:_OnSerial() 
    
    local listCount = self.list:Count();
    self:WriteInt32(listCount);
    for listIndex = 1, listCount, 1 do 
        local listValue = self.list:Get(listIndex);
        
        self:WriteInt64(listValue.buildingId);
        self:WriteInt32(listValue.index);
        self:WriteInt64(listValue.occupyLeagueId);
        self:WriteString(listValue.occupyLeagueName);
    end
end

--@Override
function SyncOccupyWildCity:_OnDeserialize() 
    
    local listCount = self:ReadInt32();
    for i = 1, listCount, 1 do 
        local listValue = OccupyWildCityModel.new();
        listValue.buildingId = self:ReadInt64();
        listValue.index = self:ReadInt32();
        listValue.occupyLeagueId = self:ReadInt64();
        listValue.occupyLeagueName = self:ReadString();
        self.list:Push(listValue);
    end
end

return SyncOccupyWildCity;
