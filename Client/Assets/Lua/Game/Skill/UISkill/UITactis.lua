
local UIBase = require("Game/UI/UIBase")

local UITactis = class("UITactis", UIBase)
local UIService = require("Game/UI/UIService")
local UIType = require("Game/UI/UIType")
local List = require("common/List");
local SkillType = require("Game/Skill/SkillType");
local DataTable = require("Game/Table/model/DataSkill")

function UITactis:ctor()
    UITactis.super.ctor(self)
    self._upGrid = nil
    self._skillNum = nil;
    self._backBtn = nil
    self._splitSkillBtn = nil;
    self._skillTransExpBtn = nil;
    self._SkillExpLabel = nil;
    self._chooseTypeBtn = nil;
    self._chooseTypeLabel = nil;
    self._allSkillBtn = nil;
    self._chooseBgBtn = nil;
    self._skillBtn1 = nil;
    self._skillBtn2 = nil;
    self._skillBtn3 = nil;
    self._skillBtn4 = nil;
    self._skillBtnLabel1 = nil;
    self._skillBtnLabel2 = nil;
    self._skillBtnLabel3 = nil;
    self._skillBtnLabel4 = nil;
    self._choosedObj = nil;
    self._allChooseObj = nil;
    self._skillObjList = List:new();
    self._skillinfoList = List:new();
    self._skillDic = { };
    self._skillTableDic = { }
    self._showChooseBtns = false;
    self._chooseType = 0;
    self._panel = nil;
    self._VerticalLayout = nil;
    self._ContentSizeFitter = nil;
    self._fromHero = false;
    self._fromHeropamp = nil;
end

function UITactis:OnInit()

end

function UITactis:DoDataExchange()
    self._upGrid = self:RegisterController(UnityEngine.Transform, "GridBack/Panel/VerticalLayout/UpGrid")
    self._skillNum = self:RegisterController(UnityEngine.UI.Text, "ChooseTypeBtn/SkillNum");
    self._backBtn = self:RegisterController(UnityEngine.UI.Button, "BackBtn");
    self._splitSkillBtn = self:RegisterController(UnityEngine.UI.Button, "GridBack/Panel/VerticalLayout/UpGrid/SplitSkill/SplitSkillBtn");
    self._spliteText = self:RegisterController(UnityEngine.UI.Text, "GridBack/Panel/VerticalLayout/UpGrid/SplitSkill/SplitSkillBtn/Text");
    self._skillTransExpBtn = self:RegisterController(UnityEngine.UI.Button, "GridBack/Panel/VerticalLayout/UpGrid/SkillTransExp/SkillTransExpBtn");
    self._SkillExpLabel = self:RegisterController(UnityEngine.UI.Text, "GridBack/Panel/VerticalLayout/UpGrid/SkillTransExp/SkillTransExpBtn/Text");
    self._chooseTypeBtn = self:RegisterController(UnityEngine.UI.Button, "ChooseTypeBtn");
    -- self._chooseTypeLabel = self:RegisterController(UnityEngine.UI.Text, "ChooseTypeBtn/Image/Text");
    self._allSkillBtn = self:RegisterController(UnityEngine.UI.Button, "ChooseTypeBtn/AllChooser/AllSkillBtn");
    self._chooseBgBtn = self:RegisterController(UnityEngine.UI.Button, "ChooseTypeBtn/AllChooser/ChooseBgBtn");
    self._skillBtn1 = self:RegisterController(UnityEngine.UI.Button, "ChooseTypeBtn/AllChooser/chooser1");
    self._skillBtn2 = self:RegisterController(UnityEngine.UI.Button, "ChooseTypeBtn/AllChooser/chooser2");
    self._skillBtn3 = self:RegisterController(UnityEngine.UI.Button, "ChooseTypeBtn/AllChooser/chooser3");
    self._skillBtn4 = self:RegisterController(UnityEngine.UI.Button, "ChooseTypeBtn/AllChooser/chooser4");
    self._skillBtnLabel1 = self:RegisterController(UnityEngine.UI.Text, "ChooseTypeBtn/AllChooser/chooser1/ChooserLabel");
    self._skillBtnLabel2 = self:RegisterController(UnityEngine.UI.Text, "ChooseTypeBtn/AllChooser/chooser2/ChooserLabel");
    self._skillBtnLabel3 = self:RegisterController(UnityEngine.UI.Text, "ChooseTypeBtn/AllChooser/chooser3/ChooserLabel");
    self._skillBtnLabel4 = self:RegisterController(UnityEngine.UI.Text, "ChooseTypeBtn/AllChooser/chooser4/ChooserLabel");
    self._choosedObj = self:RegisterController(UnityEngine.Transform, "ChooseTypeBtn/AllChooser/ChoosedObj");
    self._choosedObj1 = self:RegisterController(UnityEngine.Transform, "ChooseTypeBtn/AllChooser/ChoosedObj/ChoosedObj");
    self._allChooseObj = self:RegisterController(UnityEngine.Transform, "ChooseTypeBtn/AllChooser");
    self._panel = self:RegisterController(UnityEngine.RectTransform, "GridBack/Panel");
    self._VerticalLayout = self:RegisterController(UnityEngine.RectTransform, "GridBack/Panel/VerticalLayout");
    self._ContentSizeFitter = self._VerticalLayout.gameObject:GetComponent(typeof(UnityEngine.UI.ContentSizeFitter));
