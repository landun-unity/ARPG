-- region *.lua

local UIBase = require("Game/UI/UIBase");
local UIHeroSpliteSkill = class("UIHeroSpliteSkill", UIBase);
local DataHero = require("Game/Table/model/DataHero");
local DataSkill = require("Game/Table/model/DataSkill");
local ArmyType = require("Game/Hero/HeroCardPart/ArmyType")
local CampType = require("Game/Hero/HeroCardPart/CampType");
function UIHeroSpliteSkill:ctor()

    UIHeroSpliteSkill.super.ctor(self)
    self.data = { }
    self.heroId = nil;
    self.skillBtn = nil;
    self.skill2Btn = nil;
    self.skillname = nil;
    self.skill2name = nil;
    self.skilltype = nil;
    self.skillrange = nil;
    self.targettype = nil;
    self.armtype = nil;
    self.probability = nil;
    self.splitBtn = nil;
    self.basematter = nil;
    self.matterone = nil;
    self.mattertwo = nil;
    self.matterthree = nil;
    self.Promatterthree = nil;
    self.skillintro = nil;
    self.back = nil;
    self.canShow = nil;
    self._maxLv = 10;
    self.skillintro2 = nil;
    self.currentSkill = nil;
    self.matteroneText = nil;
    self.mattertwoText = nil;
    self.matterthreeText = nil;
    self.Gird = nil;
end

function UIHeroSpliteSkill:DoDataExchange()

    self.Aready = self:RegisterController(UnityEngine.UI.Text, "skill/aready");
    self.Aready2 = self:RegisterController(UnityEngine.UI.Text, "skill2/aready2");
    self.skillBtn = self:RegisterController(UnityEngine.UI.Button, "skill");
    self.skill2Btn = self:RegisterController(UnityEngine.UI.Button, "skill2");
    self.skillname = self:RegisterController(UnityEngine.UI.Text, "skill/Text");
    self.skill2name = self:RegisterController(UnityEngine.UI.Text, "skill2/Text");
    self.skilltype = self:RegisterController(UnityEngine.UI.Text, "Scroll/Viewport/Gird/skilltype/Text");
    self.skillrange = self:RegisterController(UnityEngine.UI.Text, "Scroll/Viewport/Gird/skillrange/Text");
    self.targettype = self:RegisterController(UnityEngine.UI.Text, "Scroll/Viewport/Gird/targettype/Text");
    self.armytype = self:RegisterController(UnityEngine.Transform, "Scroll/Viewport/Gird/armytype");
    self.probability = self:RegisterController(UnityEngine.UI.Text, "Scroll/Viewport/Gird/probability/Text");
    self.splitBtn = self:RegisterController(UnityEngine.UI.Button, "split");
    self.basematter = self:RegisterController(UnityEngine.UI.Text, "basematter");
    self.matterone = self:RegisterController(UnityEngine.UI.Text, "matterOne");
    self.mattertwo = self:RegisterController(UnityEngine.UI.Text, "matterTwo");
    self.matterthree = self:RegisterController(UnityEngine.UI.Text, "matterThree");
    self.matteroneText = self:RegisterController(UnityEngine.UI.Text, "matterOne/Textone");
    self.mattertwoText = self:RegisterController(UnityEngine.UI.Text, "matterTwo/Textwo");
    self.matterthreeText = self:RegisterController(UnityEngine.UI.Text, "matterThree/Texthree");
    self.skillintro2 = self:RegisterController(UnityEngine.UI.Text, "Scroll/Viewport/Gird/skillintro2");
    self.skillintro = self:RegisterController(UnityEngine.UI.Text, "Scroll/Viewport/Gird/skillintro");
    self.back = self:RegisterController(UnityEngine.UI.Button, "back");
    self.Gird = self:RegisterController(UnityEngine.Transform, "Scroll/Viewport/Gird");
end

function UIHeroSpliteSkill:DoEventAdd()

    self:AddListener(self.skillBtn, self.OnClickskillBtn);
    self:AddListener(self.skill2Btn, self.OnClickskill2Btn);
    self:AddListener(self.splitBtn, self.OnClicksplitBtn);
    self:AddListener(self.back, self.OnClickbackBtn);

