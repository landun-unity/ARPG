--
-- 逻辑服务器 --> 客户端
-- 首战攻城前三名
-- @author czx
--
local FirstOccupySiegePlayer = class("FirstOccupySiegePlayer");

function FirstOccupySiegePlayer:ctor()
    --
    -- 玩家Id
    --
    self.playerId = 0;
    
    --
    -- 玩家名字
    --
    self.name = "";
    
    --
    -- 攻城值
    --
    self.siegeValue = 0;
end

return FirstOccupySiegePlayer;