end


function UITactis:DoEventAdd()

    -- self:AddListener(self._btn,self.OnClickBtn);
    self:AddListener(self._backBtn, self.OnClickBackBtn);
    self:AddListener(self._splitSkillBtn, self.OnClickSplitSkillBtn);
    self:AddListener(self._skillTransExpBtn, self.OnClickSkillTrabsExpBtn);
    self:AddListener(self._chooseTypeBtn, self.OnClickChooseBtn);
    self:AddListener(self._allSkillBtn, self.OnClickAllBtn);
    self:AddListener(self._chooseBgBtn, self.OnClickChooseBgBtn);
    self:AddListener(self._skillBtn1, self.OnType1Btn);
    self:AddListener(self._skillBtn2, self.OnType2Btn);
    self:AddListener(self._skillBtn3, self.OnType3Btn);
    self:AddListener(self._skillBtn4, self.OnType4Btn);
end

-- 注册所有的事件
function UITactis:RegisterAllNotice()
    self:RegisterNotice(L2C_Skill.GetOnePlayerSkillListRespond, self.InitSkillInfoList);
    self:RegisterNotice(L2C_Skill.UpdateSkill, self.InitSkillInfoList);
    self:RegisterNotice(L2C_Skill.DeleteOneSkillRespond, self.InitSkillInfoList);
    self:RegisterNotice(L2C_Player.SynchronizeWarfare, self.RefreshExp);
end

function UITactis.OnClickBtn(self)
    -- UIService:Instance():ShowUI(UIType.UITactis);
end

-- 拆解
function UITactis.OnClickSplitSkillBtn(self)
    UIService:Instance():HideUI(UIType.UITactis);
    UIService:Instance():ShowUI(UIType.UIHeroSpliteHero);
end

-- 转换战法经验
function UITactis.OnClickSkillTrabsExpBtn(self)
    UIService:Instance():HideUI(UIType.UITactis);
    SkillService:Instance():SetChangeNum(0)
    UIService:Instance():ShowUI(UIType.UITactisTransExp, true);

end

-- 点击选择背景
function UITactis:OnClickChooseBgBtn()
    self._showChooseBtns = false;
    self._allChooseObj.gameObject:SetActive(self._showChooseBtns);
end

-- 点击选择
function UITactis:OnClickChooseBtn()
    if self._allChooseObj.gameObject.activeSelf == false then
        self._showChooseBtns = true;
        self._allChooseObj.gameObject:SetActive(self._showChooseBtns);
    else
        self._showChooseBtns = false;
        self._allChooseObj.gameObject:SetActive(self._showChooseBtns);
    end

end

