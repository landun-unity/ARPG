-- region *.lua
-- Date
local UIBase = require("Game/UI/UIBase");
local LeagueInfluence = class("LeagueInfluence", UIBase)
local List = require("common/list");
local UICityInfo = require("Game/League/UICityInfo");
require("Game/Table/model/DataUIConfig")
local CityBaseType = require("Game/Build/Building/CityBaseType")

function LeagueInfluence:ctor()

    LeagueInfluence.super.ctor(self)

    self.backBtn = nil;
    self._perfabPath = DataUIConfig[UIType.UICityInfo].ResourcePath;
    self._parentObj = nil;
    self.Ctoggle = nil;
    self.Ptoggle = nil;
    self.Ttoggle = nil;
    self.Stoggle = nil;
    self.Passtoggle = nil;
    -- 国
    self.Cten = nil;
    -- 省
    self.Pnine = nil;
    self.Peight = nil;
    -- 郡城
    self.Tten = nil;
    self.Tnine = nil;
    self.Teight = nil;
    self.Tseven = nil;
    self.Tsix = nil;
    self.Tfive = nil;
    -- 城池
    self.Seight = nil
    self.Sseven = nil;
    self.Ssix = nil;
    self.Sfive = nil;
    self.Sfour = nil;
    self.Sthree = nil;
    self.Stwo = nil;
    -- 关卡
    self.Passnine = nil;
    self.Passseven = nil;
    self.Passfive = nil;

    -- 取消
    self.allCancel = nil;

    -- 类型List
    self.influenceList = List:new()
    self.countryList = List:new()
    self.procityList = List:new()
    self.townList = List:new()
    self.smallcityList = List:new()
    self.passList = List:new()
    -- 显示List
    self.buildingList = List:new()
    self.bulidingTable = { }

    self.countryNum = 0;

    self.proCityNineNum = 0;
    self.proCityEightNum = 0;

    self.townEightNum = 0;
    self.townSevenNum = 0;
    self.townSixNum = 0;
    self.townFiveNum = 0;

    self.SeightNum = 0
    self.SsevenNum = 0;
    self.SsixNum = 0;
    self.SfiveNum = 0;
    self.SfourNum = 0;
    self.SthreeNum = 0;


    self.PassnineNum = 0;
    self.PasssevenNum = 0;
    self.PassfiveNum = 0;

    -- 选中
    self.open = true;
    self.NoFluText = nil;
end


function LeagueInfluence:DoDataExchange()
    self.allCancel = self:RegisterController(UnityEngine.UI.Button, "AllCancel");
    self.backBtn = self:RegisterController(UnityEngine.UI.Button, "back");
    self._parentObj = self:RegisterController(UnityEngine.Transform, "CityInfo/Viewport/Content");
    self.Ctoggle = self:RegisterController(UnityEngine.UI.Toggle, "CityNum/Viewport/Content/country");
    self.Ptoggle = self:RegisterController(UnityEngine.UI.Toggle, "CityNum/Viewport/Content/procity");
    self.Ttoggle = self:RegisterController(UnityEngine.UI.Toggle, "CityNum/Viewport/Content/town");
    self.Stoggle = self:RegisterController(UnityEngine.UI.Toggle, "CityNum/Viewport/Content/smallcity");
    self.Passtoggle = self:RegisterController(UnityEngine.UI.Toggle, "CityNum/Viewport/Content/pass");
    -- 国
    self.Cten = self:RegisterController(UnityEngine.UI.Text, "CityNum/Viewport/Content/country/Label/ten");
    -- 省
    self.Pnine = self:RegisterController(UnityEngine.UI.Text, "CityNum/Viewport/Content/procity/Label/nine");
    self.Peight = self:RegisterController(UnityEngine.UI.Text, "CityNum/Viewport/Content/procity/Label/eight");
    -- 郡城
    self.Tten = self:RegisterController(UnityEngine.UI.Text, "CityNum/Viewport/Content/town/Label/10");
    self.Tnine = self:RegisterController(UnityEngine.UI.Text, "CityNum/Viewport/Content/town/Label/9");
    self.Teight = self:RegisterController(UnityEngine.UI.Text, "CityNum/Viewport/Content/town/Label/8");
    self.Tseven = self:RegisterController(UnityEngine.UI.Text, "CityNum/Viewport/Content/town/Label/7");
    self.Tsix = self:RegisterController(UnityEngine.UI.Text, "CityNum/Viewport/Content/town/Label/6");
    self.Tfive = self:RegisterController(UnityEngine.UI.Text, "CityNum/Viewport/Content/town/Label/5");
    -- 城池
    self.Seight = self:RegisterController(UnityEngine.UI.Text, "CityNum/Viewport/Content/smallcity/Label/8");
    self.Sseven = self:RegisterController(UnityEngine.UI.Text, "CityNum/Viewport/Content/smallcity/Label/7");
    self.Ssix = self:RegisterController(UnityEngine.UI.Text, "CityNum/Viewport/Content/smallcity/Label/6");
    self.Sfive = self:RegisterController(UnityEngine.UI.Text, "CityNum/Viewport/Content/smallcity/Label/5")
    self.Sfour = self:RegisterController(UnityEngine.UI.Text, "CityNum/Viewport/Content/smallcity/Label/4");
    self.Sthree = self:RegisterController(UnityEngine.UI.Text, "CityNum/Viewport/Content/smallcity/Label/3");
    self.Stwo = self:RegisterController(UnityEngine.UI.Text, "CityNum/Viewport/Content/smallcity/Label/2");
    -- 关卡
    self.Passnine = self:RegisterController(UnityEngine.UI.Text, "CityNum/Viewport/Content/pass/Label/9");
    self.Passseven = self:RegisterController(UnityEngine.UI.Text, "CityNum/Viewport/Content/pass/Label/7");
    self.Passfive = self:RegisterController(UnityEngine.UI.Text, "CityNum/Viewport/Content/pass/Label/5");
    self.NoFluText = self:RegisterController(UnityEngine.UI.Text, "NoFluText");
    self.allCancelText = self:RegisterController(UnityEngine.UI.Text, "AllCancel/Text");

