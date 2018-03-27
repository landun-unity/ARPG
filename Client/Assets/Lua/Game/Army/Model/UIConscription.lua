
--[[
    征兵界面
--]]

local UIBase = require("Game/UI/UIBase")

local UIConscription = class("UIConscription", UIBase)
require("Game/UI/UIType")
require("Game/Army/ArmySlotType");
local CurrencyEnum = require("Game/Player/CurrencyEnum");
local DataConscriptionResources = require("Game/Table/model/DataConscriptionResources");
local DataHeroLevel = require("Game/Table/model/DataHeroLevel");
local DataHero = require("Game/Table/model/DataHero");
local ConscriptionConfirmUI = require("Game/Army/Model/ConscriptionConfirmUI");
local UIConscriptionItem = require("Game/Army/Model/UIConscriptionItem");


-- 构造函数
function UIConscription:ctor()
    UIConscription.super.ctor(self)   
    self._costWoodText = nil;                       -- 花费木材   
    self._costIronText = nil;                       -- 花费铁矿   
    self._costFoodText = nil;                       -- 花费粮草
    self._costGoldText = nil;                       -- 花费粮草
    self._costGoldObj = nil;   
    self._confirmBtn = nil;                         -- 确认征兵按钮
    self._confirmBtnBg = nil;                       -- 确定征兵按钮灰色遮挡图片
    self._soliderMaxTipText = nil;                  
    self._nowConscriptionToggle = nil;              -- 立即征兵
    self._immediatelyBgBtn = nil;    
    self._closeBtn = nil;                           -- 关闭界面  
    self._redifText = nil;                          -- 预备兵 
    self.cancelBtnTable={ };                        -- 3个取消按钮
    
    self.backItemParent = nil;
    self.middleItemParent = nil;
    self.frontItemParent = nil;

    --------------------------------------数据层------------------------------

    self.positionParents = {};
    self.itemTables = {};

    self.curArmy = nil;                             --当前部队
    self.curBuilding = nil;

    self.couldUseRedifSoldier = true;               --是否可以使用立即征兵（默认是true,要塞中不可以）
    self.curArmyConsQueueIsFull = false;            --当前部队的征兵队列是否已满 
    self._isImmediatelyState = false;               --是否处于立即征兵状态 

    self._allHaveResource={ };                      --玩家拥有的资源
    self._allConscriptionResourcesDatas = { };      --3个位置卡牌对应的 DataConscriptionResources表数据   
    self._armySmallHeroTable = { };                 --部队对应samllherocard脚本
    self._armyObjTable = { };                       --部队数据table。键:ArmySlotType，值:对应数据 HeroCard
    self._backCostResource={};                      --大营消耗的资源
    self._middleCostResource={};                    --中军消耗的资源
    self._frontCostResource={};                     --前锋消耗的资源
    self._allCostResource={ };                      --所有消耗的资源
    self._choosedSliderCounts = { };                --滑动滑动条产生的普通征兵数量
    self.curChoosedRedifCount = { };                --滑动滑动条选中的预备兵数量      
    self.curRedifMax = 0;                           --当前最大的预备兵数量

    self.foodSubCount = 0;                          --粮食减少后剩下的产量
end

-- 注册控件
function UIConscription:DoDataExchange()
    self.backItemParent =  self:RegisterController(UnityEngine.Transform, "MiddlePart/TroopsBackgroundImage/BackPart")
    self.middleItemParent =  self:RegisterController(UnityEngine.Transform, "MiddlePart/TroopsBackgroundImage/MiddlePart")
    self.frontItemParent =  self:RegisterController(UnityEngine.Transform, "MiddlePart/TroopsBackgroundImage/FrontPart")

    self.positionParents[ArmySlotType.Front] = self.frontItemParent;
    self.positionParents[ArmySlotType.Center] = self.middleItemParent;
    self.positionParents[ArmySlotType.Back] = self.backItemParent;

    ---------------------------------------------功能部分--------------------------------------------------------
    self._nowConscriptionToggle = self:RegisterController(UnityEngine.UI.Toggle, "DownPart/ImmediatelyToggle")
    self._immediatelyBgBtn = self:RegisterController(UnityEngine.UI.Button, "DownPart/ImmediatelyToggle/BlackBg")
    self._costWoodText = self:RegisterController(UnityEngine.UI.Text, "DownPart/WoodImage/ValueText")
    self._costIronText = self:RegisterController(UnityEngine.UI.Text, "DownPart/IronImage/ValueText")
    self._costFoodText = self:RegisterController(UnityEngine.UI.Text, "DownPart/FoodImage/ValueText")

    self._costGoldText = self:RegisterController(UnityEngine.UI.Text, "DownPart/Copper/ValueText");
    self._costGoldObj = self:RegisterController(UnityEngine.Transform, "DownPart/Copper");

    self._confirmBtn = self:RegisterController(UnityEngine.UI.Button, "ConfirmButton")
    self._confirmBtnBg = self:RegisterController(UnityEngine.UI.Image, "ConfirmButton/BlackBg")
    self._soliderMaxTipText = self:RegisterController(UnityEngine.UI.Text, "ConfirmButton/MaxText")
    self._closeBtn = self:RegisterController(UnityEngine.UI.Button, "XButton")
    self._redifText = self:RegisterController(UnityEngine.UI.Text, "DownPart/SpareSoldiersText")
    
end

