--
-- 逻辑服务器 --> 客户端
-- 同步主城标记
-- @author czx
--
local MainCityTiledIndexModel = class("MainCityTiledIndexModel");

function MainCityTiledIndexModel:ctor()
    --
    -- 格子索引
    --
    self.tiledIndex = 0;
end

return MainCityTiledIndexModel;
