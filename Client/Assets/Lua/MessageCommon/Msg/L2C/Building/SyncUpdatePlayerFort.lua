--
-- 逻辑服务器 --> 客户端
-- 要塞升级
-- @author czx
--
local GameMessage = require("common/Net/GameMessage");
local SyncUpdatePlayerFort = class("SyncUpdatePlayerFort", GameMessage);

--
-- 构造函数
--
function SyncUpdatePlayerFort:ctor()
    SyncUpdatePlayerFort.super.ctor(self);
    --
    -- 要塞等级
    --
    self.level = 0;

    --所在地index
    self.tiledIndex = 0;
end

--@Override
function SyncUpdatePlayerFort:_OnSerial() 
    self:WriteInt32(self.level);
    self:WriteInt64(self.tiledIndex);
end

--@Override
function SyncUpdatePlayerFort:_OnDeserialize() 
    self.level = self:ReadInt32();
    self.tiledIndex = self:ReadInt32();
end

return SyncUpdatePlayerFort;
