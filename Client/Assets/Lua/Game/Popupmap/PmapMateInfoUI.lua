-- region *.lua
-- Date
-- 此文件由[BabeLua]插件自动生成
-- region *.lua
-- Date 
local UIBase = require("Game/UI/UIBase");
local PmapMateInfoUI = class("PmapMateInfoUI", UIBase)

function PmapMateInfoUI:ctor()

    PmapMateInfoUI.super.ctor(self)
    self.posx = nil;
    self.posy = nil;
    self.id = nil;
    self.tiledId = nil;
    self.playerid = nil;
    self.Panel = nil;
    self.title = nil;
    self.deleteBtn = nil;
    self.data = nil;
    self.publistID = nil;
    self.ConfirmMember = nil
end


function PmapMateInfoUI:DoDataExchange()
    self.InfoName = self:RegisterController(UnityEngine.UI.Text, "NameBtn/InfoName");
    self.InfoTitle = self:RegisterController(UnityEngine.UI.Text, "BottomBlue/InfoTitle");
    self.Posx = self:RegisterController(UnityEngine.UI.Text, "Button/Posx");
    self.Posy = self:RegisterController(UnityEngine.UI.Text, "Button/Posy");
    self.InfoIntro = self:RegisterController(UnityEngine.UI.Text, "InfoIntro");
    self.MarkPos = self:RegisterController(UnityEngine.UI.Text, "MarkPos");
    self.confirmBtn = self:RegisterController(UnityEngine.UI.Button, "Confirm");
    self.ConfirmMember = self:RegisterController(UnityEngine.UI.Button, "ConfirmMember");
    self.button = self:RegisterController(UnityEngine.UI.Button, "Button");
    self.NameBtn = self:RegisterController(UnityEngine.UI.Button, "NameBtn");
    self.Panel = self:RegisterController(UnityEngine.UI.Button, "Panel");
    self.title = self:RegisterController(UnityEngine.UI.Text, "title");
    self.deleteBtn = self:RegisterController(UnityEngine.UI.Button, "delete");
end

function PmapMateInfoUI:DoEventAdd()
    self:AddListener(self.confirmBtn, self.OnClickconfirmBtn)
    self:AddListener(self.ConfirmMember, self.OnClickConfirmMember)
    self:AddListener(self.button, self.OnClickbutton)
    self:AddListener(self.NameBtn, self.OnClickNameBtn)
    self:AddListener(self.Panel, self.OnClickPanel)
    self:AddListener(self.deleteBtn, self.OnClickdeleteBtn)
end


function PmapMateInfoUI:OnShow(data)

    self.data = data
    self.id = self.data[6]
    self.playerid = self.data[9]
    self.InfoTitle.text = self.data[10]
    self.InfoName.text = self.data[8]
    self.publistID = self.data[9]
    self.posx = self.data[3]
    self.posy = self.data[4]
    self:SetTitle(self.data[10])
    self.tiledId = self.data[5]
    self:SetName(MapService:Instance():GetTiledByIndex(self.tiledId))
    self.Posx.text = self.posx
    self.Posy.text = self.posy
    self.InfoIntro.text = self.data[7]
    if self.data[2] then
        self.confirmBtn.gameObject:SetActive(true)
        self.deleteBtn.gameObject:SetActive(true)
        self.ConfirmMember.gameObject:SetActive(false)
    else
        self.confirmBtn.gameObject:SetActive(false)
        self.deleteBtn.gameObject:SetActive(false)
        self.ConfirmMember.gameObject:SetActive(true)
    end
end

function PmapMateInfoUI:SetTitle(title)
    if title == LeagueTitleType.Leader then
        self.title.text = "盟主";
    elseif title == LeagueTitleType.ViceLeader then
        self.title.text = "副盟主";
    elseif title == LeagueTitleType.Command then
        self.title.text = "指挥官";
    elseif title == LeagueTitleType.Officer then
        self.title.text = "官员";
    elseif title == LeagueTitleType.Nomal then
        self.title.text = "";
    end
end

