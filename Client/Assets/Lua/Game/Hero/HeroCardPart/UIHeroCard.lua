-- Anchor:Dr
-- Date: 16/9/13
-- 英雄卡牌

local UIBase = require("Game/UI/UIBase");
local UIHeroCard = class("UIHeroCard", UIBase);
local DataHero = require("Game/Table/model/DataHero");
local HeroHandbookCard = require("Game/Hero/HeroCardPart/HeroHandbookCard");
local NoHeroPic = "dead_herocardhalf7";
local HeroCard = require("Game/Hero/HeroCardPart/HeroCard");
local Istate = "March13";
local Ostate = "March14";
local ArmyType = require("Game/Hero/HeroCardPart/ArmyType")
local CampType = require("Game/Hero/HeroCardPart/CampType");
function UIHeroCard:ctor()
    UIHeroCard.super.ctor(self);

    self._heroNameText = nil;
    -- 英雄名字
    self._heroLevelText = nil;
    -- 英雄等级
    self._heroCostText = nil;
    -- 英雄cost
    self._buttonOrClick = false;

    self.conscriptionTimeText = nil;
    -- 征兵剩余时间
    self.addSoliderObj = nil;
    self.conscriptingSoliderText = nil;
    self.heroHurt = nil;
    -- 重伤
    self.heroTired = nil;
    -- 疲劳
    self.RecoverTimetext = nil;
    -- 重伤时间
    self.tiredTimeText = nil;
    -- 疲劳时间

    self._heroSoldierType = nil;
    -- 英雄兵种类型
    self._heroIconSprite = nil;
    -- 英雄icon图片
    self._heroAttackDisText = nil;
    -- 英雄攻击距离
    self._heroSoldiersText = nil;
    -- 英雄兵数
    self._heroBelongText = nil;
    -- 英雄所属城市
    self._heroInArmy = nil;
    self.hurtTiredText = nil;
    -- 英雄是否在部队中
    self._campParent = nil;
    -- 英雄所属大阵营(如:魏/蜀/吴)
    self.canshow = nil;
    self._heroYellowStarObj = nil;
    -- 英雄星级
    self._heroRedStarObj = nil;
    -- 英雄进阶星级(红星)
    self._heroAwakeSprite = nil;

    self.stateImage = nil;
    -- 英雄是否觉醒
    self._heroAddPointSprite = nil;
    -- 英雄是否能加点属性
    self._heroBtn = nil;
    -- 武将点击按钮
    self._heroClick = nil;
    self._TransparentBg = nil;

    self.heroCard = nil;
    -- 卡牌数据 HeroCard
    self._heroId = 0;
    -- 英雄id
    self.tableID = 0;
    self.BackGround = nil
    self._transExpStar = 0;
    self.EffectPos = nil;

    self.GeneralsImage = nil;
end

