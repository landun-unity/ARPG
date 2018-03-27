--[[
	同步线消息
--]]

local GameMessage = require("common/Net/GameMessage");

local SyncLineMsg = class("SyncLineMsg", GameMessage);


function SyncLineMsg:ctor()
    -- 出发格子
    self.startTiledIndex = 0;

    -- 目标格子
    self.targetTiledIndex = 0;

    -- 行走时间
    self.marchTime = 0;
    SyncLineMsg.super.ctor(self);

end




-- @override
function SyncLineMsg:_OnSerial()
	self:WriteInt32(self.startTiledIndex);
	self:WriteInt32(self.targetTiledIndex);
    self:WriteInt64(self.marchTime);
end


-- @override
function SyncLineMsg:_OnDeserialize()
	self.startTiledIndex = self:ReadInt32();
	self.targetTiledIndex = self:ReadInt32();
    self.marchTime = self:ReadInt64();

end

return SyncLineMsg;


