--
-- 客户端 --> 逻辑服务器
-- 打开城市设施
-- @author czx
--
local GameMessage = require("common/Net/GameMessage");
local OpenCityFacility = class("OpenCityFacility", GameMessage);

--
-- 构造函数
--
function OpenCityFacility:ctor()
    OpenCityFacility.super.ctor(self);
    --
    -- 玩家id
    --
    self.playerid = 0;
    
    --
    -- 建筑物id
    --
    self.buildingId = 0;
end

--@Override
function OpenCityFacility:_OnSerial() 
    self:WriteInt64(self.playerid);
    self:WriteInt64(self.buildingId);
end

--@Override
function OpenCityFacility:_OnDeserialize() 
    self.playerid = self:ReadInt64();
    self.buildingId = self:ReadInt64();
end

return OpenCityFacility;
