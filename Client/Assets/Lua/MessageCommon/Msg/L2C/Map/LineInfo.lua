--
-- 逻辑服务器 --> 客户端
-- 线的信息
-- @author czx
--
local LineInfo = class("LineInfo");

function LineInfo:ctor()
    --
    -- 线的唯一Id
    --
    self.lineId = 0;
    
    --
    -- 开始时间
    --
    self.startTime = 0;
    
    --
    -- 结束时间
    --
    self.endTime = 0;
    
    --
    -- 起点
    --
    self.startTiled = 0;
    
    --
    -- 终点
    --
    self.endTiled = 0;
    
    --
    -- 玩家ID
    --
    self.playerId = 0;
    
    --
    -- 玩家名称
    --
    self.playerName = "";
    
    --
    -- 同盟Id
    --
    self.leagueId = 0;
    
    --
    -- 上级盟Id
    --
    self.superiorLeagueId = 0;
    
    --
    -- 部队的建筑物Id
    --
    self.buildingId = 0;
    
    --
    -- 部队的槽位索引
    --
    self.armySlotIndex = 0;
    
    --
    -- 是否拥有线起点格子的视野
    --
    self.isHaveStartTiledView = false;
    
    --
    -- 是否拥有线终点格子的视野
    --
    self.isHaveEndTiledView = false;
    
    --
    -- 是否拥有线起点格子的个人视野
    --
    self.isHaveStartPersionalView = false;
    
    --
    -- 是否拥有线终点格子的个人视野
    --
    self.isHaveEndPersionalView = false;
end

return LineInfo;
