local UIBase = require("Game/UI/UIBase")

local ArmySwapUI = class("ArmySwapUI",UIBase)
local UIService=require("Game/UI/UIService")
local UIType=require("Game/UI/UIType")


function ArmySwapUI:ctor()
	ArmySwapUI.super.ctor(self)
	ArmySwapUI.instance = self;

    self.allObjParent = nil;
    self.armyIndexText2 = nil ;
    self.armyIndexText3 = nil ;
    self.armyIndexText4 = nil ;
    self.armyIndexText5 = nil ;
    self.armyIndexOneParent = nil ;
    self.armyIndexTwoParent = nil ;
    self.armyIndexThreeParent = nil ;
    self.armyIndexFourParent = nil ;
    self.armyIndexFiveParent = nil ;
    self.exitBtn = nil;

    self.armyMaxCount = 5;
    
    self.armyItemTable = {};                --键：部队位置  值：ArmySwapItem的父GameObject
    self.armyItemUiBaseDic = {};            --键：部队位置  值：ArmySwapItem脚本   

    self.curDragObj = nil;                  --当前拖拽的物体
    self.curDragUiBase = nil;               --当前拖拽的物体上的脚本    UISmallHeroCard
    self._localPointerPosition = nil;         

    self.curBuilding = nil;                 --当前城市
    self.curArmyInfo = nil;

    self.textTabel = {};
end

-- 单例
function ArmySwapUI:Instance()
    return ArmySwapUI.instance;
end

function ArmySwapUI:GetCurBuilding()
    return self.curBuilding;
end

--注册控件
function ArmySwapUI:DoDataExchange()
    self.allObjParent = self:RegisterController(UnityEngine.RectTransform,"ArmyAllObj");
    self.armyIndexText2 = self:RegisterController(UnityEngine.UI.Text,"ArmyAllObj/ArmyIndexTwo/Background/ArmyIndexText");
    self.armyIndexText3 = self:RegisterController(UnityEngine.UI.Text,"ArmyAllObj/ArmyIndexThree/Background/ArmyIndexText");
    self.armyIndexText4 = self:RegisterController(UnityEngine.UI.Text,"ArmyAllObj/ArmyIndexFour/Background/ArmyIndexText");
    self.armyIndexText5 = self:RegisterController(UnityEngine.UI.Text,"ArmyAllObj/ArmyIndexFive/Background/ArmyIndexText");
    self.armyIndexOneParent = self:RegisterController(UnityEngine.RectTransform,"ArmyAllObj/ArmyIndexOne");
    self.armyIndexTwoParent = self:RegisterController(UnityEngine.RectTransform,"ArmyAllObj/ArmyIndexTwo");
    self.armyIndexThreeParent = self:RegisterController(UnityEngine.RectTransform,"ArmyAllObj/ArmyIndexThree");
    self.armyIndexFourParent = self:RegisterController(UnityEngine.RectTransform,"ArmyAllObj/ArmyIndexFour");
    self.armyIndexFiveParent = self:RegisterController(UnityEngine.RectTransform,"ArmyAllObj/ArmyIndexFive");
 	self.exitBtn = self:RegisterController(UnityEngine.UI.Button,"ReturnBtn");

    self.textTabel[2] = self.armyIndexText2;
    self.textTabel[3] = self.armyIndexText3;
    self.textTabel[4] = self.armyIndexText4;
    self.textTabel[5] = self.armyIndexText5;
end

--注册点击事件
function ArmySwapUI:DoEventAdd()    
	self:AddOnClick(self.exitBtn,self.OnCilckExitBtn);
end

-- 注册 部队更新的通知
function ArmySwapUI:RegisterAllNotice()
    self:RegisterNotice(L2C_Army.ArmyBaseInfo, self.ArmyBaseCallBack)
end

-- 部队更新回调
function ArmySwapUI:ArmyBaseCallBack()
    --刷新部队信息         
    self:RefreshArmyInformations();
end

