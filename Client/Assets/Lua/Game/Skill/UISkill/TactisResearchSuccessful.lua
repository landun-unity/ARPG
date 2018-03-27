
local UIBase = require("Game/UI/UIBase")
local TactisResearchSuccessful = class("TactisResearchSuccessful",UIBase)
local UIType = require("Game/UI/UIType")
local UIService=require("Game/UI/UIService")
local exlSkill = require("Game/Table/model/DataSkill")
local EffectsType = require("Game/Effects/EffectsType")
local Effect = nil;
function TactisResearchSuccessful:ctor()
  TactisResearchSuccessful.super.ctor(self)
  self._BackBtn= nil;
  self._skillIcon= nil;
  self._skillNum= nil;
  self._skillName= nil;
  self._skillEffect= nil;
end

function TactisResearchSuccessful:DoDataExchange()
  self._BackBtn = self:RegisterController(UnityEngine.UI.Button,"Bg")
  self._skillIcon = self:RegisterController(UnityEngine.UI.Image,"Bg/SkillIcon")
  self._skillNum = self:RegisterController(UnityEngine.UI.Text,"Bg/DistributableSkillNum")
  self._skillName = self:RegisterController(UnityEngine.UI.Text,"Bg/SkillName")
  self._skillEffect = self:RegisterController(UnityEngine.Transform,"Bg/Effect")
end

function TactisResearchSuccessful:DoEventAdd()
  self:AddListener(self._BackBtn,self.OnClickBackBtn)
end

function TactisResearchSuccessful:OnClickBackBtn()
  UIService:Instance():HideUI(UIType.TactisResearchSuccessful);

end

--设置战法信息
function TactisResearchSuccessful:OnShow(skillInfo)
   local skillLine = exlSkill[skillInfo._tableId];
   self._skillName.text = skillLine.Name;
   local maxlearn = skillLine.MaxLearnNum;
   self._skillNum.text = maxlearn.."/"..maxlearn;
   self._skillIcon.sprite = SkillService:Instance():GetSkillBgByType(skillLine.Type);
   self:ShowEffect();
end

--显示特效
function TactisResearchSuccessful:ShowEffect()
    EffectsService:Instance():AddEffect(self._skillIcon.gameObject,EffectsType.ResearchEffect, 1)
end

--显示完特效
function TactisResearchSuccessful:ShowEffectEnd()
    if(Effect)then
        Effect:SetActive(false);
    end
end

return TactisResearchSuccessful