-- override
function UIHeroCard:DoDataExchange()
    self._heroNameText = self:RegisterController(UnityEngine.UI.Text, "HeroNameText");
    self._heroCostText = self:RegisterController(UnityEngine.UI.Text, "Cost/CostValue");
    self.conscriptionTimeText = self:RegisterController(UnityEngine.UI.Text, "ConscriptionTimeText");
    self.addSoliderObj = self:RegisterController(UnityEngine.Transform, "ConscriptionTimeText/AddSoliderObj");
    self.conscriptingSoliderText = self:RegisterController(UnityEngine.UI.Text, "ConscriptionTimeText/AddSoliderObj/ConscriptingSoliderText");

    self._heroAttackDisText = self:RegisterController(UnityEngine.UI.Text, "DistanceText");
    self._campParent = self:RegisterController(UnityEngine.Transform, "StateFormImage");
    self._heroSoldierType = self:RegisterController(UnityEngine.Transform, "SoldierType");
    self._heroLevelText = self:RegisterController(UnityEngine.UI.Text, "GradeText/Text");
    self._heroSoldiersText = self:RegisterController(UnityEngine.UI.Text, "NumberImage/BackGround/TroopsText");
    self.BackGround = self:RegisterController(UnityEngine.Transform, "NumberImage/BackGround");
    self._heroIconSprite = self:RegisterController(UnityEngine.UI.Image, "HeroHeadImage");
    self._heroYellowStarObj = self:RegisterController(UnityEngine.Transform, "StarImage/YellowStar");
    self._heroRedStarObj = self:RegisterController(UnityEngine.Transform, "StarImage/RedStar");
    self._heroBtn = self:RegisterController(UnityEngine.UI.Button, "HeroBtn");
    self._heroClick = self:RegisterController(UnityEngine.Transform, "HeroClick");
    self._Image = self:RegisterController(UnityEngine.UI.Image, "StatusText/Image");
    self._heroInArmy = self:RegisterController(UnityEngine.UI.Text, "StatusText/StateText");
    self.hurtTiredText = self:RegisterController(UnityEngine.UI.Text, "StatusText/HurtTiredText");
    self._heroBelongText = self:RegisterController(UnityEngine.UI.Text, "StatusText/NameText");
    self._heroAwakeSprite = self:RegisterController(UnityEngine.UI.Image, "AwakenImage/AwakenImage");
    self._heroAddPointSprite = self:RegisterController(UnityEngine.Transform, "AwakenImage/AddPoint");

    self.RecoverTimetext = self:RegisterController(UnityEngine.UI.Text, "RecoverTimetext");
    self.heroHurt = self:RegisterController(UnityEngine.UI.Text, "StatusText/heroHurt");
    self.heroTired = self:RegisterController(UnityEngine.UI.Text, "StatusText/heroTired");
    self.tiredTimeText = self:RegisterController(UnityEngine.UI.Text, "TiredTimeText");
    self.stateImage = self:RegisterController(UnityEngine.UI.Image, "StatusText/StateText/Image");
    self._TransExpText = self:RegisterController(UnityEngine.Transform, "Panel");
    self._Image_Tactics = self:RegisterController(UnityEngine.Transform, "Tactics");
    self._Text_Tactics = self:RegisterController(UnityEngine.Transform,"Panel/HadTurned");
    self._TransparentBg = self:RegisterController(UnityEngine.Transform, "TransparentBg");
    self.EffectPos = self:RegisterController(UnityEngine.Transform,"EffectPos");
    -- 状态text先默认隐藏
    self._heroInArmy.gameObject:SetActive(false);
    self._Image.gameObject:SetActive(false);

    self._heroBelongText.gameObject:SetActive(false);
    self._TransExpText.gameObject:SetActive(false);
    self._Image_Tactics.gameObject:SetActive(false);

    self.GeneralsImage = self:RegisterController(UnityEngine.UI.Image,"HeroHeadImage/Image/Image");
end 

-- override
function UIHeroCard:DoEventAdd()
    self:AddListener(self._heroBtn, self.OnClickHeroBtn);
    self:AddOnClick(self._heroClick.gameObject.transform, self.OnClickHeroBtn)
end


function UIHeroCard:OnShow()
    self.transform.localScale = Vector3.one
    self._Image.gameObject:SetActive(false);
    self._heroInArmy.gameObject:SetActive(false);
end

function UIHeroCard:SetTransparentBg(show)
    self._TransparentBg.gameObject:SetActive(show);
end

-- 设置点击按钮和点击控件
function UIHeroCard:SetClickModel(_Clickbool)
    self._buttonOrClick = _Clickbool
end