end

function UIHeroSpliteSkill:OnShow(data)
    self.data = data;
    self.heroId = data[1].tableID
    self.canShow = data[2]
    self.Gird.localPosition = Vector3.zero;
    local mHero = DataHero[self.heroId];

    if self.canShow == false then
        self.splitBtn.gameObject:SetActive(false)
    else
        self.splitBtn.gameObject:SetActive(true)
    end


    self.skillname.text = DataSkill[mHero.ExtractSkillIDArray[1]].SkillnameText;

    self:SetMessage(DataSkill[mHero.ExtractSkillIDArray[1]])

    if mHero.ExtractSkillIDArray[2] == nil then
        self.skill2Btn.gameObject:SetActive(false)
    else
        self.skill2name.text = DataSkill[mHero.ExtractSkillIDArray[2]].SkillnameText;
    end

    if self:IfContainSkill(mHero.ExtractSkillIDArray[1]) then
        self.Aready.gameObject:SetActive(true)
    else
        self.Aready.gameObject:SetActive(false)
    end
    if self:IfContainSkill(mHero.ExtractSkillIDArray[2]) then
        self.Aready2.gameObject:SetActive(true)
    else
        self.Aready2.gameObject:SetActive(false)
    end

end


function UIHeroSpliteSkill:IfContainSkill(Id)
    local count = SkillService:Instance():GetSkillListSize();
    for i = 1, count do
        if SkillService:Instance():GetSkillFromListByID(Id) ~= nil then
            return true
        end
    end
    return false
end


function UIHeroSpliteSkill:SetMessage(id)

    self.currentSkill = id.ID
    self.skilltype.text = id.TypeText;
    if id.Range == 0 then
        self.skillrange.text = "--"
    else
        self.skillrange.text = id.Range
    end
    self.targettype.text = id.TargetTypeText;
    self:SetCamp(id.ArmyTypeLearnable)
    self.probability.text = id.SkillChanceText / 100 .. "%";
    self:SetCurIntro(self.skillintro, id, 1)
    self:SetCurIntro(self.skillintro2, id, 2)

    self.basematter.text = id.ResearchConditionText
    if id.ResearchProgressOfHero[1] ~= 0 then
        local one = DataHero[id.ResearchProgressOfHero[1]];
        self.matterone.text = "【" .. self:GetCamp(one.Camp) .. "·" .. one.Name .. "·" .. self:GetArmyType(one.BaseArmyType) .. "】"
        self.matteroneText.text = "+" .. id.ResearchProgressPreHero[1] / 100 .. "%"
    else
        self.matterone.text = ""
        self.matteroneText.text = ""
    end
    if id.ResearchProgressOfHero[2] ~= nil then
        local two = DataHero[id.ResearchProgressOfHero[2]];
        self.mattertwo.text = "【" .. self:GetCamp(two.Camp) .. "·" .. two.Name .. "·" .. self:GetArmyType(two.BaseArmyType) .. "】"
        self.mattertwoText.text = "+" .. id.ResearchProgressPreHero[1] / 100 .. "%"
    else
        self.mattertwo.text = ""
        self.mattertwoText.text = ""
    end

    if id.ResearchProgressOfHero[3] ~= nil then
        local three = DataHero[id.ResearchProgressOfHero[3]];
        self.matterthree.text = "【" .. self:GetCamp(three.Camp) .. "·" .. three.Name .. "·" .. self:GetArmyType(three.BaseArmyType) .. "】"
        self.matterthreeText.text = "+" .. id.ResearchProgressPreHero[1] / 100 .. "%"
    else
        self.matterthree.text = ""
        self.matterthreeText.text = ""
    end


end

function UIHeroSpliteSkill:GetArmyType(i)
    if i == ArmyType.Qi then
        return "骑"
    end
    if i == ArmyType.Gong then
        return "弓"
    end
    if i == ArmyType.Bu then
        return "步"
    end
