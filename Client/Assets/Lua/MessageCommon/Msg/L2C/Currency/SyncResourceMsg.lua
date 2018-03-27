--[[
    同步资源信息
--]]

local GameMessage = require("common/Net/GameMessage");

local SyncResourceMsg = class("SyncResourceMsg", GameMessage);
   
function SyncResourceMsg:ctor()
    SyncResourceMsg.super.ctor(self);

    -- 木材
    self.wood = 0;

    -- 铁矿
    self.iron = 0;

    -- 石料
    self.stone = 0;

    -- 粮草
    self.grain = 0;
end

-- @override
function SyncResourceMsg:_OnSerial()
    self:WriteInt32(self.wood);
    self:WriteInt32(self.iron);
    self:WriteInt32(self.stone);
    self:WriteInt32(self.grain);
end


-- @override
function SyncResourceMsg:_OnDeserialize()
    
    self.wood = self:ReadInt32();
    self.iron = self:ReadInt32();
    self.stone = self:ReadInt32();
    self.grain = self:ReadInt32();
    print(self.wood)
    print(self.iron)
    print(self.stone)
    print(self.grain)
end

return SyncResourceMsg;

-- endregion