-- 招募出来的卡牌 参数为卡牌id 卡牌lv
function UIHeroCard:SetRecruitHeroCard(heroid, tabelid, herolv,index)
    self:SetTransExpEffect(false);
    local mmHerocard = DataHero[tabelid]
    local HeroHandbookCard = HeroCard.new();
    if heroid ~= nil then
        -- print("CameIn     ".. heroid);
        HeroHandbookCard.id = heroid;
    end
    HeroHandbookCard.tableID = mmHerocard.ID;
    HeroHandbookCard.level = herolv;
    HeroHandbookCard.star = mmHerocard.Star;
    -- HeroHandbookCard.attack = mmHerocard.AttackBase;
    -- HeroHandbookCard.def = mmHerocard.DefenseBase;
    -- HeroHandbookCard.strategy = mmHerocard.SpiritBase;
    -- HeroHandbookCard.speed = mmHerocard.SpeedBase;
    HeroHandbookCard.allSkillSlotList[1] = mmHerocard.SkillOriginalID;
    HeroHandbookCard.allSkillSlotList[2] = 0
    HeroHandbookCard.allSkillSlotList[3] = 0
    HeroHandbookCard.allSkillLevelList[1] = 1
    HeroHandbookCard.allSkillLevelList[2] = 1
    HeroHandbookCard.allSkillLevelList[3] = 1
    HeroHandbookCard:InitPower(100);
    HeroHandbookCard.exp = 0;
    HeroHandbookCard.point = math.floor(herolv/10)*10;
    HeroHandbookCard.troop = 100;
    if (HeroHandbookCard) then
        if RecruitService:Instance():GetIsTransToExp() == true then
            if mmHerocard.Star <= RecruitService:Instance():GetTransUnderStarNum() and heroid == 0 then
                self:SetTransExpEffect(true);
                self:SetHeroCardMessage(HeroHandbookCard, false);
            else
                self:SetTransExpEffect(false);
                self:SetHeroCardMessage(HeroHandbookCard, true);
            end
        else
            self:SetTransExpEffect(false);
            self:SetHeroCardMessage(HeroHandbookCard, true);
        end
    end    
end

function UIHeroCard:JudgeTransExp(star)
    -- body
    self._transExpStar = star;
end

function UIHeroCard:SetTransExpEffect(value)
    -- body
     if Timer1~= nil then
            Timer1:Stop();
        end
    local UIBase = UIService:Instance():GetUIClass(UIType.UIRecruitUI);
    local endPos = nil;
    if UIBase ~= nil then
        endPos = Vector3.New(UIBase.powerImage.position.x, UIBase.powerImage.position.y, 0)
    end
    local time = 0.3;
    self._TransExpText.gameObject:SetActive(false);
    local Timer1 = Timer.New( function()
        self._TransExpText.gameObject:SetActive(value);      
        -- print(value) ;
        self._Image_Tactics.gameObject:SetActive(value);
        self._Text_Tactics.gameObject.transform.localScale = Vector3.New(3,3,0)
        -- self._Image_Tactics.gameObject.transform.parent = nil;
        local ltDescr = self._Text_Tactics.gameObject.transform:DOScale(Vector3.one, time)
        self._Image_Tactics.gameObject.transform.localPosition = UnityEngine.Vector3.zero;
        self._Image_Tactics.gameObject.transform.localScale = UnityEngine.Vector3.one;
        -- print(endPos.x,"     ",endPos.y);
        local beforeEffect = self._Image_Tactics:DOScale(UnityEngine.Vector3.one,time)
        beforeEffect:OnComplete(self._Image_Tactics,function ()
            -- body
            local effect = self._Image_Tactics:DOMove(endPos, 0.5)
            self._Image_Tactics:DOScale(Vector3.zero,0.5)
            effect:OnComplete(self._Image_Tactics,function ()
            -- body
            self._Image_Tactics.gameObject:SetActive(false);
        end)
        end)

        
       if Timer1~= nil then
            Timer1:Stop();
        end
    end , time, 1, false
    )
    Timer1:Start();
end



