--[[
    创建玩家自建要塞
--]]

local GameMessage = require("common/Net/GameMessage");
local CreatePlayerFort = class("CreatePlayerFort", GameMessage);

function CreatePlayerFort:ctor()
    CreatePlayerFort.super.ctor(self);

    -- 玩家id
    self.playerId = 0;

	-- 格子index
	self.index = 0;

	-- 要塞名称
	self.name = "";

    -- 要塞列表
    self.nameNum = 0;
end

function CreatePlayerFort:_OnSerial()
    self:WriteInt64(self.playerId);
    self:WriteInt32(self.index);
    self:WriteString(self.name);
    self:WriteInt32(self.nameNum)
end

function CreatePlayerFort:_OnDeserialize()
    self.playerId = self:ReadInt64();
    self.index = self:ReadInt32();
    self.name = self:ReadString();
    self.nameNum = self:ReadInt32();
end

return CreatePlayerFort;