-- 注册控件点击事件
function UIConscription:DoEventAdd()
    self:AddToggleOnValueChanged(self._nowConscriptionToggle, self.OnToggleChanged);
    self:AddListener(self._closeBtn,self.OnClickCloseBtn)
    self:AddListener(self._confirmBtn,self.OnClickConfirmBtn)
    
    self:AddListener(self._immediatelyBgBtn,self.OnClickImmediatelyBgBtn)
end

function UIConscription:OnBeforeDestroy()
    if self then
        CommonService:Instance():RemoveAllTimeDownInfoInUI(UIType.UIConscription);
    end
end

-- 显示
function UIConscription:OnShow(param)
    self.curArmy = param[1];
    --self.couldUseRedifSoldier =  param[2];
    self.curBuilding = BuildingService:Instance():GetBuilding(self.curArmy.spawnBuildng);
    local building = BuildingService:Instance():GetBuilding(self.curArmy.curBuildingId);
    if building._dataInfo.Type == BuildingType.PlayerFort or 
        building._dataInfo.Type == BuildingType.WildFort then
        self.couldUseRedifSoldier = false;
     else
        self.couldUseRedifSoldier = true;
     end

    --print("_____________________________________当前部队的index： "..param.spawnSlotIndex);
    local cardCount = self.curArmy:GetCardCount(); 
    --print("self.curArmy is't nil".." cardCount = "..cardCount);
    
    self:ResetData();    
    self:RefreshArmyCardData();
    self:RefreshResourceData();    
    self:RefreshAllCost();
    self:CheckConscriptionQueueState();
    self:ShowConscriptionBtnState();  
    --显示队伍3个位置的征兵信息
    self:SetArmyInfo(); 
end

--征兵队列上限检测检测
function UIConscription:CheckConscriptionQueueState()
    local maxConscriptionCount = 0;
    local curConsCount = 0;
    if self.couldUseRedifSoldier == true then--主城分城 
        maxConscriptionCount =  self.curBuilding:GetCityPropertyByFacilityProperty(FacilityProperty.RecruitQueue);
        curConsCount =  self.curBuilding:GetArmyConscritionCount();
    else--要塞
        maxConscriptionCount = 1;
        local fort = BuildingService:Instance():GetBuilding(self.curArmy.curBuildingId);
        if fort._dataInfo.Type == BuildingType.PlayerFort then
            if fort~= nil then
                curConsCount = fort:GetFortArmyConscritionCount();
            end
        elseif fort._dataInfo.Type == BuildingType.WildFort then
            if fort~= nil then
                curConsCount = fort:GetWildFortArmyConscritionCount();
            end
        end
    end
    if  curConsCount < maxConscriptionCount  then   
        self.curArmyConsQueueIsFull = false;
    else
        self.curArmyConsQueueIsFull = true;
    end
end

--预备兵状态显示（是否可以使用）
function UIConscription:ShowRedifSoldierState()
    if  self.couldUseRedifSoldier == true then 
        self._immediatelyBgBtn.gameObject:SetActive(false);
    else
        self._immediatelyBgBtn.gameObject:SetActive(true);
    end
end

--征兵按钮遮挡显示状态、队伍所有卡牌达到最大兵力上限检测
function UIConscription:ShowConscriptionBtnState()
    if self._isImmediatelyState == false then
        if  self.curArmyConsQueueIsFull == false  then   
            self._confirmBtnBg.gameObject:SetActive(false);
        else
            local consSoliderCount = self.curArmy:GetConscriptingCardCount();
            local armyCardCount = self.curArmy:GetCardCount();
            if consSoliderCount < armyCardCount and self.curArmy:IsArmyInConscription() == true then 
                self._confirmBtnBg.gameObject:SetActive(false);
            else
                self._confirmBtnBg.gameObject:SetActive(true);
            end
        end
    else
        self._confirmBtnBg.gameObject:SetActive(false);
    end
    local isMaxSoliders = self.curArmy:CheckArmyAllSoliderMax();
    self._soliderMaxTipText.gameObject:SetActive(isMaxSoliders);
    self._confirmBtnBg.gameObject:SetActive(isMaxSoliders);
end

function UIConscription:SliderCheckConsQueueFull(armySlotType)    
    if self._isImmediatelyState == false then
        local consSoliderCount = self.curArmy:GetConscriptingCardCount();
        local armyCardCount = self.curArmy:GetCardCount();
        if  self.curArmyConsQueueIsFull == true then
            if self.curArmy:IsConscription(armySlotType) == true or self.curArmy:IsArmyInConscription() == false or (self.curArmy:IsConscription(armySlotType) == false and consSoliderCount >= armyCardCount and self.curArmy:IsArmyInConscription() == true) then         
                UIService:Instance():ShowUI(UIType.UICueMessageBox,68);
                if self.itemTables[armySlotType] ~= nil then
--                    local curSlider = self:GetSlider(armySlotType);
--                    curSlider.value = 0;
--                    curSlider.interactable = false;
                    self.itemTables[armySlotType]:ResetSliderValue();
                end
                return;
            end
        end
    end
end