end

function LeagueInfluence:DoEventAdd()
    -- btn
    self:AddListener(self.backBtn.gameObject, self.OnClickbackBtn);
    self:AddListener(self.allCancel.gameObject, self.OnClickallCancelBtn);
    -- toggle
    self:AddToggleOnValueChanged(self.Ctoggle.gameObject, self.OnCtoggleChange)
    self:AddToggleOnValueChanged(self.Ptoggle.gameObject, self.OnPtoggleChange)
    self:AddToggleOnValueChanged(self.Ttoggle.gameObject, self.OnTtoggleChange)
    self:AddToggleOnValueChanged(self.Stoggle.gameObject, self.OnStoggleChange)
    self:AddToggleOnValueChanged(self.Passtoggle.gameObject, self.OnPasstoggleChange)
end


function LeagueInfluence:OnShow()

    self.influenceList = LeagueService:Instance():GetLeagueInfluenceList()
    self:GetBulidingById()
    self:OnShowToggle()
    self:ShowCardInfo(self.buildingList)

end

function LeagueInfluence:ShowCardInfo()

    self._parentObj.transform.localPosition = Vector3.zero
    for k, v in pairs(self.bulidingTable) do
        if (v.gameObject.activeSelf == true) then
            v.gameObject:SetActive(false);
        end
    end
    local size = self.buildingList:Count();
    for index = 1, size do
        local buildingIndex = self.buildingList:Get(index);
        local mBuilding = self.bulidingTable[index];
        if mBuilding == nil then
            GetFromUnVisable = false;
            mBuilding = UICityInfo.new();
            GameResFactory.Instance():GetUIPrefab(self._perfabPath, self._parentObj, mBuilding, function(go)
                mBuilding:Init();
                mBuilding:SetCityInfo(buildingIndex)
                self.bulidingTable[index] = mBuilding
            end );
        else
            self.bulidingTable[index].gameObject:SetActive(true);
            mBuilding:SetCityInfo(buildingIndex);
        end
    end

end


