
-- Anchor:Dr
-- Date: 16/9/13
-- 英雄小卡牌预制

local UIBase = require("Game/UI/UIBase");
local UISmallHeroCard = class("UISmallHeroCard", UIBase);
local DataHero=require("Game/Table/model/DataHero");
local UIType=require("Game/UI/UIType");
local ArmyInfo = class("ArmyInfo");
local EnterType =require("Game/Hero/HeroCardPart/UIEnterType");
local NowArmyState = require("Game/Army/ArmyState")
-- override
function UISmallHeroCard:ctor()
    UISmallHeroCard.super.ctor(self);
      
    self.bottomObj = nil;
    self.leftUpObj = nil;
    self.rifhtUpObj = nil;
    self._heroNameText = nil;               -- 英雄名字  
    self._heroLevelText = nil;              -- 英雄等级
    self._costParentObj = nil; 
    self._heroCostText = nil;               -- 英雄cost
    self._heroSoldierType=nil;              -- 英雄兵种类型   
    self._heroIconSprite=nil;               --英雄icon图片
    self.grayBG = nil;
    self.conscriptingStateText = nil;
    self.armyStateText = nil;  
    self._heroAttackDisText = nil;          -- 英雄攻击距离  
    self._heroSoldiersText = nil;           -- 英雄兵力（部队兵力）   
    self._heroBelongText = nil;             -- 英雄所属城市    
    self._heroInArmySprite = nil;           -- 英雄是否在部队中
    self._campParent = nil;                 -- 英雄所属大阵营(如:魏/蜀/吴)
    self._heroYellowStarObj = nil;          -- 英雄星级
    self._heroYellowGrayStarObj  = nil      -- 黄灰英雄星级
    self._heroRedStarObj = nil;             -- 英雄进阶星级(红星)
    self._heroRedGrayStartObj = nil         -- 红灰英雄星级
    self._heroAwakeSprite = nil;            -- 英雄是否觉醒
    self._heroAddPointSprite = nil;         -- 英雄是否能加点属性
    self._heroButtonBtn = nil;              -- 武将点击按钮
    self._heroClickImage =nil;
    --这个图片是否变灰
    self._TroopsImage = nil;
    self._TroopsImageGray = nil;
    --Lv这个符号是佛变灰
    self._LevelTextBg = nil

    self._troopType = nil;
    self._curTiledIndex = nil;
    self.spawnSlotIndex = nil;
    self._troopUIType = nil;

    self.ArmyInfo = nil;

    self._buttonOrClick = true;             --是否开启Button点击事件  (小卡默认是开启Button点击事件)
    self._buildingId = nil

    self.curHeroCard = nil;                 -- 英雄数据 HeroCard

    self._isImageisGray=false;  --图片是否变灰
end

