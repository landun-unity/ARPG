
-- region *.lua
-- Date16/10/19

local UIBase = require("Game/UI/UIBase")
local UIService = require("Game/UI/UIService")
local UIType = require("Game/UI/UIType")
require("Game/Table/model/DataState")
local AddLeagueUI = class("AddLeagueUI", UIBase);


function AddLeagueUI:ctor()

    AddLeagueUI.super.ctor(self);
    self.leagueId = nil;
    self.name = nil;
    self.level = nil;
    self.num = nil;
    self.province = nil;
    self._coord = nil;
    self._nameBtn = nil;
    self._ApplyBtn = nil;
    self._distanceImage = nil;
    self.areadlyApply = nil;
    self.state = nil;
end

function AddLeagueUI:DoDataExchange()

    self.name = self:RegisterController(UnityEngine.UI.Text, "LeagueName/Text");
    self.level = self:RegisterController(UnityEngine.UI.Text, "levelText");
    self.num = self:RegisterController(UnityEngine.UI.Text, "memberText");
    self.province = self:RegisterController(UnityEngine.UI.Text, "locationText");
    self._distance = self:RegisterController(UnityEngine.UI.Text, "Image1/DistanceText");
    self._nameBtn = self:RegisterController(UnityEngine.UI.Button, "LeagueName");
    self._ApplyBtn = self:RegisterController(UnityEngine.UI.Button, "ApplyBtn")
    self.state = self:RegisterController(UnityEngine.UI.Text, "ApplyBtn/Text");
    self._distanceImage = self:RegisterController(UnityEngine.UI.Image, "Image");
end

function AddLeagueUI:SetAddLeagueMessage(mAddLeagueUI)

    self.leagueId = mAddLeagueUI.leagueid;
    -- print(self.leagueId)
    self.name.text = mAddLeagueUI.name;
    self.province.text = DataState[mAddLeagueUI.province].Name;
    self.level.text = mAddLeagueUI.level;
    self.num.text = mAddLeagueUI.num;
    self._coord = mAddLeagueUI.coord;
    self.areadlyApply = mAddLeagueUI.alreadApply;
    -- 通过坐标判断远近 - - - - - - NeedAd-----
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
    if self.areadlyApply == true then
        self.state.text = "取消申请";
    else
        self.state.text = "申请加入";
    end
end

function AddLeagueUI:OnShow()



end


function AddLeagueUI:DoEventAdd()

    self:AddListener(self._ApplyBtn, self.OnClick_ApplyBtn)
    self:AddListener(self._nameBtn, self.OnClick_nameBtn)

end

function AddLeagueUI:OnClick_ApplyBtn()
    --- 请求加入同盟
    -- print(self.areadlyApply)
    if self.areadlyApply == false then
        LeagueService:Instance():SendApplyJoin(PlayerService:Instance():GetPlayerId(), self.leagueId)

    else
        LeagueService:Instance():CancelApplyJoin(PlayerService:Instance():GetPlayerId(), self.leagueId)

    end


end

function AddLeagueUI:OnClick_nameBtn()
    -- 请求同盟信息
    LeagueService:Instance():SendOpenAppiontLeague(PlayerService:Instance():GetPlayerId(), self.leagueId)
end

return AddLeagueUI;

-- endregion
