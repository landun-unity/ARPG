
local UIBase = require("Game/UI/UIBase")

local UITactisDetail = class("UITactisDetail", UIBase)
local UIService = require("Game/UI/UIService")
local UIType = require("Game/UI/UIType")

local exlSkill = require("Game/Table/model/DataSkill")
local SKillRemove = require("MessageCommon/Msg/C2L/Skill/DeleteOneSkill");
local LearnSkill = require("MessageCommon/Msg/C2L/Skill/LearnSkill");
local SkillEnhance = require("MessageCommon/Msg/C2L/Skill/SkillEnhance");
local ForGetSkill = require("MessageCommon/Msg/C2L/Skill/ForGetSkill");
local SkillType = require("Game/Skill/SkillType");
local ArmyState = require("Game/Army/ArmyState");
local List = require("common/List");
local DataTable = require("Game/Table/model/DataSkill")
local DataHero = require("Game/Table/model/DataHero");
local Effect = nil;
local CloseWhenUpdate = false;
function UITactisDetail:ctor()
    UITactisDetail.super.ctor(self)
    self._researchObj = nil;
    self._lvObj = nil;
    self._LvFullObj = nil;
    self._generalSkillObj = nil;
    self._generalSkillIcon = nil;
    self._backImage = nil;
    self._backBtn = nil;
    self._back = nil;
    self._researchBtn = nil;
    self._LearnSkillBtn = nil;
    self._StrengSkillBtn = nil;
    self._removeBtn = nil;
    self._removeFromHeroBtn = nil;
    self._skillName = nil;
    self._progressNum = nil;
    self._learnNum = nil;
    self._learnGeneral = nil;
    self._NOLearnGeneral = nil;
    self._researchConditionDetail = nil;
    self._researchConditon = nil;
    self._learnOver = nil;
    self._mask = nil;
    self._typeLabel = nil;
    self._disLabel = nil;
    self._TargetTypeLabel = nil;
    self._chance = nil;
    self._CurrentLvLabel = nil;
    self._NextLvTitle = nil;
    self._NextLvLabel = nil;
    self._armType1 = nil;
    self._armType2 = nil;
    self._armType3 = nil;
    self.skillLine = nil;
    self._skillInfo = nil;
    self._leftBtn = nil;
    self._RightBtn = nil;
    self._expNumLabel = nil;
    self._isFromHero = 0;
    -- 0正常的技能 1 来自英雄学习  2.来自英雄技能升级
    self._cruuendLv = 1;
    self._maxLv = 10;
    self._maxLearnNum = 5;
    self._index = 0;
    self.param = nil;
    self._all = 0;
    self._LearnSkillList = List.new();
    self._heroId = 0;
    self._SkillPos = 0;
    self._currentExp = 0;
    self._needexp = 0;
    self._CurrentLv = nil;
    self._NextLv = nil;
    self._Exp = nil;
    self._CanStrengthen = false;
    self._StrengthEffect = nil;
    self._StrengSkillBtnImage = nil;
    self.defultPicGray = "TonYonButtonNormal2Grey";
    self.defultPic = "TonYonButtonNormal1"
end

