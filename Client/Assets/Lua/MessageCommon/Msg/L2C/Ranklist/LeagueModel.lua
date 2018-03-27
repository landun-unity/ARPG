--
-- 逻辑服务器 --> 客户端
-- 玩家打开同盟排行
-- @author czx
--
local LeagueModel = class("LeagueModel");

function LeagueModel:ctor()
    --
    -- leagueid
    --
    self.leagueId = 0;
    
    --
    -- 排名
    --
    self.rankPostion = 0;
    
    --
    -- 名字
    --
    self.name = "";
    
    --
    -- 国家名字
    --
    self.countryName = "";
    
    --
    -- 同盟等级
    --
    self.leagueLevel = 0;
    
    --
    -- 所属州
    --
    self.province = 0;
    
    --
    -- 成员数量
    --
    self.memberNum = 0;
    
    --
    -- 城池数量
    --
    self.wildCityNum = 0;
    
    --
    -- 势力
    --
    self.influence = 0;
end

return LeagueModel;
