--Anchor:HXH
--Date:16/10/21
--RecruitService


local GameService = require("FrameWork/Game/GameService");

local RecruitHandler = require("Game/Recruit/RecruitHandler");
local RecruitManage = require("Game/Recruit/RecruitManage");
RecruitService = class("RecruitService", GameService);

--构造函数
function RecruitService:ctor()
    RecruitService._instance = self;
    RecruitService.super.ctor(self, RecruitManage.new(), RecruitHandler.new());
end

function RecruitService:InitRecruitList()
    -- body

end

--清空数据
function RecruitService:Clear()
    self._logic:ctor()
end

function RecruitService:GetPackageByID(index)
    return self._logic:GetPackageByID(index);
end

function RecruitService:Instance()
    return RecruitService._instance;
end

--获取收到的招募种类的总数量
function RecruitService:GetRecruitKindCount()
    return self._logic:GetAllRecruitKindCount();
end

function RecruitService:GetRecruitPackageByIndex(index)
    return self._logic:GetRecruitPackageByIndex(index);
end

--获取新增加的招募个数
function RecruitService:GetNewRecruitListCount()
    return self._logic:GetNewRecruitListCount();
end

--获取某个新的卡包信息 通过index
function RecruitService:GetNewRecruitListByIndex(index)
    return self._logic:GetNewRecruitListByIndex(index);
end

--清空新增加的招募个数
function RecruitService:ClearNewRecruitList()
    self._logic:ClearNewRecruitList();
end

function RecruitService:RemoveInfoFromNewRecruitList(value)
    -- body
    self._logic:RemoveInfoFromNewRecruitList(value);
end

function RecruitService:PushElementToNewRecruitList(value)
    -- body
    self._logic:PushElementToNewRecruitList(value);
end

function RecruitService:GetPackageID()
    return self._logic:GetPackageID();
end

function RecruitService:GetCardListCount()
    return self._logic:GetCardListCount();
end

function RecruitService:GetCardInfoByIndex(index)
    return self._logic:GetCardInfoByIndex(index);
end

function RecruitService:SetIsTransToExp(temp)
    self._logic:SetIsTransToExp(temp);
end

function RecruitService:GetIsTransToExp()
    return self._logic:GetIsTransToExp();
end

function RecruitService:SetTransUnderStarNum(temp)
    self._logic:SetTransUnderStarNum(temp);
end

function RecruitService:GetTransUnderStarNum()
    return self._logic:GetTransUnderStarNum();
end

function RecruitService:SetTransWay(temp)
    self._logic:SetTransWay(temp);
end

function RecruitService:GetTransWay()
    return self._logic:GetTransWay();
end

function RecruitService:GetBatchRecruitInfo()
    return self._logic:GetBatchRecruitInfo();
end

function RecruitService:GetLastUpdateID()
    return self._logic:GetLastUpdateID();
end

function RecruitService:GetMaxHeroCardsCount()
    return HeroService:Instance():GetCardMaxLimit();
end

function RecruitService:GetLayoutObjWidth()
    -- body
    return self._logic:GetLayoutObjWidth();
end

function RecruitService:SetLayoutObjWidth(value)
    -- body
    self._logic:SetLayoutObjWidth(value);
end

function RecruitService:GetCurRecruitPackageTimes()
    -- body
    return self._logic:GetCurRecruitPackageTimes();
end

function RecruitService:SetIsRecruit(value)
    -- body
    self._logic:SetIsRecruit(value);
end

function RecruitService:GetIsRecruit()
    -- body
    return self._logic:GetIsRecruit();
end

function RecruitService:GetPackageTableId()
    -- body
    return self._logic:GetPackageTableId();
end

function RecruitService:GetTransExpValue()
    -- body
    return self._logic:GetTransExpValue();
end

function RecruitService:SetTransExpValue(value)
    -- body
    self._logic:SetTransExpValue(value);
end

function RecruitService:GetNeedEffectShowCardListCount()
    -- body
    return self._logic:GetNeedEffectShowCardListCount()
end

function RecruitService:GetNeedEffectShowCardByIndex(index)
    -- body
    return self._logic:GetNeedEffectShowCardByIndex(index)
end

function RecruitService:RemoveNeedEffectShowCard(value)
    -- body
    return self._logic:RemoveNeedEffectShowCard(value);
end

function RecruitService:AddNeedEffectShowCard(value)
    -- body
    self._logic:AddNeedEffectShowCard(value);
end

function RecruitService:SetIsBatchRecruit(value)
    -- body
    self._logic:SetIsBatchRecruit(value);
end

function RecruitService:GetIsBatchRecruit()
    -- body
    return self._logic:GetIsBatchRecruit();
end

function RecruitService:GetShowCardListCount()
    -- body
    return self._logic:GetShowCardListCount()
end

function RecruitService:GetShowCardByIndex(index)
    -- body
    return self._logic:GetShowCardByIndex(index)
end

function RecruitService:RemoveShowCard(value)
    -- body
     self._logic:RemoveShowCard(value)
end

function RecruitService:AddShowCard(value)
    -- body
    self._logic:AddShowCard(value)
end

function RecruitService:ClearShowCardList()
    -- body
    self._logic:ClearShowCardList();
end

return RecruitService;