function UITactisDetail:DoDataExchange()
    self._researchObj = self:RegisterController(UnityEngine.Transform, "Background/TopObj/ResearchObj");
    self._lvObj = self:RegisterController(UnityEngine.Transform, "Background/TopObj/ResearchConditon/LvObj");
    self._LvFullObj = self:RegisterController(UnityEngine.Transform, "Background/TopObj/ResearchConditon/LvFullObj");
    self._generalSkillObj = self:RegisterController(UnityEngine.Transform, "Background/TopObj/GeneralSkillObj");
    self._SkillBtnIcon = self:RegisterController(UnityEngine.UI.Image, "Background/TopObj/GeneralSkillObj/SkillAll/SkillIcon");
    self._generalSkillIcon = self:RegisterController(UnityEngine.UI.Image, "Background/TopObj/ResearchObj/SkillIcon/SkillBtn");
    self._generalSkillLv = self:RegisterController(UnityEngine.UI.Text, "Background/TopObj/GeneralSkillObj/SkillAll/Bg/SkillLv");
    self._backBtn = self:RegisterController(UnityEngine.UI.Button, "Background/BackBtn");
    self._back = self:RegisterController(UnityEngine.UI.Button, "Back");
    self._backImage = self:RegisterController(UnityEngine.RectTransform, "Background");
    self._researchBtn = self:RegisterController(UnityEngine.UI.Button, "ResearchBtn");
    self._LearnSkillBtn = self:RegisterController(UnityEngine.UI.Button, "LearnSkillBtn");
    self._StrengSkillBtn = self:RegisterController(UnityEngine.UI.Button, "StrengSkillBtn");
    self._StrengSkillBtnImage = self:RegisterController(UnityEngine.UI.Image, "StrengSkillBtn");
    self._removeBtn = self:RegisterController(UnityEngine.UI.Button, "Background/TopObj/ResearchObj/RemoveBtn");
    self._removeFromHeroBtn = self:RegisterController(UnityEngine.UI.Button, "Background/TopObj/GeneralSkillObj/removeFromHeroBtn");
    self._skillName = self:RegisterController(UnityEngine.UI.Text, "Background/SkillName");
    self._progressNum = self:RegisterController(UnityEngine.UI.Text, "Background/TopObj/ResearchObj/SkillIcon/Percent");
    self._learnNum = self:RegisterController(UnityEngine.UI.Text, "Background/TopObj/ResearchObj/SkillIcon/DistributableSkillNum");
    self._learnGeneral = self:RegisterController(UnityEngine.UI.Text, "Background/TopObj/ResearchObj/LearnGeneral");
    self._learnGeneralText1 = self:RegisterController(UnityEngine.UI.Button, "Background/TopObj/ResearchObj/LearnGeneral/Text");
    self._learnGeneralText2 = self:RegisterController(UnityEngine.UI.Button, "Background/TopObj/ResearchObj/LearnGeneral/Text1");
    self._learnGeneralText3 = self:RegisterController(UnityEngine.UI.Button, "Background/TopObj/ResearchObj/LearnGeneral/Text2");
    self._learnGeneralText4 = self:RegisterController(UnityEngine.UI.Button, "Background/TopObj/ResearchObj/LearnGeneral/Text3");
    self._learnGeneralText5 = self:RegisterController(UnityEngine.UI.Button, "Background/TopObj/ResearchObj/LearnGeneral/Text4");

    self._NOLearnGeneral = self:RegisterController(UnityEngine.Transform, "Background/TopObj/ResearchObj/NOLearnGeneral");
    self._learnOver = self:RegisterController(UnityEngine.UI.Text, "Background/TopObj/ResearchConditon/LearnOver");
    self._researchConditon = self:RegisterController(UnityEngine.Transform, "Background/TopObj/ResearchConditon/ResearchCondition");
    self._researchConditionDetail = self:RegisterController(UnityEngine.UI.Text, "Background/TopObj/ResearchConditon/ResearchCondition/ResearchConditionDetail");
    self._mask = self:RegisterController(UnityEngine.UI.Image, "Background/TopObj/ResearchObj/SkillIcon/Mask");
    self._typeLabel = self:RegisterController(UnityEngine.UI.Text, "Background/TopObj/DetailObj/DetailPanel/Parent/All/Type/TypeLabel");
    self._disLabel = self:RegisterController(UnityEngine.UI.Text, "Background/TopObj/DetailObj/DetailPanel/Parent/All/Dis/DisLabel");
    self._TargetTypeLabel = self:RegisterController(UnityEngine.UI.Text, "Background/TopObj/DetailObj/DetailPanel/Parent/All/TargetType/TargetTypeLabel");
    self._chance = self:RegisterController(UnityEngine.UI.Text, "Background/TopObj/DetailObj/DetailPanel/Parent/All/Chance/ChanceLabel");
    self._CurrentLvLabel = self:RegisterController(UnityEngine.UI.Text, "Background/TopObj/DetailObj/DetailPanel/Parent/verticalLayOut/CurrentLvLabel");
    self._expNumLabel = self:RegisterController(UnityEngine.UI.Text, "StrengSkillBtn/Tips");
    self._NextLvLabel = self:RegisterController(UnityEngine.UI.Text, "Background/TopObj/DetailObj/DetailPanel/Parent/verticalLayOut/NextLvLabel");
    self._NextLvTitle = self:RegisterController(UnityEngine.UI.Text, "Background/TopObj/DetailObj/DetailPanel/Parent/verticalLayOut/Image1/NextLv");
    self._armType1 = self:RegisterController(UnityEngine.UI.Image, "Background/TopObj/DetailObj/DetailPanel/Parent/All/ArmType/ArmType1");
    self._armType2 = self:RegisterController(UnityEngine.UI.Image, "Background/TopObj/DetailObj/DetailPanel/Parent/All/ArmType/ArmType2");
    self._armType3 = self:RegisterController(UnityEngine.UI.Image, "Background/TopObj/DetailObj/DetailPanel/Parent/All/ArmType/ArmType3");
    self._leftBtn = self:RegisterController(UnityEngine.UI.Button, "LeftBtn");
    self._RightBtn = self:RegisterController(UnityEngine.UI.Button, "RightBtn");
    self._CurrentLv = self:RegisterController(UnityEngine.UI.Text, "Background/TopObj/ResearchConditon/LvObj/CurrentLv");
    self._NextLv = self:RegisterController(UnityEngine.UI.Text, "Background/TopObj/ResearchConditon/LvObj/NextLv");
    self._Exp = self:RegisterController(UnityEngine.UI.Text, "Background/TopObj/ResearchConditon/LvObj/Exp");
    self._StrengthEffect = self:RegisterController(UnityEngine.Transform, "Background/TopObj/GeneralSkillObj/SkillAll/StrengthEffect");
    self.parentObj = self:RegisterController(UnityEngine.Transform, "Background/TopObj/DetailObj/DetailPanel/Parent")
end

