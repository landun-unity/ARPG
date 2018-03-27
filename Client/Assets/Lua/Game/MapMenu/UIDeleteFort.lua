--[[
    自建要塞
--]]

local UIBase= require("Game/UI/UIBase");
local UIDeleteFort=class("UIDeleteFort",UIBase);        
local UIService=require("Game/UI/UIService");
local UIType=require("Game/UI/UIType");
require("Game/Table/InitTable");

--构造函数
function UIDeleteFort:ctor()
    UIDeleteFort.super.ctor(self);
    self.abandon = nil;
    self.curTiledIndex = nil;
    self.closeBtn = nil;
    self.BuildingPlusFirst = nil;
    self.BuildingPlusLast = nil;
    self.BuildingPlusOneFirst = nil;
    self.BuildingPlusOneLast = nil;
    self.facilitylevel = nil;
    self._imagepanel = nil;

    
    self.time = nil
    self.upgradeInterval = nil;
end


function UIDeleteFort:DoDataExchange()    
    self.abandon = self:RegisterController(UnityEngine.UI.Button,"abandon/Button");
    self.closeBtn = self:RegisterController(UnityEngine.UI.Button,"backGround/closeBtn")
    self.BuildingPlusFirst = self:RegisterController(UnityEngine.UI.Text,"TextGrid/BuildingPlus/BuildingPlusFirst");
    self.BuildingPlusLast = self:RegisterController(UnityEngine.UI.Text,"TextGrid/BuildingPlus/BuildingPlusLast");
    self.BuildingPlusOneFirst = self:RegisterController(UnityEngine.UI.Text,"TextGrid/BuildingPlusOne/BuildingPlusOneFirst");
    self.BuildingPlusOneLast = self:RegisterController(UnityEngine.UI.Text,"TextGrid/BuildingPlusOne/BuildingPlusOneLast");
    self.facilitylevel = self:RegisterController(UnityEngine.UI.Text,"BuildingImage/FacilityItem/facilitylevel");
    self._imagepanel = self:RegisterController(UnityEngine.UI.Image,"BuildingImage/FacilityItem/imagepanel")
    self.time = self:RegisterController(UnityEngine.UI.Text,"BuildingImage/FacilityItem/time")
end

function UIDeleteFort:DoEventAdd()
    self:AddListener(self.abandon,self.OnClickaBandon);
    self:AddListener(self.closeBtn,self.OnClickCloseBtn)
end

function UIDeleteFort:RegisterAllNotice()
    self:RegisterNotice(L2C_Player.SyncBuildingInfo, self.ShowDeleteState)
end

function UIDeleteFort:OnShow(curTiledIndex)
    self.curTiledIndex = curTiledIndex;
    local level = BuildingService:Instance():GetBuildingByTiledId(self.curTiledIndex)._fortGrade;
    if level ~= nil then
    if level == 1 then
        self.BuildingPlusFirst.text = DataBuilding[40001].TroopsInTown;
        self.BuildingPlusLast.text = DataBuilding[40002].TroopsInTown;
        self.BuildingPlusOneFirst.text = DataBuilding[40001].DurabilityBonus;
        self.BuildingPlusOneLast.text = DataBuilding[40002].DurabilityBonus
        self.facilitylevel.text = "1/5"
    elseif level == 2 then
        self.BuildingPlusFirst.text = DataBuilding[40002].TroopsInTown;
        self.BuildingPlusLast.text = DataBuilding[40003].TroopsInTown;
        self.BuildingPlusOneFirst.text = DataBuilding[40002].DurabilityBonus;
        self.BuildingPlusOneLast.text = DataBuilding[40003].DurabilityBonus
        self.facilitylevel.text = "2/5"
    elseif level == 3 then
        self.BuildingPlusFirst.text = DataBuilding[40003].TroopsInTown;
        self.BuildingPlusLast.text = DataBuilding[40004].TroopsInTown;   
        self.BuildingPlusOneFirst.text = DataBuilding[40003].DurabilityBonus;
        self.BuildingPlusOneLast.text = DataBuilding[40004].DurabilityBonus
        self.facilitylevel.text = "3/5"
    elseif level == 4 then
        self.BuildingPlusFirst.text = DataBuilding[40004].TroopsInTown;
        self.BuildingPlusLast.text = DataBuilding[40005].TroopsInTown; 
        self.BuildingPlusOneFirst.text = DataBuilding[40004].DurabilityBonus;
        self.BuildingPlusOneLast.text = DataBuilding[40005].DurabilityBonus  
        self.facilitylevel.text = "4/5"
    elseif level == 5 then
        self.BuildingPlusFirst.text = DataBuilding[40005].TroopsInTown;
        self.BuildingPlusLast.text = "--";
        self.BuildingPlusOneFirst.text = DataBuilding[40005].DurabilityBonus;
        self.BuildingPlusOneLast.text = "--";
        self.facilitylevel.text = "5/5"              
    end
    end
    self:ShowDeleteState()