function UIConscription:RefreshArmyCardData(args)
    --卡牌数据加入内存
    if self.curArmy ~= nil then
        if self.curArmy:GetCard(ArmySlotType.Back) ~= nil then
            self._armyObjTable[ArmySlotType.Back] = self.curArmy:GetCard(ArmySlotType.Back);
            self._allConscriptionResourcesDatas[ArmySlotType.Back] = self:GetTableData(ArmySlotType.Back);
        else
            self._armyObjTable[ArmySlotType.Back] = nil;
            if  self._allConscriptionResourcesDatas[ArmySlotType.Back] ~= nil then 
                self._allConscriptionResourcesDatas[ArmySlotType.Back] = nil;
            end
        end
        if self.curArmy:GetCard(ArmySlotType.Center) ~= nil then 
            self._armyObjTable[ArmySlotType.Center] = self.curArmy:GetCard(ArmySlotType.Center);
            self._allConscriptionResourcesDatas[ArmySlotType.Center] = self:GetTableData(ArmySlotType.Center);
        else
            self._armyObjTable[ArmySlotType.Center] = nil;
            if  self._allConscriptionResourcesDatas[ArmySlotType.Center] ~= nil then 
                self._allConscriptionResourcesDatas[ArmySlotType.Center] = nil;
            end
        end
        if self.curArmy:GetCard(ArmySlotType.Front) ~= nil then 
            self._armyObjTable[ArmySlotType.Front] = self.curArmy:GetCard(ArmySlotType.Front);
            self._allConscriptionResourcesDatas[ArmySlotType.Front] = self:GetTableData(ArmySlotType.Front);
        else
            self._armyObjTable[ArmySlotType.Front] = nil;
            if  self._allConscriptionResourcesDatas[ArmySlotType.Front] ~= nil then 
                self._allConscriptionResourcesDatas[ArmySlotType.Front] = nil;
            end
        end
    end
end

function UIConscription:RefreshResourceData()    
    --获取拥有的资源
    local myWood = PlayerService.Instance():GetCurrencyVarCalcByKey(CurrencyEnum.Wood):GetValue();
    local myIron = PlayerService.Instance():GetCurrencyVarCalcByKey(CurrencyEnum.Iron):GetValue();
    local myFood = PlayerService.Instance():GetCurrencyVarCalcByKey(CurrencyEnum.Grain):GetValue();
    local myGold = PlayerService.Instance():GetCurrencyVarCalcByKey(CurrencyEnum.Money):GetValue();
    --print("_______________________________当前拥有Wood: "..myWood.." Iron:"..myIron.." Grain:"..myFood.."_________________________________");
    self._allHaveResource[CurrencyEnum.Wood] = myWood;
    self._allHaveResource[CurrencyEnum.Iron] = myIron;
    self._allHaveResource[CurrencyEnum.Grain] = myFood;
    self._allHaveResource[CurrencyEnum.Money] = myGold;
    --print("-------------------------当前城"..self.curArmy.spawnBuildng.."的预备兵数量: "..self.curBuilding._redif);
    if self.couldUseRedifSoldier == true then
        local building = BuildingService:Instance():GetBuilding(self.curArmy.curBuildingId);
        self.curRedifMax = building:GetBuildingRedif();
    end
end

function UIConscription:ResetData()    
    self._nowConscriptionToggle.isOn = false;
    self._isImmediatelyState = false;
    for i=1,#self.itemTables do
        self.itemTables[i]:ResetSliderValue();
        self.itemTables[i]:SetImmediatelySoliderText(self._isImmediatelyState);
    end
    self._allCostResource[CurrencyEnum.Wood] = 0;
    self._allCostResource[CurrencyEnum.Iron] = 0;
    self._allCostResource[CurrencyEnum.Grain] = 0;
    self._allCostResource[CurrencyEnum.Money] = 0;
    self._backCostResource[CurrencyEnum.Wood] = 0;
    self._backCostResource[CurrencyEnum.Iron] = 0;
    self._backCostResource[CurrencyEnum.Grain] = 0;
    self._backCostResource[CurrencyEnum.Money] = 0;
    self._middleCostResource[CurrencyEnum.Wood] = 0;
    self._middleCostResource[CurrencyEnum.Iron] = 0;
    self._middleCostResource[CurrencyEnum.Grain] = 0;
    self._middleCostResource[CurrencyEnum.Money] = 0;
    self._frontCostResource[CurrencyEnum.Wood] = 0;
    self._frontCostResource[CurrencyEnum.Iron] = 0;
    self._frontCostResource[CurrencyEnum.Grain] = 0;
    self._frontCostResource[CurrencyEnum.Money] = 0;
    self._choosedSliderCounts[ArmySlotType.Back] = 0;
    self._choosedSliderCounts[ArmySlotType.Center] = 0;
    self._choosedSliderCounts[ArmySlotType.Front] = 0;   
    self.curChoosedRedifCount[ArmySlotType.Back] = 0;
    self.curChoosedRedifCount[ArmySlotType.Center] = 0;
    self.curChoosedRedifCount[ArmySlotType.Front] = 0;
end

function UIConscription:SetArmyInfo()
    for k, v in pairs(ArmySlotType) do
        if v ~= ArmySlotType.None then
            self:LoadItem(v);
        end
    end
    self:ShowRedifSoldierState();
    self:ShowRedifCountText();
    self:RefreshSliderBackGorund();
end