-- 注册所有的事件
function UITactisDetail:RegisterAllNotice()
    self:RegisterNotice(L2C_Skill.UpdateSkill, self.RefreshProgress);
    self:RegisterNotice(L2C_Skill.DeleteOneSkillRespond, self.DeleteOneSkillRespond);
    self:RegisterNotice(L2C_Skill.LearnSkillResult, self.LearnSkillResult);
    self:RegisterNotice(L2C_Skill.SkillEnhanceResult, self.SkillEnhanceResult);
    self:RegisterNotice(L2C_Player.SynchronizeWarfare, self.SetExp);
end

-- 删除技能回调
function UITactisDetail:DeleteOneSkillRespond()
    if (self._isFromHero == 2) then
        return
    end
    local info = SkillService:Instance():GetSkillFromListByID(self._skillInfo._id);
    if (info ~= nil) then
        self._skillInfo = info;
        self:SetSkillInfo();
    else
        self:OnClickBackBtn();
    end
end

-- 学习技能返回结果
function UITactisDetail:LearnSkillResult()
    UIService:Instance():HideUI(UIType.UITactis);
    UIService:Instance():HideUI(UIType.UITactisDetail);
    HeroService:Instance():ShowHeroInfoUI(self._heroId)
    if UIService:Instance():GetOpenedUI(UIType.UITactisTransExp) then
        UIService:Instance():GetUIClass(UIType.UITactisTransExp):OnShow(UIService:Instance():GetUIClass(UIType.UITactisTransExp):GetPamp())
    end
end

-- 强化技能返回结果
function UITactisDetail:SkillEnhanceResult()
    local heroinfo = HeroService:Instance():GetOwnHeroesById(self._heroId);
    if (heroinfo) then
        self._cruuendLv = 1;
        for index = 1, 3 do
            if (heroinfo.allSkillSlotList[index] and heroinfo.allSkillSlotList[index] == self._skillInfo._tableId) then
                self._cruuendLv = heroinfo.allSkillLevelList[index];
                break;
            end
        end
    end
    self:SetExp();
    self:SetCurrentLv();
    self:InitStrengthLv();
    self:SetWindowsSize();
    self:ShowEffect();
    self:CheackImage();
end

function UITactisDetail:DoEventAdd()
    self:AddListener(self._backBtn, self.OnClickBackBtn);
    self:AddListener(self._back, self.OnClickBackBtn);
    self:AddListener(self._removeBtn, self.OnClickRemoveBtn);
    self:AddListener(self._removeFromHeroBtn, self.OnClickRemoveFromHeroBtn);
    self:AddListener(self._researchBtn, self.OnClickResearchBtn);
    self:AddListener(self._leftBtn, self.OnClickLeft);
    self:AddListener(self._RightBtn, self.OnClickRight);
    self:AddListener(self._LearnSkillBtn, self.OnClickLearnSkillBtn);
    self:AddListener(self._StrengSkillBtn, self.OnClickStrengSkillBtn);
    self:AddListener(self._learnGeneralText1, self.OnClicklearnGeneralText1Btn);
    self:AddListener(self._learnGeneralText2, self.OnClicklearnGeneralText2Btn);
    self:AddListener(self._learnGeneralText3, self.OnClicklearnGeneralText3Btn);
    self:AddListener(self._learnGeneralText4, self.OnClicklearnGeneralText4Btn);
    self:AddListener(self._learnGeneralText5, self.OnClicklearnGeneralText5Btn);

end

function UITactisDetail:OnClicklearnGeneralText1Btn()
    local learnId = self._skillInfo._learnHeroID:Get(1);
    if learnId ~= nil then
        HeroService:Instance():ShowHeroInfoUI(learnId)
        UIService:Instance():HideUI(UIType.UITactisDetail)
    end
end
function UITactisDetail:OnClicklearnGeneralText2Btn()
    local learnId = self._skillInfo._learnHeroID:Get(2);
    if learnId ~= nil then
        UIService:Instance():HideUI(UIType.UITactisDetail)
        HeroService:Instance():ShowHeroInfoUI(learnId)
    end
end
function UITactisDetail:OnClicklearnGeneralText3Btn()
    local learnId = self._skillInfo._learnHeroID:Get(3);
    if learnId ~= nil then
        UIService:Instance():HideUI(UIType.UITactisDetail)
        HeroService:Instance():ShowHeroInfoUI(learnId)
    end
end
function UITactisDetail:OnClicklearnGeneralText4Btn()
    local learnId = self._skillInfo._learnHeroID:Get(4);
    if learnId ~= nil then
        UIService:Instance():HideUI(UIType.UITactisDetail)
        HeroService:Instance():ShowHeroInfoUI(learnId)
    end
end
function UITactisDetail:OnClicklearnGeneralText5Btn()
    local learnId = self._skillInfo._learnHeroID:Get(5);
    if learnId ~= nil then
        UIService:Instance():HideUI(UIType.UITactisDetail)
        HeroService:Instance():ShowHeroInfoUI(learnId)
    end
end

