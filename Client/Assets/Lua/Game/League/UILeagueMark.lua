-- region *.lua
-- Date
local UIBase = require("Game/UI/UIBase");
local UILeagueMark = class("UILeagueMark", UIBase)

function UILeagueMark:ctor()

    UILeagueMark.super.ctor(self)

    self.name = nil
    self.intro = nil;
    self.cancelBtn = nil;
    self.confirm = nil;
    self.typeText = nil;
    self.coord = nil;
    self.coordx = nil;
    self.coordy = nil;
end


function UILeagueMark:DoDataExchange()

    self.name = self:RegisterController(UnityEngine.UI.InputField, "name")
    self.intro = self:RegisterController(UnityEngine.UI.InputField, "intro")
    self.cancelBtn = self:RegisterController(UnityEngine.UI.Button, "cancel")
    self.confirm = self:RegisterController(UnityEngine.UI.Button, "confirm")
    self.typeText = self:RegisterController(UnityEngine.UI.Text, "type")
    self.coord = self:RegisterController(UnityEngine.UI.Text, "coord")

end

function UILeagueMark:DoEventAdd()

    self:AddListener(self.confirm.gameObject, self.OnClickconfirmBtn);
    self:AddListener(self.cancelBtn.gameObject, self.OnClickcancelBtn);

end

function UILeagueMark:OnShow(data)
    self.name.text = "";
    self.intro.text = ""
    self.coordx = data[1]
    self.coordy = data[2]
    self.coord.text = self.coordx .. "," .. self.coordy
    self.typeText.text = "土地资源："
    local index = MapService:Instance():GetTiledIndex(self.coordx, self.coordy);
    local tiled = MapService:Instance():GetTiledByIndex(index);
    self:SetName(tiled)
end

function UILeagueMark:SetName(tiled)
    local tiledInfo = MapService:Instance():GetDataTiled(tiled)
    if tiledInfo ~= nil then
        local town = tiled:GetTown();
        if town ~= nil then
            local building = town._building
            if building ~= nil then
                local name = building._name
                if building._dataInfo.Type == BuildingType.MainCity or building._dataInfo.Type == BuildingType.SubCity then
                    self.typeText.text = name .. "-城区";
                else
                    self.typeText.text = building._dataInfo.Name .. "-城区 <color=#FFE384>Lv." .. tiledInfo.TileLv .. "</color>"
                end
            end
            return
        end
        local building = tiled:GetBuilding()
        if building ~= nil then
            if building._owner ~= 0 then
                if building._dataInfo.Type == BuildingType.MainCity then
                    self.typeText.text = tiled.tiledInfo.ownerName;
                elseif building._dataInfo.Type == BuildingType.SubCity then
                    self.typeText.text = building._name;
                elseif building._dataInfo.Type == BuildingType.PlayerFort then
                    self.typeText.text = building._name;
                elseif building._dataInfo.Type == BuildingType.WildFort then
                    self.typeText.text = "野外要塞";
                else
                    self.typeText.text = building._dataInfo.Name .. "<color=#FFE384>Lv." .. tiledInfo.TileLv .. "</color>"
                end
            else
                local name = building._name;
                self.typeText.text = building._dataInfo.Name;
            end
        else
            self.typeText.text = " <color=#FFE384>土地Lv." .. tiledInfo.TileLv .. "</color>";
        end
    end
end

function UILeagueMark:OnClickconfirmBtn()
    local _index = MapService:Instance():GetTiledIndex(self.coordx, self.coordy);
    if self.name.text == "" or self.intro.text == "" or string.len(self.name.text) > 18 or string.len(self.intro.text) > 60 then
        UIService:Instance():ShowUI(UIType.UICueMessageBox, UICueMessageType.LeagueMarkWriteFalseInfo)
        return
    end

    local name = string.gsub(self.name.text, "^%s*(.-)%s*$", "%1");
    local intro = string.gsub(self.intro.text, "^%s*(.-)%s*$", "%1");
    if name == "" or intro == "" then
        UIService:Instance():ShowUI(UIType.UICueMessageBox, UICueMessageType.LeagueMarkWriteFalseInfo)
        return
    end

    if CommonService:Instance():LimitText(self.name.text) then
        UIService:Instance():ShowUI(UIType.UICueMessageBox, UICueMessageType.LeagueMarkWriteFalseInfo)
        return
    end
    if CommonService:Instance():LimitText(self.intro.text) then
        UIService:Instance():ShowUI(UIType.UICueMessageBox, UICueMessageType.LeagueMarkWriteFalseInfo)
        return
    end

    LeagueService:Instance():SendAddLeagueMarkMessage(self.name.text, _index, self.intro.text)

end

function UILeagueMark:OnClickcancelBtn()

    UIService:Instance():HideUI(UIType.UILeagueMark)

end








return UILeagueMark