-- 点击选择所有
function UITactis:OnClickAllBtn()
    self:OnClickChooseBgBtn();
    self._chooseType = SkillType.All;
    -- self._chooseTypeLabel.text = "全部"
    self._choosedObj1.localPosition = Vector3.zero;
    self._choosedObj.localPosition = self._allSkillBtn.gameObject.transform.localPosition;
    self:InitSkillInfoList();
end

-- 点击选择1
function UITactis:OnType1Btn()
    self:OnClickChooseBgBtn();
    self._chooseType = SkillType.Command;
    -- self._chooseTypeLabel.text = "指挥战法"
    self._choosedObj1.localPosition = Vector3.zero;
    self._choosedObj.localPosition = self._skillBtn1.gameObject.transform.localPosition;
    self:InitSkillInfoList();
end

-- 点击选择2
function UITactis:OnType2Btn()
    self:OnClickChooseBgBtn();
    self._chooseType = SkillType.Active;
    --  self._chooseTypeLabel.text = "主动战法"
    self._choosedObj1.localPosition = Vector3.zero;
    self._choosedObj.localPosition = self._skillBtn2.gameObject.transform.localPosition;
    self:InitSkillInfoList();
end

-- 点击选择3
function UITactis:OnType3Btn()
    self:OnClickChooseBgBtn();
    self._chooseType = SkillType.Pursuit;
    --  self._chooseTypeLabel.text = "追击战法"
    self._choosedObj1.localPosition = Vector3.zero;
    self._choosedObj.localPosition = self._skillBtn3.gameObject.transform.localPosition;
    self:InitSkillInfoList();
end

-- 点击选择4
function UITactis:OnType4Btn()
    self:OnClickChooseBgBtn();
    self._chooseType = SkillType.Passive;
    -- self._chooseTypeLabel.text = "被动战法"
    self._choosedObj1.localPosition = Vector3.zero;
    self._choosedObj.localPosition = self._skillBtn4.gameObject.transform.localPosition;
    self:InitSkillInfoList();
end

function UITactis:OnShow(temp)
    self._fromHeropamp = nil;
    if (temp) then
        self._fromHero = true;
        self._splitSkillBtn.transform.parent.gameObject:SetActive(false);
        self._skillTransExpBtn.transform.parent.gameObject:SetActive(false);
    else
        self._fromHero = false;
        self._splitSkillBtn.transform.parent.gameObject:SetActive(true);
        self._skillTransExpBtn.transform.parent.gameObject:SetActive(true);
    end
    self._fromHeropamp = temp;
    self:OnClickAllBtn();
    self._choosedObj.gameObject:SetActive(true);
    self:RefreshExp();
    self._spliteText.text = SkillService:Instance():GetSkillListSize()
    self._VerticalLayout.gameObject.transform.localPosition = Vector3.zero
end

-- 刷新战法经验
function UITactis:RefreshExp()
    self._SkillExpLabel.text = tostring(PlayerService:Instance():GetCurrencyVarCalcByKey(CurrencyEnum.Warfare):GetValue());
end

-- 初始化列表
function UITactis:InitSkillInfoList()
    self._skillinfoList:Clear();
    local allcount = SkillService:Instance():GetSkillCountByType(SkillType.All);
    local CommandNum = 0;
    local ActiveNum = 0;
    local PursuitNum = 0;
    local PassiveNum = 0;
    for index = 1, allcount do
        local info = SkillService:Instance():GetSkillFromListByIndex(index);
        if (self:JudgeIfCanAddToList(info)) then
            local skilltype = DataTable[info._tableId].Type;
            if (self._chooseType == SkillType.All or self._chooseType == skilltype) then
                self._skillinfoList:Push(info);
            end
            if (skilltype == SkillType.Passive) then
                PassiveNum = PassiveNum + 1;
            end
            if (skilltype == SkillType.Active) then
                ActiveNum = ActiveNum + 1;
            end
            if (skilltype == SkillType.Command) then
                CommandNum = CommandNum + 1;
            end
            if (skilltype == SkillType.Pursuit) then
                PursuitNum = PursuitNum + 1;
            end
        end
    end
    self:RefreshSkillIconGrid();
    self._skillNum.text = tostring(self._skillinfoList:Count());
    self._spliteText.text = tostring(self._skillinfoList:Count())
    self._skillBtnLabel1.text = "指挥战法" .. CommandNum;
    self._skillBtnLabel2.text = "主动战法" .. ActiveNum;
    self._skillBtnLabel3.text = "追击战法" .. PursuitNum;
    self._skillBtnLabel4.text = "被动战法" .. PassiveNum;