-- 设置左右切换按钮
function UITactisDetail:SetLeftAndRightBtns()
    if (self._isFromHero == 2) then
        return
    end
    if (self._isFromHero == 0) then
        self._all = SkillService:Instance():GetSkillCountByType(SkillType.All);
        if (self._index == 0) then
            for index = 1, self._all do
                local info = SkillService:Instance():GetSkillByTypeAndIndex(SkillType.All, index);
                if (info == self._skillInfo) then
                    self._index = index;
                    break;
                end
            end
        end
    end
    if (self._isFromHero == 1) then
        self._index = 0;
        self._LearnSkillList:Clear();
        local allcount = SkillService:Instance():GetSkillCountByType(SkillType.All);
        for index = 1, allcount do
            local info = SkillService:Instance():GetSkillFromListByIndex(index);
            if (self:JudgeIfCanAddToList(info)) then
                self._index = self._index + 1;
                if (info == self._skillInfo) then
                    self._index = index;
                end
                self._LearnSkillList:Push(info);
            end
        end
        self._all = self._LearnSkillList:Count();
    end
    if (self._all <= 1) then
        self._leftBtn.gameObject:SetActive(false)
        self._RightBtn.gameObject:SetActive(false)
        return;
    end
    self._leftBtn.gameObject:SetActive(true)
    self._RightBtn.gameObject:SetActive(true)
    if (self._index <= 1) then
        self._leftBtn.gameObject:SetActive(false)
    elseif (self._index >= self._all) then
        self._RightBtn.gameObject:SetActive(false)
    end
end

-- 是否满足条件
function UITactisDetail:JudgeIfCanAddToList(info)
    if (self._fromHero) then
        if (info._progress >= 10000 and skillInfo._learnHeroID:Count() > DataTable[info._tableId].MaxLearnNum) then
            return true;
        else
            return false;
        end
    else
        return true;
    end
    return false;
end

-- 刷新研究进度
function UITactisDetail:RefreshProgress()
    self._index = 0;
    for index = 1, self._all do
        local info = SkillService:Instance():GetSkillByTypeAndIndex(SkillType.All, index);
        if (info._id == self._skillInfo._id) then
            self._index = index;
            break;
        end
    end
    self:SetLeftAndRightBtns();
    self:RefreshSkillInfo();
end

-- 点击左边按钮
function UITactisDetail:OnClickLeft()
    self._index = self._index - 1;
    self:SetLeftAndRightBtns();
    self:RefreshSkillInfo();
end

-- 点击右边按钮
function UITactisDetail:OnClickRight()
    self._index = self._index + 1;
    self:SetLeftAndRightBtns();
    self:RefreshSkillInfo();
end

-- 刷新技能
function UITactisDetail:RefreshSkillInfo()
    local skillinfo = SkillService:Instance():GetSkillByTypeAndIndex(SkillType.All, self._index);
    if (skillinfo ~= nil) then
        self._skillInfo = skillinfo;
        self:ResetSKillInfo();
    else
        self:OnClickBackBtn();
    end
end

-- param 1.3个状态（0正常的技能 1 来自英雄学习  2.来自英雄技能升级） 2.skillinfo  3英雄卡牌id 4.位置id 5.当前等级  6.是否可以研究
function UITactisDetail:OnShow(param)
    self.param = param
    if (param == nil) then
        return;
    end
    self._skillInfo = param[2];
    self._index = 0
    self._isFromHero = param[1];
    if (param[3]) then
        self._heroId = param[3];
    else
        self._heroId = 0;
    end
    if (param[4]) then
        self._SkillPos = param[4];
    else
        self._SkillPos = 0;
    end
    self._cruuendLv = 1;
    if (param[5]) then
        self._cruuendLv = param[5]
    end
    self._CanStrengthen = false;
    if (param[6] and param[6] == true) then
        self._CanStrengthen = param[6];
    end

    self:SetLeftAndRightBtns();
    self.skillLine = exlSkill[self._skillInfo._tableId];
    if (self.skillLine == nil) then
        return;
    end
    self._maxLearnNum = self.skillLine.MaxLearnNum;
    self:SetDetail();
    self:SetArmyType();
    self:InitType();
    self:SetSkillInfo();
    -- self:ShowEffectOver();
    self:CheackImage();
    self.parentObj.transform.localPosition = Vector3.zero;
    local bassClass = UIService:Instance():GetOpenedUI(UIType.UIHeroHandbook);
    if bassClass then
        self._removeFromHeroBtn.gameObject:SetActive(false)
    end
    if UIService:Instance():GetOpenedUI(UIType.UIRecruitUI) then
        self._removeFromHeroBtn.gameObject:SetActive(false)
    end
    local open1 = UIService:Instance():GetOpenedUI(UIType.UIHeroAdvance)
    local open2 = UIService:Instance():GetOpenedUI(UIType.UITactisResearch)
    local open3 = UIService:Instance():GetOpenedUI(UIType.UITactisTransExp)
    local open4 = UIService:Instance():GetOpenedUI(UIType.UIHeroSpliteHero)
    local open5 = UIService:Instance():GetOpenedUI(UIType.UIHeroAwake)
    if open1 or open2 or open3 or open4 or open5 then
        self._StrengSkillBtn.gameObject:SetActive(false)
    end