-- 设置英雄卡牌信息
function UIHeroCard:SetHeroCardMessage(mOwnHero, canShow)
    self.hero = mOwnHero;
    self.canshow = canShow;

    -- 点击OR按钮
    self:ButtonOrClick();

    if mOwnHero == nil then
        return;
    else
        if DataHero[mOwnHero.tableID] == nil then
            return;
        end
    end

    self.heroCard = mOwnHero;
    self._heroId = mOwnHero.id;

    -- 静态
    local mHero = DataHero[mOwnHero.tableID]
    if mHero == nil then
        return;
    end
    
    local pic = mHero.PicInterceptCoordinate
    local picX = pic[1]
    local picY = pic[2]
    self.GeneralsImage.transform.localPosition = Vector3.New(picX,picY,0);
    self.GeneralsImage.sprite = GameResFactory.Instance():GetResSprite(mHero.LengthPortrait);

    self._heroNameText.text = mHero.Name;
    self._heroCostText.text = mHero.Cost;
    self._heroAttackDisText.text = mHero.AttackRange;
    -- 设置英雄卡牌阵营
    self:SetCamp(mHero.Camp);
    -- 设置兵种类型
    self:SetSoldierType(mHero.BaseArmyType);

    -- 动态
    self._heroLevelText.text = mOwnHero.level;
    local isInArmy = PlayerService:Instance():CheckCardInArmy(mOwnHero.id);
    if isInArmy == false then
        self._heroSoldiersText.text = "-"
    else
        self._heroSoldiersText.text = mOwnHero.troop;
    end

    -- 设置星级
    self:SetStar(mHero.Star, mOwnHero.advancedTime);

    self:SetIfChecked(false);
    -- 是否觉醒
    if mOwnHero.isAwaken then
        self._heroAwakeSprite.gameObject:SetActive(true)
    else
        self._heroAwakeSprite.gameObject:SetActive(false)
    end
end


-- 设定是不是被选中 
function UIHeroCard:SetIfChecked(temp)

end

function UIHeroCard:SetStatePicFalse()
    self.stateImage.gameObject:SetActive(false)
end


function UIHeroCard:CanShowRedPoint()
    -- 能否加点
    if self.hero == nil then
        return
    end
    if self.hero.point > 0 or self:CanAdvance(self.hero) then
        self._heroAddPointSprite.gameObject:SetActive(true)
    else
        self._heroAddPointSprite.gameObject:SetActive(false)
    end

    if UIService:Instance():GetOpenedUI(UIType.UIRecruitUI) then
        self._heroAddPointSprite.gameObject:SetActive(false)
    end
end

function UIHeroCard:CanAdvance(hero)
    if hero.advancedTime == hero.star then
        return false
    end
    local count = HeroService:Instance():GetOwnHeroCount()
    for i = 1, count do
        if HeroService:Instance():GetOwnHeroes(i).tableID == hero.tableID and HeroService:Instance():GetOwnHeroes(i).id ~= hero.id then
            return true
        end
    end
    return false
end


-- 设置征兵时间
function UIHeroCard:SetConscrtptionState(armyInfo, armyAlotType, isConscripting, endTime)
    -- print("设置征兵时间")
    local armySlotIndex = armyInfo.spawnSlotIndex;
    if isConscripting == false then
        self.conscriptionTimeText.gameObject:SetActive(false);
        self.addSoliderObj.gameObject:SetActive(false);
    else
        self.conscriptionTimeText.gameObject:SetActive(true);
        self.addSoliderObj.gameObject:SetActive(true);
        self.conscriptingSoliderText.text = "<color=#FFFFFF>" .. armyInfo:GetIndexSoldierCount(armyAlotType) .. "</color><color=#FFFF00>+" .. armyInfo:GetConscriptionCount(armyAlotType) .. "</color>";
        local curTimeStamp = PlayerService:Instance():GetLocalTime();
        local valueTime = math.ceil(endTime - curTimeStamp);
        if valueTime <= 0 then
            valueTime = 0;
        end
        local cdTime = math.floor(valueTime / 1000)
        self.conscriptionTimeText.text = CommonService:Instance():GetDateString(cdTime);
        CommonService:Instance():TimeDown(UIType.ArmyFunctionUI,endTime, self.conscriptionTimeText, function() self:ConscriptionTimersEnds() end);
    end
end

