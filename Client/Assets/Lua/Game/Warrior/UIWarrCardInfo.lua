
local UIBase = require("Game/UI/UIBase")
local UIWarrCardInfo = class("UIWarrCardInfo", UIBase);
local DataHero = require("Game/Table/model/DataHero");

function UIWarrCardInfo:ctor()

    UIWarrCardInfo.super.ctor(self);

    -- 保存当前预设对象
    self.mParantobj = nil;
    -- 头像
    self._mHeadIconBtn = nil;
    self._mPlayerInfo = nil;
    self._mPname = nil;
    -- 星级
    self._mS1 = nil;
    self._mS2 = nil;
    self._mS3 = nil;
    self._mS4 = nil;
    self._mS5 = nil;
    self.mStarList = { };

    -- 次数信息
    self._mCardStateInfo = nil;
    -- 时间信息
    self._mTimeInfo = nil;
    -- 等级信息
    self._mLvInfo = nil;
    -- 军队类型信息 军队类型及攻击距离
    self._mArmyType = nil;
    -- 状态提示信息
    self._mStateTip = nil;
    -- 总兵力
    self._mAllTroopsTex = nil;
    --是否觉醒
    self.mAwaken=nil;

    self._mOpenInfo = nil;
    self._mRankTex = nil;
    --保存部队信息及当前大营英雄卡信息
    self.mCurArmyInfo = nil;
    self.mCurHeroCard = nil;

end


function UIWarrCardInfo:DoDataExchange()

    self._mPlayerInfo = self:RegisterController(UnityEngine.Transform, "PlayerInfo");
    self.mAwaken=self:RegisterController(UnityEngine.Transform, "PlayerInfo/Awaken");
    self._mPname = self:RegisterController(UnityEngine.UI.Text, "PlayerInfo/TopInfo/PName");
    self._mS1 = self:RegisterController(UnityEngine.UI.Image, "PlayerInfo/TopInfo/Stars/s1");
    self._mS2 = self:RegisterController(UnityEngine.UI.Image, "PlayerInfo/TopInfo/Stars/s2");
    self._mS3 = self:RegisterController(UnityEngine.UI.Image, "PlayerInfo/TopInfo/Stars/s3");
    self._mS4 = self:RegisterController(UnityEngine.UI.Image, "PlayerInfo/TopInfo/Stars/s4");
    self._mS5 = self:RegisterController(UnityEngine.UI.Image, "PlayerInfo/TopInfo/Stars/s5");
    self.mStarList[1] = self._mS1;
    self.mStarList[2] = self._mS2;
    self.mStarList[3] = self._mS3;
    self.mStarList[4] = self._mS4;
    self.mStarList[5] = self._mS5;
    self._mCardStateInfo = self:RegisterController(UnityEngine.Transform, "PlayerInfo/CardState");
    self._mTimeInfo = self:RegisterController(UnityEngine.Transform, "PlayerInfo/TimeInfo");
    self._mLvInfo = self:RegisterController(UnityEngine.UI.Text, "PlayerInfo/LvInfo/LvText");
    self._mArmyType = self:RegisterController(UnityEngine.Transform, "PlayerInfo/ArmTypeInfo");
    self._mStateTip = self:RegisterController(UnityEngine.UI.Image, "PlayerInfo/StateTip");
    self._mAllTroopsTex = self:RegisterController(UnityEngine.UI.Text, "PlayerInfo/AllTroopsText");

    self._mOpenInfo = self:RegisterController(UnityEngine.Transform, "OpenInfo");
    self._mRankTex = self:RegisterController(UnityEngine.UI.Text, "Rank/Text");
    self._mHeadIconBtn = self:RegisterController(UnityEngine.UI.Button, "HeadIcon");

    self._mCardStateInfo.gameObject:SetActive(false);
    self._mTimeInfo.gameObject:SetActive(false);

end

-- 注册控件事件
function UIWarrCardInfo:DoEventAdd()
    self:AddListener(self._mHeadIconBtn, self.OnClickHead)

end

-- 刷新数据
-- 设置队伍信息 参数：ArmyInfo类型
function UIWarrCardInfo:SetWarrCardDataInfo(armyInfo)
    self.mCurArmyInfo = armyInfo;
    self.mCurHeroCard = armyInfo:GetCard(ArmySlotType.Back)
    --没有设置大营并且。。
    if self.mCurHeroCard==nil then 
     self:SetOpenInfo();
     else
      self:SetCardInfo();
    end
   
end



---------------------------- 设置卡牌信息
function UIWarrCardInfo:SetCardInfo()
    self:SetArmyBaseInfo();
    self:SetHeadIcon();
    self:SetTopInfo();
    -- self:SetCardSateInfo();
    self:SetArmyState();
    self:SetArmyTypeInfo();
  
end

-- 设置部队基础信息
function UIWarrCardInfo:SetArmyBaseInfo()
    -- 排列信息
    self._mRankTex.text = "1";
    -- 总兵力
    print("总兵力=="..self.mCurArmyInfo:GetAllSoldierCount());
    self._mAllTroopsTex.text = self.mCurArmyInfo:GetAllSoldierCount();

    -- 获取当前大营武将卡 HeroCard类型
    self._mLvInfo.text = "Lv. " .. self.mCurHeroCard.level;
     self.mAwaken.gameObject:SetActive(self.mCurHeroCard.isAwaken);