function UIConscription:LoadItem(armySlotType)
    local heroCardData =  self._armyObjTable[armySlotType];
    if self.itemTables[armySlotType] == nil then
        local dataConfig = DataUIConfig[UIType.UIConscriptionItem];
        local uiBase = require(dataConfig.ClassName).new(); 
        GameResFactory.Instance():GetUIPrefab(dataConfig.ResourcePath, self.positionParents[armySlotType], uiBase, function(go)
            uiBase:Init();
            uiBase:SetInformation(self,self.curArmy,armySlotType,heroCardData);
            self.itemTables[armySlotType] = uiBase;
            if self.curArmy:GetCard(armySlotType) ~= nil then
                if self.curArmy:IsConscription(armySlotType) == false then
                    uiBase:RefreshSingleSliderBG(armySlotType,self:GetCouldGetSoliders(armySlotType));
                end 
            end
        end);
    else
        self.itemTables[armySlotType]:SetInformation(self,self.curArmy,armySlotType,heroCardData);
        if self.curArmy:GetCard(armySlotType) ~= nil then
            if self.curArmy:IsConscription(armySlotType) == false then
                self.itemTables[armySlotType]:RefreshSingleSliderBG(armySlotType,self:GetCouldGetSoliders(armySlotType));
            end 
        end
    end
end

--获取最大的征兵数量
function UIConscription:GetMaxSoliders(armySlotType)
    local heroCardData = self._armyObjTable[armySlotType];
    if  heroCardData == nil then 
        return 0;
    end
    --获取兵营增加的最大可征兵数量
    local soldierBuildingCount = self.curBuilding:GetCityPropertyByFacilityProperty(FacilityProperty.NumberTroops);
    local couldNum = DataHeroLevel[heroCardData.level].UnitAmount + soldierBuildingCount;
    if couldNum <= 0 then
        couldNum = 0;
    end
    return couldNum;  
end

--获取最大可征兵数量
function UIConscription:GetCouldGetSoliders(armySlotType)
    local maxNum = self:GetMaxSoliders(armySlotType);
    local couldNum = maxNum - self.curArmy:GetIndexSoldierCount(armySlotType);
    if couldNum <= 0 then
        couldNum = 0;
    end
    return couldNum;  
end

function UIConscription:OnSliderUp(armySlotType,slider,timeText,comscriptinonText)
    if GuideServcice:Instance():GetIsFinishGuide() == false then
        local guideStep = 0;
        if armySlotType == ArmySlotType.Back then
            guideStep = 41;
        elseif armySlotType == ArmySlotType.Center then
            guideStep = 42;
        end
        if slider.value > 0.2 and GuideServcice:Instance():GetCurrentStep() == guideStep then
            self:ConscritingToMax(armySlotType,slider,timeText,comscriptinonText);
            GuideServcice:Instance():GoToNextStep();
        end
    end
end    

function UIConscription:OnSliderChanged(armySlotType,slider,timeText,comscriptinonText)
    self:ShowConscriptionBtnState();
    self:SliderCheckConsQueueFull(armySlotType);
    self:SliderUpdate(armySlotType,slider,timeText,comscriptinonText);
    self:RefreshAllCost();
    self:RefreshSliderBackGorund();
end

--新手引导调用，直接征兵满
function UIConscription:ConscritingToMax(armySlotType,slider,timeText,comscriptinonText)
    self:ShowConscriptionBtnState();
    self:SliderCheckConsQueueFull(armySlotType);
    self:SliderUpdate(armySlotType,slider,timeText,comscriptinonText,true);
    self:RefreshAllCost();
    self:RefreshSliderBackGorund();
end

function UIConscription:SliderUpdate(armySlotType,curSlider,curTimeText,comscriptinonText,isFull)
    --获取储存的数据
    local heroCardData = self._armyObjTable[armySlotType];
--    if heroCardData == nil then 
--        return;
--    end
    local mHeroData = DataHero[heroCardData.tableID];--静态表
    local mTableData = self._allConscriptionResourcesDatas[armySlotType];
    --限制滑动条可滑动的最大值
    --local curSlider = self:GetSlider(armySlotType);
    local maxNumber = self:GetCouldGetSoliders(armySlotType);
    local sliderMaxValue = self:GetMaxSliderValue(armySlotType,self:GetTableData(armySlotType),maxNumber);
    --print(armySlotType.." 可以滑动的最大位置 "..sliderMaxValue);
    if isFull ~= nil and isFull == true then
        curSlider.value = 1.0;
    end
    if curSlider.value > sliderMaxValue then
        curSlider.value = sliderMaxValue;
        --curSlider.interactable = false;
    end
    local num = math.floor(maxNumber  * curSlider.value);
    --print("位置"..armySlotType .." 的 slider is changed, the Slider value now is "..curSlider.value.."  添加的兵力: "..num);
    --征兵数量显示
    comscriptinonText.text = num;
    --更新当前选择的正常征兵数量
    self._choosedSliderCounts[armySlotType] = num;
    --更新当前选择的预备兵征兵数量
    if self._isImmediatelyState then 
        self.curChoosedRedifCount[armySlotType] = num;
        self:ShowRedifCountText();
    end

    --征兵消耗时间
    local costTime =self:GetEndConsTimes(armySlotType,num); 
    --local curTimeText = self:GetUseTimeText(armySlotType);
    curTimeText.text =  self:GetDateString(costTime,self.curArmy:IsConscription(armySlotType));

    --木/铁/粮消耗
    local costResources = self:GetCostResourceData(armySlotType);
    costResources[CurrencyEnum.Wood] = mTableData.Wood * num;
    --!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!Iorn
    costResources[CurrencyEnum.Iron] = mTableData.Iorn * num;
    costResources[CurrencyEnum.Grain] = mTableData.Food * num;
    costResources[CurrencyEnum.Money] = mTableData.Gold * num;
    self:RefreshAllCost();
