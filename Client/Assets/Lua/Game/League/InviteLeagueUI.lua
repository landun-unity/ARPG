-- region *.lua
-- Date16/10/19

local UIBase = require("Game/UI/UIBase")
local UIService = require("Game/UI/UIService")
local UIType = require("Game/UI/UIType")
local DataState = require("Game/Table/model/DataState")
local InviteLeagueUI = class("InviteLeagueUI", UIBase);

function InviteLeagueUI:ctor()

    InviteLeagueUI.super.ctor(self);
    self._name = nil;
    self._province = nil;
    self._level = nil;
    self._num = nil;
    self._coord = nil;
    self._nameBtn = nil;
    self._ApplyBtn = nil;
    self._distance = nil;
    self._leagueId = nil;

    self._ApplyState = nil;
end

-- override
function InviteLeagueUI:DoDataExchange()

    self._name = self:RegisterController(UnityEngine.UI.Text, "LeagueName/Text");
    self._province = self:RegisterController(UnityEngine.UI.Text, "locationText");
    self._level = self:RegisterController(UnityEngine.UI.Text, "levelText");
    self._num = self:RegisterController(UnityEngine.UI.Text, "memberText ");
    self._nameBtn = self:RegisterController(UnityEngine.UI.Button, "LeagueName");
    self._ApplyBtn = self:RegisterController(UnityEngine.UI.Button, "ApplyBtn")
    self._distance = self:RegisterController(UnityEngine.UI.Text, "Image/DistanceText");
    self._ApplyState = self:RegisterController(UnityEngine.UI.Text, "ApplyBtn/Text")

end



function InviteLeagueUI:SetInviteLeagueMessage(mInviteLeague)
    -- print(mInviteLeague._leagueId);
    self._leagueId = mInviteLeague.leagueId;
    self._name.text = mInviteLeague.name;
    self._province.text = DataState[mInviteLeague.province].Name;
    self._level.text = mInviteLeague.level;
    self._num.text = mInviteLeague.num;
    self._coord = mInviteLeague.coord;
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
    -- ͨ�������ж�Զ�� - - - - - - NeedAd-----
end

function InviteLeagueUI:DoEventAdd()

    self:AddListener(self._ApplyBtn, self.OnClick_ApplyBtn)
    self:AddListener(self._nameBtn, self.OnClick_nameBtn)


end

function InviteLeagueUI:OnClick_ApplyBtn()
    --- ͬ������ͬ��
    -- print(self._leagueId)
    LeagueService:Instance():SendplayerAgreeJoinMsg(PlayerService:Instance():GetPlayerId(), self._leagueId)

end

function InviteLeagueUI:OnClick_nameBtn()
    -- ����ͬ����Ϣ
    LeagueService:Instance():SendOpenAppiontLeague(PlayerService:Instance():GetPlayerId(), self._leagueId)

end



return InviteLeagueUI
-- endregion
