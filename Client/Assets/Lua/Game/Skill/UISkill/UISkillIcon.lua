
local UIBase = require("Game/UI/UIBase")

local UISkillIcon = class("UISkillIcon", UIBase)
local UIType = require("Game/UI/UIType")
local UIService = require("Game/UI/UIService")
require("Game/Table/InitTable")
local exlSkill = require("Game/Table/model/DataSkill")
local DataHero = require("Game/Table/model/DataHero")
local Effect = nil;
function UISkillIcon:ctor()
    UISkillIcon.super.ctor(self)
    self._skillBtn = nil
    self._skillBg = nil
    self._skillName = nil
    self._mask = nil
    self._percent = nil
    self.SkillInfo = nil;
    self._effectobj = nil;
    self._fromHero = false;
    self._fromHeropamp = nil;
    self.param = { };
    self._progress = 0;
end

function UISkillIcon:OnInit()

end

function UISkillIcon:DoDataExchange()
    self._skillBtn = self:RegisterController(UnityEngine.UI.Button, "SkillBtn")
    self._skillBg = self:RegisterController(UnityEngine.UI.Image, "SkillBtn")
    self._skillName = self:RegisterController(UnityEngine.UI.Text, "SkillName")
    self._mask = self:RegisterController(UnityEngine.UI.Image, "Mask")
    self._percent = self:RegisterController(UnityEngine.UI.Text, "Percent")
    self._leranNum = self:RegisterController(UnityEngine.UI.Text, "DistributableSkillNum")
    self._effectobj = self:RegisterController(UnityEngine.Transform, "Effect");
    self.isSoft = self:RegisterController(UnityEngine.Transform, "Text");
end



function UISkillIcon:DoEventAdd()
    self:AddListener(self._skillBtn, self.OnClickSkillBtn)
end


function UISkillIcon:GetSkillInfo()
    if (self._fromHero) then
        self.param[1] = 1;
        -- 是否来自武将技能
        if (self.SkillInfo._learnHeroID:Count() >= exlSkill[self.SkillInfo._tableId].MaxLearnNum) then
            UIService:Instance():ShowUI(UIType.UICueMessageBox, 2401);
            ----print("可学习点数不足")
            return;
        end
    else
        self.param[1] = 0;
    end
    self.param[2] = self.SkillInfo;
    if (self._fromHeropamp) then
        self.param[3] = self._fromHeropamp[1];
        self.param[4] = self._fromHeropamp[2];
    end
    return self.param
end


-- 处理点击战法图标按钮逻辑
function UISkillIcon:OnClickSkillBtn()
    self.param = { };
    if (self._fromHero) then
        self.param[1] = 1;
        -- 是否来自武将技能
        if self.isSoft.gameObject.activeInHierarchy then
            UIService:Instance():ShowUI(UIType.UICueMessageBox, 2403);
            return
        end
        if (self.SkillInfo._learnHeroID:Count() >= exlSkill[self.SkillInfo._tableId].MaxLearnNum) then
            UIService:Instance():ShowUI(UIType.UICueMessageBox, 2401);
            ----print("可学习点数不足")
            return;
        end
    else
        self.param[1] = 0;
    end
    self.param[2] = self.SkillInfo;
    if (self._fromHeropamp) then
        self.param[3] = self._fromHeropamp[1];
        self.param[4] = self._fromHeropamp[2];
    end
    UIService:Instance():ShowUI(UIType.UITactisDetail, self.param);
end

-- 设置遮罩数值
function UISkillIcon:SetMaskFillAmount(fillAmountVal)
    self._mask.fillAmount = fillAmountVal
end

-- 设置战法信息
function UISkillIcon:SetSkillInfo(skillInfo)
    self._fromHeropamp = nil;
    self._effectobj.gameObject:SetActive(false);
    if (skillInfo == nil or skillInfo._tableId == nil) then
        return;
    end
    self.SkillInfo = skillInfo;
    local skillLine = exlSkill[skillInfo._tableId];

    self._progress = skillInfo._progress / 100;

    self._skillName.text = skillLine.SkillnameText;
    if (self._progress >= 100) then
        self._percent.text = ""
    else
        self._percent.text = self._progress .. "%"
    end

    local maxlearn = skillLine.MaxLearnNum;
    if (self._progress >= 100) then
        local learnmum = skillInfo._learnHeroID:Count();
        self._leranNum.text =(maxlearn - learnmum) .. "/" .. maxlearn;
    else
        self._leranNum.text = "-/" .. maxlearn;
    end
    self:SetMaskFillAmount((1 - self._progress / 100))
    self._skillBg.sprite = SkillService:Instance():GetSkillBgByType(skillLine.Type);
end

-- 设置一些参数 是否来自英雄等等
function UISkillIcon:SetfromHero(fromhero, fromHeropamp)
    self.isSoft.gameObject:SetActive(false)
    self._fromHero = fromhero;
    self._fromHeropamp = fromHeropamp;
    if self._fromHeropamp == nil then
        return
    end
    local info = HeroService:Instance():GetOwnHeroesById(self._fromHeropamp[1]);
    local baseArmyType = DataHero[info.tableID].BaseArmyType
    local _skillLine = exlSkill[self.SkillInfo._tableId]
    if self:Contain(_skillLine.ArmyTypeLearnable, baseArmyType) then
        self.isSoft.gameObject:SetActive(false)
    else
        self.isSoft.gameObject:SetActive(true)
    end
end

function UISkillIcon:Contain(args, i)
    for k, v in pairs(args) do
        if v == i then
            return true
        end
    end
    return false
end

return UISkillIcon