-- override
function UISmallHeroCard:DoDataExchange()

    self.bottomObj = self:RegisterController(UnityEngine.Transform,"BottomObj");
    self.leftUpObj = self:RegisterController(UnityEngine.Transform,"NumberBottomImage");
    self.rifhtUpObj = self:RegisterController(UnityEngine.Transform,"Awaken");

    self._heroNameText = self:RegisterController(UnityEngine.UI.Text,"HeroNameText");
    self._costParentObj = self:RegisterController(UnityEngine.Transform,"Cost");
    self._heroCostText = self:RegisterController(UnityEngine.UI.Text,"Cost/CostValue");
    self._heroAttackDisText = self:RegisterController(UnityEngine.UI.Text,"DistanceText");
    self._campParent = self:RegisterController(UnityEngine.Transform,"StateFormImage");
    self._heroSoldierType = self:RegisterController(UnityEngine.Transform,"SoldierType");
    --灰色的兵种
    self._heroSoldierTypeGray=self:RegisterController(UnityEngine.Transform,"SoldierTypeGray");
    self._heroLevelText = self:RegisterController(UnityEngine.UI.Text,"LevelTextBg/LevelText");
    
    self._heroSoldiersText = self:RegisterController(UnityEngine.UI.Text,"BottomObj/TroopsText");
    self._heroIconSprite = self:RegisterController(UnityEngine.UI.Image,"Image1/HeroHeadImage");
    self.grayBG = self:RegisterController(UnityEngine.UI.Image,"GrayBG");
    self.conscriptingStateText = self:RegisterController(UnityEngine.UI.Text,"StatusText/ConscriptingStateText");
    self.armyStateText = self:RegisterController(UnityEngine.UI.Text,"StatusText/ArmyStateText");

    self._TroopsImage =self:RegisterController(UnityEngine.UI.Image,"BottomObj/TroopsImage");
    --TroopsImage 这个图片是否变灰
    self._TroopsImageGray =self:RegisterController(UnityEngine.UI.Image,"BottomObj/TroopsImageGray");
    
    self._heroYellowStarObj =self:RegisterController(UnityEngine.Transform,"StarImage/YellowStar");
    self._heroYellowStarObjParent =self:RegisterController(UnityEngine.Transform,"StarImage");
    --灰色的黄星星
    self._heroYellowGrayStarObj = self:RegisterController(UnityEngine.Transform,"StarImageGray/YellowStarGray");
    self._heroYellowGrayStarObjParent = self:RegisterController(UnityEngine.Transform,"StarImageGray");
    
    self._heroRedStarObj =self:RegisterController(UnityEngine.Transform,"StarImage/RedStar");
    --灰色的红星星
    self._heroRedGrayStartObj = self:RegisterController(UnityEngine.Transform,"StarImageGray/RedStarGray");
    --Lv这个符号是佛变灰
    self._LevelTextBg = self:RegisterController(UnityEngine.UI.Text,"LevelTextBg");
    
    self._heroButtonBtn = self:RegisterController(UnityEngine.UI.Button,"HeroBtn");
    self._heroClickImage = self:RegisterController(UnityEngine.Transform, "HeroClick");
end 

--注册控件点击事件
function UISmallHeroCard:DoEventAdd()
   self:AddListener(self._heroButtonBtn,self.OnClickHeroCard);

end

--隐藏部队数量信息
function UISmallHeroCard:SetArmyCountFalse()
    if self.bottomObj.gameObject.activeSelf == true then
        self.bottomObj.gameObject:SetActive(false);
    end
end

--部队Cost显示
function UISmallHeroCard:SetCardCostTrue()
    self._costParentObj.gameObject:SetActive(true);
end

--设置英雄卡牌信息
-- uiType  根据不同的界面uiType 显示内容有所不同
-- allParent 卡牌拖拽时预制的父物体,拖拽时传
function UISmallHeroCard:SetUISmallHeroCardMessage(mOwnHero,isGray)
    self._isImageisGray=false;
    
    self:ButtonOrClick();
    
    if mOwnHero == nil then
        --print("Hero is nil");
        return;
    else
        if DataHero[mOwnHero.tableID] == nil then
            --print("Hero'table is nil,tableid:"..mOwnHero.tableID);
            return;
        end
    end
    self.curHeroCard = mOwnHero;

    self._costParentObj.gameObject:SetActive(false);
    --卡牌是否置灰
    self._isImageisGray=isGray; 

    --静态
    local mHero=DataHero[mOwnHero.tableID];

    local pic = mHero.HeadInterceptCoordinate
    local picX = pic[1]
    local picY = pic[2]
    self._heroIconSprite.transform.localPosition = Vector3.New(picX,picY,0);
    self._heroIconSprite.sprite = GameResFactory.Instance():GetResSprite(mHero.LengthPortrait);
    self.grayBG.sprite = GameResFactory.Instance():GetResSprite(mHero.HeadPortraitGray);
    self._heroNameText.text = mHero.Name;
    self._heroCostText.text = mHero.Cost;
    
    self:SetUISmallHeroCardCamp(mHero.Camp);
 
    --动态
    --self._heroLevelText.text = mOwnHero.exp;--暂时写着，以后通过经验算等级
    self._heroLevelText.text = mOwnHero.level;

    -- 设置星级
    self:SetStar(mHero.Star, mOwnHero.advancedTime);
    
    self:SetSoldierType(mHero.BaseArmyType);
    if self._isImageisGray == true then
        self._heroAttackDisText.text = "<color=#FFFFFF37>"..mHero.AttackRange.."</color>";
    else
        self._heroAttackDisText.text = mHero.AttackRange;
    end

    -- 设置部队
    --self:SetHeroInArmy(mHero._heroIsInArmy, mHero._heroBelongCity);
