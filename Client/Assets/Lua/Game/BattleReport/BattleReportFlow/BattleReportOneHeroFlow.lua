

-- 战报OneHeroFlow

local BattleReportOneHeroFlow = class("BattleReportOneHeroFlow");
local BattleFlowType = require("Game/BattleReport/BattleFlowType");
local BattleReportEffectFlowModel = require("Game/BattleReport/BattleReportFlow/BattleReportEffectFlowModel");
local BattleReportSkillFlowModel = require("Game/BattleReport/BattleReportFlow/BattleReportSkillFlowModel");
local List = require("common/List");

function BattleReportOneHeroFlow:ctor()
    --类型
    self.BattleFlowType = BattleFlowType.OneHeroFlow

    --标题显示的英雄名字
    self.TiledHeroId = 0;

    -- 攻击英雄
    self.FlowList = List.new();
    self.isgray = false;
end

function BattleReportOneHeroFlow:_OnDeserialize(byteArray)
    self.isgray = byteArray:ReadBoolean();
    self.TiledHeroId = byteArray:ReadInt32();
    local count = byteArray:ReadInt32();
    --print("------count--------------------------",count)
    for ind = 1,count do
        local flowtype = byteArray:ReadInt32();
        if(flowtype == BattleFlowType.Effect or flowtype == BattleFlowType.buff) then
            local effectflow = BattleReportEffectFlowModel.new();
            effectflow:_OnDeserialize(byteArray);
            self.FlowList:Push(effectflow)
        else
            local Skillflow = BattleReportSkillFlowModel.new();
            Skillflow.BattleFlowType = flowtype;
            Skillflow:_OnDeserialize(byteArray);
            self.FlowList:Push(Skillflow)
        end
    end
    --print("--------------------------------",self.FlowList:Count())
end

return BattleReportOneHeroFlow