end

-- 判断是否要满足要求
function UITactis:JudgeIfCanAddToList(info)
    if (self._fromHero) then
        if (info._progress >= 10000) then
            return true;
        else
            return false;
        end
    else
        return true;
    end
    return false;
end

-- 刷新战法图标列表
function UITactis:RefreshSkillIconGrid()
    self:SetAllFalse();
    local count = self._skillinfoList:Count();
    for index = 1, count do
        local UISkillIcon = self._skillObjList:Get(index);
        if (UISkillIcon == nil) then
            self:AddChild(index);
        else
            UISkillIcon.gameObject:SetActive(true);
            UISkillIcon:Init()
            local skillinfo = self._skillinfoList:Get(index);
            if (skillinfo ~= nil) then
                UISkillIcon:SetSkillInfo(skillinfo)
                UISkillIcon:SetfromHero(self._fromHero, self._fromHeropamp);
                local CanLearnskillinfo = SkillService:Instance():GetCanLearnedSkill();
                if (CanLearnskillinfo and skillinfo == CanLearnskillinfo) then
                    -- UISkillIcon:ShowEffect();
                    UIService:Instance():HideUI(UIType.UITactisDetail)
                    UIService:Instance():ShowUI(UIType.TactisResearchSuccessful, skillinfo)
                    SkillService:Instance():SetCanLearnedSkill();
                    CanLearnskillinfo = nil;
                end
            end
            self._skillDic[index] = UISkillIcon;
            self._skillTableDic[self._skillinfoList:Get(index)._tableId] = UISkillIcon
        end
    end
    self:SetHeight();
end

-- 设置高度
function UITactis:SetHeight()

    self._ContentSizeFitter.enabled = true;
    local parentheight = self._panel.rect.height;
    if (self._VerticalLayout.sizeDelta.y <= parentheight) then
        self._ContentSizeFitter.enabled = true;
        local wide = self._VerticalLayout.sizeDelta.x;
        self._VerticalLayout.sizeDelta = Vector2.New(wide, self._skillObjList:Count() / 8 * 170);
    end
    local transformRect = self._VerticalLayout.rect.height;
    self._VerticalLayout.gameObject.transform.localPosition = Vector3.zero
end

-- 隐藏所有
function UITactis:SetAllFalse()
    for k, v in pairs(self._skillObjList._list) do
        if (v.gameObject.activeSelf == true) then
            v.gameObject:SetActive(false);
        end
    end
end

-- 添加并初始化
function UITactis:AddChild(index)
    local UISkillIcon = require("Game/Skill/UISkill/UISkillIcon").new();
    GameResFactory.Instance():GetUIPrefab("UIPrefab/SkillIcon", self._upGrid, UISkillIcon, function(go)
        UISkillIcon:Init()
        UISkillIcon:SetSkillInfo(self._skillinfoList:Get(index))
        UISkillIcon:SetfromHero(self._fromHero, self._fromHeropamp);
        self._skillObjList:Push(UISkillIcon);
        self._skillDic[index] = UISkillIcon;
        self._skillTableDic[self._skillinfoList:Get(index)._tableId] = UISkillIcon
    end );
end


--返回时获取最新变化的技能
function UITactis:GetLastChangeSkill(id)
    return self._skillTableDic[id]:GetSkillInfo()
end


-- 点击返回按键按钮
function UITactis:OnClickBackBtn()
    UIService:Instance():HideUI(UIType.UITactis);

    if (self._fromHero == false) and UIService:Instance():GetOpenedUI(UIType.ArmyFunctionUI) == false then
        UIService:Instance():ShowUI(UIType.UIGameMainView);
    end
    if self._fromHero then
        SkillService:Instance():ReturnRememberID()
    end
end

return UITactis;
