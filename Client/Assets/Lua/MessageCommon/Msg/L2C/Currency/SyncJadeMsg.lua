--[[
    同步资源信息
--]]

local GameMessage = require("common/Net/GameMessage");

local SyncJadeMsg = class("SyncJadeMsg", GameMessage);
   
function SyncJadeMsg:ctor()
    SyncJadeMsg.super.ctor(self);

    -- 玉
    self.jade = 0;
end

-- @override
function SyncJadeMsg:_OnSerial()
    self:WriteInt32(self.jade);
end


-- @override
function SyncJadeMsg:_OnDeserialize()
    self.jade = self:ReadInt32();
end

return SyncJadeMsg;

-- endregion