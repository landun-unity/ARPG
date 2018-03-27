--
-- 逻辑服务器 --> 客户端
-- 格子上部队信息
-- @author czx
--
local ArmyInfoModel = class("ArmyInfoModel");

function ArmyInfoModel:ctor()
    --
    -- 玩家ID
    --
    self.playerID = 0;
    
    --
    -- 建筑物ID
    --
    self.buildingID = 0;
    
    --
    -- 所在槽位索引
    --
    self.slotIndex = 0;
    
    --
    -- 同盟ID
    --
    self.leagueID = 0;
    
    --
    -- 上级盟ID
    --
    self.superiorLeagueID = 0;
    
    --
    -- 名字
    --
    self.name = "";
    
    --
    -- 部队所在的格子
    --
    self.tiledId = 0;
end

return ArmyInfoModel;
