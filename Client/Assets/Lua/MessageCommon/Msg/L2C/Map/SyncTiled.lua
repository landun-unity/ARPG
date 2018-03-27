--
-- 逻辑服务器 --> 客户端
-- 同步单个格子
-- @author czx
--
local List = require("common/List");

local TiledInfo = require("MessageCommon/Msg/L2C/Map/TiledInfo");
local ArmyInfoModel = require("MessageCommon/Msg/L2C/Map/ArmyInfoModel");

local GameMessage = require("common/Net/GameMessage");
local SyncTiled = class("SyncTiled", GameMessage);

--
-- 构造函数
--
function SyncTiled:ctor()
    SyncTiled.super.ctor(self);
    --
    -- 所有的格子
    --
    self.allTiledList = List.new();
end

--@Override
function SyncTiled:_OnSerial() 
    
    local allTiledListCount = self.allTiledList:Count();
    self:WriteInt32(allTiledListCount);
    for allTiledListIndex = 1, allTiledListCount, 1 do 
        local allTiledListValue = self.allTiledList:Get(allTiledListIndex);
        
        self:WriteInt32(allTiledListValue.tiledId);
        self:WriteInt64(allTiledListValue.ownerId);
        self:WriteString(allTiledListValue.ownerName);
        self:WriteInt64(allTiledListValue.leagueId);
        self:WriteString(allTiledListValue.leagueName);
        self:WriteInt64(allTiledListValue.avoidWarTime);
        self:WriteInt64(allTiledListValue.farmmingTime);
        self:WriteInt64(allTiledListValue.trainingTime);
        self:WriteInt64(allTiledListValue.giveUpLandTime);
        self:WriteInt32(allTiledListValue.curDurableVal);
        self:WriteInt32(allTiledListValue.maxDurableVal);
        self:WriteInt64(allTiledListValue.superiorLeagueId);
        self:WriteString(allTiledListValue.superiorLeagueName);
        
        local allTiledListValueAllGarrisonArmyInfoListCount = allTiledListValue.allGarrisonArmyInfoList:Count();
        self:WriteInt32(allTiledListValueAllGarrisonArmyInfoListCount);
        for allTiledListValueAllGarrisonArmyInfoListIndex = 1, allTiledListValueAllGarrisonArmyInfoListCount, 1 do 
            local allTiledListValueAllGarrisonArmyInfoListValue = allTiledListValue.allGarrisonArmyInfoList:Get(allTiledListValueAllGarrisonArmyInfoListIndex);
            
            self:WriteInt64(allTiledListValueAllGarrisonArmyInfoListValue.playerID);
            self:WriteInt64(allTiledListValueAllGarrisonArmyInfoListValue.buildingID);
            self:WriteInt32(allTiledListValueAllGarrisonArmyInfoListValue.slotIndex);
            self:WriteInt64(allTiledListValueAllGarrisonArmyInfoListValue.leagueID);
            self:WriteInt64(allTiledListValueAllGarrisonArmyInfoListValue.superiorLeagueID);
            self:WriteString(allTiledListValueAllGarrisonArmyInfoListValue.name);
            self:WriteInt32(allTiledListValueAllGarrisonArmyInfoListValue.tiledId);
        end
        
        local allTiledListValueAllTrainingArmyInfoListCount = allTiledListValue.allTrainingArmyInfoList:Count();
        self:WriteInt32(allTiledListValueAllTrainingArmyInfoListCount);
        for allTiledListValueAllTrainingArmyInfoListIndex = 1, allTiledListValueAllTrainingArmyInfoListCount, 1 do 
            local allTiledListValueAllTrainingArmyInfoListValue = allTiledListValue.allTrainingArmyInfoList:Get(allTiledListValueAllTrainingArmyInfoListIndex);
            
            self:WriteInt64(allTiledListValueAllTrainingArmyInfoListValue.playerID);
            self:WriteInt64(allTiledListValueAllTrainingArmyInfoListValue.buildingID);
            self:WriteInt32(allTiledListValueAllTrainingArmyInfoListValue.slotIndex);
            self:WriteInt64(allTiledListValueAllTrainingArmyInfoListValue.leagueID);
            self:WriteInt64(allTiledListValueAllTrainingArmyInfoListValue.superiorLeagueID);
            self:WriteString(allTiledListValueAllTrainingArmyInfoListValue.name);
            self:WriteInt32(allTiledListValueAllTrainingArmyInfoListValue.tiledId);
        end
        
        local allTiledListValueAllMitaingArmyInfoListCount = allTiledListValue.allMitaingArmyInfoList:Count();
        self:WriteInt32(allTiledListValueAllMitaingArmyInfoListCount);
        for allTiledListValueAllMitaingArmyInfoListIndex = 1, allTiledListValueAllMitaingArmyInfoListCount, 1 do 
            local allTiledListValueAllMitaingArmyInfoListValue = allTiledListValue.allMitaingArmyInfoList:Get(allTiledListValueAllMitaingArmyInfoListIndex);
            
            self:WriteInt64(allTiledListValueAllMitaingArmyInfoListValue.playerID);
            self:WriteInt64(allTiledListValueAllMitaingArmyInfoListValue.buildingID);
            self:WriteInt32(allTiledListValueAllMitaingArmyInfoListValue.slotIndex);
            self:WriteInt64(allTiledListValueAllMitaingArmyInfoListValue.leagueID);
            self:WriteInt64(allTiledListValueAllMitaingArmyInfoListValue.superiorLeagueID);
            self:WriteString(allTiledListValueAllMitaingArmyInfoListValue.name);
            self:WriteInt32(allTiledListValueAllMitaingArmyInfoListValue.tiledId);
        end
        
        local allTiledListValueAllDrawArmyInfoListCount = allTiledListValue.allDrawArmyInfoList:Count();
        self:WriteInt32(allTiledListValueAllDrawArmyInfoListCount);
        for allTiledListValueAllDrawArmyInfoListIndex = 1, allTiledListValueAllDrawArmyInfoListCount, 1 do 
            local allTiledListValueAllDrawArmyInfoListValue = allTiledListValue.allDrawArmyInfoList:Get(allTiledListValueAllDrawArmyInfoListIndex);
            
            self:WriteInt64(allTiledListValueAllDrawArmyInfoListValue.playerID);
            self:WriteInt64(allTiledListValueAllDrawArmyInfoListValue.buildingID);
            self:WriteInt32(allTiledListValueAllDrawArmyInfoListValue.slotIndex);
            self:WriteInt64(allTiledListValueAllDrawArmyInfoListValue.leagueID);
            self:WriteInt64(allTiledListValueAllDrawArmyInfoListValue.superiorLeagueID);
            self:WriteString(allTiledListValueAllDrawArmyInfoListValue.name);
            self:WriteInt32(allTiledListValueAllDrawArmyInfoListValue.tiledId);
        end
        self:WriteBoolean(allTiledListValue.isHaveView);
        self:WriteInt64(allTiledListValue.guideAvoidWarOwnerId);
        self:WriteInt64(allTiledListValue.nPCRecoverTime);
    end