function PmapMateInfoUI:SetName(tiled)

    local tiledInfo = MapService:Instance():GetDataTiled(tiled)
    if tiledInfo ~= nil then
        local town = tiled:GetTown();
        if town ~= nil then
            local building = town._building
            if building ~= nil then
                local name = building._name
                if building._dataInfo.Type == BuildingType.MainCity or building._dataInfo.Type == BuildingType.SubCity then
                    self.MarkPos.text = name .. "-城区";
                else
                    self.MarkPos.text = building._dataInfo.Name .. "-城区 <color=#FFE384>Lv." .. tiledInfo.TileLv .. "</color>"
                end
            end
            return
        end


        local building = tiled:GetBuilding()
        if building ~= nil then
            if building._owner ~= 0 then
                if building._dataInfo.Type == BuildingType.MainCity then
                    self.MarkPos.text = tiled.tiledInfo.ownerName;
                elseif building._dataInfo.Type == BuildingType.SubCity then
                    self.MarkPos.text = building._name;
                elseif building._dataInfo.Type == BuildingType.PlayerFort then
                    self.MarkPos.text = building._name;
                elseif building._dataInfo.Type == BuildingType.WildFort then
                    self.MarkPos.text = "野外要塞";
                else
                    self.MarkPos.text = building._dataInfo.Name .. "<color=#FFE384>Lv." .. tiledInfo.TileLv .. "</color>"
                end
            else
                local name = building._name;
                self.MarkPos.text = building._dataInfo.Name;
            end
        else
            self.MarkPos.text = " <color=#FFE384>土地Lv." ..self.data[11] .. "</color>";
        end
    else
        self.MarkPos.text = " <color=#FFE384>土地Lv." .. self.data[11].. "</color>";
    end
end


function PmapMateInfoUI:OnClickconfirmBtn()
    UIService:Instance():HideUI(UIType.PmapMateInfoUI)
end


function PmapMateInfoUI:OnClickdeleteBtn()
    LeagueService:Instance():RemoveLeagueMark(self.id)
    UIService:Instance():HideUI(UIType.PmapMateInfoUI)
end

function PmapMateInfoUI:OnClickbutton()
    self.temp = { };
    self.temp[1] = "是否跳转到坐标<color=#599ba9>(" .. self.posx .. "," .. self.posy .. ")</color>"
    self.temp[2] = self;
    self.temp[3] = self.CommonOk;
    UIService:Instance():ShowUI(UIType.CommonGoToPosition, self.temp)
end

function PmapMateInfoUI:CommonOk()
    UIService:Instance():GetUIClass(UIType.UIPmap):ChangeInputField(self.posx, self.posy)
    UIService:Instance():GetUIClass(UIType.UIPmap):MoveToClickMateAndMark(self.posx, self.posy)
    MapService:Instance():ScanTiled(self.tiledId, nil, 0, true);
    UIService:Instance():ShowUI(UIType.UIGameMainView);
    UIService:Instance():HideUI(UIType.PmapMateInfoUI);
    UIService:Instance():HideUI(UIType.UIPmap);
end

function PmapMateInfoUI:OnClickNameBtn()
    if self.playerid == PlayerService:Instance():GetPlayerId() then
        UIService:Instance():ShowUI(UIType.UIPersonalPower);
    else
        local msg = require("MessageCommon/Msg/C2L/Player/RequestOtherPlayerBaseInfo").new();
        msg:SetMessageId(C2L_Player.RequestOtherPlayerBaseInfo);
        print(self.playerid)
        msg.playerId = self.playerid
        NetService:Instance():SendMessage(msg);
    end
end
function PmapMateInfoUI:CommonCancle(...)
    UIService:Instance():HideUI(UIType.CommonOkOrCancle);
end

function PmapMateInfoUI:OnClickPanel()
    UIService:Instance():HideUI(UIType.PmapMateInfoUI)
end

function PmapMateInfoUI:OnClickConfirmMember()
    UIService:Instance():HideUI(UIType.PmapMateInfoUI)
end
return PmapMateInfoUI


-- endregion