end

--设置点击按钮和点击控件
function UISmallHeroCard:SetClickModel(_Clickbool)
    --print(_Clickbool)
    self._buttonOrClick = _Clickbool
end

-- 设置部队
function UISmallHeroCard:SetArmyInfo(armyInfo)
    self.ArmyInfo = armyInfo;
end

-- 初始化部队类型
function UISmallHeroCard:InitTroopInfo(troopType, curTiledIndex, troopIndex,armyInfo)
    self._troopType = troopType;
    self._curTiledIndex = curTiledIndex;
    self.spawnSlotIndex = troopIndex
    self.ArmyInfo = armyInfo;
end

-- 设置部队类型
function UISmallHeroCard:SetTroopUIType(ddtype,armyIndex,buildingId)
    self._troopUIType = ddtype
    self._troopIndex = armyIndex;
    self._buildingId = buildingId;
end

-- 图片变灰
function UISmallHeroCard:SetGrayCardIcon(isGray)
    self.grayBG.gameObject:SetActive(isGray);
end

--设置征兵、重伤、疲劳状态Text
function UISmallHeroCard:SetCardInConscripting(ishow,content)
    self.conscriptingStateText.gameObject:SetActive(ishow);
    if content ~= nil then 
        self.conscriptingStateText.text = content;
    end
end

-- 设置部队状态 全部在自己脚本里定义 状态 只传进来string
function UISmallHeroCard:SetArmyStateText(stateStr)
    if self.armyStateText.gameObject.activeSelf == false then
        self.armyStateText.gameObject:SetActive(true);
    end
    self.armyStateText.text = stateStr;
end

--设置队伍状态Text isInMainCity是否在城中(部队在要塞中时才传这个参数)  isShow 是否显示状态text
function UISmallHeroCard:SetArmyState(armyState,isInMainCity,isShow)
    if isShow ~= nil and isShow == false then 
        self.armyStateText.gameObject:SetActive(false);
        return; 
    end
    self.armyStateText.gameObject:SetActive(true);    
    if isInMainCity~= nil and isInMainCity == false and armyState == ArmyState.TransformArrive then        
        self.armyStateText.text = CommonService:Instance():FormatArmyState(ArmyState.None);
        return;
    end
    self.armyStateText.text = CommonService:Instance():FormatArmyState(armyState);
end

--设置队伍状态Text 征兵>重伤>疲劳
function UISmallHeroCard:SetArmyNoneState(isConscripting,isBadlyHurt,isTired)
    print("aaaaaaaaaaaaaaaaaaaaaaaaa")
    if isConscripting == false and isBadlyHurt == false and isTired == false then
        return;
    end
    self.armyStateText.gameObject:SetActive(true); 
    if isConscripting == true then 
        self.armyStateText.text = "<color=#C0C0C0>征兵</color>";
    else
        if isBadlyHurt == true then 
            self.armyStateText.text = "<color=#FF0000>重伤</color>";
        else
            if isTired == true then 
                self.armyStateText.text = "<color=#FF0000>疲劳</color>";
            end
        end
    end
end

--设置卡牌兵力
function UISmallHeroCard:SetCardSoliderCount(count)
    self._heroSoldiersText.text = count;
end

--设置部队兵力
function UISmallHeroCard:AllSoldierCount(armyInfo)
    local SoldierCount = armyInfo:GetAllSoldierCount()
    self._heroSoldiersText.text = SoldierCount;
