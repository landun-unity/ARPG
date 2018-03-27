local UIBase = require("Game/UI/UIBase")

local ArmySwapItem = class("ArmySwapItem",UIBase)
local UIService = require("Game/UI/UIService")
local UIType = require("Game/UI/UIType")
local ArmySwapUI =  require("Game/Army/Model/ArmySwapUI")
local NowArmyState = require("Game/Army/ArmyState")

function ArmySwapItem:ctor()
	ArmySwapItem.super.ctor(self)

    self.armyIndexText = nil;
    self.commanderText = nil;
    self.armyStateText = nil;
    self.frontShowText = nil;
    self.backParent = nil;
    self.middleParent = nil;
    self.frontParent = nil;

    self.additionBtn = nil;                 --加成点击按钮
    self.leftRightObj = nil;
    self.speedText = nil;                   --部队速度
    self.cityAttackText = nil;              --部队攻城值
    self.soliderAddImage = nil;
    self.campAddImage = nil;
    self.campLines = nil;                   --阵营加成线     

    self.backArea = nil;                    --大营拖动检测区域
    self.middleArea = nil;                  --中军拖动检测区域
    self.frontArea = nil;                   --前锋拖动检测区域
    self.allParent = nil;                   --"UIPrefab_ArmySwap/ArmyAllObj"

    self.cardObjTable = {};                 --键：ArmySlotType    值:卡牌GameObject上的脚本 UISmallHeroCard
    self.armyObjSlotTypeDic = {};           --键：卡牌GameObject  值:ArmySlotType
    self.armyObjUiBaseDic = {};             --键：卡牌GameObject  值:卡牌GameObject上的脚本 UISmallHeroCard  
    self.armyIndexBgObjDic = {};            --键：部队位置的父GameObject  值:UISmallHeroCard   (用于拖动区域检测)  
    self.armyBgObjSlotTypeDic = {};         --键：部队位置的父GameObject  值:ArmySlotType

    self._curDragObj = nil;                 --当前拖拽的物体（唯一）
    self.curDragUiBase = nil;               --当前拖拽物体上的脚本UISmallHeroCard
    self._localPointerPosition = nil;       --不拖拽时为nil
    self.curArmyInfo = nil;                 --当前的部队信息
end

--注册控件
function ArmySwapItem:DoDataExchange()
    self.additionBtn = self:RegisterController(UnityEngine.UI.Button,"LeftArmyShowInformation/Image");
    self.soliderAddImage = self:RegisterController(UnityEngine.UI.Image,"LeftArmyShowInformation/Image/SoliderAddImage");
    self.campAddImage = self:RegisterController(UnityEngine.UI.Image,"LeftArmyShowInformation/Image/CampAddImage");
    self.titleAddImage = self:RegisterController(UnityEngine.UI.Image,"LeftArmyShowInformation/Image/TitleAddImage");
    self.campLines = self:RegisterController(UnityEngine.RectTransform,"LeftArmyShowInformation/Image/HighLightLines");    	
    self.armyIndexText = self:RegisterController(UnityEngine.UI.Text,"LeftArmyShowInformation/NumberBg/ArmyIndex");
    self.commanderText = self:RegisterController(UnityEngine.UI.Text,"LeftArmyShowInformation/Image/CommanderText");
    self.armyStateText = self:RegisterController(UnityEngine.UI.Text,"LeftArmyShowInformation/Image/Bottom/ArmyStateText");
    self.frontShowText = self:RegisterController(UnityEngine.UI.Text,"HeroCards/Front/Text");
    self.leftRightObj = self:RegisterController(UnityEngine.RectTransform,"LeftArmyShowInformation/LeftRightObj");
    self.speedText = self:RegisterController(UnityEngine.UI.Text,"LeftArmyShowInformation/LeftRightObj/SpeedEncircleImage/SpeedText");
    self.cityAttackText = self:RegisterController(UnityEngine.UI.Text,"LeftArmyShowInformation/LeftRightObj/CityAttackImage/CityAttackText");
    self.backParent = self:RegisterController(UnityEngine.RectTransform,"HeroCards/Back");
    self.middleParent = self:RegisterController(UnityEngine.RectTransform,"HeroCards/Middle");
    self.frontParent = self:RegisterController(UnityEngine.RectTransform,"HeroCards/Front");
    self.backArea = self:RegisterController(UnityEngine.RectTransform,"HeroCards/Back/BgImage");
    self.middleArea = self:RegisterController(UnityEngine.RectTransform,"HeroCards/Middle/BgImage");
    self.frontArea = self:RegisterController(UnityEngine.RectTransform,"HeroCards/Front/BgImage");
