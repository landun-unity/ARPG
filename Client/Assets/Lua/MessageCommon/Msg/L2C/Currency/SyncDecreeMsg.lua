--[[
    同步资源信息
--]]

local GameMessage = require("common/Net/GameMessage");

local SyncDecreeMsg = class("SyncDecreeMsg", GameMessage);
   
function SyncDecreeMsg:ctor()
    SyncDecreeMsg.super.ctor(self);

    -- 政令
    self.decree = 0;
end

-- @override
function SyncDecreeMsg:_OnSerial()
    self:WriteInt32(self.decree);
end


-- @override
function SyncDecreeMsg:_OnDeserialize()
    self.decree = self:ReadInt32();
end

return SyncDecreeMsg;

-- endregion