end

--征兵消耗时间 (单位：秒)
function UIConscription:GetEndConsTimes(armySlotType,soliderCount)
    local mTableData = self._allConscriptionResourcesDatas[armySlotType];          
    local ArmyTypeCostTime = mTableData.ArmyTypeCostTime;
    local building = BuildingService:Instance():GetBuilding(self.curArmy.spawnBuildng);
    local armyConscriptionTime = building:GetCityPropertyByFacilityProperty(FacilityProperty.RecruitTime);

    local card = self.curArmy:GetCard(armySlotType);
    --获取该阵营点将台满级征兵缩减时间
    local maxCampSubTime = building:GetCityMaxLevelFacilityProperty(card.camp + 1);
    local costTime = math.floor((ArmyTypeCostTime/1000 * soliderCount * (1 + armyConscriptionTime)) * (1 + maxCampSubTime/10000));
    return  costTime;
end

function UIConscription:ShowRedifCountText()
    if self.couldUseRedifSoldier == true then
        local allRedifCount = self:GetAllRedifCount();
        self._redifText.text = allRedifCount.."<color=#e2bd75>/"..self.curRedifMax.."</color>";
    else
        self._redifText.text = "<color=#FFFFFF>--</color><color=#e2bd75>/--</color>";
    end
end

function UIConscription:GetAllRedifCount()
    local countValue = 0;
    if self.curChoosedRedifCount[ArmySlotType.Back] ~= nil then 
        countValue = self.curChoosedRedifCount[ArmySlotType.Back];
    end
    if self.curChoosedRedifCount[ArmySlotType.Center] ~= nil then 
        countValue = countValue + self.curChoosedRedifCount[ArmySlotType.Center];
    end
    if self.curChoosedRedifCount[ArmySlotType.Front] ~= nil then 
        countValue = countValue + self.curChoosedRedifCount[ArmySlotType.Front];
    end
    return countValue;
end

--时间转化字符串
function UIConscription:GetDateString(costTime,isConscriping)
    if isConscriping == nil then 
        isConscriping = false;
    end
    local timeString = nil;
    local t1, t2 = math.modf(costTime / 3600);
    local hour = t1 ;
    local t3,t4 = math.modf((costTime - t1*3600)/60);
    local minute = t3;
    local second = costTime%60;
    if hour<10 then 
        hour = "0"..hour;
    end 
    if minute<10 then 
        minute ="0"..minute;
    end 
    if second<10 then 
        second ="0"..second;
    end

    if isConscriping == true then
        timeString =  "<color=#e2bd75>剩余时间:</color>"..hour..":"..minute..":"..second;
    else
        timeString =  "<color=#e2bd75>预计用时:</color>"..hour..":"..minute..":"..second;
    end
    return  timeString;
end

function UIConscription:GetCostResourceData(armySlotType)
    if ArmySlotType.Back == armySlotType then
        return self._backCostResource;
    elseif ArmySlotType.Center == armySlotType then
        return self._middleCostResource;
    elseif ArmySlotType.Front == armySlotType then
        return self._frontCostResource;
    end
end

--刷新所有滑动条背景长度（3个位置互相影响）
function UIConscription:RefreshSliderBackGorund()
    for k, v in pairs(ArmySlotType) do
        if v ~= ArmySlotType.None then
            if self.curArmy:GetCard(v) ~= nil then
                if self.curArmy:IsConscription(v) == false then
                    if self.itemTables[v] ~= nil then
                        self.itemTables[v]:RefreshSingleSliderBG(v,self:GetCouldGetSoliders(v));
                    end
                end 
            end
        end
    end
end

--刷新单个滑动条背景图
function UIConscription:RefreshSingleSliderBG(armySlotType,mTableData,spriteBg,maxCSPNum)
    local sliderValue = self:GetMaxSliderValue(armySlotType,mTableData,maxCSPNum);
    spriteBg.fillAmount = sliderValue;
    if self.itemTables[armySlotType] ~= nil then
        if sliderValue == 0 or maxCSPNum == 0 then
            self.itemTables[armySlotType]:SetSliderInteractable(false);
        else
            self.itemTables[armySlotType]:SetSliderInteractable(true);
        end
    end
end