end

function ArmySwapItem:DoEventAdd()
    self:AddListener(self.additionBtn, self.OnClickAdditionBtn);
end

--点击加成
function ArmySwapItem:OnClickAdditionBtn()
    UIService:Instance():ShowUI(UIType.ArmyAdditionUI,self.curArmyInfo);
end

-- 显示
function ArmySwapItem:OnShow(param)
       
end

--设置部队的显示信息
function ArmySwapItem:SetArmyInformation(armyInfo,parentObj)
    if armyInfo == nil then
        --print("armyInfo is nil!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!");
        return;
    end
    self.allParent = parentObj;
    --刷新（加载）一个队伍的UI
    self:RefreshArmyUIInfo(armyInfo);   
end

function ArmySwapItem:RefreshArmyUIInfo(armyInfo)
    self.curArmyInfo = armyInfo;
    
    --print("ArmySwapItem  部队位置：  "..armyInfo.spawnSlotIndex.." 部队所属城市："..armyInfo.spawnBuildng);
    if self.curArmyInfo  ~= nil  then
        --左边信息
        self.armyIndexText.text =  armyInfo.spawnSlotIndex;
        self.commanderText.text =  armyInfo:GetArmyAllCost().."/"..armyInfo:GetArmyMaxCost();
        self.armyStateText.text = CommonService:Instance():FormatArmyState(armyInfo:GetArmyState());

        --设置加成显示
        self:SetArmyAdditions(armyInfo);

        --速度和攻城值显示
        local curArmyCardCounts =  armyInfo:GetCardCount();
        if curArmyCardCounts <= 0 then 
            self.leftRightObj.gameObject:SetActive(false);
            self.armyStateText.gameObject:SetActive(false);
        else
            self.armyStateText.gameObject:SetActive(true);

            local isconscripting =  self.curArmyInfo:IsArmyInConscription();
            if isconscripting == true then
                self.armyStateText.text = "<color=#FFFFFFFF>征兵</color>";
            else
                if self.curArmyInfo:IsArmyIsBadlyHurt() ==true then
                    self.armyStateText.text = "<color=#D94444FF>重伤</color>"; 
                else
                    if self.curArmyInfo:IsArmyIsTired() ==true then
                        self.armyStateText.text = "<color=#D94444FF>疲劳</color>"; 
                    else
                        self.armyStateText.text = CommonService:Instance():FormatArmyState(armyInfo:GetArmyState());
                    end
                end
            end          
            
            self.leftRightObj.gameObject:SetActive(true);
            local speedAdd = FacilityService:Instance():GetCityPropertyByFacilityProperty(self.curArmyInfo.spawnBuildng, FacilityProperty.ArmySpeed);
            if speedAdd > 0 then
                self.speedText.text = armyInfo:GetSpeed() .. "+<color=#FFFF00>" .. speedAdd.."</color>";
            else
                self.speedText.text = armyInfo:GetSpeed();
            end
            self.cityAttackText.text = armyInfo:GetAllAttackCityValue();
        end

        --右边卡牌
        self:LoadSmallCard(ArmySlotType.Back);
        self:LoadSmallCard(ArmySlotType.Center);
        self:LoadSmallCard(ArmySlotType.Front);
    end
end