function LeagueInfluence:GetBulidingById()
    
    local count =  self.influenceList:Count()
    if count==0 then
        self.NoFluText.gameObject:SetActive(true)
    else
        self.NoFluText.gameObject:SetActive(false)
    end

    for i = 1, count do
        local Building = BuildingService:Instance():GetBuilding(self.influenceList:Get(i))
        if self.influenceList:Get(i) == nil then
            return;
        end
        if Building._dataInfo.CityType == CityBaseType.country then
            if self:CheakInList(Building, self.countryList) then
                self.countryList:Push(Building)
                self.countryNum = self.countryNum + 1;
            end
        elseif Building._dataInfo.CityType == CityBaseType.chiefcity then
            if self:CheakInList(Building, self.procityList) then
                self.procityList:Push(Building)
                if Building._dataInfo.level == 9 then
                    self.proCityNineNum = self.proCityNineNum + 1
                elseif Building._dataInfo.level == 8 then
                    self.proCityEightNum = self.proCityEightNum + 1
                end
            end
        elseif Building._dataInfo.CityType == CityBaseType.firstcity then
            if self:CheakInList(Building, self.townList) then
                self.townList:Push(Building)
                if Building._dataInfo.level == 8 then
                    self.townEightNum = self.townEightNum + 1
                elseif Building._dataInfo.level == 7 then
                    self.townSevenNum = self.townSevenNum + 1
                elseif Building._dataInfo.level == 6 then
                    self.townSixNum = self.townSixNum + 1
                elseif Building._dataInfo.level == 5 then
                    self.townFiveNum = self.townFiveNum + 1
                end
            end
        elseif Building._dataInfo.CityType <= CityBaseType.smallcity then
            if self:CheakInList(Building, self.smallcityList) then
                self.smallcityList:Push(Building)
                if Building._dataInfo.level == 8 then
                    self.SeightNum = self.SeightNum + 1
                elseif Building._dataInfo.level == 7 then
                    self.SsevenNum = self.SsevenNum + 1
                elseif Building._dataInfo.level == 6 then
                    self.SsixNum = self.SsixNum + 1
                elseif Building._dataInfo.level == 5 then
                    self.SfiveNum = self.SfiveNum + 1
                elseif Building._dataInfo.level == 4 then
                    self.SfourNum = self.SfourNum + 1
                elseif Building._dataInfo.level == 3 then
                    self.SthreeNum = self.SthreeNum + 1
                end
            end
        elseif Building._dataInfo.CityType == CityBaseType.passcity then
            if self:CheakInList(Building, self.passList) then

                self.passList:Push(Building)
                if Building._dataInfo.level == 9 then
                    self.PassnineNum = self.PassnineNum + 1
                elseif Building._dataInfo.level == 7 then
                    self.PasssevenNum = self.PasssevenNum + 1
                elseif Building._dataInfo.level == 5 then
                    self.PassfiveNum = self.PassfiveNum + 1
                end
            end
        end
    end

    for i = 1, self.countryList:Count() do
        if self:CheakIn(self.countryList:Get(i)) then
            self.buildingList:Push(self.countryList:Get(i))
        end
    end
    for i = 1, self.procityList:Count() do
        if self:CheakIn(self.procityList:Get(i)) then
            self.buildingList:Push(self.procityList:Get(i))
        end
    end
    for i = 1, self.townList:Count() do
        if self:CheakIn(self.townList:Get(i)) then
            self.buildingList:Push(self.townList:Get(i))
        end
    end
    for i = 1, self.smallcityList:Count() do
        if self:CheakIn(self.smallcityList:Get(i)) then
            self.buildingList:Push(self.smallcityList:Get(i))
        end
    end
    for i = 1, self.passList:Count() do
        if self:CheakIn(self.passList:Get(i)) then
            self.buildingList:Push(self.passList:Get(i))
        end
    end
    -- 国
    self.Cten.text = self.countryNum
    -- 省
    self.Pnine.text = self.proCityNineNum
    self.Peight.text = self.proCityEightNum
    -- 郡城
    self.Teight.text = self.townEightNum
    self.Tseven.text = self.townSevenNum
    self.Tsix.text = self.townSixNum
    self.Tfive.text = self.townFiveNum
    -- 城池
    self.Seight.text = self.SeightNum
    self.Sseven.text = self.SsevenNum
    self.Ssix.text = self.SsixNum
    self.Sfive.text = self.SfiveNum
    self.Sfour.text = self.SfourNum
    self.Sthree.text = self.SthreeNum
    -- 关卡
    self.Passnine.text = self.PassnineNum
    self.Passseven.text = self.PasssevenNum
    self.Passfive.text = self.PassfiveNum

end


function LeagueInfluence:CheakInList(args, list)
    for k, v in pairs(list._list) do
        if v == args then
            return false
        end
    end
    return true
end


function LeagueInfluence:CheakIn(args)

    for k, v in pairs(self.buildingList._list) do
        if v == args then
            return false
        end
    end
    return true