end

function UIHeroSpliteSkill:GetCamp(i)
    if i == CampType.Qin then
        return "秦"
    end
    if i == CampType.Janpan then
        return "侍"
    end
    if i == CampType.Europe then
        return "都铎"
    end
    if i == CampType.Viking then
        return "维京"
    end
end

-- 通过等级获得加成
function UIHeroSpliteSkill:GetBufferByLv(lv, i, id)
    if (i == 0) then
        return 0;
    end
    local temp =((id.FinalSkillParameter[i] - id.InitialSkillParameter[i]) /(self._maxLv - 1) *(lv - 1) + id.InitialSkillParameter[i]) / 10;
    return temp;
    -- return string.format("%.1f", temp)
end


function UIHeroSpliteSkill:SetCurIntro(label, id, lv)

    local count = #id.InitialSkillParameter
    local tempNums = { }
    for index = 1, count do
        tempNums[index] = self:GetBufferByLv(lv, index, id);
    end
    if (count == 0) then
        -- 这是临时的 正式的用下面那四种
        label.text = id.Skilldescription;
    end
    if (count == 1) then
        label.text = string.format(id.Skilldescription, tempNums[1]);
    end
    if (count == 2) then
        label.text = string.format(id.Skilldescription, tempNums[1], tempNums[2]);
    end
    if (count == 3) then
        label.text = string.format(id.Skilldescription, tempNums[1], tempNums[2], tempNums[3]);
    end
    if (count == 4) then
        label.text = string.format(id.Skilldescription, tempNums[1], tempNums[2], tempNums[2], tempNums[3]);
    end

end


function UIHeroSpliteSkill:SetCamp(mCamp)

    local tranParent = self.armytype.transform;
    tranParent.gameObject:SetActive(true);

    for i = 1, table.getn(mCamp) do
        if mCamp[i] then
            tranParent:GetChild(mCamp[i] -1).gameObject:SetActive(true);
        else
            tranParent:GetChild(mCamp[i] -1).gameObject:SetActive(false);
        end

    end

end



function UIHeroSpliteSkill:OnClickskillBtn()
    local mHero = DataHero[self.heroId];
    self:SetMessage(DataSkill[mHero.ExtractSkillIDArray[1]])
end

function UIHeroSpliteSkill:OnClickskill2Btn()
    local mHero = DataHero[self.heroId];

    self:SetMessage(DataSkill[mHero.ExtractSkillIDArray[2]])
end

function UIHeroSpliteSkill:OnClicksplitBtn()
    if self:IfContainSkill(self.currentSkill) then
        UIService:Instance():ShowUI(UIType.UICueMessageBox, 901)
        return
    end

    if PlayerService:Instance():CheckCardInArmy(self.data[1].id) then
        UIService:Instance():ShowUI(UIType.UICueMessageBox, UICueMessageType.HeroInArmy)
        return
    end
    if self.data[1].isProtect then
        UIService:Instance():ShowUI(UIType.UICueMessageBox, UICueMessageType.HeroIsProtect)
        return
    end
    if self.data[1].allSkillSlotList[2] ~= 0 then
        UIService:Instance():ShowUI(UIType.UICueMessageBox, UICueMessageType.LearnedSkill)
        return
    end
    UIService:Instance():ShowUI(UIType.UIHeroSpliteHero, self.data)
    UIService:Instance():HideUI(UIType.UIHeroSpliteSkill)
    UIService:Instance():HideUI(UIType.UIHeroAdvance)
    UIService:Instance():HideUI(UIType.UITactisTransExp)
    UIService:Instance():HideUI(UIType.UITactisResearch)
    UIService:Instance():HideUI(UIType.UIHeroCardInfo)

end

function UIHeroSpliteSkill:OnClickbackBtn()
    UIService:Instance():HideUI(UIType.UIHeroSpliteSkill)
    UIService:Instance():ShowUI(UIType.UIHeroCardInfo, self.data)
end

return UIHeroSpliteSkill 
-- endregion
