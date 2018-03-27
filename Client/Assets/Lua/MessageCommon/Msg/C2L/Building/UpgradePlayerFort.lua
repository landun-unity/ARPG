--
-- 客户端 --> 逻辑服务器
-- 要塞升级时间
-- @author czx
--
local GameMessage = require("common/Net/GameMessage");
local UpgradePlayerFort = class("UpgradePlayerFort", GameMessage);

--
-- 构造函数
--
function UpgradePlayerFort:ctor()
    UpgradePlayerFort.super.ctor(self);
    --
    -- 建筑物Id
    --
    self.buildingId = 0;
    
    --
    -- 格子索引
    --
    self.tiledIndex = 0;
end

--@Override
function UpgradePlayerFort:_OnSerial() 
    self:WriteInt64(self.buildingId);
    self:WriteInt32(self.tiledIndex);
end

--@Override
function UpgradePlayerFort:_OnDeserialize() 
    self.buildingId = self:ReadInt64();
    self.tiledIndex = self:ReadInt32();
end

return UpgradePlayerFort;
