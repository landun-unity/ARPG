
--
local BattleReportDetailModel = class("BattleReportDetailModel");
local BattleReportHeroCardModel = require("Game/BattleReport/BattleReportFlow/BattleReportHeroCardModel");
local BattleReportEffectFlowModel = require("Game/BattleReport/BattleReportFlow/BattleReportEffectFlowModel");
local BattleReportOneHeroFlow = require("Game/BattleReport/BattleReportFlow/BattleReportOneHeroFlow");
local BattleReportSkillFlowModel = require("Game/BattleReport/BattleReportFlow/BattleReportSkillFlowModel");
local BattleReportCountModel = require("Game/BattleReport/BattleReportFlow/BattleReportCountModel");
local OutOfBattleReportType = require("Game/BattleReport/BattleReportFlow/OutOfBattleReportType");
local List = require("common/List");
--
-- 构造函数
--
function BattleReportDetailModel:ctor()
    self.BeforeRound = List.new();
    self.AttackHero = List.new();
    self.DefensHero = List.new();
    self.FightFlowRound = List.new();
    self.AttackCountList = List.new();
    self.DefenseCountList = List.new();
end

--@Override
function BattleReportDetailModel:_OnDeserialize(byteArray) 
    local count = byteArray:ReadInt32();
    for index = 1,count do
        local outtype = byteArray:ReadInt32();
        local info = nil;
        if(outtype == OutOfBattleReportType.AddExp) then
            info = require("Game/BattleReport/BattleReportFlow/BattleReportOutAddExpModel").new()
        end
        if(outtype == OutOfBattleReportType.TroopNum) then
            info = require("Game/BattleReport/BattleReportFlow/BattleReportOutTroopNumModel").new()
        end
        if(outtype == OutOfBattleReportType.ChangeDurable) then
            info = require("Game/BattleReport/BattleReportFlow/BattleReportOutChangeDurableModel").new()
        end
        if(outtype == OutOfBattleReportType.GetResource) then
            info = require("Game/BattleReport/BattleReportFlow/BattleReportOutGetResourceModel").new()
        end
        if(outtype == OutOfBattleReportType.Occupy) then
            info = require("Game/BattleReport/BattleReportFlow/BattleReportOutOccupyModel").new()
        end
        if(outtype == OutOfBattleReportType.LeagueExp) then
            info = require("Game/BattleReport/BattleReportFlow/BattleReportOutLeagueExpModel").new()
        end
        if(outtype == OutOfBattleReportType.AddWuxun) then
            info = require("Game/BattleReport/BattleReportFlow/BattleReportOutAddWuxunModel").new()
        end
        if(outtype == OutOfBattleReportType.LoseBuilding) then
            info = require("Game/BattleReport/BattleReportFlow/BattleReportOutLoseBuildingModel").new()
        end
        if(outtype == OutOfBattleReportType.LoseLand) then
            info = require("Game/BattleReport/BattleReportFlow/BattleReportOutLoseLandModel").new()
        end
        if(outtype == OutOfBattleReportType.NullReportReason) then
            info = require("Game/BattleReport/BattleReportFlow/BattleReportOutNullReportReasonModel").new()
        end
        if(outtype == OutOfBattleReportType.FrameNotEnough) then
            info = require("Game/BattleReport/BattleReportFlow/FrameNotEnough").new()
        end
        if(outtype == OutOfBattleReportType.DefensBackCardID) then
            info = require("Game/BattleReport/BattleReportFlow/DefensBackCardID").new()
        end
        if(info~=nil)then
            info:_OnDeserialize(byteArray);
            self.BeforeRound:Push(info);   
        else   
            --print("info == nil outtype =",outtype)
        end  
    end
    local attackCount = byteArray:ReadInt32();
    for index = 1,attackCount do
        local mAttackerModel = BattleReportHeroCardModel.new();
        mAttackerModel:_OnDeserialize(byteArray);
        self.AttackHero:Push(mAttackerModel);
    end
    local DefensCount = byteArray:ReadInt32();
    for index = 1,DefensCount do
        local mDefensModel = BattleReportHeroCardModel.new();
        mDefensModel:_OnDeserialize(byteArray);
        self.DefensHero:Push(mDefensModel);
    end
    local RoundCount = byteArray:ReadInt32();
    for index = 1,RoundCount do
        local count = byteArray:ReadInt32();
        local Listinfo = List.new();
        for inde = 1,count do
            local flowtype = byteArray:ReadInt32();
            if(flowtype == BattleFlowType.Effect or flowtype == BattleFlowType.buff) then
                local effectflow = BattleReportEffectFlowModel.new();
                effectflow:_OnDeserialize(byteArray);
                Listinfo:Push(effectflow)
            else
                local mOneHeroFlow = BattleReportOneHeroFlow.new()
                mOneHeroFlow:_OnDeserialize(byteArray);
                Listinfo:Push(mOneHeroFlow)
            end
        end
        self.FightFlowRound:Push(Listinfo)
    end

    local AttackCount = byteArray:ReadInt32();
    for index = 1,AttackCount do
        local mReportCount = BattleReportCountModel.new();
        mReportCount:_OnDeserialize(byteArray);
        self.AttackCountList:Push(mReportCount);
    end

    local DefenseCount = byteArray:ReadInt32();
    for index = 1,DefenseCount do
        local mReportCount = BattleReportCountModel.new();
        mReportCount:_OnDeserialize(byteArray);
        self.DefenseCountList:Push(mReportCount);
    end
end

return BattleReportDetailModel;