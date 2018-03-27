--[[城池卡牌]]--
local UIBase= require("Game/UI/UIBase");
local UICityCard=class("UICityCard",UIBase);        
local UIService=require("Game/UI/UIService");
local UIType=require("Game/UI/UIType");
local DataHero = require("Game/Table/model/DataHero");
local ArmyManage = require("Game/Army/ArmyManage");


--构造函数
function UICityCard:ctor()
    UICityCard.super.ctor(self);
    -- 武将等级
    self._gradeText = nil;
    -- 兵种
    self._cavalry = nil;
    -- 攻击距离
    self._distanceText = nil;
    -- 武将名字
    self._cardText = nil;
    -- red星
    self._redStar = nil;
    -- yellow星
    self._yellowStar = nil;
    self._yellowStar1 = nil;
    self._yellowStar2 = nil;
    self._yellowStar3 = nil;
    self._yellowStar4 = nil;
    -- 排序
    self._indexText = nil;
    -- 背景图
    self.cardBackground = nil;

    self.mStarList = { };
     -- 保存部队信息及当前大营英雄卡信息
    self.mCurArmyInfo = nil;
    self.mCurHeroCard = nil;
    -- 兵力
    self._troopText = nil;
    -- 部队状态
    self._stateText = nil;

end

function UICityCard:DoDataExchange()
	self._gradeText = self:RegisterController(UnityEngine.UI.Text,"card/grade/gradeText");
	self._cavalry = self:RegisterController(UnityEngine.UI.Image,"card/corps/cavalry");
	self._distanceText = self:RegisterController(UnityEngine.UI.Text,"card/corps/cavalry/distanceText");
	self._cardText = self:RegisterController(UnityEngine.UI.Text,"card1/cardText");
	self._yellowStar = self:RegisterController(UnityEngine.UI.Image,"card1/yellowStar/yellow1");
	self._yellowStar1 = self:RegisterController(UnityEngine.UI.Image,"card1/yellowStar/yellow2");
	self._yellowStar2 = self:RegisterController(UnityEngine.UI.Image,"card1/yellowStar/yellow3");
	self._yellowStar3 = self:RegisterController(UnityEngine.UI.Image,"card1/yellowStar/yellow4");
	self._yellowStar4 = self:RegisterController(UnityEngine.UI.Image,"card1/yellowStar/yellow5");
	self.mStarList[1] = self._yellowStar;
    self.mStarList[2] = self._yellowStar1;
    self.mStarList[3] = self._yellowStar2;
    self.mStarList[4] = self._yellowStar3;
    self.mStarList[5] = self._yellowStar4;
	self._indexText = self:RegisterController(UnityEngine.UI.Text,"card1/index/indexText");
	self.cardBackground = self:RegisterController(UnityEngine.UI.Image,"");
	self._troopText = self:RegisterController(UnityEngine.UI.Text,"troopsText");
	self._stateText = self:RegisterController(UnityEngine.UI.Image,"stateImage");
end

-- 卡牌信息
function UICityCard:SetCard(armyInfo)

	self.mCurArmyInfo = ArmyManage:GetMyArmyInMainCity(1);
	print(mCurArmyInfo)
    self.mCurHeroCard = self.mCurArmyInfo:GetCard(ArmySlotType.Back)

	--武将等级
	self._gradeText.text = "3";

	-- 武将名字
	self._cardText.text = "周瑜";
	--self._cardText.text = DataHero[self.mCurArmyInfo.id].Name;

	-- 兵力
	self._troopText.text = "3333";
	--self._troopText.text = self.mCurArmyInfo:GetAllSoldierCount();

	-- -- 第几只部队
	self._indexText.text = 3;
	self:SetArms();
	self:SetStar();
	-- self:SetArmyState();
	self:SetBackground();
end

-- --设置部队状态:行军 疲劳 重伤
-- function UICityCard:SetArmyState()
--     -- 保存要显示的姿态精灵图片名
--     local strState = nil;
--     local armyState = self.mCurArmyInfo.armyState;
--     print("当前状态==" .. armyState);
--     -- 状态设置
--     if armyState == ArmyState.None then
--         -- 无
--         strState = "";
--     elseif armyState == ArmyState.Back then
--         -- 返回
--         strState = "";
--     elseif armyState == ArmyState.GarrisonIng then
--         -- 驻守
--         strState = "";
--     elseif armyState == ArmyState.MitaIng then
--         -- 屯田
--         strState = "";
--     elseif armyState == ArmyState.Training then
--         -- 练兵
--         strState = "";
--     else
--         strState = "";
--         -- 其他在路上为 行军
--     end

