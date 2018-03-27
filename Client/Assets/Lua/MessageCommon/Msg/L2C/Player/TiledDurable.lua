--
-- 逻辑服务器 --> 客户端
-- 同步玩家所有格子耐久
-- @author czx
--
local TiledDurable = class("TiledDurable");

function TiledDurable:ctor()
    --
    -- 格子Id
    --
    self.tiledId = 0;
    
    --
    -- 格子当前耐久
    --
    self.tiledCurDurable = 0;
    
    --
    -- 格子最大耐久
    --
    self.tiledMaxDurable = 0;
end

return TiledDurable;