end

-- 重置技能强化图标
function UITactisDetail:CheackImage()
    if self._currentExp >= self._needexp then
        self._StrengSkillBtnImage.sprite = GameResFactory.Instance():GetResSprite(self.defultPic);
        self._expNumLabel.color = Color.white
    else
        self._StrengSkillBtnImage.sprite = GameResFactory.Instance():GetResSprite(self.defultPicGray);
        self._expNumLabel.color = Color.red
    end
end

-- 初始化技能
function UITactisDetail:ResetSKillInfo()
    self.skillLine = exlSkill[self._skillInfo._tableId];
    self._maxLearnNum = self.skillLine.MaxLearnNum;
    self:SetDetail();
    self:SetArmyType();
    self:InitType();
    self:SetSkillInfo();
    -- self:ShowEffectOver();
end

-- 设置技能
function UITactisDetail:SetSkillInfo()
    local learnHero = "";
    local haveNo = true;
    local learnmum = 0;
    local learnCount = self._skillInfo._learnHeroID:Count();
    self._learnGeneral.text = "";
    for index = 1, self._learnGeneral.transform.childCount do
        self._learnGeneral.transform:GetChild(index - 1).gameObject:SetActive(false)
    end

    for index = 1, learnCount do
        haveNo = false;
        local learnId = self._skillInfo._learnHeroID:Get(index);
        learnHero = HeroService:Instance():GetOwnHeroNameById(learnId);
        learnmum = learnmum + 1
        if learnHero == "" then
            self._learnGeneral.transform:GetChild(index - 1).gameObject:SetActive(false)
        else
            self._learnGeneral.transform:GetChild(index - 1).gameObject:SetActive(true)
            self._learnGeneral.transform:GetChild(index - 1).gameObject:GetComponent(typeof(UnityEngine.UI.Text)).text = learnHero
        end
    end

    if (self._skillInfo._progress >= 10000) then
        self._learnNum.text =(self._maxLearnNum - learnmum) .. "/" .. self._maxLearnNum;
        self._learnOver.text = "该战法已经研究成功，可以配置" .. self.skillLine.MaxLearnNum .. "个武将";
    else
        self._learnNum.text = "-/" .. self._maxLearnNum;
    end
    self:SetProgress(self._skillInfo._progress / 100);
    self:SetWindowsSize();
    if (haveNo == false) then
        self._learnGeneral.gameObject:SetActive(true)
        self._learnGeneral.text = "学习的武将 :"
    end
    self._NOLearnGeneral.gameObject:SetActive(haveNo);
end

-- 设置类型
function UITactisDetail:InitType()
    self._researchBtn.gameObject:SetActive(false);
    self._LearnSkillBtn.gameObject:SetActive(false);
    self._lvObj.gameObject:SetActive(false);
    self._LvFullObj.gameObject:SetActive(false);
    self._researchObj.gameObject:SetActive(false);
    self._generalSkillObj.gameObject:SetActive(false);
    self._StrengSkillBtn.gameObject:SetActive(false);
    self._learnOver.gameObject:SetActive(false);
    if (self._isFromHero == 0) then
        self._researchObj.gameObject:SetActive(true);
        self._researchBtn.gameObject:SetActive(true);
    else
        self._generalSkillObj.gameObject:SetActive(true);
    end
    if (self._isFromHero == 1) then
        self._LearnSkillBtn.gameObject:SetActive(true);
        self._generalSkillLv.text = "Lv" .. 1;
        self._removeFromHeroBtn.gameObject:SetActive(false)
    end
    if (self._isFromHero == 2) then
        if (self._SkillPos == 1) then
            self._removeFromHeroBtn.gameObject:SetActive(false)
        else
            self._removeFromHeroBtn.gameObject:SetActive(true)
        end
        self._leftBtn.gameObject:SetActive(false);
        self._RightBtn.gameObject:SetActive(false);
        self:SetExp();
        self:InitStrengthLv();
    end
end

-- 设置战法经验
function UITactisDetail:SetExp()
    self._currentExp = PlayerService:Instance():GetCurrencyVarCalcByKey(CurrencyEnum.Warfare):GetValue()
    self._expNumLabel.text = tostring(self._currentExp);
    if UIService:Instance():GetUIClass(UIType.UIHeroSpliteHero) ~= nil then
        UIService:Instance():GetUIClass(UIType.UIHeroSpliteHero):RefreshExp()
    end
end

-- 设置强化技能
function UITactisDetail:InitStrengthLv()
    if (self._cruuendLv >= self._maxLv) then
        self._LvFullObj.gameObject:SetActive(true);
        self._StrengSkillBtn.gameObject:SetActive(false);
        self._lvObj.gameObject:SetActive(false);
    else
        if (self._CanStrengthen) then
            self._StrengSkillBtn.gameObject:SetActive(true);

        end
        self._lvObj.gameObject:SetActive(true);
        self._CurrentLv.text = tostring(self._cruuendLv);
        self._NextLv.text = tostring(self._cruuendLv + 1);
    end
    self._generalSkillLv.text = "Lv" .. self._cruuendLv;
    self._needexp =(DataTable[self._skillInfo._tableId].SkillUpNeedExp)[self._cruuendLv];
    if (self._needexp == nil) then
        self._needexp = 0;
    end
    self._Exp.text = tostring(self._needexp);
