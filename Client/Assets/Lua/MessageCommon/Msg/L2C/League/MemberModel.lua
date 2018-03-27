--
-- 逻辑服务器 --> 客户端
-- 玩家打开被同盟邀请列表
-- @author czx
--
local MemberModel = class("MemberModel");

function MemberModel:ctor()
    --
    -- id
    --
    self.playerid = 0;
    
    --
    -- 名字
    --
    self.name = "";
    
    --
    -- 总贡献
    --
    self.totalContribution = 0;
    
    --
    -- 本周贡献
    --
    self.weekContribution = 0;
    
    --
    -- 武勋
    --
    self.battleAchievment = 0;
    
    --
    -- 势力
    --
    self.influence = 0;
    
    --
    -- 坐标
    --
    self.coord = 0;
    
    --
    -- 官位
    --
    self.title = 0;
    
    --
    -- 太守id
    --
    self.cheifId = 0;
    
    --
    -- 是否被沦陷
    --
    self.isBeFall = false;
    
    --
    -- 下次罢免冷却时间
    --
    self.nextAppointCoolingTime = 0;
end

return MemberModel;
