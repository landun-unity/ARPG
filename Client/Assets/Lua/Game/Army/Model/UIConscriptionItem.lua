--region *.lua
--Date
local UIBase = require("Game/UI/UIBase");
local UIConscriptionItem = class("UIConscriptionItem",UIBase)
require("Game/Army/ArmySlotType");

function UIConscriptionItem:ctor()    
    UIConscriptionItem.super.ctor(self)
    self._itemObj = nil;
    self._CurText = nil;                        -- 当前兵力/最大兵力
    self._MaxConscriptionText = nil;            -- 最大征兵数量 
    self._ComscriptinonText = nil;              -- 征兵数量 
    self._UseTimeText = nil;                    -- 大营预计用时  
    self._ImmediateText = nil;                  -- 大营立即转为士兵
    self._ComscritingStateObj = nil;            -- 正在征兵   
    self._CancelTimeBtn = nil;                  -- 取消征兵  
    self._Slider = nil;                         -- 滑动条   
    self._ParentObj = nil;                      -- 征兵头像设置父物体       
    self._BackGround = nil;                     -- 滑动条背景    
    self._WarningText = nil;
    self._PositionText = nil;

    self.armyInfo = nil;
    self.armySlotType = ArmySlotType.None;
    self.UIConscriptionScript = nil;            -- UIConscription脚本
    self.uiSmallHeroCard = nil;
    self.sliderCouldMove = true;
end

function UIConscriptionItem:DoDataExchange()
    self._itemObj = self:RegisterController(UnityEngine.Transform, "ConscriptionTroopItem");
    self._CurText = self:RegisterController(UnityEngine.UI.Text, "ConscriptionTroopItem/ConscriptionObj/AtPresentTroopsText");
    self._MaxConscriptionText = self:RegisterController(UnityEngine.UI.Text, "ConscriptionTroopItem/ConscriptionObj/MaximumTextBg/MaximumText");
    self._ComscriptinonText = self:RegisterController(UnityEngine.UI.Text, "ConscriptionTroopItem/ConscriptionObj/ConscriptionText/NumberText");
    self._UseTimeText = self:RegisterController(UnityEngine.UI.Text, "ConscriptionTroopItem/ConscriptionObj/TimeText");
    self._ImmediateText = self:RegisterController(UnityEngine.UI.Text, "ConscriptionTroopItem/ConscriptionObj/NowSoldier");
    self._ComscritingStateObj = self:RegisterController(UnityEngine.Transform, "ConscriptionTroopItem/ConscriptingStateUi");
    self._CancelTimeBtn = self:RegisterController(UnityEngine.UI.Button, "ConscriptionTroopItem/ConscriptingStateUi/ConscriptionFrontObj/BackCancelButton");
    self._Slider = self:RegisterController(UnityEngine.UI.Slider, "ConscriptionTroopItem/ConscriptionObj/Slider");
    self._ParentObj = self:RegisterController(UnityEngine.Transform, "ConscriptionTroopItem/ConscriptionObj/GeneralParentObj") ;   
    self._BackGround = self:RegisterController(UnityEngine.UI.Image, "ConscriptionTroopItem/ConscriptionObj/Slider/Background");
    self._WarningText = self:RegisterController(UnityEngine.UI.Text, "ItemMainBg/BG/Text");
    self._PositionText = self:RegisterController(UnityEngine.UI.Text, "ItemMainBg/PositionImage/PositionText");
end

function UIConscriptionItem:DoEventAdd()
    self:AddSliderOnValueChanged(self._Slider, self.OnSliderChanged);
    self:AddOnUp(self._Slider, self.OnSliderUp);
    self:AddListener(self._CancelTimeBtn,self.OnClickCancelBtn)
end

function UIConscriptionItem:SetInformation(UiConscriptionBase,armyInfo,armySlotType,heroCard)
    self.UIConscriptionScript = UiConscriptionBase;
    self.armySlotType = armySlotType;
    self.armyInfo = armyInfo;
    if heroCard == nil then
        self:SetItemEnable(false,armyInfo);
    else
        self:SetItemEnable(true,armyInfo);
    end
    self:SetPosition(armySlotType);
    self:LoadSmallCard(armyInfo,armySlotType,heroCard);
    self:SetImmediatelySoliderText(false);
end

function UIConscriptionItem:SetPosition(armySlotType)
    if armySlotType == ArmySlotType.Front then
        self._PositionText.text = "前锋";
    elseif armySlotType == ArmySlotType.Center then
        self._PositionText.text = "中军";
    elseif armySlotType == ArmySlotType.Back then
        self._PositionText.text = "大营";
    end
end

function UIConscriptionItem:ResetSliderValue(isRefresh)
    self._Slider.value = 0;
    local maxNumber = self.UIConscriptionScript:GetCouldGetSoliders(self.armySlotType);
    if isRefresh ~= nil and isRefresh == false then
        return;
    end
    self:RefreshSingleSliderBG(self.armySlotType,maxNumber);
    self._ComscriptinonText.text = 0;
end

function UIConscriptionItem:SetSliderInteractable(could)
    --self._Slider.interactable = could;
     self.sliderCouldMove = could;
end

function UIConscriptionItem:SetImmediatelySoliderText(show)
    self._ImmediateText.gameObject:SetActive(show);
    self._UseTimeText.gameObject:SetActive(show == false and true or false);
end