end

-- 设置技能详情
function UITactisDetail:SetDetail()
    self._skillName.text = self.skillLine.SkillnameText;
    self._typeLabel.text = self.skillLine.TypeText;
    if self.skillLine.Range == 0 then
        self._disLabel.text = "-";
    else
        self._disLabel.text = self.skillLine.Range;
    end

    self._TargetTypeLabel.text = self.skillLine.TargetTypeText;

    self:SetCurrentLv();
end

-- 设置当前等级 下一等级
function UITactisDetail:SetCurrentLv()
    local num = self:GetSkillChanceByLv(self._cruuendLv) / 100;
    if (math.floor(num) < num) then
        self._chance.text = string.format("%.1f", num);
    else
        self._chance.text = string.format("%d", num);
    end
    local oneLevelNum =(self.skillLine.SkillChanceLvMaxText - self.skillLine.SkillChanceText) / 9
    self._chance.text =(math.floor((self.skillLine.SkillChanceText + oneLevelNum *(self._cruuendLv - 1)) / 10)) / 10 .. "%"
    if (self._cruuendLv == self._maxLv) then
        self._NextLvTitle.gameObject:SetActive(false);
        self._NextLvTitle.transform.parent.gameObject:SetActive(false)
        self._NextLvLabel.text = "";
    else
        self._NextLvTitle.transform.parent.gameObject:SetActive(true)
        self._NextLvTitle.gameObject:SetActive(true);
        self:SetLabelText(self._NextLvLabel,(self._cruuendLv + 1));
    end
    self:SetLabelText(self._CurrentLvLabel, self._cruuendLv);
end

-- 设置等级label 显示的内容
function UITactisDetail:SetLabelText(label, lv)
    local count = #self.skillLine.InitialSkillParameter;
    local tempNums = { };
    for index = 1, count do
        tempNums[index] = self:GetBufferByLv(lv, index);
    end
    if (count == 0) then
        -- 这是临时的 正式的用下面那四种
        label.text = self.skillLine.Skilldescription;
    end
    if (count == 1) then
        label.text = string.format(self.skillLine.Skilldescription, tempNums[1]);
    end
    if (count == 2) then
        label.text = string.format(self.skillLine.Skilldescription, tempNums[1], tempNums[2]);
    end
    if (count == 3) then
        label.text = string.format(self.skillLine.Skilldescription, tempNums[1], tempNums[2], tempNums[3]);
    end
    if (count == 4) then
        label.text = string.format(self.skillLine.Skilldescription, tempNums[1], tempNums[2], tempNums[2], tempNums[3]);
    end
end

-- 通过等级获得加成
function UITactisDetail:GetBufferByLv(lv, i)
    if (i == 0) then
        return 0;
    end
    local temp =((self.skillLine.FinalSkillParameter[i] - self.skillLine.InitialSkillParameter[i]) /(self._maxLv - 1) *(lv - 1) + self.skillLine.InitialSkillParameter[i]) / 10;
    return temp;
    -- return string.format("%.1f", temp)
end

-- 通过等级获得概率
function UITactisDetail:GetSkillChanceByLv(lv)
    return((self.skillLine.SkillChanceLvMax - self.skillLine.SkillChance) /(self._maxLv - 1) *(lv - 1) + self.skillLine.SkillChance);
end

-- 设置类型
function UITactisDetail:SetArmyType()
    self._generalSkillIcon.sprite = SkillService:Instance():GetSkillBgByType(self.skillLine.Type);
    self._SkillBtnIcon.sprite = SkillService:Instance():GetSkillBgByType(self.skillLine.Type);
    self._armType1.gameObject:SetActive(false);
    self._armType2.gameObject:SetActive(false);
    self._armType3.gameObject:SetActive(false);
    if (self.skillLine.ArmyTypeIcon[1] ~= nil) then
        self._armType1.gameObject:SetActive(true);
        self._armType1.sprite = GameResFactory.Instance():GetResSprite(self.skillLine.ArmyTypeIcon[1]);
    end
    if (self.skillLine.ArmyTypeIcon[2] ~= nil) then
        self._armType2.gameObject:SetActive(true);
        self._armType2.sprite = GameResFactory.Instance():GetResSprite(self.skillLine.ArmyTypeIcon[2]);
    end
    if (self.skillLine.ArmyTypeIcon[3] ~= nil) then
        self._armType3.gameObject:SetActive(true);
        self._armType3.sprite = GameResFactory.Instance():GetResSprite(self.skillLine.ArmyTypeIcon[3]);
    end
end



