-- region *.lua
-- Date
local UIBase = require("Game/UI/UIBase")
local UIService = require("Game/UI/UIService")
local UIType = require("Game/UI/UIType")
local DataState = require("Game/Table/model/DataState")
local AddMemberUI = class("AddMemberUI", UIBase);

function AddMemberUI:ctor()

    AddMemberUI.super.ctor(self);
    self.influence = nil;
    self.name = nil;
    self.playerid = nil;
    self.isInvited = nil;
    self.province = nil;
    self.coord = nil;
    self._nameBtn = nil;
    self._coord = nil
    self._ApplyBtn = nil;
    self.state = nil;
    self._distance = nil
end

function AddMemberUI:DoDataExchange()

    self.name = self:RegisterController(UnityEngine.UI.Text, "Name/Text");
    self.influence = self:RegisterController(UnityEngine.UI.Text, "influence");
    self._distance = self:RegisterController(UnityEngine.UI.Text, "Image/coord");
    self.province = self:RegisterController(UnityEngine.UI.Text, "locationText");
    self.state = self:RegisterController(UnityEngine.UI.Text, "ApplyBtn/Text");
    self._nameBtn = self:RegisterController(UnityEngine.UI.Button, "Name");
    self._ApplyBtn = self:RegisterController(UnityEngine.UI.Button, "ApplyBtn")


end

function AddMemberUI:SetAddMemberMessage(mAddMemberUI)
    self.playerid = mAddMemberUI.playerId;
    self.name.text = mAddMemberUI.name;
    self.province.text = DataState[mAddMemberUI.province].Name;
    self.influence.text = mAddMemberUI.influence;
    self.isInvited = mAddMemberUI.isInvented;
    self._coord = mAddMemberUI.coord
    local x, y = MapService:Instance():GetTiledCoordinate(self._coord)
    local x1, y1 = MapService:Instance():GetTiledCoordinate(PlayerService:Instance():GetMainCityTiledId())
    if math.abs(x - x1) >= 50 or math.abs(y - y1) >= 50 then
        if math.abs(x - x1) >= 150 or math.abs(y - y1) >= 150 then
            self._distance.text = "远"
        else
            self._distance.text = "中"
        end
    else
        self._distance.text = "近"
    end

    -- 通过坐标判断远近 - - - - - - NeedAd-----
    if self.isInvited == false then
        self.state.text = "邀请";
    else
        self.state.text = "已邀请";
    end
end

function AddMemberUI:OnShow()
end

function AddMemberUI:DoEventAdd()

    self:AddListener(self._ApplyBtn, self.OnClick_ApplyBtn)
    self:AddListener(self._nameBtn, self.OnClick_nameBtn)

end

function AddMemberUI:OnClick_ApplyBtn()
    --- 请求加入同盟
    if self.isInvited == false then
        LeagueService:Instance():SendInviteMsg(PlayerService:Instance():GetPlayerId(), self.playerid)
    end
end


function AddMemberUI:OnClick_nameBtn()
    -- 请求同盟信息
    local msg = require("MessageCommon/Msg/C2L/Player/RequestOtherPlayerBaseInfo").new();
    msg:SetMessageId(C2L_Player.RequestOtherPlayerBaseInfo);
    msg.playerId = self.playerid;
    NetService:Instance():SendMessage(msg);
end


return AddMemberUI;

-- endregion