--设置部队加成图片显示（兵种、阵营、称号）
function ArmySwapItem:SetArmyAdditions(armyInfo)
    if armyInfo == nil then 
        print("armyInfo is nil !")
        return;
    end
    --兵种加成
    local soldierAdd = armyInfo:CheckSoldierAddition();
    self.soliderAddImage.sprite = (soldierAdd == true and GameResFactory.Instance():GetResSprite("Soldiers") or GameResFactory.Instance():GetResSprite("SoldiersGrey"));   
    --阵营加成
    local campAdd = armyInfo:CheckCampAddition();
    self.campAddImage.sprite = (campAdd == true and GameResFactory.Instance():GetResSprite("Position") or GameResFactory.Instance():GetResSprite("PositionGrey"));   
    local addedCamp = -1;
    if campAdd == true then 
        addedCamp = armyInfo:GetAddedCamp();
    end
    for i =1 ,self.campAddImage.transform.childCount do
        local item = self.campAddImage.transform:GetChild(i-1);
        if i == addedCamp then 
           item.gameObject:SetActive(true);
        else
           item.gameObject:SetActive(false); 
        end
    end
    --阵营加成线
    self.campLines.gameObject:SetActive(campAdd);
    if  campAdd == true then
        for i =1 ,self.campLines.childCount do
            local item = self.campLines:GetChild(i-1);
            if i == addedCamp then 
               item.gameObject:SetActive(true);
            else
               item.gameObject:SetActive(false); 
            end
        end
    end
end

function ArmySwapItem:LoadSmallCard(armySlotType)
    local isGray = false;
    if self.curArmyInfo:GetArmyState() ~= ArmyState.None or self.curArmyInfo:IsConscription(armySlotType)
        or self.curArmyInfo:CheckArmyCardIsHurt(armySlotType) or self.curArmyInfo:CheckArmyCardIsTired(armySlotType) then
        isGray = true;
    end
    if self.cardObjTable[armySlotType] == nil then 
        local dataConfig = DataUIConfig[UIType.UISmallHeroCard];
        local uiBase = require(dataConfig.ClassName).new();
        local parentTransform = self:GetParentObj(armySlotType);
        GameResFactory.Instance():GetUIPrefab(dataConfig.ResourcePath, parentTransform, uiBase, function(go)
            uiBase:Init();
            if uiBase.gameObject then
                self:AddOnDown(uiBase, self.OnDownStartBtn);
                self:AddOnUp(uiBase, function()self:OnUpStartBtn(); end);
                self:AddOnDrag(uiBase, self.OnDragStartBtn);
                uiBase:SetClickModel(false);
                self.cardObjTable[armySlotType] = uiBase;
                self.armyIndexBgObjDic[parentTransform.gameObject] = uiBase;            
                self.armyBgObjSlotTypeDic[parentTransform.gameObject] = armySlotType;
                self.armyObjSlotTypeDic[uiBase.gameObject] = armySlotType;
                self.armyObjUiBaseDic[uiBase.gameObject] = uiBase;
                          
                if self.curArmyInfo:GetCard(armySlotType) ~= nil then
                    uiBase.gameObject:SetActive(true);           
                    uiBase:SetUISmallHeroCardMessage(self.curArmyInfo:GetCard(armySlotType),isGray);
                    uiBase:SetCardCostTrue();
                    uiBase:SetCardSoliderCount(self.curArmyInfo:GetIndexSoldierCount(armySlotType));
                    if self.curArmyInfo:GetArmyState() ~= ArmyState.None then
                        uiBase:SetGrayCardIcon(true);
                    else
                        self:ShowSmallCardState(self.curArmyInfo,armySlotType,uiBase);
                    end                     
                else
                    uiBase.gameObject:SetActive(false);
                    self.frontShowText.text = "未配置";
                end
                self:CheckInfo(armySlotType,uiBase);
            end
        end);
    else
        if self.curArmyInfo:GetCard(armySlotType) ~= nil then
            self.cardObjTable[armySlotType].gameObject:SetActive(true);           
            self.cardObjTable[armySlotType]:SetUISmallHeroCardMessage(self.curArmyInfo:GetCard(armySlotType),isGray);
            self.cardObjTable[armySlotType]:SetCardCostTrue();
            self.cardObjTable[armySlotType]:SetCardSoliderCount(self.curArmyInfo:GetIndexSoldierCount(armySlotType));
            if self.curArmyInfo:GetArmyState() ~= ArmyState.None then
                self.cardObjTable[armySlotType]:SetGrayCardIcon(true);
            else
                self:ShowSmallCardState(self.curArmyInfo,armySlotType,self.cardObjTable[armySlotType]);
            end
        else
            self:CheckInfo(armySlotType,self.cardObjTable[armySlotType]);
            self.cardObjTable[armySlotType].gameObject:SetActive(false);
        end
    end
end