-- 设置卡牌重伤状态
function UIHeroCard:HeroHurt(armySlotIndex, isHurt)
    if self.heroCard ~= nil then
        if isHurt == true then
            self.heroHurt.text = "重伤";
            self.heroHurt.gameObject:SetActive(true)
            self.RecoverTimetext.gameObject:SetActive(true)

            local Retime = self.heroCard.RecoverTime - PlayerService:Instance():GetLocalTime();
            local cdTime = math.floor(Retime / 1000)
            if cdTime <= 0 then
                cdTime = 0;
            end
            self.RecoverTimetext.text = CommonService:Instance():GetDateString(cdTime);
            CommonService:Instance():TimeDown(UIType.ArmyFunctionUI,self.heroCard.RecoverTime, self.RecoverTimetext, function() self:HurtTimersEnds(armySlotIndex) end);
        else
            self.heroHurt.gameObject:SetActive(false)
            self.RecoverTimetext.gameObject:SetActive(false)
        end
    end
end

-- 设置卡牌疲劳状态
function UIHeroCard:HeroTired(armySlotIndex, isTired)
    if self.heroCard ~= nil then
        if isTired == true then
            self.heroTired.gameObject:SetActive(true)
            self.heroTired.text = "疲劳";
            self.tiredTimeText.gameObject:SetActive(true);
            local needTime = self.heroCard.TiredTime - PlayerService:Instance():GetLocalTime();
            local cdTime = math.floor(needTime / 1000)
            if cdTime <= 0 then
                cdTime = 0;
            end
            self.tiredTimeText.text = CommonService:Instance():GetDateString(cdTime);
            CommonService:Instance():TimeDown(UIType.ArmyFunctionUI,self.heroCard.TiredTime, self.tiredTimeText, function() self:TiredTimersEnds() end);
        else
            self.heroTired.gameObject:SetActive(false);
            self.tiredTimeText.gameObject:SetActive(false);
        end
    end
end

-- 疲劳倒计时结束回调
function UIHeroCard:TiredTimersEnds()
    self.heroTired.gameObject:SetActive(false)
    self.tiredTimeText.gameObject:SetActive(false)
end

-- 征兵倒计时结束回调
function UIHeroCard:ConscriptionTimersEnds()
    self.conscriptionTimeText.gameObject:SetActive(false);
end

-- 重伤倒计时结束回调
function UIHeroCard:HurtTimersEnds(armySlotIndex)
    self.heroHurt.gameObject:SetActive(false)
    self.RecoverTimetext.gameObject:SetActive(false)
end

-- 英雄是否在部队中 
function UIHeroCard:SetHeroInArmy(heroCard)
    if heroCard == nil then
        return
    end
    local isInArmy = PlayerService:Instance():CheckCardInArmy(heroCard.id);
    if isInArmy then
        self._Image.gameObject:SetActive(true);
        self._heroInArmy.gameObject:SetActive(true);
        self._heroInArmy.text = "部队中"
        self.stateImage.gameObject:SetActive(true)
        self.stateImage.sprite = GameResFactory.Instance():GetResSprite(Istate);
    else
        local baseClass = UIService:Instance():GetUIClass(UIType.ArmyFunctionUI);
        local isOpen =  UIService:Instance():GetOpenedUI(UIType.ArmyFunctionUI);
        if baseClass ~= nil and isOpen == true then
            if heroCard.RecoverTime > 0 then
                 self.hurtTiredText.gameObject:SetActive(true);
                 self.hurtTiredText.text = "重伤";
            elseif heroCard.TiredTime > 0 then
                 self.hurtTiredText.gameObject:SetActive(true);
                 self.hurtTiredText.text = "疲劳";
            end
        else
            self.hurtTiredText.gameObject:SetActive(false);
            self._heroInArmy.text = "";
            self._Image.gameObject:SetActive(false);
            self.stateImage.gameObject:SetActive(false)
        end
    end
end