--     if self.mCurHeroCard.power < 20 then
--         -- 体力小于20 疲劳
--         strState = "";
--     end
--     if self.mCurHeroCard.troop < 100 then
--         -- 兵力小于100 重伤
--         strState = "";
--     end
--     --是否在征兵
--     if self.mCurArmyInfo:IsConscription(ArmySlotType.Back)then
    
--     end
--     -- self._stateText.sprite = GameResFactory.Instance():GetResSprite(strState);
--     -- 状态
--     -- self._stateText.sprite = GameResFactory.Instance():GetResSprite("AwaitOrders");
-- end

-- 设置星星
function UICityCard:SetStar()
    -- if self.mCurHeroCard ~= nil then
    --     -- 当前卡牌星级
    --     local star = DataHero[self.mCurHeroCard.id].Star;
    --     -- 进阶数
    --     local advancedCount = self.mCurHeroCard.advancedTime;
    --     if advancedCount <= 0 then
    --         -- 未进阶
    --         for i = 1, star do
    --             self.mStarList[i].sprite = GameResFactory.Instance():GetResSprite("herobag_icon_star");
    --         end
    --     else
    --         -- 设置进阶星
    --         for j = 1, advancedCount do
    --             self.mStarList[j].sprite = GameResFactory.Instance():GetResSprite("herobag_icon_starupgrade");
    --         end
    --         -- 设置未进阶星
    --         for k =(advancedCount + 1), star do
    --             self.mStarList[k].sprite = GameResFactory.Instance():GetResSprite("herobag_icon_star");
    --         end
    --     end
    --     -- 设置显隐
    --     for index = 1, 5 do
    --         if (index - star) <= 0 then
    --             self.mStarList[index].gameObject:SetActive(true);
    --         else
    --             self.mStarList[index].gameObject:SetActive(false);
    --         end
    --     end
    -- end

	local yellowStar = self.gameObject.transform:Find("card1/yellowStar/yellow1");
	yellowStar.gameObject:SetActive(true);
	local yellowStarx1 = self.gameObject.transform:Find("card1/yellowStar/yellow2");
	yellowStarx1.gameObject:SetActive(true);
	local yellowStarx2 = self.gameObject.transform:Find("card1/yellowStar/yellow3");
	yellowStarx2.gameObject:SetActive(true);
	local yellowStarx3 = self.gameObject.transform:Find("card1/yellowStar/yellow4");
	yellowStarx3.gameObject:SetActive(true);
	local yellowStarx4 = self.gameObject.transform:Find("card1/yellowStar/yellow5");
	yellowStarx4.gameObject:SetActive(true);
	self._yellowStar.gameObject:GetComponent(typeof(UnityEngine.UI.Image)).sprite = GameResFactory.Instance():GetResSprite("herobag_icon_star");
	self._yellowStar1.gameObject:GetComponent(typeof(UnityEngine.UI.Image)).sprite = GameResFactory.Instance():GetResSprite("herobag_icon_star");
	self._yellowStar2.gameObject:GetComponent(typeof(UnityEngine.UI.Image)).sprite = GameResFactory.Instance():GetResSprite("herobag_icon_star");
	self._yellowStar3.gameObject:GetComponent(typeof(UnityEngine.UI.Image)).sprite = GameResFactory.Instance():GetResSprite("herobag_icon_star");
	self._yellowStar4.gameObject:GetComponent(typeof(UnityEngine.UI.Image)).sprite = GameResFactory.Instance():GetResSprite("herobag_icon_starupgrade");
end

-- 设置兵种
function UICityCard:SetArms()
	local cavalry = self.gameObject.transform:Find("card/corps/cavalry");
	cavalry.gameObject:SetActive(true);
	--local attackRange = DataHero[self.mCurHeroCard.id].AttackRange;
	self._cavalry.gameObject:GetComponent(typeof(UnityEngine.UI.Image)).sprite = GameResFactory.Instance():GetResSprite("herobag_icon_armyarcher");
		-- 攻击距离
	--self._distanceText.text = attackRange;
	self._distanceText.text = "3";
end

-- 设置武将背景图
function UICityCard:SetBackground()
	self.cardBackground.sprite = GameResFactory.Instance():GetResSprite("zhouyu");
end

return UICityCard