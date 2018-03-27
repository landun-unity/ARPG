--[[
    拆除玩家自建要塞
--]]

local GameMessage = require("common/Net/GameMessage");
local TearDownPlayerFort = class("TearDownPlayerFort", GameMessage);

function TearDownPlayerFort:ctor()
    TearDownPlayerFort.super.ctor(self);

    -- 建筑物id
    self.buildingId = 0;

    -- 所在格子索引
    self.index = 0;
end

function TearDownPlayerFort:_OnSerial()
    self:WriteInt64(self.buildingId);
    self:WriteInt32(self.index);
end

function TearDownPlayerFort:_OnDeserialize()
    self.buildingI = self:ReadInt64();
    self.index = self:ReadInt32();
end

return TearDownPlayerFort;