function UIHeroCard:HeroCardState(heroCard)
    if (SkillService:Instance():GetIfChooseList(heroCard)) then
        self:SetChooseState();
        return;
    end
    if self._heroInArmy.text ~= "部队中" then
        self.stateImage.gameObject:SetActive(true)
        if heroCard.isProtect then
            self._Image.gameObject:SetActive(true);
            self._heroInArmy.gameObject:SetActive(true);
            self._heroInArmy.text = "被保护"
            self.stateImage.sprite = GameResFactory.Instance():GetResSprite(Istate);
        elseif heroCard.isAwaken then
            self._Image.gameObject:SetActive(true);
            self._heroInArmy.gameObject:SetActive(true);
            self._heroInArmy.text = "已觉醒"
            self.stateImage.sprite = GameResFactory.Instance():GetResSprite(Istate);
        elseif heroCard.advancedTime > 0 then
            self._Image.gameObject:SetActive(true);
            self._heroInArmy.gameObject:SetActive(true);
            self._heroInArmy.text = "已进阶"
            self.stateImage.sprite = GameResFactory.Instance():GetResSprite(Istate);
        elseif heroCard.allSkillSlotList[2] ~= 0 then
            self._Image.gameObject:SetActive(true);
            self._heroInArmy.gameObject:SetActive(true);
            self._heroInArmy.text = "已学习"
            self.stateImage.sprite = GameResFactory.Instance():GetResSprite(Istate);
        elseif heroCard.allSkillLevelList[1] > 1 then
            self._Image.gameObject:SetActive(true);
            self._heroInArmy.gameObject:SetActive(true);
            self._heroInArmy.text = "已强化"
            self.stateImage.sprite = GameResFactory.Instance():GetResSprite(Istate);
        elseif DataHero[heroCard.tableID].Star > 3 then
            self._Image.gameObject:SetActive(true);
            self._heroInArmy.gameObject:SetActive(true);
            self._heroInArmy.text = "稀有"
            self.stateImage.sprite = GameResFactory.Instance():GetResSprite(Istate);
        elseif heroCard.level > 1 then
            self._Image.gameObject:SetActive(true);
            self._heroInArmy.gameObject:SetActive(true);
            self._heroInArmy.text = "已升级"
            self.stateImage.sprite = GameResFactory.Instance():GetResSprite(Istate);
        else
            self._heroInArmy.text = ""
            self._Image.gameObject:SetActive(false);
            self.stateImage.gameObject:SetActive(false)

        end
    end

end



-- 设置选中状态
function UIHeroCard:SetChooseState()
    self._Image.gameObject:SetActive(true);
    self._heroInArmy.gameObject:SetActive(true);
    self._heroInArmy.text = "已选定"
    self.stateImage.gameObject:SetActive(true)
    self.stateImage.sprite = GameResFactory.Instance():GetResSprite(Ostate);
end

function UIHeroCard:HeroCardStateNil()
    if self._heroInArmy.text ~= "部队中" then
        self._heroInArmy.text = ""
        self._Image.gameObject:SetActive(false);
        self.stateImage.gameObject:SetActive(false)

    end
end

-- 显示所属城市
-- curBuildingId： 部队配置界面传的当前城市id，非当前城市的显示城市名字
function UIHeroCard:SetHeroBelongsCityName(heroCard, curBuildingId)
    if heroCard == nil then
        return
    end
    local isInArmy = PlayerService:Instance():CheckCardInArmy(heroCard.id);
    if isInArmy then
        self._heroBelongText.gameObject:SetActive(true);
        local building = PlayerService:Instance():GetCardBuilding(heroCard.id);
        if curBuildingId ~= nil then
            if building._id ~= curBuildingId then
                self._heroBelongText.text = building._name;
            else
                self._heroBelongText.gameObject:SetActive(false);
            end
        else
            self._heroBelongText.text = building._name;
        end
    else
        self._heroBelongText.gameObject:SetActive(false);
    end
end

function UIHeroCard:SetPic(bool)
    if bool then
        self.GeneralsImage.sprite = GameResFactory.Instance():GetResSprite(DataHero[self.hero.tableID].LengthPortrait);
    else
        self.GeneralsImage.sprite = GameResFactory.Instance():GetResSprite(NoHeroPic);
    end