--滑动条可以滑到的最大位置
function UIConscription:GetMaxSliderValue(armySlotType,mTableData,maxCSPNum)   
    local heroCardData = self._armyObjTable[armySlotType];    
    --计算剩余资源够征兵多少
    local myWood = self:GetLeftResources(armySlotType,CurrencyEnum.Wood);
    local myIron = self:GetLeftResources(armySlotType,CurrencyEnum.Iron);
    local myFood = self:GetLeftResources(armySlotType,CurrencyEnum.Grain);
    local myGold = 0;
    if  self.couldUseRedifSoldier == false then 
        myGold = self:GetLeftResources(armySlotType,CurrencyEnum.Money);    
    end    
    if mTableData ~= nil then
        local woodNum = math.floor(myWood / mTableData.Wood);
        --!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!表里的是 Iorn
        local ironNum = math.floor(myIron / mTableData.Iorn);
        local foodNum = math.floor(myFood / mTableData.Food);   
        local goldNum = math.floor(myGold / mTableData.Gold)      
        --资源可以征的最多数量
        local resourceMaxNum = 0;
        if  self.couldUseRedifSoldier == true then         
            resourceMaxNum = math.min(woodNum,ironNum,foodNum);
        else
            resourceMaxNum = math.min(woodNum,ironNum,foodNum,goldNum);
        end
        local resourceCouldMaxNum = resourceMaxNum > maxCSPNum and maxCSPNum or resourceMaxNum;

        if self._isImmediatelyState then
            --预备兵可以征的最多数量
            local soldierMaxNum = self:GetLeftSoldiers(armySlotType);
            local soldierCouldMaxNum = soldierMaxNum > maxCSPNum and maxCSPNum or soldierMaxNum;
            --print("位置 "..armySlotType.." 资源可以征的最多数量： "..resourceCouldMaxNum.."  预备兵可以征的最多数量:"..soldierMaxNum.."  最终可以征兵的数量 ;"..soldierCouldMaxNum);
            if soldierCouldMaxNum <= 0 then 
                return 0;
            end
            local endValue = math.min(resourceCouldMaxNum,soldierCouldMaxNum);
            return endValue/maxCSPNum;
        end
        --最大征兵数/能征兵数
        return resourceCouldMaxNum/maxCSPNum;
    else
       --print("卡牌消耗表数据 mTableData is nil!!!!!!!!!!!!!");
    end
    return 0;
end

--获取除去一个位置后剩余的预备兵
function UIConscription:GetLeftSoldiers(armySlotType)
    if armySlotType == ArmySlotType.Back then 
        return   self.curRedifMax - self._choosedSliderCounts[ArmySlotType.Center]-self._choosedSliderCounts[ArmySlotType.Front];
    elseif armySlotType == ArmySlotType.Center then
        return   self.curRedifMax - self._choosedSliderCounts[ArmySlotType.Back]-self._choosedSliderCounts[ArmySlotType.Front];
    elseif armySlotType == ArmySlotType.Front then
        return   self.curRedifMax - self._choosedSliderCounts[ArmySlotType.Center]-self._choosedSliderCounts[ArmySlotType.Back];
    end
    return 0;
end

--获取除去一个位置后剩余的资源
function UIConscription:GetLeftResources(armySlotType,currencyEnum)
    if armySlotType == ArmySlotType.Back then 
        return   self._allHaveResource[currencyEnum] - self._middleCostResource[currencyEnum]-self._frontCostResource[currencyEnum];
    elseif armySlotType == ArmySlotType.Center then
        return   self._allHaveResource[currencyEnum] - self._backCostResource[currencyEnum]-self._frontCostResource[currencyEnum];
    elseif armySlotType == ArmySlotType.Front then
        return   self._allHaveResource[currencyEnum] - self._middleCostResource[currencyEnum]-self._backCostResource[currencyEnum];
    end
    return 0;
end

--刷新所有消耗
function UIConscription:RefreshAllCost()
    self:RefreshOnePartCost(CurrencyEnum.Wood,self._costWoodText);
    self:RefreshOnePartCost(CurrencyEnum.Iron,self._costIronText);
    self:RefreshOnePartCost(CurrencyEnum.Grain,self._costFoodText);
    if self.couldUseRedifSoldier == true then
        self._costGoldObj.gameObject:SetActive(false);
    else
        self._costGoldObj.gameObject:SetActive(true);
        self:RefreshOnePartCost(CurrencyEnum.Money,self._costGoldText);
    end
end

function UIConscription:RefreshOnePartCost(mEnum,mText)
    --print("self._backCostResource[mEnum]: "..self._backCostResource[mEnum].."self._middleCostResource[mEnum]: "..self._middleCostResource[mEnum].."self._frontCostResource[mEnum]: "..self._frontCostResource[mEnum]);
    self._allCostResource[mEnum] = self._backCostResource[mEnum]+self._middleCostResource[mEnum]+self._frontCostResource[mEnum];
    mText.text = "<color=#FFFFFF>"..self._allCostResource[mEnum].."</color><color=#e2bd75>/"..self._allHaveResource[mEnum].."</color>";
    
    --维持消耗减得产量显示
    if mEnum == CurrencyEnum.Grain then
        local lastCostValue = self.curArmy:GetKeepArmyCost(CurrencyEnum.Grain);
        local allCount = 0;
        allCount = allCount + self:GetGrainCostCount(ArmySlotType.Back);
        allCount = allCount + self:GetGrainCostCount(ArmySlotType.Center);
        allCount = allCount + self:GetGrainCostCount(ArmySlotType.Front);
        self.foodSubCount = allCount - lastCostValue;
        --print(allCount)
        if self.foodSubCount > 0 then 
            mText.text = mText.text.."\n产量<color=#e2bd75>-"..self.foodSubCount.."</color>/小时";
        end
    end
end

function UIConscription:GetGrainCostCount(armySlotType)
    local costDel = 0;
    if self._allConscriptionResourcesDatas[armySlotType] ~= nil then
        local soliders = self.curArmy:GetIndexSoldierCount(armySlotType);
        if  self._isImmediatelyState == false then
            costDel = costDel + math.floor(self._allConscriptionResourcesDatas[armySlotType].KeepFood *(self._choosedSliderCounts[armySlotType]+soliders)/100);
        else
            costDel = costDel + math.floor(self._allConscriptionResourcesDatas[armySlotType].KeepFood *(self.curChoosedRedifCount[armySlotType]+soliders)/100);
        end
    end 
    return costDel;
end