end


-- 设置头像信息 
function UIWarrCardInfo:SetHeadIcon()
    self._mHeadIconBtn.gameObject:GetComponent(typeof(UnityEngine.UI.Image)).sprite = GameResFactory.Instance():GetResSprite("GeneralIM");
    -- 读表

end

function UIWarrCardInfo:SetTopInfo()

    self._mPname.text = DataHero[self.mCurHeroCard.id].Name;
    -- 根据id获取表中名称
    self:SetStarInfo();
end

-- 设置星级信息
function UIWarrCardInfo:SetStarInfo()

    -- 当前卡牌星级
    local star = DataHero[self.mCurHeroCard.id].Star;
    -- 进阶数
    local advancedCount = self.mCurHeroCard.advancedTime;
    if advancedCount <= 0 then
        -- 未进阶
        for i = 1, star do
            self.mStarList[i].sprite = GameResFactory.Instance():GetResSprite("herobag_icon_star");
        end
    else
        -- 设置进阶星
        for j = 1, advancedCount do
            self.mStarList[j].sprite = GameResFactory.Instance():GetResSprite("herobag_icon_starupgrade");
        end
        -- 设置未进阶星
        for k =(advancedCount + 1), star do
            self.mStarList[k].sprite = GameResFactory.Instance():GetResSprite("herobag_icon_star");
        end
    end
    -- 设置显隐
    for index = 1, 5 do
     if (index-star)<=0 then
      self.mStarList[index].gameObject:SetActive(true);
      else
       self.mStarList[index].gameObject:SetActive(false);
     end
    end
    --    self._mS1.sprite = GameResFactory.Instance():GetResSprite("herobag_icon_starupgrade");
    --    self._mS2.sprite = GameResFactory.Instance():GetResSprite("herobag_icon_starupgrade");
    --    self._mS3.sprite = GameResFactory.Instance():GetResSprite("herobag_icon_star");
    --    self._mS4.sprite = GameResFactory.Instance():GetResSprite("herobag_icon_star");
    --    self._mS5.sprite = GameResFactory.Instance():GetResSprite("herobag_icon_star");

end

-- 设置兵种信息
function UIWarrCardInfo:SetArmyTypeInfo()
 
 --兵种类型(骑兵=1;弓兵=2;步兵=3;重骑兵=4;轻骑兵=5;弓骑兵=6;铁骑兵=7;重步兵=8;长枪兵=9;禁卫军=10;藤甲兵=11;蛮兵=12;长弓兵=13;弩兵=14;死士=15)
    local cardtype= DataHero[self.mCurHeroCard.id].BaseArmyType;
    local cardAttackRange=DataHero[self.mCurHeroCard.id].AttackRange;
    local armyType = self._mArmyType.gameObject.transform:FindChild("type");
    armyType.gameObject:GetComponent(typeof(UnityEngine.UI.Image)).sprite = GameResFactory.Instance():GetResSprite("herobag_icon_armyfootman");
    local dsTex = self._mArmyType.gameObject.transform:FindChild("DsText");
    -- 距离
    dsTex.gameObject:GetComponent(typeof(UnityEngine.UI.Text)).text = cardAttackRange;
end

-- 设置部队状态:行军 疲劳 重伤
function UIWarrCardInfo:SetArmyState()
    -- 保存要显示的姿态精灵图片名
    local strState = nil;
    local armyState = self.mCurArmyInfo.armyState;
    -- 状态设置
    if armyState == ArmyState.None then
        -- 无
        strState = "";
    elseif armyState == ArmyState.Back then
        -- 返回
        strState = "";
    elseif armyState == ArmyState.GarrisonIng then
        -- 驻守
        strState = "";
    elseif armyState == ArmyState.MitaIng then
        -- 屯田
        strState = "";
    elseif armyState == ArmyState.Training then
        -- 练兵
        strState = "";
    else
        strState = "";
        -- 其他在路上为 行军
    end

    if self.mCurHeroCard.power < 20 then
        -- 体力小于20 疲劳
        strState = "";
    end
    if self.mCurHeroCard.troop < 100 then
        -- 兵力小于100 重伤
        strState = "";
    end
     --是否在征兵
--    if self.mCurArmyInfo:IsConscription(ArmySlotType.Back)then

--    end
    -- self._mStateTip.sprite = GameResFactory.Instance():GetResSprite(strState);
end


--跟设施中的校场关联 ：校场总共5级
function UIWarrCardInfo:SetOpenInfo()

    --当部队数小于校场数或部队大营卡未设置英雄时都为未配置部队-此时部队不能有出战
    --当校场未到5级时提前预设下一个部队开放所需的校场开放等级：   
    local tipTex = self._mOpenInfo.gameObject.transform:FindChild("TipText");
    tipTex.gameObject:GetComponent(typeof(UnityEngine.UI.Text)).text = "未配置";
    self._mPlayerInfo.gameObject:SetActive(false);
    self._mOpenInfo.gameObject:SetActive(true);

end

-- 点击头像事件
function UIWarrCardInfo:OnClickHead()

--未开放的点击不做操作，
--其他的都跳转到出征队伍配置界面

end 

return UIWarrCardInfo;