--
-- 逻辑服务器 --> 客户端
-- 首战杀敌前三名
-- @author czx
--
local FirstOccupyKillPlayer = class("FirstOccupyKillPlayer");

function FirstOccupyKillPlayer:ctor()
    --
    -- 玩家Id
    --
    self.playerId = 0;
    
    --
    -- 玩家名字
    --
    self.name = "";
    
    --
    -- 杀敌数
    --
    self.killValue = 0;
end

return FirstOccupyKillPlayer;
