--
-- 逻辑服务器 --> 客户端
-- 申请入盟者model
-- @author czx
--
local ApplyJoinLeagueModel = class("ApplyJoinLeagueModel");

function ApplyJoinLeagueModel:ctor()
    --
    -- 玩家id
    --
    self.playerId = 0;
    
    --
    -- 玩家名字
    --
    self.name = "";
    
    --
    -- 玩家势力
    --
    self.influence = 0;
    
    --
    -- 玩家省份
    --
    self.province = 0;
end

return ApplyJoinLeagueModel;
