-- region *.lua
-- Date16/10/19

local UIBase = require("Game/UI/UIBase")

local underMemberLeagueUI = class("underMemberLeagueUI", UIBase)

require("Game/Table/model/DataState")

function underMemberLeagueUI:ctor()

    underMemberLeagueUI.super.ctor(self);
    self.playerid = nil;
    self.name = nil;
    self.coord = nil;
    self.nameBtn = nil;
    self.coordBtn = nil;
    self.tiled = nil;
    self.tiledId = nil;
end


function underMemberLeagueUI:DoDataExchange()

    self.name = self:RegisterController(UnityEngine.UI.Text, "nameButton/nameText");

    self.coord = self:RegisterController(UnityEngine.UI.Text, "Coord");
    self.coordBtn = self:RegisterController(UnityEngine.UI.Button, "Coord/btn");
    self.nameBtn = self:RegisterController(UnityEngine.UI.Button, "nameButton")
    self.state = self:RegisterController(UnityEngine.UI.Text, "Location")


end

function underMemberLeagueUI:SetMemberLeagueMessage(munderMemberLeagueUI)


    self.playerid = munderMemberLeagueUI.playerId
    self.name.text = munderMemberLeagueUI.name;
    local x,y = MapService:Instance():GetTiledCoordinate(munderMemberLeagueUI.coord)
    local stateID = PmapService:Instance():GetStateIDbyIndex(munderMemberLeagueUI.coord)
    self.coord.text = "" .. "(" .. x .. "," .. y .. ")";
    self.state.text = DataState[stateID].Name
    self.tiledId = munderMemberLeagueUI.coord;
end


function underMemberLeagueUI:DoEventAdd()

    self:AddListener(self.nameBtn, self.OnClicknameBtn)
    self:AddListener(self.coordBtn, self.OnClickcoordBtn)

end


function underMemberLeagueUI:DoEventAdd()

    self:AddListener(self.appiontBtn, self.OnClickappiontBtn)
    self:AddListener(self.nameBtn, self.OnClicknameBtn)
    self:AddListener(self.coordBtn, self.OnClickcoordBtn)

end


function underMemberLeagueUI:OnClickcoordBtn()
    -- body
    local x,y = MapService:Instance():GetTiledCoordinate(self.tiledId)
        self.temp = { };
    self.temp[1] = "是否跳转到坐标<color=#599ba9>(" .. x .. "," .. y .. ")</color>"
    self.temp[2] = self;
    self.temp[3] = self.CommonOk;
    UIService:Instance():ShowUI(UIType.CommonGoToPosition, self.temp)

end
-- 获取格子耐久

function underMemberLeagueUI:CommonOk()
 
    MapService:Instance():ScanTiled(self.tiledId);
    UIService:Instance():ShowUI(UIType.UIGameMainView);
    UIService:Instance():HideUI(UIType.LeagueMemberUI);
    UIService:Instance():HideUI(UIType.LeagueExistUI)
end


function underMemberLeagueUI:CommonCancle() 
     UIService:Instance():HideUI(UIType.CommonOkOrCancle);
end

function underMemberLeagueUI:OnClicknameBtn()
    -- 请求成员信息
    local msg = require("MessageCommon/Msg/C2L/Player/RequestOtherPlayerBaseInfo").new();
    msg:SetMessageId(C2L_Player.RequestOtherPlayerBaseInfo);
    msg.playerId = self.playerid;
    NetService:Instance():SendMessage(msg);
end

return underMemberLeagueUI
-- endregion
