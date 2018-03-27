--
-- 逻辑服务器 --> 客户端
-- 玩家打开个人排行
-- @author czx
--
local PlayerModel = class("PlayerModel");

function PlayerModel:ctor()
    --
    -- id
    --
    self.playerid = 0;
    
    --
    -- 排名
    --
    self.rankPostion = 0;
    
    --
    -- 名字
    --
    self.name = "";
    
    --
    -- 所属州
    --
    self.province = 0;
    
    --
    -- 分城数量
    --
    self.subcityNum = 0;
    
    --
    -- 要塞数量
    --
    self.fortNum = 0;
    
    --
    -- 总领地数量
    --
    self.landNum = 0;
    
    --
    -- 个人势力
    --
    self.influence = 0;
end

return PlayerModel;
