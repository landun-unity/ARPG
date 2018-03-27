--
-- 逻辑服务器 --> 客户端
-- 同步玩家的所有建筑物
-- @author czx
--
local List = require("common/List");

local CityTitledModel = require("MessageCommon/Msg/L2C/Player/CityTitledModel");

local SyncBuilding = class("SyncBuilding");

function SyncBuilding:ctor()
    --
    -- 建筑物唯一Id
    --
    self.id = 0;
    
    --
    -- 名称
    --
    self.name = "";
    
    --
    -- 所有者
    --
    self.ownerId = 0;
    
    --
    -- 所有者名字
    --
    self.ownerName = "";
    
    --
    -- 同盟Id
    --
    self.leagueId = 0;
    
    --
    -- 同盟名字
    --
    self.leagueName = "";
    
    --
    -- 表Id
    --
    self.tableId = 0;
    
    --
    -- 格子位置
    --
    self.tiledId = 0;
    
    --
    -- 耐久消耗
    --
    self.durabilityCost = 0;
    
    --
    -- 耐久恢复时间
    --
    self.durabilityRecoveryTime = 0;
    
    --
    -- 预备兵
    --
    self.redifNum = 0;
    
    --
    -- 能够扩展次数
    --
    self.canExpandTime = 0;
    
    --
    -- 建造成功时间戳
    --
    self.buildSuccessTime = 0;
    
    --
    -- 失去建筑物时间戳
    --
    self.removeBuildTime = 0;
    
    --
    -- 建筑物类型
    --
    self.buildingType = 0;
    
    --
    -- 建筑物等级
    --
    self.buildingLev = 0;
    
    --
    -- 建筑物升级时间
    --
    self.buildingUpgradeTime = 0;
    
    --
    -- 在建中建筑物ID
    --
    self.onBuildingId = 0;
    
    --
    -- 要塞编号
    --
    self.nameNum = 0;
    
    --
    -- 要塞部队数
    --
    self.fortArmyCount = 0;
    
    --
    -- 要塞升级时间
    --
    self.upgradeFortTime = 0;
    
    --
    -- 创建时间
    --
    self.createTime = 0;
    
    --
    -- 拆除时间
    --
    self.removeTime = 0;
    
    --
    -- 外观list
    --
    self.titleList = List.new();
end

return SyncBuilding;
