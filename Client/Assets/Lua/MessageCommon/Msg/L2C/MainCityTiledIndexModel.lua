--
-- 逻辑服务器 --> 客户端
-- 同步主城标记
-- @author czx
--
local GameMessage = require("common/Net/GameMessage");
local MainCityTiledIndexModel = class("MainCityTiledIndexModel", GameMessage);

--
-- 构造函数
--
function MainCityTiledIndexModel:ctor()
    MainCityTiledIndexModel.super.ctor(self);
    --
    -- 格子索引
    --
    self.tiledIndex = 0;
end

--@Override
function MainCityTiledIndexModel:_OnSerial() 
    self:WriteInt32(self.tiledIndex);
end

--@Override
function MainCityTiledIndexModel:_OnDeserialize() 
    self.tiledIndex = self:ReadInt32();
end

return MainCityTiledIndexModel;