end

function UISmallHeroCard:ButtonOrClick()
    if self._buttonOrClick then
       self._heroClickImage.gameObject:SetActive(false)
    else
       self._heroButtonBtn.gameObject:SetActive(false)
    end
end

 -- 设置阵营
function UISmallHeroCard:SetUISmallHeroCardCamp(mCampStr)
      
      local childeIndex=-1;
       if mCampStr == "群" then
       childeIndex=0;
       elseif mCampStr == "蜀" then
        childeIndex=1;
               elseif mCampStr == "汉" then
        childeIndex=2;
               elseif mCampStr == "吴" then
        childeIndex=3;
               elseif mCampStr == "魏" then
        childeIndex=4;
       else
       --print("Can not find Camp");
       return;
       end
       self:ShowChild(childeIndex, self._campParent.transform);
end

 -- 设置兵种
function UISmallHeroCard:SetSoldierType(mSoldierType)
       --print(mSoldierType);
       --骑兵:1,步兵:3,弓兵:2.
       local childeIndex=-1;
       if mSoldierType == 1 then
           childeIndex=0;
       elseif mSoldierType == 3 then
           childeIndex=1;
       elseif mSoldierType == 2 then
           childeIndex=2;
       end
       --print(self._isImageisGray);
       --print(self._heroSoldierTypeGray.transform);
       --print(self._heroSoldierType.transform);
       local heroSoldierType = nil;
       --print(self._isImageisGray);
       
       if(self._isImageisGray == false) then 
          --print("兵种不变灰")        
          
          self:ShowChild(childeIndex, self._heroSoldierType.transform);
       elseif(self._isImageisGray == true) then
          --print("兵种变灰")

          self:ShowChild(childeIndex,self._heroSoldierTypeGray.transform);
       end
end

-- 英雄是否在部队中，在哪个部队
function UISmallHeroCard:SetHeroInArmy(mIsInArmy, mCity)

    if type(mIsInArmy) ~= 'boolean' then
        error("mIsInArmy is not bool");
        return;
    end

    if mIsInArmy == true then
        self._heroInArmySprite.text = "部队中";
        self._heroBelongText.text = mCity or "漓江城";

    end

    self._heroInArmySprite.gameObject:SetActive(mIsInArmy);
    self._heroBelongText.gameObject:SetActive(mIsInArmy);

end



-- 设置英雄星级
function UISmallHeroCard:SetStar(mYellowStar, mRedStar)
    self:SetYellowStar(mYellowStar);
    self:SetRedStar(mYellowStar, mRedStar);
end

-- 设置英雄黄色星级
function UISmallHeroCard:SetYellowStar(mstar)
    local yellowTran = nil;
    if(self._isImageisGray == false) then
        
       yellowTran = self._heroYellowStarObj.transform;
       
       self:SetSmallHeroCardNotGray();
       --print(yellowTran);
    elseif(self._isImageisGray == true) then 
       
       yellowTran = self._heroYellowGrayStarObj.transform;
       
       self:SetSmallHeroCardGray();
       --print(yellowTran);
    end
    
    if yellowTran == nil then
        --print("yellowStar is nil");
        return;
    end

    for i = 1, yellowTran.childCount do
        local tran = yellowTran:GetChild(i-1);
        if (i-1) < mstar then
            tran.gameObject:SetActive(true);
        else
            tran.gameObject:SetActive(false);
        end
    end
end

function UISmallHeroCard:SetSmallHeroCardGray()
       self._heroYellowStarObjParent.gameObject:SetActive(false);
       self._heroYellowGrayStarObjParent.gameObject:SetActive(true);

       self._TroopsImage.gameObject:SetActive(false)
       self._TroopsImageGray.gameObject:SetActive(true)

       self._LevelTextBg.text = "<color=#FFFFFF37>lv</color>"

       self._heroSoldierTypeGray.gameObject:SetActive(true);
       self._heroSoldierType.gameObject:SetActive(false);

       self:SetGrayCardIcon(true);