function UITactisDetail:GetCamp(i)
    if i == 1 then
        return "秦"
    end
    if i == 2 then
        return "侍"
    end
    if i == 3 then
        return "都铎"
    end
    if i == 4 then
        return "维京"
    end
end


function UITactisDetail:GetArmyType(i)
    if i == 1 then
        return "骑"
    end
    if i == 2 then
        return "弓"
    end
    if i == 3 then
        return "步"
    end
end
-- 设置进度
function UITactisDetail:SetProgress(fillAmountVal)
    if (fillAmountVal >= 100) then
        self._researchBtn.gameObject:SetActive(false);
        self._researchConditon.gameObject:SetActive(false);
        if (self._isFromHero == 0) then
            self._learnOver.gameObject:SetActive(true);
        end
    else
        self._researchBtn.gameObject:SetActive(true);
        self._researchConditon.gameObject:SetActive(true);
        self._researchConditionDetail.text = self.skillLine.ResearchConditionText;
        if self.skillLine.ResearchProgressOfHero[1] ~= 0 then
            local one = DataHero[self.skillLine.ResearchProgressOfHero[1]];
            self._researchConditionDetail.text = self._researchConditionDetail.text .. "    " .. "【" .. self:GetCamp(one.Camp) .. "·" .. one.Name .. "·" .. self:GetArmyType(one.BaseArmyType) .. "】" .. " " .. "+" .. self.skillLine.ResearchProgressPreHero[1] / 100 .. "%"
        end
        if self.skillLine.ResearchProgressOfHero[2] ~= nil then
            local two = DataHero[self.skillLine.ResearchProgressOfHero[2]];
            self._researchConditionDetail.text = self._researchConditionDetail.text .. "    " .. "【" .. self:GetCamp(two.Camp) .. "·" .. two.Name .. "·" .. self:GetArmyType(two.BaseArmyType) .. "】" .. " " .. "+" .. self.skillLine.ResearchProgressPreHero[1] / 100 .. "%"
        end
        if self.skillLine.ResearchProgressOfHero[3] ~= nil then
            local two = DataHero[self.skillLine.ResearchProgressOfHero[3]];
            self._researchConditionDetail.text = self._researchConditionDetail.text .. "    " .. "【" .. self:GetCamp(two.Camp) .. "·" .. two.Name .. "·" .. self:GetArmyType(two.BaseArmyType) .. "】" .. " " .. "+" .. self.skillLine.ResearchProgressPreHero[1] / 100 .. "%"
        end
    end
    self._mask.fillAmount =(1 - fillAmountVal / 100);
    if (fillAmountVal >= 100) then
        self._progressNum.gameObject:SetActive(false);
        self._progressNum.text = "100%"
    else
        self._progressNum.gameObject:SetActive(true);
        self._progressNum.text = fillAmountVal .. "%"
    end
end

-- 设置窗口大小
function UITactisDetail:SetWindowsSize()
    self._backImage.sizeDelta = Vector2.New(980, 600);
    if (self._skillInfo._progress >= 10000) then
        if (self._isFromHero == 0) then
            self._backImage.sizeDelta = Vector2.New(980, 600);
        end
        if (self._isFromHero == 2 and(self._cruuendLv == self._maxLv or self._CanStrengthen == false)) then
            self._backImage.sizeDelta = Vector2.New(980, 600);
        end
    end
end

-- 删除技能
function UITactisDetail:OnClickRemoveBtn()
    if (false) then
        UIService:Instance():ShowUI(UIType.UICueMessageBox, 63);
        -- 预设战法无法被删除
        return;
    end
    if (self._skillInfo._learnHeroID:Count() > 0) then
        UIService:Instance():ShowUI(UIType.UICueMessageBox, 62);
        -- 战法被学习 不能被删除
        return;
    end
    CommonService:Instance():ShowOkOrCancle(self, self.ConfirmRemove, nil, "确认", "战法移除后将不能学习和研究");
end

-- 确定删除
function UITactisDetail:ConfirmRemove()
    CloseWhenUpdate = true;
    local msg = SKillRemove.new();
    msg:SetMessageId(C2L_Skill.DeleteOneSkill);
    msg.skillID = self._skillInfo._id;
    NetService:Instance():SendMessage(msg);
end

-- 从卡牌里移除战法
function UITactisDetail:OnClickRemoveFromHeroBtn()
    if PlayerService:Instance():CheckCardInArmy(self._heroId) then
        local army = PlayerService:Instance():GetCardInArmy(self._heroId)
        if army:GetArmyState() ~= ArmyState.None then
            UIService:Instance():ShowUI(UIType.UICueMessageBox, UICueMessageType.CanNotDeleteSkill);
            return
        end
    end
    local heroname = HeroService:Instance():GetOwnHeroNameById(self._heroId);
    local skillname = self.skillLine.SkillnameText;
    local returnexp = self:GetRetrunExp();
    local tips = "遗忘此战法后，会返回80%战法经验(" .. math.floor(returnexp) .. ")点，并返回此战法1次学习数"
    CommonService:Instance():ShowOkOrCancle(self, self.ConfirmRemoveFromHeroBtn, nil, "遗忘战法", "确定将" .. heroname .. "的" .. skillname .. "遗忘吗？", nil, nil, tips);
