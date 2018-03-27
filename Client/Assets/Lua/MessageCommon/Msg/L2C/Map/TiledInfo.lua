--
-- 逻辑服务器 --> 客户端
-- 同步格子信息
-- @author czx
--
local List = require("common/List");

local ArmyInfoModel = require("MessageCommon/Msg/L2C/Map/ArmyInfoModel");

local TiledInfo = class("TiledInfo");

function TiledInfo:ctor()
    --
    -- 名称
    --
    self.tiledId = 0;
    
    --
    -- 所有者Id
    --
    self.ownerId = 0;
    
    --
    -- 所有者名称
    --
    self.ownerName = "";
    
    --
    -- 帮派Id
    --
    self.leagueId = 0;
    
    --
    -- 帮派名称
    --
    self.leagueName = "";
    
    --
    -- 免战结束时间
    --
    self.avoidWarTime = 0;
    
    --
    -- 屯田结束时间
    --
    self.farmmingTime = 0;
    
    --
    -- 练兵结束时间
    --
    self.trainingTime = 0;
    
    --
    -- 放弃土地结束时间
    --
    self.giveUpLandTime = 0;
    
    --
    -- 当前地块耐久
    --
    self.curDurableVal = 0;
    
    --
    -- 地块耐久最大值
    --
    self.maxDurableVal = 0;
    
    --
    -- 上级盟ID
    --
    self.superiorLeagueId = 0;
    
    --
    -- 上级盟名称
    --
    self.superiorLeagueName = "";
    
    --
    -- 所有驻守部队列表
    --
    self.allGarrisonArmyInfoList = List.new();
    
    --
    -- 所有练兵部队列表
    --
    self.allTrainingArmyInfoList = List.new();
    
    --
    -- 所有屯田部队列表
    --
    self.allMitaingArmyInfoList = List.new();
    
    --
    -- 所有战平部队列表
    --
    self.allDrawArmyInfoList = List.new();
    
    --
    -- 是否拥有本地块视野
    --
    self.isHaveView = false;
    
    --
    -- 新手引导专用地块免战拥有者Id
    --
    self.guideAvoidWarOwnerId = 0;
    
    --
    -- 守军恢复时间
    --
    self.nPCRecoverTime = 0;
end

return TiledInfo;