end

--@Override
function SyncTiled:_OnDeserialize() 
    
    local allTiledListCount = self:ReadInt32();
    for i = 1, allTiledListCount, 1 do 
        local allTiledListValue = TiledInfo.new();
        allTiledListValue.tiledId = self:ReadInt32();
        allTiledListValue.ownerId = self:ReadInt64();
        allTiledListValue.ownerName = self:ReadString();
        allTiledListValue.leagueId = self:ReadInt64();
        allTiledListValue.leagueName = self:ReadString();
        allTiledListValue.avoidWarTime = self:ReadInt64();
        allTiledListValue.farmmingTime = self:ReadInt64();
        allTiledListValue.trainingTime = self:ReadInt64();
        allTiledListValue.giveUpLandTime = self:ReadInt64();
        allTiledListValue.curDurableVal = self:ReadInt32();
        allTiledListValue.maxDurableVal = self:ReadInt32();
        allTiledListValue.superiorLeagueId = self:ReadInt64();
        allTiledListValue.superiorLeagueName = self:ReadString();
        
        local allTiledListValueAllGarrisonArmyInfoListCount = self:ReadInt32();
        for i = 1, allTiledListValueAllGarrisonArmyInfoListCount, 1 do 
            local allTiledListValueAllGarrisonArmyInfoListValue = ArmyInfoModel.new();
            allTiledListValueAllGarrisonArmyInfoListValue.playerID = self:ReadInt64();
            allTiledListValueAllGarrisonArmyInfoListValue.buildingID = self:ReadInt64();
            allTiledListValueAllGarrisonArmyInfoListValue.slotIndex = self:ReadInt32();
            allTiledListValueAllGarrisonArmyInfoListValue.leagueID = self:ReadInt64();
            allTiledListValueAllGarrisonArmyInfoListValue.superiorLeagueID = self:ReadInt64();
            allTiledListValueAllGarrisonArmyInfoListValue.name = self:ReadString();
            allTiledListValueAllGarrisonArmyInfoListValue.tiledId = self:ReadInt32();
            allTiledListValue.allGarrisonArmyInfoList:Push(allTiledListValueAllGarrisonArmyInfoListValue);
        end
        
        local allTiledListValueAllTrainingArmyInfoListCount = self:ReadInt32();
        for i = 1, allTiledListValueAllTrainingArmyInfoListCount, 1 do 
            local allTiledListValueAllTrainingArmyInfoListValue = ArmyInfoModel.new();
            allTiledListValueAllTrainingArmyInfoListValue.playerID = self:ReadInt64();
            allTiledListValueAllTrainingArmyInfoListValue.buildingID = self:ReadInt64();
            allTiledListValueAllTrainingArmyInfoListValue.slotIndex = self:ReadInt32();
            allTiledListValueAllTrainingArmyInfoListValue.leagueID = self:ReadInt64();
            allTiledListValueAllTrainingArmyInfoListValue.superiorLeagueID = self:ReadInt64();
            allTiledListValueAllTrainingArmyInfoListValue.name = self:ReadString();
            allTiledListValueAllTrainingArmyInfoListValue.tiledId = self:ReadInt32();
            allTiledListValue.allTrainingArmyInfoList:Push(allTiledListValueAllTrainingArmyInfoListValue);
        end
        
        local allTiledListValueAllMitaingArmyInfoListCount = self:ReadInt32();
        for i = 1, allTiledListValueAllMitaingArmyInfoListCount, 1 do 
            local allTiledListValueAllMitaingArmyInfoListValue = ArmyInfoModel.new();
            allTiledListValueAllMitaingArmyInfoListValue.playerID = self:ReadInt64();
            allTiledListValueAllMitaingArmyInfoListValue.buildingID = self:ReadInt64();
            allTiledListValueAllMitaingArmyInfoListValue.slotIndex = self:ReadInt32();
            allTiledListValueAllMitaingArmyInfoListValue.leagueID = self:ReadInt64();
            allTiledListValueAllMitaingArmyInfoListValue.superiorLeagueID = self:ReadInt64();
            allTiledListValueAllMitaingArmyInfoListValue.name = self:ReadString();
            allTiledListValueAllMitaingArmyInfoListValue.tiledId = self:ReadInt32();
            allTiledListValue.allMitaingArmyInfoList:Push(allTiledListValueAllMitaingArmyInfoListValue);
        end
        
        local allTiledListValueAllDrawArmyInfoListCount = self:ReadInt32();
        for i = 1, allTiledListValueAllDrawArmyInfoListCount, 1 do 
            local allTiledListValueAllDrawArmyInfoListValue = ArmyInfoModel.new();
            allTiledListValueAllDrawArmyInfoListValue.playerID = self:ReadInt64();
            allTiledListValueAllDrawArmyInfoListValue.buildingID = self:ReadInt64();
            allTiledListValueAllDrawArmyInfoListValue.slotIndex = self:ReadInt32();
            allTiledListValueAllDrawArmyInfoListValue.leagueID = self:ReadInt64();
            allTiledListValueAllDrawArmyInfoListValue.superiorLeagueID = self:ReadInt64();
            allTiledListValueAllDrawArmyInfoListValue.name = self:ReadString();
            allTiledListValueAllDrawArmyInfoListValue.tiledId = self:ReadInt32();
            allTiledListValue.allDrawArmyInfoList:Push(allTiledListValueAllDrawArmyInfoListValue);
        end
        allTiledListValue.isHaveView = self:ReadBoolean();
        allTiledListValue.guideAvoidWarOwnerId = self:ReadInt64();
        allTiledListValue.nPCRecoverTime = self:ReadInt64();
        self.allTiledList:Push(allTiledListValue);
    end
end

return SyncTiled;