--获取DataConscriptionResources表中数据
function UIConscription:GetTableData(armySlotType)
    local mData = self._armyObjTable[armySlotType];
    if mData == nil then 
        return;
    end
    --print("mData.tableID :  "..mData.tableID);
    local mHeroData = DataHero[mData.tableID];  --静态表 
    --print("查找DataConscriptionResources表中数据 目标：  mHeroData.Star= "..mHeroData.Star.."   mHeroData.Camp= "..mHeroData.Camp.."   mHeroData.BaseArmyType= "..mHeroData.BaseArmyType);
    local mTableData =  ArmyService:Instance():GetCardDataConscriptionResources(mHeroData.Star,mHeroData.Camp,mHeroData.BaseArmyType);
    return mTableData;
end

function UIConscription:GetSliderSpriteBg(armySlotType)
    if ArmySlotType.Back == armySlotType then
        return self._backBackGround;
    elseif ArmySlotType.Center == armySlotType then
        return self._middleBackGround;
    elseif ArmySlotType.Front == armySlotType then
        return self._frontBackGround;
    end
    return nil;
end

--检测是否可以开始征兵
function UIConscription:CheckCouldConscripting()
    if self._isImmediatelyState then 
        if self.curChoosedRedifCount[ArmySlotType.Back]==0 and  self.curChoosedRedifCount[ArmySlotType.Center]==0 and self.curChoosedRedifCount[ArmySlotType.Front]==0 then
            return false;
        end
    else
        if self._choosedSliderCounts[ArmySlotType.Back]==0 and self._choosedSliderCounts[ArmySlotType.Center]==0 and self._choosedSliderCounts[ArmySlotType.Front]==0 then
            return false

        end
    end
    return true
end

--发送确定征兵消息
function UIConscription:SendConfirmConscriptionMessage()
--    if self:CheckFoodIsMinus(true) == true then
--        return;
--    end
    local msg = require("MessageCommon/Msg/C2L/Army/ArmyConscription").new();
    --开始征兵消息
    msg:SetMessageId(C2L_Army.ArmyConscription);
    msg.playerId = PlayerService:Instance():GetPlayerId();
    msg.cityBuliding = self.curBuilding._id;
    --print("+++++++++++++++++++++++++++++++++++++++++++++++++++++++"..self.curArmy.spawnSlotIndex);
    msg.armyIndex = self.curArmy.spawnSlotIndex - 1;
    msg.backNum = self._choosedSliderCounts[ArmySlotType.Back];
    msg.middleNum = self._choosedSliderCounts[ArmySlotType.Center];
    msg.frontNum = self._choosedSliderCounts[ArmySlotType.Front];
    --print("msg.playerId:"..msg.playerId.." msg.cityBuliding:"..msg.cityBuliding.."  msg.backNum:"..msg.backNum.."  msg.middleNum".. msg.middleNum.."  msg.frontNum:"..msg.frontNum);
    NetService:Instance():SendMessage(msg)
end

--发送确认立即征兵消息
function  UIConscription:SendConfirmImmediatelyConsMessage()
--    if self:CheckFoodIsMinus(false) == true then
--        return;
--    end
    local msg = require("MessageCommon/Msg/C2L/Army/ArmyImmediateConscription").new();
    --开始征兵消息
    msg:SetMessageId(C2L_Army.ArmyImmediateConscription);
    msg.playerId = PlayerService:Instance():GetPlayerId();
    msg.cityBuliding = self.curBuilding._id;
    --print("+++++++++++++++++++++++++++++++++++++++++++++++++++++++"..self.curArmy.spawnSlotIndex);
    msg.armyIndex = self.curArmy.spawnSlotIndex -1;
    msg.backNum = self:GetImmediatelyChoosedSoliders(ArmySlotType.Back);
    msg.middleNum = self:GetImmediatelyChoosedSoliders(ArmySlotType.Center);
    msg.frontNum = self:GetImmediatelyChoosedSoliders(ArmySlotType.Front);
    NetService:Instance():SendMessage(msg)
    --]]
end



--检测征兵后粮食产量是否为负数
function UIConscription:CheckFoodIsMinus(isNormalConscription)
    print("self.foodSubCount: "..self.foodSubCount)
    local isMinus = PlayerService:Instance():CheckFoodIsMinus(self.foodSubCount);
    if  isMinus == true then
        CommonService:Instance():ShowOkOrCancle(
            self,
            function()  
                if isNormalConscription == true then
                    self:SendConfirmConscriptionMessage();
                else
                    self:SendConfirmImmediatelyConsMessage();
                end
            end,
            function()  self:CancleConscriptionCallBack() end,
            "确认",
            "征兵后粮食产量将为负数，是否继续征兵",
            "确认",
            "取消");
    else
        if isNormalConscription == true then
            self:SendConfirmConscriptionMessage();
        else
            self:SendConfirmImmediatelyConsMessage();
        end
    end
end

function UIConscription:GetImmediatelyChoosedSoliders(armySlotType)
    if self.curChoosedRedifCount[armySlotType] then 
        return self.curChoosedRedifCount[armySlotType];
    else
        return 0;
    end
end

