-- region *.lua
-- Date10.24 -10.25 pppppppppppppppppppppppppppppppppppppppppppppppppppppppppppp

local UIBase = require("Game/UI/UIBase")
local UIService = require("Game/UI/UIService")
local UIType = require("Game/UI/UIType")
require("Game/Table/InitTable")
local RequireMemberUI = class("RequireMemberUI", UIBase);


function RequireMemberUI:ctor()

    RequireMemberUI.super.ctor(self);

    self._name = nil;

    self._influence = nil;
    self._province = nil;
    self._playerId = nil;
    self._nameBtn = nil;
    self._ApplyBtn = nil;
    self._confuseBtn = nil;

end

function RequireMemberUI:DoDataExchange()

    self._influence = self:RegisterController(UnityEngine.UI.Text, "influence");
    self._name = self:RegisterController(UnityEngine.UI.Text, "Button/Text");
    self._province = self:RegisterController(UnityEngine.UI.Text, "province");
    self._nameBtn = self:RegisterController(UnityEngine.UI.Button, "Button");
    self._agree = self:RegisterController(UnityEngine.UI.Button, "agree")
    self._confuseBtn = self:RegisterController(UnityEngine.UI.Button, "refuse")
end

function RequireMemberUI:SetRequireMemberMessage(mRequireMemberUI)

    -- print(mRequireMemberUI.name)
    self._name.text = mRequireMemberUI.name;
    self._province.text = DataState[mRequireMemberUI.province].Name
    self._playerId = mRequireMemberUI.playerId;
    -- print(self._playerId)
    self._influence.text = mRequireMemberUI.influence;
    -- 通过坐标判断远近 - - - - - - NeedAd-----
end


function RequireMemberUI:DoEventAdd()

    self:AddListener(self._agree, self.OnClick_agree)
    self:AddListener(self._nameBtn, self.OnClick_nameBtn)
    self:AddListener(self._confuseBtn, self.OnClick_confuseBtn)
end

function RequireMemberUI:OnClick_agree()

    -- print(self._palyerId);
    LeagueService:Instance():SendAgreeJoin(PlayerService:Instance():GetPlayerId(), self._playerId);

end


function RequireMemberUI:OnClick_nameBtn()
    local msg = require("MessageCommon/Msg/C2L/Player/RequestOtherPlayerBaseInfo").new();
    msg:SetMessageId(C2L_Player.RequestOtherPlayerBaseInfo);
    msg.playerId = self._playerId;
    NetService:Instance():SendMessage(msg);
end



function RequireMemberUI:OnClick_confuseBtn()

    LeagueService:Instance():SendRefuseJoin(PlayerService:Instance():GetPlayerId(), self._playerId);

end

return RequireMemberUI;

-- endregion




-- endregion
