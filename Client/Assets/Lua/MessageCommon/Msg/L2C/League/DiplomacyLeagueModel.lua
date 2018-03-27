--
-- 逻辑服务器 --> 客户端
-- 外交同盟model
-- @author czx
--
local DiplomacyLeagueModel = class("DiplomacyLeagueModel");

function DiplomacyLeagueModel:ctor()
    --
    -- 同盟id
    --
    self.leagueId = 0;
    
    --
    -- 同盟名字
    --
    self.name = "";
    
    --
    -- 省份
    --
    self.province = 0;
    
    --
    -- 等级
    --
    self.level = 0;
    
    --
    -- 数量
    --
    self.num = 0;
    
    --
    -- 坐标
    --
    self.coord = 0;
    
    --
    -- 势力
    --
    self.influence = 0;
    
    --
    -- 下次设置时间
    --
    self.nextSettingTime = 0;
    
    --
    -- 关系
    --
    self.mType = 0;
end

return DiplomacyLeagueModel;