end

-- 返回的经验
function UITactisDetail:GetRetrunExp()
    local returnexp = 0;
    for index = 1,(self._cruuendLv - 1) do
        if (DataTable[self._skillInfo._tableId] and DataTable[self._skillInfo._tableId].SkillUpNeedExp and
            (DataTable[self._skillInfo._tableId].SkillUpNeedExp)[index]) then
            returnexp = returnexp +(DataTable[self._skillInfo._tableId].SkillUpNeedExp)[index];
        end
    end
    return returnexp * 0.8;
end

-- 确定移除
function UITactisDetail:ConfirmRemoveFromHeroBtn()
    CloseWhenUpdate = true;
    local msg = ForGetSkill.new();
    msg:SetMessageId(C2L_Skill.ForGetSkill);
    msg.cardId = self._heroId;
    msg.skillSlot = self._SkillPos;
    local Learnskillinfo = SkillService:Instance():GetSkillByTableID(self._skillInfo._tableId);
    if (Learnskillinfo ~= nil) then
        msg.skillID = Learnskillinfo._id;
    end
    NetService:Instance():SendMessage(msg);
end

-- 点击研究
function UITactisDetail:OnClickResearchBtn()
    local data = { self._skillInfo, self.param }
    UIService:Instance():ShowUI(UIType.UITactisResearch, data)
    -- 下面两行用来隐藏详情和背包界面
    UIService:Instance():HideUI(UIType.UITactisDetail)
    UIService:Instance():HideUI(UIType.UITactis)
    UIService:Instance():HideUI(UIType.UIHeroSpliteHero)
    if UIService:Instance():GetOpenedUI(UIType.UIHeroCardInfo) then
        UIService:Instance():HideUI(UIType.UIHeroCardInfo)
    end
end

-- 点击学习按钮
function UITactisDetail:OnClickLearnSkillBtn()
    local herocard = HeroService:Instance():GetOwnHeroesById(self._heroId);
    if herocard:IsLearnedSkill(self._skillInfo._id) then
        UIService:Instance():ShowUI(UIType.UICueMessageBox, 2402);
        return;
    end
    UIService:Instance():HideUI(UIType.UITactis)
    local army = PlayerService:Instance():GetCardInArmy(self._heroId);
    if (army ~= nil) then
        if (army.armyState ~= ArmyState.None) then
            UIService:Instance():ShowUI(UIType.UICueMessageBox, 2400);
            return
        end
    end
    CloseWhenUpdate = true;
    -- 下边是发送消息的代码
    local msg = LearnSkill.new();
    msg:SetMessageId(C2L_Skill.LearnSkill);
    msg.cardId = self._heroId;
    msg.skillSlot = self._SkillPos;
    msg.skillID = self._skillInfo._id;
    NetService:Instance():SendMessage(msg);
end

-- 点击强化
function UITactisDetail:OnClickStrengSkillBtn()
    CloseWhenUpdate = false;
    if (self._currentExp >= self._needexp) then
        -- 下边是发送消息的代码
        -- self._heroId
        -- self._SkillPos
        local msg = SkillEnhance.new();
        msg:SetMessageId(C2L_Skill.SkillEnhance);
        msg.cardId = self._heroId;
        msg.skillSlot = self._SkillPos;
        NetService:Instance():SendMessage(msg);
    else
        CommonService:Instance():ShowOkOrCancle(self, self.GotoUITactisTransExp, self.Cancle, "确认", "战法经验不足以强化\n去转换战法经验");
    end
end

function UITactisDetail:Cancle()
    -- 空方法保留
end


-- 跳的转换经验
function UITactisDetail:GotoUITactisTransExp()
    UIService:Instance():HideUI(UIType.UIHeroAwake)
    UIService:Instance():HideUI(UIType.UIHeroAdvance)
    UIService:Instance():HideUI(UIType.UIHeroSpliteHero)
    UIService:Instance():ShowUI(UIType.UITactisTransExp);
    UIService:Instance():HideUI(UIType.UITactisDetail);
    UIService:Instance():HideUI(UIType.UIHeroCardInfo);
end

-- 隐藏
function UITactisDetail:OnClickBackBtn()
    UIService:Instance():HideUI(UIType.UITactisDetail);
end

-- 显示特效
function UITactisDetail:ShowEffect()
    EffectsService:Instance():AddEffect(self._StrengthEffect.gameObject, EffectsType.ResearchEffect, 1)

    --    self._StrengthEffect.gameObject:SetActive(true);
    --    Effect = self._StrengthEffect.gameObject;

    --    local ltDescr = Effect.transform:DOScale(Vector3.one, 1)
    --    ltDescr:OnComplete(self, self.ShowEffectOver)
end

---- 显示特效后
-- function UITactisDetail:ShowEffectOver()
--    if (Effect) then
--        Effect.gameObject:SetActive(false);
--    else
--        self._StrengthEffect.gameObject:SetActive(false);
--    end
-- end

return UITactisDetail;