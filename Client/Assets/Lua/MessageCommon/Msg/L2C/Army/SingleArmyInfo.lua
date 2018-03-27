--
-- 逻辑服务器 --> 客户端
-- 单个部队信息
-- @author czx
--
local SingleArmyInfo = class("SingleArmyInfo");

function SingleArmyInfo:ctor()
    --
    -- 卡牌1
    --
    self.card1 = 0;
    
    --
    -- 部队1的数量
    --
    self.soldier1Count = 0;
    
    --
    -- 部队1征兵开始时间
    --
    self.soldier1ConscriptionStartTime = 0;
    
    --
    -- 部队1征兵数量
    --
    self.soldier1ConscriptionCount = 0;
    
    --
    -- 卡牌2
    --
    self.card2 = 0;
    
    --
    -- 部队2的数量
    --
    self.soldier2Count = 0;
    
    --
    -- 部队2征兵开始时间
    --
    self.soldier2ConscriptionStartTime = 0;
    
    --
    -- 部队2征兵数量
    --
    self.soldier2ConscriptionCount = 0;
    
    --
    -- 卡牌3
    --
    self.card3 = 0;
    
    --
    -- 部队3的数量
    --
    self.soldier3Count = 0;
    
    --
    -- 部队3征兵开始时间
    --
    self.soldier3ConscriptionStartTime = 0;
    
    --
    -- 部队3征兵数量
    --
    self.soldier3ConscriptionCount = 0;
    
    --
    -- 开始格子
    --
    self.startTiled = 0;
    
    --
    -- 结束格子
    --
    self.endTiled = 0;
    
    --
    -- 开始移动时间
    --
    self.startTime = 0;
    
    --
    -- 结束移动时间
    --
    self.endTime = 0;
    
    --
    -- 在建筑物中的槽位
    --
    self.slotId = 0;
    
    --
    -- 出生在建筑物中的槽位
    --
    self.spawnSlotId = 0;
    
    --
    -- 出生的建筑物
    --
    self.spawnBuilding = 0;
    
    --
    -- 所在格子Id
    --
    self.tiledId = 0;
    
    --
    -- 当前所在建筑物Id
    --
    self.curBuildingId = 0;
    
    --
    -- 屯田开始时间
    --
    self.farmmingStartTime = 0;
    
    --
    -- 屯田结束时间
    --
    self.farmmingEndTime = 0;
    
    --
    -- 练兵开始时间
    --
    self.trainingStartTime = 0;
    
    --
    -- 练兵结束时间
    --
    self.trainingEndTime = 0;
    
    --
    -- 战平开始时间
    --
    self.battleStartTime = 0;
    
    --
    -- 战平结束时间
    --
    self.battleEndTime = 0;
    
    --
    -- 练兵总次数
    --
    self.totalTrainingTimes = 0;
    
    --
    -- 当前练兵次数
    --
    self.curTrainingTimes = 0;
    
    --
    -- 部队的状态
    --
    self.state = 0;
end

return SingleArmyInfo;