end
function UISmallHeroCard:SetSmallHeroCardNotGray()
        self._heroYellowStarObjParent.gameObject:SetActive(true);
        self._heroYellowGrayStarObjParent.gameObject:SetActive(false);
        
        self._TroopsImage.gameObject:SetActive(true)
        self._TroopsImageGray.gameObject:SetActive(false)

        self._LevelTextBg.text = "lv"
        
        self._heroSoldierTypeGray.gameObject:SetActive(false);
        self._heroSoldierType.gameObject:SetActive(true);

        self:SetGrayCardIcon(false);
end
-- 设置英雄红色星级
function UISmallHeroCard:SetRedStar(mYellowStar, mRedStar)
    local redTran = nil;
    if(self._isImageisGray == false) then
        redTran = self._heroRedStarObj.transform;
        self:SetSmallHeroCardNotGray();
       
        --print(redTran);
    elseif(self._isImageisGray == true) then 
        redTran = self._heroRedGrayStartObj.transform;
        self:SetSmallHeroCardGray();
        
        --print(redTran);
    end
    if redTran == nil then
        --print("redTran is nil");
        return;
    end
    for i = 1, redTran.childCount do
        local tran = redTran:GetChild(i-1);
        if (i-1) <(mYellowStar - mRedStar) then
            tran.gameObject:SetActive(false);
        else
            if (i-1) >= mYellowStar then
                tran.gameObject:SetActive(false);
            else
                tran.gameObject:SetActive(true);
            end
        end
    end
end

-- 设置子物体下的某一个显示
function UISmallHeroCard:ShowChild(mChildIndex, mTransform)

    if mTransform == nil or mChildIndex < 0 then
        --print("transform is nil or childindex<0");
        return;
    end

    local tranParent = mTransform;
    tranParent.gameObject:SetActive(true);

    for i = 1, tranParent.childCount do
        local tran = tranParent:GetChild(i-1);
        if (i-1) == mChildIndex then
            tran.gameObject:SetActive(true);
        else
            tran.gameObject:SetActive(false);
        end
    end
end

-- 设置阵营
function UISmallHeroCard:SetCamp(mCamp)
    local tranParent = self._campParent.transform;
    tranParent.gameObject:SetActive(true);
    for i = 0, tranParent.childCount do
        if i == mCamp then
            tranParent:GetChild(i).gameObject:SetActive(true);
        else
            tranParent:GetChild(i).gameObject:SetActive(false);
        end
    end
end

-- 获取建筑物到目标地格子的距离
function UISmallHeroCard:GetToTargetDistance(buildId)
    local building = BuildingService:Instance():GetBuilding(buildId)
    if building == nil then
        return 0;
    end
    local targetX, targetY = MapService:Instance():GetTiledCoordinate(self._curTiledIndex);
    local buildX, buildY = MapService:Instance():GetTiledCoordinate(building._tiledId);
    local  distances = math.sqrt((buildX - targetX)*(buildX - targetX)*12960000+(buildY - targetY)*(buildY - targetY)*12960000)/3600;

    local troopsAddition = distances*0.03;
    return distances
end


