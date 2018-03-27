local IOHandler = require("FrameWork/Game/IOHandler")
local RecruitCardInfo = require("Game/Recruit/RecruitCardInfo");
local RecruitHandler = class("RecruitHandler", IOHandler)
local BatchRecruitInfo = require("Game/Recruit/BatchRecruitInfo");
local HeroCard = require("Game/Hero/HeroCardPart/HeroCard");

function RecruitHandler:ctor( )
    RecruitHandler.super.ctor(self);
end

function RecruitHandler:RegisterAllMessage()
    self:RegisterMessage(L2C_Recruit.ReturnRecruitPackageList,self.HandleRecruitKindList,require("MessageCommon/Msg/L2C/Recruit/ReturnRecruitPackageList"));
    self:RegisterMessage(L2C_Recruit.SyncRecruitPackage,self.UpdateRecruitInfo,require("MessageCommon/Msg/L2C/Recruit/SyncRecruitPackage"));
    self:RegisterMessage(L2C_Recruit.ReturnCardList,self.GetRecruitCards,require("MessageCommon/Msg/L2C/Recruit/ReturnCardList"));
    self:RegisterMessage(L2C_Recruit.BatchRecruitModel,self.BatchRecruitDetail,require("MessageCommon/Msg/L2C/Recruit/BatchRecruitModel"));
    self:RegisterMessage(L2C_Recruit.PackageClose,self.ShowPackageCloseInfo,require("MessageCommon/Msg/L2C/Recruit/PackageClose"));
    self:RegisterMessage(L2C_Recruit.BatchRecruitCardTableIdList,self.addCard,require("MessageCommon/Msg/L2C/Recruit/BatchRecruitCardList"));
end

function RecruitHandler:HandleRecruitKindList(msg)
    self._logicManage:HandleRecruitKindPackage(msg.recruitPackageList)
    LoginService:Instance():EnterState(LoginStateType.OpenDiplomacyLeagueRequest);
    --UIService:Instance():ShowUI(UIType.UIRecruitUI,msg.recruitPackageList:Count());
end

function RecruitHandler:UpdateRecruitInfo(msg)
    self._logicManage:UpdateRecruitInfo(msg.onePackageInfo)
end

function RecruitHandler:GetRecruitCards(msg)
    self._logicManage:SetIsBatchRecruit(msg.isBatchRecruit);
    self._logicManage:SetPackageID(msg.recruitPackageId);
    self._logicManage:SetTransExpValue(msg.transExpValue);
    self._logicManage:SetRecruitCards(msg.cardList)
end

function RecruitHandler:BatchRecruitDetail(msg)
   local info = BatchRecruitInfo.new();
   info:Init(msg);
   self._logicManage:SetBatchRecruitInfo(info)
end

function RecruitHandler:ShowPackageCloseInfo(msg)
    -- body
end

function RecruitHandler:addCard( msg )
    -- body
    for index = 1, msg.batchRecruitCardIdList:Count() do
        local mHerocard = msg.batchRecruitCardIdList:Get(index);
        local mmHerocard = DataHero[mHerocard.cardTableId]
        local heroCard = HeroCard.new();
        heroCard.id = mHerocard.cardId;
        heroCard.tableID = mHerocard.cardTableId;
        heroCard.level = 1;
        heroCard.attack = mmHerocard.AttackBase;
        heroCard.def = mmHerocard.DefenseBase;
        heroCard.strategy = mmHerocard.SpiritBase;
        heroCard.speed = mmHerocard.SpeedBase;
        heroCard.allSkillSlotList[1] = mmHerocard.SkillOriginalID;
        heroCard.allSkillLevelList[1] = 1;
        heroCard.allSkillSlotList[2] = 0;
        heroCard.allSkillSlotList[3] = 0
        heroCard.allSkillLevelList[2] = 1
        heroCard.allSkillLevelList[3] = 1
        heroCard.soilderType = mmHerocard.BaseArmyType;
        HeroService:Instance():InsertHeroCard(heroCard);
    end
    local UIRecruitUI = UIService:Instance():GetUIClass(UIType.UIRecruitUI)
    if UIRecruitUI ~= nil then
        UIRecruitUI:SetCardCount();
    end
end

return RecruitHandler