function UIConscriptionItem:LoadSmallCard(armyInfo,armySlotType,heroCard)    
    if self.uiSmallHeroCard ~= nil then
        if heroCard ~= nil then
            self.uiSmallHeroCard.gameObject:SetActive(true);
            self.uiSmallHeroCard:SetUISmallHeroCardMessage(heroCard,false);
            self.uiSmallHeroCard:SetArmyCountFalse();
            self.uiSmallHeroCard:SetCardSoliderCount(armyInfo:GetIndexSoldierCount(armySlotType));
            self:ShowConscriptionState(armyInfo,armySlotType);
        else
            self.uiSmallHeroCard.gameObject:SetActive(false);
        end
    else
        local dataconfig = DataUIConfig[UIType.UISmallHeroCard];
        local uiBase = require(dataconfig.ClassName).new();
        GameResFactory.Instance():GetUIPrefab(dataconfig.ResourcePath, self._ParentObj, uiBase, function(go)
            uiBase:Init();
            self.uiSmallHeroCard = uiBase;
            if heroCard ~= nil then
                self.uiSmallHeroCard.gameObject:SetActive(true);
                uiBase:SetUISmallHeroCardMessage(heroCard,false);
                uiBase:SetArmyCountFalse();
                uiBase:SetCardSoliderCount(armyInfo:GetIndexSoldierCount(armySlotType));
                self:ShowConscriptionState(armyInfo,armySlotType);
            else
                self.uiSmallHeroCard.gameObject:SetActive(false);
            end
        end );
    end
end

function UIConscriptionItem:ShowConscriptionState(armyInfo,armySlotType) 
    local isConscripting = armyInfo:IsConscription(armySlotType);
    if isConscripting == true then
        self._ComscritingStateObj.gameObject:SetActive(true);
        self._MaxConscriptionText.transform.parent.gameObject:SetActive(false);
        self._ComscriptinonText.transform.parent.gameObject:SetActive(false);
        --self._Slider.interactable = false;
        self.sliderCouldMove = false;
        self._BackGround.fillAmount = 0;
        self._CurText.text = "<color=#e2bd75>征兵数量</color>"..armyInfo:GetIndexSoldierCount(armySlotType).."<color=#e2bd75>+"..armyInfo:GetConscriptionCount(armySlotType).."</color>";
        local curTimeStamp = PlayerService:Instance():GetLocalTime();
        local endTimeStamp = armyInfo:GetConscriptionEndTime(armySlotType);
        local valueTime = math.ceil(endTimeStamp - curTimeStamp);
        if valueTime <= 0 then
            valueTime = 0;
        end
        local cdTime = math.floor(valueTime/1000)
        self._UseTimeText.text = self.UIConscriptionScript:GetDateString(cdTime,true);
        CommonService:Instance():TimeDown(UIType.UIConscription,endTimeStamp,self._UseTimeText,function() self._UseTimeText.text = "<color=#e2bd75>预计时间:</color>00:00:00"; end);
    else
        self.sliderCouldMove = true;
        self._ComscritingStateObj.gameObject:SetActive(false);
        self._MaxConscriptionText.transform.parent.gameObject:SetActive(true);
        self._ComscriptinonText.transform.parent.gameObject:SetActive(true);
        self._CurText.text = "<color=#e2bd75>当前兵力</color>"..armyInfo:GetIndexSoldierCount(armySlotType).."<color=#e2bd75>/"..self.UIConscriptionScript:GetMaxSoliders(armySlotType).."</color>";
        CommonService:Instance():RemoveTimeDownInfo(self._UseTimeText.transform.gameObject);
        self._UseTimeText.text = "<color=#e2bd75>预计时间:</color>00:00:00";
        local maxNumber = self.UIConscriptionScript:GetCouldGetSoliders(armySlotType);
        self._MaxConscriptionText.text = maxNumber;
        self:RefreshSingleSliderBG(armySlotType,maxNumber);
    end 
end

function UIConscriptionItem:RefreshSingleSliderBG(armySlotType,maxNumber)
    self.UIConscriptionScript:RefreshSingleSliderBG(armySlotType,self.UIConscriptionScript:GetTableData(armySlotType),self._BackGround,maxNumber);
end

function UIConscriptionItem:SetItemEnable(enable,armyInfo)
    self._itemObj.gameObject:SetActive(enable);
    if enable == fasle then
        if armyInfo ~= nil then
            if armyInfo:CheckArmyOpenFront() == true then
                self._WarningText.text ="<color=#EE5050FF>未配置武将</color>";    
            else
                self._WarningText.text = "<color=#EE5050FF>未开放\n统帅厅Lv."..armyInfo.spawnSlotIndex.."开启</color>";  
            end
        end
    end
end

function UIConscriptionItem:OnSliderChanged()
    if self.UIConscriptionScript ~= nil then
        if self.sliderCouldMove == true then
            self.UIConscriptionScript:OnSliderChanged(self.armySlotType,self._Slider,self._UseTimeText,self._ComscriptinonText);
        else
            self:ResetSliderValue(false);
        end
    end
end

function UIConscriptionItem:OnSliderUp()
    if self.UIConscriptionScript ~= nil then
        if self.sliderCouldMove == true  then
            self.UIConscriptionScript:OnSliderUp(self.armySlotType,self._Slider,self._UseTimeText,self._ComscriptinonText);
        else
             if self.armyInfo ~= nil then
                if self.armyInfo:IsConscription(self.armySlotType) == true then
                    UIService:Instance():ShowUI(UIType.UICueMessageBox,72);
                end
            end
        end
    end
end

function UIConscriptionItem:OnClickCancelBtn()
    if self.UIConscriptionScript ~= nil then
        self.UIConscriptionScript:OnCancelSend(self.armySlotType);
    end
end

return UIConscriptionItem