end

function UIHeroCard:SetCardAlpha(bool)
--    local mImages = self.gameObject:GetComponentsInChildren(typeof(UnityEngine.UI.Image));
--    local Images = mImages:ToTable()
--    if bool then
--        for k, v in pairs(Images) do
--            if v.gameObject ~= self._heroBtn.gameObject and v.gameObject ~= self.BackGround.gameObject then
--                v.color = Color.New(1, 1, 1, 1)
--            end
--        end
--    else
--        for k, v in pairs(Images) do
--            if v.gameObject ~= self._heroBtn.gameObject and v.gameObject ~= self.BackGround.gameObject then
--                v.color = Color.New(1, 1, 1, 0.5)
--            end
--        end
--    end
    self:SetTransparentBg(bool == false and true or false);
end


-- 设置阵营
function UIHeroCard:SetUIHeroCardCamp(mCampStr)

    local childeIndex = -1;
    if mCampStr == CampType.Qin then
        childeIndex = 0;
    elseif mCampStr == CampType.Janpan then
        childeIndex = 1;
    elseif mCampStr == CampType.Europe then
        childeIndex = 2;
    elseif mCampStr == CampType.Viking then
        childeIndex = 3;
    else
        -- ----print("Can not find Camp");
        return;
    end
    self:ShowChild(childeIndex, self._campParent.transform);

end

-- 设置兵种
function UIHeroCard:SetSoldierType(mSoldierType)

    local childeIndex = -1;
    if mSoldierType == ArmyType.Qi then
        childeIndex = 0;
    elseif mSoldierType == ArmyType.Gong then
        childeIndex = 1;
    elseif mSoldierType == ArmyType.Bu then
        childeIndex = 2;
    else
        -- ----print("Can not find SoldierType");
        return;
    end
    self:ShowChild(childeIndex, self._heroSoldierType.transform);
end

-- 设置英雄星级
function UIHeroCard:SetStar(mYellowStar, mRedStar)
    self:SetYellowStar(mYellowStar);
    self:SetRedStar(mYellowStar, mRedStar);
end

-- 设置英雄黄色星级
function UIHeroCard:SetYellowStar(mstar)

    local yellowTran = self._heroYellowStarObj.transform;

    if yellowTran == nil then
        return;
    end

    for i = 1, yellowTran.childCount do
        local tran = yellowTran:GetChild(i - 1);
        if (i - 1) < mstar then
            tran.gameObject:SetActive(true);
        else
            tran.gameObject:SetActive(false);
        end

    end
end

-- 设置英雄红色星级
function UIHeroCard:SetRedStar(mYellowStar, mRedStar)
    local redTran = self._heroRedStarObj.transform;
    if redTran == nil then
        return;
    end
    for i = 1, redTran.childCount do
        local tran = redTran:GetChild(i - 1);
        tran.gameObject:SetActive(false)
    end
    for i = 1, mRedStar do
        local tran = redTran:GetChild(i - 1);
        tran.gameObject:SetActive(true)
    end
end


-- 设置子物体下的某一个显示
function UIHeroCard:ShowChild(mChildIndex, mTransform)

    if mTransform == nil or mChildIndex < 0 then
        -- ----print("transform is nil or childindex<0");
        return;
    end

    local tranParent = mTransform;
    tranParent.gameObject:SetActive(true);


    for i = 1, tranParent.childCount do
        local tran = tranParent:GetChild(i - 1);
        if (i - 1) == mChildIndex then
            tran.gameObject:SetActive(true);
        else
            tran.gameObject:SetActive(false);
        end

    end
end


-- 设置阵营
function UIHeroCard:SetCamp(mCamp)

    local tranParent = self._campParent.transform;
    tranParent.gameObject:SetActive(true);


    for i = 1, tranParent.childCount do
        if i == mCamp then
            tranParent:GetChild(i - 1).gameObject:SetActive(true);
        else
            tranParent:GetChild(i - 1).gameObject:SetActive(false);
        end

    end