--设置小卡的征兵、疲劳重伤状态
function ArmySwapItem:ShowSmallCardState(armyInfo,armySlotType,uiBase)
    local isInConscripting = armyInfo:IsConscription(armySlotType);
    uiBase:SetGrayCardIcon(isInConscripting);
    if isconscripting == true then
        uiBase:SetCardInConscripting(true,"<color=#FFFFFFFF>征兵</color>");
    else
        if self.curArmyInfo:CheckArmyCardIsHurt(armySlotType) == true then
            uiBase:SetCardInConscripting(true,"<color=#D94444FF>重伤</color>");
        else
            if self.curArmyInfo:CheckArmyCardIsTired(armySlotType) == true then
                uiBase:SetCardInConscripting(true,"<color=#D94444FF>疲劳</color>");
            else
                uiBase:SetCardInConscripting(false);
            end
        end
    end
end

--前锋信息检测
function ArmySwapItem:CheckInfo(armySlotType,uiBase)
    if self.curArmyInfo:CheckArmyOpenFront() == true then
        self.frontShowText.text = "未配置";  
    else
        self.frontShowText.text = "未开放\n统帅厅Lv."..self.curArmyInfo.spawnSlotIndex.."开放";
    end
end



function ArmySwapItem:ResetItemPointerPosition()
    if self._localPointerPosition ~= nil then 
        self._localPointerPosition = nil;
    end
end