--发送取消征兵消息
function UIConscription:SendCancelConscriptionMessage(armySlotType)
    --print("UIConscription:SendCancelConscriptionMessage    发送取消位置: "..armySlotType.." 的征兵消息");
    ---[[    
    local msg = require("MessageCommon/Msg/C2L/Army/CancelArmyConscription").new();
    --取消征兵消息 
    msg:SetMessageId(C2L_Army.CancelArmyConscription);
    msg.buliding = self.curBuilding._id;
    --print("+++++++++++++++++++++++++++++++++++++++++++++++++++++++"..self.curArmy.spawnSlotIndex);
    msg.armyIndex = self.curArmy.spawnSlotIndex-1;
    --msg.armyIndex = self.curArmy.slotIndex;
    msg.slotType = armySlotType;
    NetService:Instance():SendMessage(msg)
    --]]
end

function UIConscription:OnCancelSend(armySlotType)
    local stringText = "是否确认取消为武将卡<color=#e2bd75>"..DataHero[self._armyObjTable[armySlotType].tableID].Name.."</color>";
    stringText = stringText.."所征的".."<color=#e2bd75>"..self.curArmy:GetConscriptionCount(armySlotType).."</color>兵力";
    local param = { };
    param[2] = stringText;
    ConscriptionConfirmUI:RegistConfirmEvnet(function() self:SendCancelConscriptionMessage(armySlotType) end);
    UIService:Instance():ShowUI(UIType.ConscriptionConfirmUI,param);
end

--确定征兵按钮
function UIConscription:OnClickConfirmBtn(obj)
    if self:CheckCouldConscripting() then
        local stringText = "<size=20>是否确认:</size> \n";
        --print(self._choosedSliderCounts[ArmySlotType.Back].."   "..self._choosedSliderCounts[ArmySlotType.Center].."  "..self._choosedSliderCounts[ArmySlotType.Front]);
        if self._choosedSliderCounts[ArmySlotType.Back] > 0 then 
            stringText = self:ConscripingContentTextString(stringText,ArmySlotType.Back);
        end
        if self._choosedSliderCounts[ArmySlotType.Center] > 0 then 
            stringText = self:ConscripingContentTextString(stringText,ArmySlotType.Center);
            end
        if self._choosedSliderCounts[ArmySlotType.Front] > 0 then 
            stringText = self:ConscripingContentTextString(stringText,ArmySlotType.Front);
        end
        
        local param = { };
        ConscriptionConfirmUI:RegistCancelEvnet(function() self:CancleConscriptionCallBack() end);
        if  self._isImmediatelyState == false then        
            param[1] = stringText;
            ConscriptionConfirmUI:RegistConfirmEvnet(function() self:CheckFoodIsMinus(true) end);
            UIService:Instance():ShowUI(UIType.ConscriptionConfirmUI,param);
        else
            param[3] = stringText;
            ConscriptionConfirmUI:RegistConfirmEvnet(function() self:CheckFoodIsMinus(false) end);
            UIService:Instance():ShowUI(UIType.ConscriptionConfirmUI,param);
        end
    else
        --弹出提示
        UIService:Instance():ShowUI(UIType.UICueMessageBox,81);
    end
end

function UIConscription:CancleConscriptionCallBack()
    UIService:Instance():HideUI(UIType.ConscriptionConfirmUI);
    UIService:Instance():HideUI(UIType.CommonOKOrCancle);
end

function UIConscription:ConscripingContentTextString(initString,armySlotType)   
    if  self._isImmediatelyState == false then
        initString = initString.."<color=#e2bd75>"..DataHero[self._armyObjTable[armySlotType].tableID].Name.."</color>征兵".."<color=#e2bd75>"..self._choosedSliderCounts[armySlotType]..",</color>耗时";
        initString = initString.."<color=#e2bd75>"..self:GetDateString(self:GetEndConsTimes(armySlotType, self._choosedSliderCounts[armySlotType])).."</color>\n";       
    else
        initString = initString.."对<color=#e2bd75>"..DataHero[self._armyObjTable[armySlotType].tableID].Name.."</color>立即征兵可立即获得士兵";
        initString = initString.."<color=#e2bd75>"..self.curChoosedRedifCount[armySlotType].."</color>\n"; 
    end
    return initString;
end

function UIConscription:OnClickImmediatelyBgBtn()
   UIService:Instance():ShowUI(UIType.UICueMessageBox,201);
end

-- 立即征兵
function UIConscription:OnToggleChanged(isShut)
    self._isImmediatelyState = self._nowConscriptionToggle.isOn;
    self:ResetSliderData(ArmySlotType.Back);
    self:ResetSliderData(ArmySlotType.Center);
    self:ResetSliderData(ArmySlotType.Front);
    --预备兵数量text刷新
    self:ShowRedifCountText();
    self:ShowConscriptionBtnState();
end

function UIConscription:ResetSliderData(armySlotType)
    
    if self.curArmy:GetCard(armySlotType) ~= nil then
        if self.curArmy:IsConscription(armySlotType) == false then           
            self.curChoosedRedifCount[armySlotType] = 0;
            if self.itemTables[armySlotType] ~= nil then
                self.itemTables[armySlotType]:ResetSliderValue();
                self.itemTables[armySlotType]:SetImmediatelySoliderText(self._isImmediatelyState);
            end
        end
    end
end

--关闭征兵界面
function UIConscription:OnClickCloseBtn()
    --数据重置
    self:ResetData();
    UIService:Instance():HideUI(UIType.UIConscription);
    --刷新征兵功能界面    
    local baseClass = UIService:Instance():GetUIClass(UIType.ArmyFunctionUI);
    if baseClass ~= nil then 
        baseClass:RefreshArmyPart();
        baseClass:RefreshUIShow();
    end
end

return UIConscription;