-- 显示 展示用队伍1的数据
function ArmySwapUI:OnShow(armyInfo)
    self.armyItemTable[1] = self.armyIndexOneParent;
    self.armyItemTable[2] = self.armyIndexTwoParent;
    self.armyItemTable[3] = self.armyIndexThreeParent;
    self.armyItemTable[4] = self.armyIndexFourParent;
    self.armyItemTable[5] = self.armyIndexFiveParent;
    self.curArmyInfo = armyInfo;
    self:RefreshArmyInformations();
end

--显示所有的队伍信息
function ArmySwapUI:RefreshArmyInformations()
    local building = BuildingService.Instance():GetBuilding(self.curArmyInfo.spawnBuildng);
    self.curBuilding = building;
    for i = 1 ,self.armyMaxCount do
        local  mArmyInfo = building:GetArmyInfo(i);
        if self.armyItemUiBaseDic[i] == nil then
            local dataConfig = DataUIConfig[UIType.ArmySwapItem];
            local uiBase = require(dataConfig.ClassName).new(); 
            GameResFactory.Instance():GetUIPrefab(dataConfig.ResourcePath, self.armyItemTable[i], uiBase, function(go)
                uiBase:Init();
                uiBase:SetArmyInformation(mArmyInfo,self.allObjParent);
                if self.curBuilding:CheckArmySlotIndexOpen(i) == true then
                    uiBase.gameObject:SetActive(true);
                    self:SetBgText(i,false);
                else
                    self:SetBgText(i,true);
                    uiBase.gameObject:SetActive(false);
                end
                self.armyItemUiBaseDic[i] = uiBase;
            end);
        else
            self.armyItemUiBaseDic[i]:SetArmyInformation(mArmyInfo,self.allObjParent);
            if self.curBuilding:CheckArmySlotIndexOpen(i) == true then           
                self:SetBgText(i,false);
                self.armyItemUiBaseDic[i].gameObject:SetActive(true);
            else
                self:SetBgText(i,true);
                self.armyItemUiBaseDic[i].gameObject:SetActive(false);
            end  
        end
    end
end

function ArmySwapUI:SetBgText(index,isShow)
    if self.textTabel[index] ~= nil then 
        self.textTabel[index].gameObject:SetActive(isShow);
    else
        --print(index.." 位置的text 为nil");
    end
end

--检测拖拽的卡牌是否到某个队伍下的某个ArmySlotType 框中
function ArmySwapUI:CheckDragEndInKuang()
    --print("ArmySwapItem 个数 ："..#self.armyItemUiBaseDic);
    local isInItem = false;
    for i = 1, #self.armyItemUiBaseDic do
        isInItem = self.armyItemUiBaseDic[i]:CheckInItemIndex();
        --print(isInItem);
        if isInItem then
            self.armyItemUiBaseDic[i]:ResetItemPointerPosition();
            self._localPointerPosition = nil;
            return isInItem;
        end
    end    
    return false;
end

--根据部队位置获取ArmySwapItem脚本
function ArmySwapUI:GetIndexArmySwapItem(armyIndex)
    if  self.armyItemUiBaseDic[armyIndex] ~= nil then 
        return self.armyItemUiBaseDic[armyIndex];
    end
    return nil;
end

--根据部队位置获取ArmySwapItem预制的父物体
function ArmySwapUI:GetIndexParent(armyIndex)
    if  self.armyItemTable[armyIndex] ~= nil then 
        return self.armyItemTable[armyIndex];
    end
    return nil;
end

function ArmySwapUI:OnCilckExitBtn()
	UIService:Instance():HideUI(UIType.ArmySwapUI);
end

function ArmySwapUI:SetDrogObj(drogObj)
    self.curDragObj = drogObj;
end

function ArmySwapUI:GetDrogObj()
    return self.curDragObj;
end

function ArmySwapUI:SetDrogObjUiBase(uiBase)
    self.curDragUiBase = uiBase;
end

function ArmySwapUI:GetDrogObjUiBase()
    return self.curDragUiBase;
end

function ArmySwapUI:SetPointerPosition(localPosition)
    self._localPointerPosition = localPosition;
end

function ArmySwapUI:GetPointerPosition()
    return self._localPointerPosition;
end

return ArmySwapUI;