-- 点击英雄
function UISmallHeroCard:OnClickHeroCard()
--print("我就看看点没点到")
    if self._troopUIType == "behavior" then
        local param = {};
        param.troopType = self._troopType;
        param.tiledIndex = self._curTiledIndex;
        param.troopIndex = self.spawnSlotIndex;
        param.armyInfo = self.ArmyInfo;
        param.buildingId = self._buildingId;
        local building = BuildingService:Instance():GetBuildingByTiledId(self._curTiledIndex)
        local armyState = param.armyInfo:GetArmyState();
        local tiled = MapService:Instance():GetTiledByIndex(param.tiledIndex)
        if param.armyInfo:IsArmyInConscription() == true then
            UIService:Instance():ShowUI(UIType.UICueMessageBox,UICueMessageType.ArmyConscribe);
        elseif self:GetToTargetDistance(param.buildingId) > 500 then
            UIService:Instance():ShowUI(UIType.UICueMessageBox,UICueMessageType.armyDistanceMark)
        elseif ArmyService:Instance():IsHaveHeroWound(param.armyInfo) == true then
            UIService:Instance():ShowUI(UIType.UICueMessageBox,UICueMessageType.ArmyGeneralsSevereInjuries);
        elseif ArmyService:Instance():IsHaveHeroTired(param.armyInfo) == true and param.armyInfo.armyState == ArmyState.TransformArrive then
            UIService:Instance():ShowUI(UIType.UICueMessageBox,91);
        elseif ArmyService:Instance():IsHaveHeroTired(param.armyInfo) == true then
            UIService:Instance():ShowUI(UIType.UICueMessageBox,UICueMessageType.ArmyGeneralsMuscleLack);
        elseif self._troopType == SelfLand.transfer and building == nil then
            UIService:Instance():ShowUI(UIType.UICueMessageBox,502)
        -- elseif tiled ~= nil and tiled.tiledInfo ~= nil and PlayerService:Instance():GetPlayerId() ~= tiled.tiledInfo.ownerId and param.troopType ~= SelfLand.battle then
        --     if tiled.tiledInfo.leagueId ~= PlayerService:Instance():GetLeagueId() then
        --         UIService:Instance():ShowUI(UIType.UICueMessageBox,UICueMessageType.UnableDoOperation);
        --     else
        --         local canGo = false;
        --     if self.ArmyInfo.curBuildingId == self.ArmyInfo.spawnBuildng then
        --         if armyState == ArmyState.None then
        --             canGo = true;
        --         end
        --     else
        --         local fort = BuildingService:Instance():GetBuilding(self.ArmyInfo.curBuildingId);
        --         if fort ~= nil then
        --             param.troopIndex = fort:GetArmyIndex(self.ArmyInfo.spawnBuildng, self.ArmyInfo.spawnSlotIndex);
        --         end
        --         if armyState == ArmyState.TransformArrive and self._isImageisGray == false then
        --             canGo = true;
        --         end
        --     end
        --     if canGo == true then
        --         UIService:Instance():ShowUI(UIType.UIConfirm, param);
        --         UIService:Instance():HideUI(UIType.UISelfLandFunction);
        --     else
        --         UIService:Instance():ShowUI(UIType.UICueMessageBox,UICueMessageType.ArmyBattleState);
        --     end 
        else
        -- 主城为none状态 以及要塞为调动中状态能出征
            local canGo = false;
            if self.ArmyInfo.curBuildingId == self.ArmyInfo.spawnBuildng then
                if armyState == ArmyState.None then
                    canGo = true;
                end
            else
                local fort = BuildingService:Instance():GetBuilding(self.ArmyInfo.curBuildingId);
                if fort._dataInfo.Type == BuildingType.PlayerFort then
                    if fort ~= nil then
                        param.troopIndex = fort:GetArmyIndex(self.ArmyInfo.spawnBuildng, self.ArmyInfo.spawnSlotIndex);
                    end
                    if armyState == ArmyState.TransformArrive and self._isImageisGray == false then
                        canGo = true;
                    end
                elseif fort._dataInfo.Type == BuildingType.WildFort or fort._dataInfo.Type == BuildingType.WildGarrisonBuilding then
                    if fort ~= nil then
                        param.troopIndex = fort:GetWildFortArmyIndex(self.ArmyInfo.spawnBuildng, self.ArmyInfo.spawnSlotIndex);
                    end
                    if armyState == ArmyState.TransformArrive and self._isImageisGray == false then
                        canGo = true;
                    end
                end
            end
            if canGo == true then
                UIService:Instance():ShowUI(UIType.UIConfirm, param);
               -- UIService:Instance():HideUI(UIType.UISelfLandFunction);
            else
                UIService:Instance():ShowUI(UIType.UICueMessageBox,UICueMessageType.ArmyBattleState);
            end
        end
    end    
end

return UISmallHeroCard;