end


function LeagueInfluence:OnClickallCancelBtn()

    if self.open then
        self.open = false
        self.allCancelText.text = "全部选中"
        self._parentObj.gameObject:SetActive(false)
        self.Ctoggle.isOn = false
        self.Ptoggle.isOn = false
        self.Ttoggle.isOn = false
        self.Stoggle.isOn = false
        self.Passtoggle.isOn = false
    else
        self.open = false
        self.allCancelText.text = "全部取消"
        self._parentObj.gameObject:SetActive(true)
        self.Ctoggle.isOn = true
        self.Ptoggle.isOn = true
        self.Ttoggle.isOn = true
        self.Stoggle.isOn = true
        self.Passtoggle.isOn = true
    end
end

function LeagueInfluence:ChangeToggleState()
    if self.Ctoggle.isOn or self.Ptoggle.isOn or self.Ttoggle.isOn or self.Stoggle.isOn or self.Passtoggle.isOn then
        self.open = true
        self._parentObj.gameObject:SetActive(true)
        self.allCancelText.text = "全部取消"
    else
        self.open = false
        self.allCancelText.text = "全部选中"
        self._parentObj.gameObject:SetActive(false)
    end
end

function LeagueInfluence:OnClickbackBtn()

    UIService:Instance():HideUI(UIType.LeagueInfluence)

end


function LeagueInfluence:OnShowToggle()
    self:OnCtoggleChange();
    self:OnTtoggleChange();
    self:OnPtoggleChange();
    self:OnStoggleChange();
    self:OnPasstoggleChange();
end


function LeagueInfluence:OnCtoggleChange()
    self._parentObj.gameObject:SetActive(true)
    if self.Ctoggle.isOn then
        self.buildingList = self:ChangeToggle()
    else
        for i = 1, self.countryList:Count() do
            self.buildingList:Remove(self.countryList:Get(i))
        end
    end
    self:ShowCardInfo()
    self:ChangeToggleState()
end

function LeagueInfluence:OnPtoggleChange()
    self._parentObj.gameObject:SetActive(true)

    if self.Ptoggle.isOn then
        self.buildingList = self:ChangeToggle()
    else
        for i = 1, self.procityList:Count() do
            self.buildingList:Remove(self.procityList:Get(i))
        end
    end
    self:ShowCardInfo()
    self:ChangeToggleState()

end

function LeagueInfluence:OnTtoggleChange()
    self._parentObj.gameObject:SetActive(true)

    if self.Ttoggle.isOn then
        self.buildingList = self:ChangeToggle()
    else
        for i = 1, self.townList:Count() do
            self.buildingList:Remove(self.townList:Get(i))
        end
    end
    self:ShowCardInfo()
    self:ChangeToggleState()

end

function LeagueInfluence:OnStoggleChange()
    self._parentObj.gameObject:SetActive(true)

    if self.Stoggle.isOn then
        self.buildingList = self:ChangeToggle()
    else
        for i = 1, self.smallcityList:Count() do
            self.buildingList:Remove(self.smallcityList:Get(i))
        end
    end
    self:ShowCardInfo()
    self:ChangeToggleState()

end

function LeagueInfluence:OnPasstoggleChange()
    self._parentObj.gameObject:SetActive(true)

    if self.Passtoggle.isOn then
        self.buildingList = self:ChangeToggle()
    else
        for i = 1, self.passList:Count() do
            self.buildingList:Remove(self.passList:Get(i))
        end
    end
    self:ChangeToggleState()
    self:ShowCardInfo()
end


function LeagueInfluence:ChangeToggle()

    local _list = List:new();
    if self.Ctoggle.isOn then
        for i = 1, self.countryList:Count() do
            _list:Push(self.countryList:Get(i))
        end
    end
    if self.Ptoggle.isOn then
        for i = 1, self.procityList:Count() do
            _list:Push(self.procityList:Get(i))
        end
    end

    if self.Ttoggle.isOn then
        for i = 1, self.townList:Count() do
            _list:Push(self.townList:Get(i))
        end
    end

    if self.Stoggle.isOn then
        for i = 1, self.smallcityList:Count() do
            _list:Push(self.smallcityList:Get(i))
        end
    end
    if self.Passtoggle.isOn then
        for i = 1, self.passList:Count() do
            _list:Push(self.passList:Get(i))
        end
    end
    return _list
end


return LeagueInfluence