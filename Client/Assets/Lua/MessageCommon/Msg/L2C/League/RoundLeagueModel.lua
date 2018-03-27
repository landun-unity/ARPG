--
-- 逻辑服务器 --> 客户端
-- 玩家打开周围盟
-- @author czx
--
local RoundLeagueModel = class("RoundLeagueModel");

function RoundLeagueModel:ctor()
    --
    -- 盟id
    --
    self.leagueid = 0;
    
    --
    -- 盟名字
    --
    self.name = "";
    
    --
    -- 盟等级
    --
    self.level = 0;
    
    --
    -- 成员数量
    --
    self.num = 0;
    
    --
    -- 所在省份
    --
    self.province = 0;
    
    --
    -- 坐标
    --
    self.coord = 0;
    
    --
    -- 已申请
    --
    self.alreadApply = false;
end

return RoundLeagueModel;