--检测是否拖拽到该队伍某个位置下
function ArmySwapItem:CheckInItemIndex()
    --print("开始检测第"..self.curArmyInfo.spawnSlotIndex.."条ArmySwapItem");
    self._localPointerPosition = ArmySwapUI:Instance():GetPointerPosition();
    if self._localPointerPosition == nil then
        --print("第"..self.curArmyInfo.spawnSlotIndex.."条ArmySwapItem._localPointerPosition is nil   return false"); 
        return false;
    else
        --print("开始检查是否拖到框中   armyIndexBgObjDic.size:"..#self.armyIndexBgObjDic);
        local parentTransform = ArmySwapUI:Instance():GetIndexParent(self.curArmyInfo.spawnSlotIndex).localPosition;
        for k, v in pairs(self.armyIndexBgObjDic) do
            --print("开始匹配位置: "..self.armyBgObjSlotTypeDic[k]);
            local vecTemp = k.transform.localPosition;
            local fWidth = k.gameObject:GetComponent(typeof(UnityEngine.RectTransform)).rect.width / 2;
            local fHeight = k.gameObject:GetComponent(typeof(UnityEngine.RectTransform)).rect.height / 2;
            -- 如果在框内
            --此处由于比较的两物体坐标系位置不同，需要把Y得相对位置加上才可以比较
            vecTemp.y =  vecTemp.y + parentTransform.y;
            if ((vecTemp.x - self._localPointerPosition.x <= fWidth) and(vecTemp.x - self._localPointerPosition.x >=(0 - fWidth)) and(vecTemp.y - self._localPointerPosition.y <= fHeight) and(vecTemp.y - self._localPointerPosition.y >=(0 - fHeight))) then
                -- 如果数据一样就返回
               -- print("第"..self.curArmyInfo.spawnSlotIndex.."条ArmySwapItem检测结果：在框中!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! ,框的位置:  部队"..self.curArmyInfo.spawnSlotIndex.." ArmySlotType:"..self.armyBgObjSlotTypeDic[k]);
                --print("拖拽的卡牌id："..ArmySwapUI:Instance():GetDrogObjUiBase().curHeroCard.id)
                              
                --先判断是否拖到自己身上
                local endArmySwapItem = ArmySwapUI:Instance():GetIndexArmySwapItem(self.curArmyInfo.spawnSlotIndex);

                if endArmySwapItem.curArmyInfo:GetCard(self.armyBgObjSlotTypeDic[k]) ~= nil then
                    --print("拖拽到的位置的卡牌id："..endArmySwapItem.curArmyInfo:GetCard(self.armyBgObjSlotTypeDic[k]).id);
                end

                --UISmallHeroCard 当前拖拽的卡牌
                local dragedUiBase = ArmySwapUI:Instance():GetDrogObjUiBase();
                --print(dragedUiBase.curHeroCard.id);

                --拖拽到的位置的卡牌
                local endCardUiBase = endArmySwapItem.curArmyInfo:GetCard(self.armyBgObjSlotTypeDic[k]);
                
                --当前拖拽的卡牌所在的队伍 ArmyInfo
                --print("  !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!     "..self.curArmyInfo.spawnBuildng);       
                local drogArmyBuilding = BuildingService:Instance():GetBuilding(self.curArmyInfo.spawnBuildng);
                local drogArmyInfo = drogArmyBuilding:GetArmyInfoByCardId(dragedUiBase.curHeroCard.id);

                --------------------------------------------------首要条件判断检测------------------------------------------
                 --队伍状态检测
                if self:CheckArmyOperationState(self.curArmyInfo) == false then
                    return;                   
                end
                if self:CheckArmyOperationState(endArmySwapItem.curArmyInfo)==false then 
                    return;
                end
                --卡牌征兵状态检测
                local drogedCardIndex = self.curArmyInfo:GetCardArmySlotType(ArmySwapUI:Instance():GetDrogObjUiBase().curHeroCard.id);
                if self:CheckCardState(self.curArmyInfo,drogedCardIndex) == false then
                    UIService:Instance():ShowUI(UIType.UICueMessageBox,72);
                    return;
                end
                if self:CheckCardState(endArmySwapItem.curArmyInfo,self.armyBgObjSlotTypeDic[k]) == false then
                    UIService:Instance():ShowUI(UIType.UICueMessageBox,72);
                    return;
                end



                --判断部队是否开启
                local buildingId = 0;
                buildingId = self.curArmyInfo.spawnBuildng;
                if buildingId == 0 then
                    local mainCityTiledId = PlayerService:Instance():GetMainCityTiledId();
                    buildingId = BuildingService:Instance():GetBuildingByTiledId(mainCityTiledId)._id; 
                end
                local building = BuildingService:Instance():GetBuilding(buildingId);
                if building:CheckArmySlotIndexOpen(self.curArmyInfo.spawnSlotIndex) == false then
                    return;
                end
                --如果是前锋位置要先判断卡槽是否开启
                if self.armyBgObjSlotTypeDic[k] == ArmySlotType.Front then
                    if self.curArmyInfo:CheckArmyOpenFront() == false then
                        UIService:Instance():ShowUI(UIType.UICueMessageBox,83);
                        return;
                    end
                end
                --------------------------------------------------首要条件判断检测--------------------------------------------
                local sameArmy = self:CheckEndInSameArmy(drogArmyInfo,endArmySwapItem.curArmyInfo);
                --拖拽到空位置
                if endCardUiBase == nil  then
                    --print("跟空位置换")
                    if self:CheckCostValueMaxWithNone(false,sameArmy,true,endArmySwapItem.curArmyInfo) == true then 
                        UIService:Instance():ShowUI(UIType.UICueMessageBox,70); 
                        return;
                    else
                        --print("发送交换信息!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"); 
                        self:SendChangeArmyMsg(self.curArmyInfo.spawnBuildng,endArmySwapItem.curArmyInfo.spawnSlotIndex-1,self.armyBgObjSlotTypeDic[k],drogArmyInfo.spawnSlotIndex-1,drogArmyInfo:GetCardArmySlotType(dragedUiBase.curHeroCard.id));                
                    end
                else
                    --拖拽到有卡牌的位置
                    
                    if  endCardUiBase.id == dragedUiBase.curHeroCard.id then
                        --print("拖拽到自身，返回!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!");
                        return;
                    else
                        local drogToArmyIndex = self.curArmyInfo.spawnSlotIndex;                        
                        local drogArmyIndex = drogArmyInfo.spawnSlotIndex;

                        --print("drogArmyIndex"..drogArmyIndex.."  drogToArmyIndex:"..drogToArmyIndex);
                        if drogArmyIndex == drogToArmyIndex then 
                            self:SendChangeArmyMsg(self.curArmyInfo.spawnBuildng,endArmySwapItem.curArmyInfo.spawnSlotIndex-1,self.armyBgObjSlotTypeDic[k],drogArmyInfo.spawnSlotIndex-1,drogArmyInfo:GetCardArmySlotType(dragedUiBase.curHeroCard.id));
                        else
                            if self:CheckCostValueMaxWithNone(false,sameArmy,false,endArmySwapItem.curArmyInfo,endCardUiBase) == true or self:CheckCostValueMaxWithNone(true,sameArmy,false,drogArmyInfo,endCardUiBase) == true then 
                                UIService:Instance():ShowUI(UIType.UICueMessageBox,70); 
                                return;
                            else
                                --print("发送交换信息!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!");
                                self:SendChangeArmyMsg(self.curArmyInfo.spawnBuildng,endArmySwapItem.curArmyInfo.spawnSlotIndex-1,self.armyBgObjSlotTypeDic[k],drogArmyInfo.spawnSlotIndex-1,drogArmyInfo:GetCardArmySlotType(dragedUiBase.curHeroCard.id));                    
                            end 
                        end                                          
                    end
                end            
                return true;
            else
                --print("第"..self.curArmyInfo.spawnSlotIndex.." 条位置"..self.armyBgObjSlotTypeDic[k].."  检测结果： 不在框中");
            end
        end
    end
end;

function ArmySwapItem:CheckEndInSameArmy(drogArmyInfo,endArmyInfo)
    if drogArmyInfo.spawnSlotIndex == endArmyInfo.spawnSlotIndex then
        return true;
    end
    return false;
end

--检测cost值上限是否超出   isSameArmy是否是同一个队伍的交换  isNilIndex = true空位置的情况   isNilIndex = false拖拽到的位置有卡牌的情况
function ArmySwapItem:CheckCostValueMaxWithNone(isDrogArmy,isSameArmy,isNilIndex,armyInfo,endCard)

    local maxCost = ArmySwapUI:Instance():GetCurBuilding():GetCityPropertyByFacilityProperty(FacilityProperty.Cost);
    --print("最大的cost"..maxCost); 

    local drogedCard = ArmySwapUI:Instance():GetDrogObjUiBase().curHeroCard;         
    local drogCost = drogedCard:GetHeroCostValue();
    --print("drogCost:"..drogCost)

    local armyCostAll = armyInfo:GetArmyAllCost();
    --print("拖拽到的位置的总cost："..armyCostAll);
    
    
     
    if isNilIndex == true and isSameArmy == false then
        if armyCostAll + drogCost > maxCost then
            return true;
        end
    else        
        --拖到的位置的卡牌的cost
        if endCard ~= nil then
            local endIndexCost = endCard:GetHeroCostValue();
            if isDrogArmy == false then
                if armyCostAll + drogCost - endIndexCost > maxCost then  
                    return true;
                end
            else
                if armyCostAll -drogCost + endIndexCost > maxCost then  
                    return true;
                end
            end
        end
    end
    return false;
end

--部队配置时检测状态  不再城市中不可以配置
function ArmySwapItem:CheckArmyOperationState(armyInfo)
    if  armyInfo.armyState ~= ArmyState.None then
        UIService:Instance():ShowUI(UIType.UICueMessageBox,66);
        return false;
    end
    return true;
end

--检测部队中卡牌的征兵状态
function ArmySwapItem:CheckCardState(armyInfo,armySlotType)
    if armyInfo == nil or  armySlotType == nil then
        return true;
    else
        if armyInfo:IsConscription(armySlotType) == true then
            return false;
        end
    end
    return true;
end

function ArmySwapItem:SendChangeArmyMsg(spawnBuildng,LeftBuildingSlotIndex,LeftArmySlotIndex,RightBuildingSlotIndex,RightArmySlotIndex)
    --print("部队互换界面 发送交换消息 "..spawnBuildng.."  "..LeftBuildingSlotIndex.."  "..LeftArmySlotIndex.."  "..RightBuildingSlotIndex.."   "..RightArmySlotIndex);
    local msg=require("MessageCommon/Msg/C2L/Army/ExchangeArmyCard").new();
    msg:SetMessageId(C2L_Army.ExchangeArmyCard);
    msg.BuildingId = spawnBuildng;
    msg.LeftBuildingSlotIndex = LeftBuildingSlotIndex;
    msg.LeftArmySlotIndex = LeftArmySlotIndex;
    msg.RightBuildingSlotIndex = RightBuildingSlotIndex;
    msg.RightArmySlotIndex = RightArmySlotIndex;

    NetService:Instance():SendMessage(msg);
end

--按下
function ArmySwapItem:OnDownStartBtn(obj, eventData)
    --print(" 按下！！！！！！！！！！！"..obj.name);
    self._curDragObj = ArmySwapUI:Instance():GetDrogObj();
    self.curDragUiBase = ArmySwapUI:Instance():GetDrogObjUiBase();
    local isGray = false;
    if self.curArmyInfo:GetArmyState() ~= ArmyState.None or self.curArmyInfo:IsConscription(armySlotType)
        or self.curArmyInfo:CheckArmyCardIsHurt(armySlotType) or self.curArmyInfo:CheckArmyCardIsTired(armySlotType) then
        isGray = true;
    end
    if self._curDragObj == nil then
        --print("第一次拖拽，加载拖拽物");
        local mdata = DataUIConfig[UIType.UISmallHeroCard];
        local uiBase = require(mdata.ClassName).new();
        GameResFactory.Instance():GetUIPrefab(mdata.ResourcePath, self.allParent, uiBase, function(go)
            uiBase:Init();
            if uiBase.gameObject then
                uiBase:SetUISmallHeroCardMessage(self.curArmyInfo:GetCard(self.armyObjSlotTypeDic[obj]),isGray);
                uiBase:SetCardSoliderCount(self.curArmyInfo:GetIndexSoldierCount(self.armyObjSlotTypeDic[obj]));
                self._curDragObj = uiBase.gameObject;
                self.curDragUiBase = uiBase; 
                ArmySwapUI:Instance():SetDrogObj(uiBase.gameObject);
                ArmySwapUI:Instance():SetDrogObjUiBase(uiBase);
                self._curDragObj.transform.position = eventData.position;
                uiBase.gameObject:SetActive(false);
            end
        end );
   else
       --print("拖拽物已加载");
       self.curDragUiBase:SetUISmallHeroCardMessage(self.curArmyInfo:GetCard(self.armyObjSlotTypeDic[obj]),isGray);
   end
end

--拖拽中
function ArmySwapItem:OnDragStartBtn(obj, eventData)
    
    local heroCard = ArmySwapUI:Instance():GetDrogObjUiBase().curHeroCard;
    local isConscripting = self.curArmyInfo:IsConscription(self.curArmyInfo:GetCardArmySlotType(heroCard.id));
    if isConscripting == true then 
        UIService:Instance():ShowUI(UIType.UICueMessageBox,71);
        self._localPointerPosition = nil;
        return;
    end
    if self.curArmyInfo:GetArmyState() ~= ArmyState.None then
        UIService:Instance():ShowUI(UIType.UICueMessageBox,66);
        self._localPointerPosition = nil;
        return;
    end
    self._curDragObj.transform.position = eventData.position;
    local localPositonVec3 = UnityEngine.Vector3.zero;
    localPositonVec3.z = self._curDragObj.transform.localPosition.z;
    local _localPosition = nil;
    local _canvas = UIService:Instance():GetUIRootCanvas();
    local isBoolPositon, _localPosition = UnityEngine.RectTransformUtility.ScreenPointToLocalPointInRectangle(self.allParent.gameObject:GetComponent(typeof(UnityEngine.RectTransform)),eventData.position,_canvas.worldCamera);
    self._localPointerPosition = _localPosition;
    ArmySwapUI:Instance():SetPointerPosition(_localPosition);
    if isBoolPositon then
        localPositonVec3.x = _localPosition.x;
        localPositonVec3.y = _localPosition.y;
        self._curDragObj.gameObject:SetActive(true);
        self._curDragObj.gameObject.transform.localPosition = localPositonVec3;
    end
end

--松开
function ArmySwapItem:OnUpStartBtn(obj, eventData)
    --print("松开！！！！！！！！！！！！                  ");
    if self._curDragObj ~= nil then
        self._curDragObj:SetActive(false);
    end

    --如果是拖拽才检测
    if self._localPointerPosition == nil then 
        --print("self._localPointerPosition is nil ");
        return;
    else
        -- 检测 是否在框中
        local mInArmyKuang = ArmySwapUI:Instance():CheckDragEndInKuang();
    end 
end

function ArmySwapItem:GetParentObj(armySlotType)
    if ArmySlotType.Back == armySlotType then
        return self.backParent;
    elseif ArmySlotType.Center == armySlotType then
        return self.middleParent;
    elseif ArmySlotType.Front == armySlotType then
        return self.frontParent;
    end
    return nil;
end

return ArmySwapItem;