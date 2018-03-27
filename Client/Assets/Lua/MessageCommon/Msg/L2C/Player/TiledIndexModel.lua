--
-- 逻辑服务器 --> 客户端
-- 返回标记信息
-- @author czx
--
local TiledIndexModel = class("TiledIndexModel");

function TiledIndexModel:ctor()
    --
    -- 标记名字
    --
    self.name = "";
    
    --
    -- 返回已标记格子index
    --
    self.tiledIndex = 0;
end

return TiledIndexModel;
