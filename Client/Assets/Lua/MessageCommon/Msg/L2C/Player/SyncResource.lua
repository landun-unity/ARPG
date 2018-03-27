﻿--
-- 逻辑服务器 --> 客户端
-- 同步资源信息
-- @author czx
--
local GameMessage = require("common/Net/GameMessage");
local SyncResource = class("SyncResource", GameMessage);

--
-- 构造函数
--
function SyncResource:ctor()
    SyncResource.super.ctor(self);
    --
    -- 木材
    --
    self.wood = 0;
    
    --
    -- 铁矿
    --
    self.iron = 0;
    
    --
    -- 石料
    --
    self.stone = 0;
    
    --
    -- 粮草
    --
    self.grain = 0;
end

--@Override
function SyncResource:_OnSerial() 
    self:WriteInt32(self.wood);
    self:WriteInt32(self.iron);
    self:WriteInt32(self.stone);
    self:WriteInt32(self.grain);
end

--@Override
function SyncResource:_OnDeserialize() 
    self.wood = self:ReadInt32();
    self.iron = self:ReadInt32();
    self.stone = self:ReadInt32();
    self.grain = self:ReadInt32();
end

return SyncResource;