end

function UIHeroCard:SetHeroCardBtnTrue()
    self._heroBtn.gameObject:SetActive(true)
end
function UIHeroCard:ButtonOrClick()
    if self._buttonOrClick then
        self._heroBtn.gameObject:SetActive(true)
        self._heroClick.gameObject:SetActive(false)
    else
        self._heroBtn.gameObject:SetActive(false)
        self._heroClick.gameObject:SetActive(false)
    end
end

-- 点击英雄
function UIHeroCard:OnClickHeroBtn()
    -- print(self.hero.id)
    local data = { self.hero, self.canshow };
    UIService:Instance():ShowUI(UIType.UIHeroCardInfo, data)

    local baseHandBookClass = UIService:Instance():GetUIClass(UIType.UIHeroHandbook)
    if baseHandBookClass ~= nil then
        baseHandBookClass:HideSortMenu()
    end
    local basePackageClass = UIService:Instance():GetUIClass(UIType.UIHeroCardPackage)
    if basePackageClass ~= nil then
        basePackageClass:HideSortMenu()
    end
end

function UIHeroCard:Insert2List(mmHerocard)
    mmHerocard = DataHero[mmHerocard]
    local HeroHandbookCard = HeroHandbookCard.new();
    HeroHandbookCard.tableID = mmHerocard.ID;
    HeroHandbookCard.exp = 0;
    HeroHandbookCard.advancedTime = 0;
    HeroHandbookCard.power = 0;
    HeroHandbookCard.troop = 0;
    HeroHandbookCard.point = 0;
    HeroHandbookCard.level = 1
    HeroHandbookCard.attack = mmHerocard.AttackBase;
    HeroHandbookCard.def = mmHerocard.DefenseBase;
    HeroHandbookCard.strategy = mmHerocard.SpiritBase;
    HeroHandbookCard.speed = mmHerocard.SpeedBase;
    HeroHandbookCard.allSkillSlotList[1] = mmHerocard.SkillOriginalID;
    HeroHandbookCard.allSkillSlotList[2] = 0
    HeroHandbookCard.allSkillSlotList[3] = 0
    HeroHandbookCard.allSkillLevelList[1] = 1
    HeroHandbookCard.allSkillLevelList[2] = 1
    HeroHandbookCard.allSkillLevelList[3] = 1
    HeroHandbookCard.lastResetPointTime = 0;
    HeroHandbookCard.lastResetCardTime = 0;
    return HeroHandbookCard
end

function UIHeroCard:SetHeroHandbookCardMessage(mOwnHero)
    if mOwnHero == nil or DataHero[mOwnHero.ID] == nil then
        return;
    end
    self.hero = self:Insert2List(mOwnHero.ID)
    self.canshow = false
    self._heroId = mOwnHero.ID
    -- 静态
    local mHero = DataHero[mOwnHero.ID];
    local pic = mHero.PicInterceptCoordinate
    local picX = pic[1]
    local picY = pic[2]
    self.GeneralsImage.transform.localPosition = Vector3.New(picX,picY,0);
    self.GeneralsImage.sprite = GameResFactory.Instance():GetResSprite(mHero.LengthPortrait);
    self._heroNameText.text = mHero.Name;
    self._heroCostText.text = mHero.Cost;
    self._heroAttackDisText.text = mHero.AttackRange;
    self:SetCamp(mHero.Camp);
    self:SetSoldierType(mHero.BaseArmyType);
    self._heroLevelText.text = 1;
    self:SetStar(mHero.Star, 0);
    -- self._heroInArmy.gameObject:SetActive(false)
    self._heroBelongText.gameObject.gameObject:SetActive(false)
    self._heroAddPointSprite.gameObject:SetActive(false)
    self._heroAwakeSprite.gameObject:SetActive(false)
    self.conscriptionTimeText.gameObject:SetActive(false)
    self:ButtonOrClick()
end

return UIHeroCard;

-- endregion