--
-- 逻辑服务器 --> 客户端
-- 加入同盟model
-- @author czx
--
local JoinLeagueModel = class("JoinLeagueModel");

function JoinLeagueModel:ctor()
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
end

return JoinLeagueModel;