end

function UIDeleteFort:ShowDeleteState()
    local building = BuildingService:Instance():GetBuildingByTiledId(self.curTiledIndex)
    if building == nil then
        return
    end
    if self.upgradeTimer ~= nil then
        self.time.gameObject:SetActive(false)
        self.upgradeTimer:Stop()
    end
    if building._buildDeleteTime - PlayerService:Instance():GetLocalTime() > 0 then
        self:ShowComplete()
        self.upgradeInterval = building._buildDeleteTime - PlayerService:Instance():GetLocalTime()
        local needTime = DataBuilding[40001].DemolishTime;
        self:TimeDown(building,needTime);
    else
        self:_Complete();
    end
end

function UIDeleteFort:ShowComplete()
    self._imagepanel.fillAmount = 1;
    self._imagepanel.gameObject:SetActive(true);
    self.time.gameObject:SetActive(true);
    -- self.updateIcon.gameObject:SetActive(true);
end

function UIDeleteFort:_Complete()
    self._imagepanel.gameObject:SetActive(false);
    self.time.gameObject:SetActive(false)
end

-- 拆除倒计时
function UIDeleteFort:TimeDown(building,needTime)
    local cdTime = math.floor((building._buildDeleteTime - PlayerService:Instance():GetLocalTime())/1000);
    self.time.text = CommonService:Instance():GetDateString(cdTime);
    self.time.gameObject:SetActive(true)
    CommonService:Instance():TimeDown(nil,building._buildDeleteTime,self.time, function() self:_Complete() end,nil,needTime,self._imagepanel);
end

function UIDeleteFort:OnClickCloseBtn()
	UIService:Instance():HideUI(UIType.UIDeleteFort)
end

function UIDeleteFort:OnClickaBandon()
    local building = BuildingService:Instance():GetBuildingByTiledId(self.curTiledIndex)
    local tiled = MapService:Instance():GetTiledByIndex(self.curTiledIndex)
    if  building~= nil and building._buildDeleteTime > PlayerService:Instance():GetLocalTime() then
        local msg = require("MessageCommon/Msg/C2L/Building/DeleteFortTimer").new();
        msg:SetMessageId(C2L_Building.DeleteFortTimer);
        msg.tiledIndex = self.curTiledIndex
        NetService:Instance():SendMessage(msg);
        MapService:Instance():HideFortTimeBox(self.curTiledIndex)
    elseif tiled ~= nil and tiled.tiledInfo.giveUpLandTime > PlayerService:Instance():GetLocalTime() then
        local msg = require("MessageCommon/Msg/C2L/Army/CancelGiveUpOwnerLand").new();
        msg:SetMessageId(C2L_Army.CancelGiveUpOwnerLand)
        msg.tiledIndex = self.curTiledIndex
        NetService:Instance():SendMessage(msg)
        local building = BuildingService:Instance():GetBuildingByTiledId(self.curTiledIndex)
        if building ~= nil then
            local baseClass = UIService:Instance():GetUIClass(UIType.UIUpgradeBuilding);
            if baseClass ~= nil then
                baseClass:SetFortResources();
            end
            UIService:Instance():HideUI(UIType.UIDeleteFort);
            UIService:Instance():ShowUI(UIType.UIUpgradeBuilding, self.curTiledIndex);
        end
    end
end

return UIDeleteFort