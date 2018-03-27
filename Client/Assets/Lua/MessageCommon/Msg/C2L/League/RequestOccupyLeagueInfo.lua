--
-- 客户端 --> 逻辑服务器
-- 请求野城占领同盟信息
-- @author czx
--
local GameMessage = require("common/Net/GameMessage");
local RequestOccupyLeagueInfo = class("RequestOccupyLeagueInfo", GameMessage);

--
-- 构造函数
--
function RequestOccupyLeagueInfo:ctor()
    RequestOccupyLeagueInfo.super.ctor(self);
    --
    -- 野城格子ID
    --
    self.wildBuildingTiledIndex = 0;
end

--@Override
function RequestOccupyLeagueInfo:_OnSerial() 
    self:WriteInt32(self.wildBuildingTiledIndex);
end

--@Override
function RequestOccupyLeagueInfo:_OnDeserialize() 
    self.wildBuildingTiledIndex = self:ReadInt32();
end

return RequestOccupyLeagueInfo;
