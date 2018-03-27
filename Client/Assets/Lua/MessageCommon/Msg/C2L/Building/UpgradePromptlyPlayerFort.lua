--
-- 客户端 --> 逻辑服务器
-- 立即升级
-- @author czx
--
local GameMessage = require("common/Net/GameMessage");
local UpgradePromptlyPlayerFort = class("UpgradePromptlyPlayerFort", GameMessage);

--
-- 构造函数
--
function UpgradePromptlyPlayerFort:ctor()
    UpgradePromptlyPlayerFort.super.ctor(self);
    --
    -- 建筑物Id
    --
    self.buildingId = 0;
    
    --
    -- 建筑物Index
    --
    self.tiledIndex = 0;
end

--@Override
function UpgradePromptlyPlayerFort:_OnSerial() 
    self:WriteInt64(self.buildingId);
    self:WriteInt32(self.tiledIndex);
end

--@Override
function UpgradePromptlyPlayerFort:_OnDeserialize() 
    self.buildingId = self:ReadInt64();
    self.tiledIndex = self:ReadInt32();
end

return UpgradePromptlyPlayerFort;
