-- 请求部队信息
local BaseState = require("Game/State/BaseState")
require("Game/Chat/ChatType");
local EnterGame = class("EnterGame", BaseState)

-- 构造函数
function EnterGame:ctor(...)
    EnterGame.super.ctor(self, ...);
end

-- 进入操作
function EnterGame:OnEnterState(...)
    UIService:Instance():InitUI(UIType.UIFacility);
    UIService:Instance():InitUI(UIType.UIChat);
    UIService:Instance():InitUI(UIType.GameBulletinBoardUI);
    UIService:Instance():InitUI(UIType.UIPandectObj);
    UIService:Instance():InitUI(UIType.UIPersonalPower);
    for i = 1 ,ChatType.CompetitionChat do
       ChatService:Instance():SetUnread(i);
    end
    local chatTream = LeagueService:Instance():GetLeagueChatTeam();
    for k,v in pairs(chatTream) do
        ChatService:Instance():SetUnread(ChatType.GroupingChat * 10000 + v.leaderId, ChatType.GroupingChat);
    end

    UIService:Instance():InitUI(UIType.UIRecruitUI);
    UIService:Instance():SetIsLogin(true)
    SyncService:Instance():StartSyncInfo();
    -- 武将卡包
    UIService:Instance():InitUI(UIType.UIHeroCardPackage);
    UIService:Instance():InitUI(UIType.UIHeroHandbook);
    -- 天下大势
    UIService:Instance():InitUI(UIType.WorldTendencyUI);

    UIService:Instance():InitUI(UIType.UITask);
    UIService:Instance():InitUI(UIType.MessageBox);
    UIService:Instance():InitUI(UIType.CommonOKOrCancle);

    MapService:Instance():ScanTiled(PlayerService:Instance():GetMainCityTiledId(),
    function()
        MapService:Instance():ChangeScreenCenter(PlayerService:Instance():GetMainCityTiledId());
        MapService:Instance():InitLightPos(PlayerService:Instance():GetMainCityTiledId());
        MapService:Instance():InitLandNewPosition();
    end, 0);
    LoginService:Instance():EnterState(LoginStateType.Empty);
    TaskService:Instance():OpenTaskListRequest();
    GuideServcice:Instance():GoToNextStep();
    CommonService:Instance():PlayBG("Audio/GameMainViewWinter")

    local msg = require("MessageCommon/Msg/C2L/Player/SyncServerTimeRequest").new();
    msg:SetMessageId(C2L_Player.SyncServerTimeRequest);
    NetService:Instance():SendMessage(msg,false);
end

-- 离开操作
function EnterGame:OnLeaveState(...)
end

return EnterGame;
