-- region *.lua
-- 同盟系统消息处理
-- Date16/10/12

local IOHandler = require("FrameWork/Game/IOHandler");
local LeagueHandler = class("LeagueHandler", IOHandler);
local List = require("common/List")
local LoadResourcesPrefab = require("Game/Util/LoadResourcesPrefab")
require("Game/League/LeagueOperateTipsType")
-- 构造函数
function LeagueHandler:ctor()

    LeagueHandler.super.ctor(self);
    self._drawLoadResourcesPrefab = LoadResourcesPrefab.new()
    self._battlingObject = nil;
    self.tiledNew = require("Game/Map/Tiled").new()
end

-- 注册消息


function LeagueHandler:RegisterAllMessage()
    -- --print(require("MessageCommon/Msg/L2C/League/OpenNoLeagueBack"));
    self:RegisterMessage(L2C_League.OpenNoLeagueBack, self.HandleOpenNoLeague, require("MessageCommon/Msg/L2C/League/OpenNoLeagueBack"));
    self:RegisterMessage(L2C_League.OpenLeagueBack, self.HandleOpenLeague, require("MessageCommon/Msg/L2C/League/OpenLeagueBack"));
    self:RegisterMessage(L2C_League.OpenLeagueMemberBack, self.HandleOpenLeagueMember, require("MessageCommon/Msg/L2C/League/OpenLeagueMemberBack"))
    self:RegisterMessage(L2C_League.CreateLeagueSuccess, self.HandleCreatLeagueSuccess, require("MessageCommon/Msg/L2C/League/CreateLeagueSuccess"))
    self:RegisterMessage(L2C_League.OpenRoundLeagueListRespond, self.HandleOpenAroundLeagueList, require("MessageCommon/Msg/L2C/League/OpenRoundLeagueListRespond"))
    self:RegisterMessage(L2C_League.BeInventLeagueListRespond, self.HandleBeInvited, require("MessageCommon/Msg/L2C/League/BeInventLeagueListRespond"))
    self:RegisterMessage(L2C_League.LeagueOperationTipsMsg, self.HandleTipsMessage, require("MessageCommon/Msg/L2C/League/LeagueOperationTipsMsg"))
    self:RegisterMessage(L2C_League.OpenPlayerInfoInLeagueRespond, self.HandlePlayerInLeagueInfo, require("MessageCommon/Msg/L2C/League/OpenPlayerInfoInLeagueRespond"))
    self:RegisterMessage(L2C_League.OpenAppiontLeagueRespond, self.HandleOpenAppiontLeague, require("MessageCommon/Msg/L2C/League/OpenAppiontLeagueRespond"))
    self:RegisterMessage(L2C_League.OpenRoundPlayerRespond, self.HandleOpenRoundPlayer, require("MessageCommon/Msg/L2C/League/OpenRoundPlayerRespond"))
    self:RegisterMessage(L2C_League.ApplyJoinLeagueList, self.HandleApplyJoinLeagueList, require("MessageCommon/Msg/L2C/League/ApplyJoinLeagueList"))
    self:RegisterMessage(L2C_League.DemiseTime, self.HandleDemiseTime, require("MessageCommon/Msg/L2C/League/DemiseTime"))
    self:RegisterMessage(L2C_League.ShutJoinApplyLeagueRespond, self.HandleApplyLeagueRespond, require("MessageCommon/Msg/L2C/League/ShutJoinApplyLeagueRespond"))
    self:RegisterMessage(L2C_League.OpenLeagueMarkRespond, self.HandleOpenLeagueMarkRespond, require("MessageCommon/Msg/L2C/League/OpenLeagueMarkRespond"))
    self:RegisterMessage(L2C_League.SyncLeagueMarkRespond, self.HandleAddLeagueMarkRespond, require("MessageCommon/Msg/L2C/League/SyncLeagueMarkRespond"))
    self:RegisterMessage(L2C_League.OpenDiplomacyLeagueRespond, self.HandleOpenDiplomacyLeagueRespond, require("MessageCommon/Msg/L2C/League/OpenDiplomacyLeagueRespond"))
    self:RegisterMessage(L2C_League.OpenOwnWildBuildRespond, self.HandleOpenOwnWildBuildRespond, require("MessageCommon/Msg/L2C/League/OpenOwnWildBuildRespond"))
    self:RegisterMessage(L2C_League.RemoveLeagueMarkRespond, self.HandleRemoveLeagueMarkRespond, require("MessageCommon/Msg/L2C/League/RemoveLeagueMarkRespond"))
    self:RegisterMessage(L2C_League.LeagueMarkRespond, self.HandleLeagueMarkRespond, require("MessageCommon/Msg/L2C/League/LeagueMarkRespond"))
    self:RegisterMessage(L2C_League.OpenUnderMemberRespond, self.HandleOpenUnderMemberRespond, require("MessageCommon/Msg/L2C/League/OpenUnderMemberRespond"))
    self:RegisterMessage(L2C_League.WildBuildingOccupyPlayerInfo, self.HandleWildBuildingOccupyPlayerInfo, require("MessageCommon/Msg/L2C/League/WildBuildingOccupyPlayerInfo"))
    self:RegisterMessage(L2C_League.SyncLeagueLevel, self.HandleSyncLeagueLevel, require("MessageCommon/Msg/L2C/League/SyncLeagueLevel"))
    self:RegisterMessage(L2C_League.LeagueChangeWildBuilding, self.HandleLeagueChangeWildBuilding, require("MessageCommon/Msg/L2C/League/LeagueChangeWildBuilding"))
    self:RegisterMessage(L2C_League.OpenRevoltRespond, self.HandleOpenRevoltRespond, require("MessageCommon/Msg/L2C/League/OpenRevoltRespond"))
    self:RegisterMessage(L2C_League.LeagueAgreePlayerJoin, self.HandleLeagueAgreePlayerJoin, require("MessageCommon/Msg/L2C/League/LeagueAgreePlayerJoin"))
    self:RegisterMessage(L2C_League.CreateLeagueChat, self.HandleCreateLeagueChat, require("MessageCommon/Msg/L2C/League/CreateLeagueChat"))
    self:RegisterMessage(L2C_League.NextJoinLeagueTime, self.HandleNextJoinLeagueTime, require("MessageCommon/Msg/L2C/League/NextJoinLeagueTime"))
    self:RegisterMessage(L2C_League.BaseLeagueChatTeamInfo, self.HandleBaseLeagueChatTeamInfo, require("MessageCommon/Msg/L2C/League/BaseLeagueChatTeamInfo"))
    self:RegisterMessage(L2C_League.OpenLeagueChatTeamRespond, self.HandleOpenLeagueChatTeamRespond, require("MessageCommon/Msg/L2C/League/OpenLeagueChatTeamRespond"))
    self:RegisterMessage(L2C_League.RemoveLeagueChatTeam, self.HandleRemoveLeagueChatTeam, require("MessageCommon/Msg/L2C/League/RemoveLeagueChatTeam"))
    self:RegisterMessage(L2C_League.SyncPlayerBaseLeagueChatTeam, self.HandleSyncPlayerBaseLeagueChatTeam, require("MessageCommon/Msg/L2C/League/SyncPlayerBaseLeagueChatTeam"))
end

-- 同步势力信息
function LeagueHandler:HandleLeagueChangeWildBuilding(args)
    if args.leagueId == PlayerService:Instance():GetLeagueId() then
        if args.gainOrLost == true then
            self._logicManage:AddToLeagueInfluenceList(args.buildingId)
            CommonService:Instance():Play("Audio/GetCity")
        else
            self._logicManage:RemoveFormInfluenceList(args.buildingId)
            CommonService:Instance():Play("Audio/LostCity")
        end
    end

end


function LeagueHandler:HandleNextJoinLeagueTime(args)
    self._logicManage:SetLeagueForeignAll(nil)
end


-- 打开野城返会
function LeagueHandler:HandleWildBuildingOccupyPlayerInfo(args)
    local wildBuildingPlayerInfo = args;
    self._logicManage:SetWildPlayerInfo(args)
    MapService:Instance():ClickWildBuilding()
end

-- 同步同盟等级
function LeagueHandler:HandleSyncLeagueLevel(args)
    if args.leagueId == PlayerService:Instance():GetLeagueId() then
        PlayerService:Instance():SetLeagueLevel(args.leagueLevel)
    end
end


function LeagueHandler:HandleLeagueAgreePlayerJoin(msg)
    local Message = msg;
    PlayerService:Instance():SetLeagueId(msg.leagueId)
end


-- 返回OpenLeague消息逻辑，存储同盟存在界面信息
function LeagueHandler:HandleOpenLeague(msg)
    local Message = msg;
    local League = require("Game/League/League").new();
    League.leagueid = msg.leagueid
    League.leagueName = msg.leagueName
    League.leaderid = msg.leaderid
    League.leaderName = msg.leaderName
    League.level = msg.level
    League.exp = msg.exp
    League.memberNum = msg.memberNum
    League.province = msg.province
    League.cityNum = msg.cityNum
    League.influnce = msg.influnce
    League.notice = msg.notice
    League.applyNum = msg.applyNum
    League.nextDemiseTime = msg.nextDemiseTime
    League.haveWildCityCount = msg.haveWildCityCount
    League.cityWoodAdd = msg.cityWoodAdd
    League.cityIronAdd = msg.cityIronAdd
    League.cityStoneAdd = msg.cityStoneAdd
    League.cityGrainAdd = msg.cityGrainAdd
    League.beDemisePlayerId = msg.beDemisePlayerId

    self._logicManage:SetLeague(League);
    self._logicManage:SetLeagueInfo(Message)
    PlayerService:Instance():SetLeagueName(msg.leagueName)
    self._logicManage:SetNextDemiseTime(Message.nextDemiseTime)
    PlayerService:Instance():SetLeagueId(msg.leagueid)


    local baseLinkManClass = UIService:Instance():GetUIClass(UIType.LinkManUI);
    local isopen = UIService:Instance():GetOpenedUI(UIType.LinkManUI);
    if baseLinkManClass ~= nil and isopen == true then
        return;
    end

    UIService:Instance():HideUI(UIType.UIPersonalPower)
    UIService:Instance():HideUI(UIType.UIGameMainView)
    if UIService:Instance():GetOpenedUI(UIType.LeagueExistUI) then
        UIService:Instance():GetUIClass(UIType.LeagueExistUI):OnShow(Message)
    else
        UIService:Instance():ShowUI(UIType.LeagueExistUI, Message)
    end
    local baseClass = UIService:Instance():GetUIClass(UIType.LeagueDonate);
    if baseClass ~= nil then
        baseClass:ReShow()
    end


end

function LeagueHandler:HandleCreateLeagueChat(msg)
    local msg1 = require("MessageCommon/Msg/C2Chat/Chat/CreatLeagueChannel").new();
    msg1:SetMessageId(C2Chat_Chat.CreatLeagueChannel);
    msg1.channelId = ChatType.AllianceChat * 10000 + PlayerService:Instance():GetLeagueId();
    msg1.country = msg.leagueId;
    msg1.leagueName = msg.leagueName;
    msg1.leadership = msg.leadership;
    NetService:Instance():SendMessage(msg1);

    local msg2 = require("MessageCommon/Msg/C2Chat/Chat/SendChat").new();
    msg2:SetMessageId(C2Chat_Chat.SendChat);
    msg2.channelId = ChatType.SystemChat * 10000 + PlayerService:Instance():GetPlayerId();
    msg2.mType = ChatContentType.JoinAllianceType;
    msg2.content = msg.leagueName;
    NetService:Instance():SendMessage(msg2);
end

-- 返回LeagueMember逻辑，存储同盟成员信息
function LeagueHandler:HandleOpenLeagueMember(msg)
    local Message = msg;
    self._logicManage:SetmemberList(Message.list)
    self._logicManage:SetTitleNum()
    local baseClassPmap = UIService:Instance():GetUIClass(UIType.UIPmap);

    if baseClassPmap then
        baseClassPmap:AddLeagueMemberOnMap()
    end

    local baseClass = UIService:Instance():GetUIClass(UIType.LinkManUI);
    local isopen = UIService:Instance():GetOpenedUI(UIType.LinkManUI);
    if baseClass ~= nil and isopen == true then
        baseClass:ShowPeople();
        return;
    end

    -- 同盟主界面处于打开状态时才打开成员列表界面
    local baseLeagueClass = UIService:Instance():GetUIClass(UIType.LeagueExistUI);
    local Leagueisopen = UIService:Instance():GetOpenedUI(UIType.LeagueExistUI);
    if baseLeagueClass ~= nil and Leagueisopen == true then
        if UIService:Instance():GetOpenedUI(UIType.LeagueMemberUI) then
            UIService:Instance():GetUIClass(UIType.LeagueMemberUI):OnShow(msg.list)
        else
            UIService:Instance():ShowUI(UIType.LeagueMemberUI, msg.list)
        end
    end

end

-- 同盟不存在信息界面
function LeagueHandler:HandleOpenNoLeague(msg)
    local Message = msg;
    self._logicManage:_IsNoLeague(msg)
    self._joinCoolTime = Message.joinCoolingTime;
    local baseClass = UIService:Instance():GetUIClass(UIType.LinkManUI);
    local isopen = UIService:Instance():GetOpenedUI(UIType.LinkManUI);
    if baseClass ~= nil and isopen == true then
        return;
    end

    UIService:Instance():ShowUI(UIType.LeagueDisExistUI, Message)
    local isopen = UIService:Instance():GetOpenedUI(UIType.UIPersonalPower);
    if isopen == false then
        UIService:Instance():ShowUI(UIType.LeagueAttentionUI)
    else
        UIService:Instance():HideUI(UIType.UIPersonalPower);
    end
    UIService:Instance():HideUI(UIType.UIGameMainView)
end


function LeagueHandler:HandleOpenUnderMemberRespond(msg)
    -- print(msg.list)
    -- print(msg.list:Count())
    self._logicManage:SetUnderMemberList(msg.list)
    local baseClass = UIService:Instance():GetUIClass(UIType.LeagueMemberUI);
    local isopen = UIService:Instance():GetOpenedUI(UIType.LeagueMemberUI);
    if baseClass ~= nil and isopen == true then
        baseClass:SetUnderMemberInfo();
    end

end 

function LeagueHandler:HandleApplyLeagueRespond(msg)

    local Message = msg;
    -- print(msg.isShut)
    if msg.isShut == true then
        UIService:Instance():ShowUI(UIType.CloseRequest)
        LeagueService:Instance():SendOpenApplyList(PlayerService:Instance():GetPlayerId())
    else
        UIService:Instance():HideUI(UIType.CloseRequest)
        LeagueService:Instance():SendOpenApplyList(PlayerService:Instance():GetPlayerId())
    end

end

-- 返回剑盟成功，向服务请求OpenLeague信息
function LeagueHandler:HandleCreatLeagueSuccess(msg)

    local Message = msg;
    UIService:Instance():HideUI(UIType.LeagueDisExistUI)
    PlayerService:Instance():SetLeagueId(msg.leagueId)
    self._logicManage:_CreatLeagueSucessOPenLeague(Message);
end

-- 返回附近同盟列表，打开League AddUI
function LeagueHandler:HandleOpenAroundLeagueList(msg)

    -- self._logicManage:_SetAroundLeague(msg);
    local Message = msg;
    local class = UIService:Instance():GetUIClass(UIType.LeagueAddUI)
    local classLeaguexsit = UIService:Instance():GetOpenedUI(UIType.LeagueDisExistUI)
    if class and UIService:Instance():GetOpenedUI(UIType.LeagueAddUI) then
        class:OnShow(msg)
    else
        if classLeaguexsit then
            UIService:Instance():ShowUI(UIType.LeagueAddUI, msg)
        end
    end

end
-- 返回邀请信息，打开LeagueInviteUI
function LeagueHandler:HandleBeInvited(msg)

    local Message = msg;
    self._logicManage:_OpenLeagueInviteUI(Message);

end

-- 申请加入列表返回
function LeagueHandler:HandleApplyJoinLeagueList(msg)
    local Message = msg;
    if msg.isShut == true then
        UIService:Instance():ShowUI(UIType.CloseRequest)
        local Message1 = List.new();
        self._logicManage:_OpenRequireUI(Message1);
        return
    end
    self._logicManage:_OpenRequireUI(Message);

end



-- 请求指定同盟返回
function LeagueHandler:HandleOpenAppiontLeague(msg)
    local Message = msg;
    if Message.leagueid == PlayerService:Instance():GetLeagueId() then
        LeagueService:Instance():SendLeagueMessage()
        UIService:Instance():HideUI(UIType.LeagueForigen)
        return
    end
    UIService:Instance():HideUI(UIType.PlayerInformationUI)
    UIService:Instance():ShowUI(UIType.AppiontLeagueUI, Message)
    UIService:Instance():HideUI(UIType.LeagueForigen)
end


function LeagueHandler:HandleDemiseTime(msg)
    local Message = msg;
    LeagueService:Instance():SetBeDimsePlayerID(Message.beDemisePlayerId)
    LeagueService:Instance():SetNextDemiseTime(Message.demisTime)
end

-- 接受返回Tips消息
function LeagueHandler:HandleTipsMessage(msg)
    --   print(msg.mtype)
    if (msg.mtype == LeagueOperateTipsType.JoinInCooling) then
        -- print("   --加入同盟冷却中")
        UIService:Instance():ShowUI(UIType.UICueMessageBox, UICueMessageType.timeCooling)
    end

    if (msg.mtype == LeagueOperateTipsType.CancelApplyJoinLeagueSuccess) then
        -- print("   --取消加入成功")
        local baseClass = UIService:Instance():GetUIClass(UIType.AppiontLeagueUI)
        if baseClass then
            baseClass:CancelSucess()
        end
        UIService:Instance():ShowUI(UIType.UICueMessageBox, 1009)
        self._logicManage:_SendOpenAroundLeagueMessage(PlayerService:Instance():GetPlayerId());
    end

    if (msg.mtype == LeagueOperateTipsType.CancelDemiseSuccess) then

        -- print("   --取消禅让成功")
        LeagueService:Instance():SetNextDemiseTime(0)
        self._logicManage:_SendOpenLeagueMemberMessage(PlayerService:Instance():GetPlayerId());
    end


    if (msg.mtype == LeagueOperateTipsType.AgreeJoinSuccess) then
        -- 加成功
        -- print("   --加入成功")
        UIService:Instance():HideUI(UIType.LeagueRequireInUI)
        self._logicManage:_SendOpenLeagueMessage()
        self._logicManage:_SendOpenLeagueMemberMessage(PlayerService:Instance():GetPlayerId());
    end
    if msg.mtype == LeagueOperateTipsType.RevoltDonateSuccess then

        self._logicManage:SendOpenRebellMsg()

    end

    -- 沦陷状态中
    if msg.mtype == LeagueOperateTipsType.AlreadBeFalled then
        UIService:Instance():ShowUI(UIType.UICueMessageBox, UICueMessageType.befalled)
    end

    if msg.mtype == LeagueOperateTipsType.HaveNoSuchPlayer then
        UIService:Instance():ShowUI(UIType.UICueMessageBox, 1000)
    end


    if msg.mtype == LeagueOperateTipsType.ConfigDiplomacyCooling then
        UIService:Instance():ShowUI(UIType.UICueMessageBox, UICueMessageType.timeCooling)
    end


    if (msg.mtype == LeagueOperateTipsType.JoinLeagueSuccess) then
        -- print("   --同意加入加入成功")
        self._logicManage:_SendOpenLeagueMessage(PlayerService:Instance():GetPlayerId());
        UIService:Instance():HideUI(UIType.LeagueDisExistUI);
        UIService:Instance():HideUI(UIType.LeagueAddUI)
        UIService:Instance():HideUI(UIType.LeagueInviteUI)

    end

    if (msg.mtype == LeagueOperateTipsType.RefreshLeagueNoticeSucess) then
        -- print("   --公告")
        LeagueService:Instance():SendLeagueMessage()
        UIService:Instance():HideUI(UIType.LeagueIntroUI)
    end
    if (msg.mtype == LeagueOperateTipsType.areadyDisInList) then
        -- print("   不在")
        UIService:Instance():ShowUI(UIType.UICueMessageBox, UICueMessageType.areadyDisInList)
    end

    if (msg.mtype == LeagueOperateTipsType.SendApplyInventSuccess) then
        -- print("   --邀请成功")
        LeagueService:Instance():SendRoundPlayerMsg(PlayerService:Instance():GetPlayerId());
    end

    if (msg.mtype == LeagueOperateTipsType.InfluenceIsNotEnough) then
        -- print("   --实力不足")
        UIService:Instance():ShowUI(UIType.UICueMessageBox, UICueMessageType.LeagueInfluenceNotEnough)
    end
    if (msg.mtype == LeagueOperateTipsType.LeagueNotInLocalSpawn) then
        -- print("   --实力不足")
        UIService:Instance():ShowUI(UIType.UICueMessageBox, UICueMessageType.LeagueNotInLocalSpawn)
    end

    if msg.mtype == 39 then

        -- print("   --捐献成功")
        local data1 = { LeagueService:Instance():GetDonateValue() };
        local data2 = { UICueMessageType.DonateSucess, data1 };
        UIService:Instance():ShowUI(UIType.UICueMessageBox, data2)
        self._logicManage:_SendOpenLeagueMessage(PlayerService:Instance():GetPlayerId());

    end
    if msg.mtype == LeagueOperateTipsType.HaveNotEnoughResource then
        -- 没有资源
        -- print("   --没有资源")

    end

    if msg.mtype == 14 then
        -- 加成功
        -- print("   --申请加入成功")
        local baseClass = UIService:Instance():GetUIClass(UIType.AppiontLeagueUI)
        if baseClass then
            baseClass:ApplySucess()
        end
        UIService:Instance():ShowUI(UIType.UICueMessageBox, 1005)
        self._logicManage:_SendOpenAroundLeagueMessage(PlayerService:Instance():GetPlayerId());

    end

    if msg.mtype == LeagueOperateTipsType.MemberOutOfLimit then
        -- 加成功
        -- print("   --同盟人数已满")

    end

    if msg.mtype == LeagueOperateTipsType.HaveNoSuchLeague then
        -- 加成功
        -- print("   --不存在同盟")
        UIService:Instance():ShowUI(UIType.UICueMessageBox, UICueMessageType.HaveNoLeague)
    end

    if msg.mtype == LeagueOperateTipsType.RefusePlayerJoinSuccess then
        -- print("   --拒绝加入成功")

        self._logicManage:_SendOpenApplyList(PlayerService:Instance():GetPlayerId());

    end

    if msg.mtype == LeagueOperateTipsType.AppointOfficerSuccess then

        -- print("   --任命官员成功")
        LeagueService:Instance():SendLeagueMemberMessage()


    end

    if msg.mtype == LeagueOperateTipsType.CreateLeagueSuccess then
        UIService:Instance():HideUI(UIType.LeagueDisExistUI)
        self._logicManage:_CreatLeagueSucessOPenLeague(Message);
    end

    if (msg.mtype == LeagueOperateTipsType.KickMemberSuccess) then
        -- 踢人成功
        -- print("   --踢人成功")
        self._logicManage:_HideLeaderOtherPowerUI()
        self._logicManage:_SendOpenLeagueMemberMessage(PlayerService:Instance():GetPlayerId());
        -- 刷消息？？？？？？？？？？？？
    end


    if (msg.mtype == LeagueOperateTipsType.AlreadyMaxMarkLimit) then
        -- print("   --标记已满")
        UIService:Instance():ShowUI(UIType.UICueMessageBox, UICueMessageType.LeagueMarkFull)
        -- 刷消息？？？？？？？？？？？？
    end


    if (msg.mtype == LeagueOperateTipsType.RecallOfficerSuccess) then
        -- 罢免成功
        -- print("   --罢免官员成功")
        self._logicManage:_HideLeaderOtherPowerUI()
        self._logicManage:_SendOpenLeagueMemberMessage(PlayerService:Instance():GetPlayerId());
        -- 刷消息？？？？？？？？？？？？
    end

    if (msg.mtype == LeagueOperateTipsType.AppointChiefSuccess) then
        -- 任命太守成功
        -- print("   --任命太守成")
        self._logicManage:_HideLeaderOtherPowerUI()
        -- 刷消息？？？？？？？？？？？？
    end

    if (msg.mtype == LeagueOperateTipsType.GiveUpMyViceLeagueSuccess) then
        -- 禅让成功
        -- print("   --禅让成")
        -- 刷消息？？？？？？？？？？？？
        self._logicManage:_SendOpenLeagueMemberMessage(PlayerService:Instance():GetPlayerId());
    end

    if (msg.mtype == LeagueOperateTipsType.QuitLeagueSuccess) then
        -- 退出同盟成功
        -- print("   --退出同盟")
        -- 刷消息？？？？？？？？？？？？
        PlayerService:Instance():SetLeagueId(0);

        UIService:Instance():HideUI(UIType.ConfirmQuitLeague)
        UIService:Instance():HideUI(UIType.LeagueMemberUI)
        UIService:Instance():HideUI(UIType.LeagueExistUI)
        UIService:Instance():ShowUI(UIType.UIGameMainView)
    end


    if (msg.mtype == 20) then
        local baseClass = UIService:Instance():GetUIClass(UIType.LinkManUI);
        local isopen = UIService:Instance():GetOpenedUI(UIType.LinkManUI);
        if baseClass ~= nil and isopen == true then
            return;
        end
        UIService:Instance():ShowUI(UIType.UICueMessageBox, UICueMessageType.HaveNoLeague)
    end

    if (msg.mtype == LeagueOperateTipsType.DissolveLeagueSuccess) then
        -- 解散同盟成功
        -- print("   --解散同盟成功")
        UIService:Instance():HideUI(UIType.LeagueMemberUI)
        UIService:Instance():HideUI(UIType.LeagueExistUI)
        UIService:Instance():ShowUI(UIType.UIGameMainView)
        -- 刷消息？？？？？？？？？？？？
        PlayerService:Instance():SetLeagueId(0);

    end

    if (msg.mtype == LeagueOperateTipsType.PlayerHaveNoLeague) then

        UIService:Instance():HideUI(UIType.LeagueRequireInUI)
        UIService:Instance():HideUI(UIType.LeagueMemberUI)
        UIService:Instance():HideUI(UIType.LeagueExistUI)
        local isopen = UIService:Instance():GetOpenedUI(UIType.UIPmap);
        if isopen then
            return
        else
            UIService:Instance():ShowUI(UIType.UIGameMainView)
        end

    end
    if (msg.mtype == LeagueOperateTipsType.AddLeagueMarkSuccess) then
        UIService:Instance():HideUI(UIType.UILeagueMark)
        UIService:Instance():ShowUI(UIType.UICueMessageBox, UICueMessageType.AddLeagueMarkSucess)
    end
    if (msg.mtype == LeagueOperateTipsType.ApplyIsShutDown) then
        -- 解散同盟成功
        -- print("   --关闭申请")
        -- 刷消息？？？？？？？？？？？？
    end

    if msg.mtype == LeagueOperateTipsType.AlreadyExistLeague then
        UIService:Instance():ShowUI(UIType.UICueMessageBox, UICueMessageType.LeagueNameIsUsed)
    end

    if (msg.mtype == LeagueOperateTipsType.CofigDiplomacySuccess) then
        -- 设置关系成功
        print("设置关系成功")
        UIService:Instance():HideUI(UIType.AppiontLeagueUI)
        UIService:Instance():HideUI(UIType.RelationUI)
        UIService:Instance():ShowUI(UIType.UICueMessageBox, UICueMessageType.CofigDiplomacySuccess)
        self._logicManage:SendLeagueForiegn();
    end

    if (msg.mtype == 48) then
        -- 设置关系成功
        -- print("反叛成功")
        UIService:Instance():HideUI(UIType.rebellUI)
        PlayerService:Instance():SetsuperiorLeagueId(0)
        local baseClass = UIService:Instance():GetUIClass(UIType.UIGameMainView);
        baseClass:HideRebellBtn()
    end

    if msg.mtype == LeagueOperateTipsType.InventLeagueChatTeamSuccess then
        -- print("邀请玩家加入同盟分组成功")
        local msg = require("MessageCommon/Msg/C2L/League/OpenLeagueChatTeam").new();
        msg:SetMessageId(C2L_League.OpenLeagueChatTeam);
        msg.teamPlayerId = PlayerService:Instance():GetPlayerId();
        NetService:Instance():SendMessage(msg);

        -- local baseClass = UIService:Instance():GetUIClass(UIType.UIChat);
        -- local isopen = UIService:Instance():GetOpenedUI(UIType.UIChat);
        -- if baseClass ~= nil and isopen == true then
        --     baseClass:Show();
        -- end

        local baseClass1 = UIService:Instance():GetUIClass(UIType.UIAllianceChat);
        local isopen1 = UIService:Instance():GetOpenedUI(UIType.UIAllianceChat);
        if baseClass1 ~= nil and isopen1 == true then
            -- 发消息
            -- baseClass1:OnShow();
            -- baseClass1:RefreshAddBtn();
            baseClass1:OnClickMemberBtn();
        end
        UIService:Instance():ShowUI(UIType.UICueMessageBox, 508);
    end

    if msg.mtype == LeagueOperateTipsType.KickMemberOutChatTeam then
        local msg = require("MessageCommon/Msg/C2L/League/OpenLeagueChatTeam").new();
        msg:SetMessageId(C2L_League.OpenLeagueChatTeam);
        msg.teamPlayerId = PlayerService:Instance():GetPlayerId();
        NetService:Instance():SendMessage(msg);
        -- print("踢人出同盟聊天分组")
        -- local baseClass = UIService:Instance():GetUIClass(UIType.UIChat);
        -- local isopen = UIService:Instance():GetOpenedUI(UIType.UIChat);
        -- if baseClass ~= nil and isopen == true then
        --     baseClass:OnShow();
        -- end
        -- local baseClass1 = UIService:Instance():GetUIClass(UIType.UIAllianceChat);
        -- local isopen1 = UIService:Instance():GetOpenedUI(UIType.UIAllianceChat);
        -- if baseClass1 ~= nil and isopen1 == true then
        --     baseClass1:RefreshBtn();
        -- end
        UIService:Instance():ShowUI(UIType.UICueMessageBox, 509);
    end

    if msg.mtype == LeagueOperateTipsType.ChangeLeagueChatNameSuccess then
        -- print("修改同盟聊天分组名字成功")
        local msg = require("MessageCommon/Msg/C2L/League/OpenLeagueChatTeam").new();
        msg:SetMessageId(C2L_League.OpenLeagueChatTeam);
        msg.teamPlayerId = PlayerService:Instance():GetPlayerId();
        NetService:Instance():SendMessage(msg);

        local baseClass = UIService:Instance():GetUIClass(UIType.UIChat);
        local isopen = UIService:Instance():GetOpenedUI(UIType.UIChat);
        if baseClass ~= nil and isopen == true then
            baseClass:RefreshChannelBtn();
        end

        local baseClass1 = UIService:Instance():GetUIClass(UIType.UIAllianceChat);
        local isopen1 = UIService:Instance():GetOpenedUI(UIType.UIAllianceChat);
        if baseClass1 ~= nil and isopen1 == true then
            baseClass1:RefreshName();
        end
        UIService:Instance():ShowUI(UIType.UICueMessageBox, 507);
    end

    if msg.mtype == LeagueOperateTipsType.CreateLeagueChatTeamSuccess then
        -- print("创建同盟聊天分组成功")
        -- local baseClass = UIService:Instance():GetUIClass(UIType.UIChat);
        -- local isopen = UIService:Instance():GetOpenedUI(UIType.UIChat);
        -- if baseClass ~= nil and isopen == true then
        --     baseClass:RefreshChannelBtn();
        -- end

        local baseClass1 = UIService:Instance():GetUIClass(UIType.UIAllianceChat);
        local isopen1 = UIService:Instance():GetOpenedUI(UIType.UIAllianceChat);
        if baseClass1 ~= nil and isopen1 == true then
            -- 发消息
            UIService:Instance():HideUI(UIType.UIAllianceChat);
            UIService:Instance():ShowUI(UIType.UICueMessageBox, 506);
        end

        -- local msg = require("MessageCommon/Msg/C2Chat/Chat/JoinChannel").new();
        -- msg:SetMessageId(C2Chat_Chat.JoinChannel);
        -- msg.channelId = ChatType.GroupingChat * 10000 + PlayerService:Instance():GetPlayerId();
        -- NetService:Instance():SendMessage(msg);
    end
end

-- 请求人物信息返回
function LeagueHandler:HandlePlayerInLeagueInfo(msg)
    local Message = msg;
    UIService:Instance():ShowUI(UIType.PlayerInfoUI, Message)
end


function LeagueHandler:HandleOpenRoundPlayer(msg)
    local Message = msg;
    local class = UIService:Instance():GetUIClass(UIType.LeagueMemberAddUI)
    if class and UIService:Instance():GetOpenedUI(UIType.LeagueMemberAddUI) then
        class:OnShow(msg)
    else
        UIService:Instance():ShowUI(UIType.LeagueMemberAddUI, msg)
    end
end


function LeagueHandler:HandleOpenLeagueMarkRespond(msg)
    local Message = msg;
    self._logicManage:SetLeagueMarkList(Message.list)
    local baseClass = UIService:Instance():GetUIClass(UIType.UIPmap);
    local isopen = UIService:Instance():GetOpenedUI(UIType.UIPmap);
    if baseClass ~= nil and isopen == true then
        baseClass:LeagueMarkMessageBack()
    end
end



-- 打开外交同盟消息回复
function LeagueHandler:HandleOpenDiplomacyLeagueRespond(msg)
    LoginService:Instance():EnterState(LoginStateType.RequestLeagueInfo);
    self._logicManage:SetLeagueForeignAll(msg.list)
    local listCount = msg.list:Count();

    if GameResFactory.Instance():GetInt("forgionNum") ~= listCount then
        LeagueService:Instance():SetForeignBool(true)
    end

    for i = 1, listCount do
        print(msg.list:Get(i).mType)
        PlayerService:Instance():AddLeagueRelation(msg.list:Get(i).leagueId,msg.list:Get(i).mType)
    end
    local baseClass = UIService:Instance():GetUIClass(UIType.LeagueForigen)
    local isOpen = UIService:Instance():GetOpenedUI(UIType.LeagueForigen)
    if isOpen then
        baseClass:OnShow()
    end
end

-- 打开势力消息回复
function LeagueHandler:HandleOpenOwnWildBuildRespond(msg)

    self._logicManage:SetLeagueInfluence(msg.list)
    local baseClass = UIService:Instance():GetUIClass(UIType.LeagueExistUI);
    local isopen = UIService:Instance():GetOpenedUI(UIType.LeagueExistUI);
    if baseClass ~= nil and isopen == true then
        UIService:Instance():ShowUI(UIType.LeagueInfluence)
    end
end

--- 添加同盟标记返回

function LeagueHandler:HandleAddLeagueMarkRespond(msg)

print("--- 添加同盟标记返回")
    local allLeagueMark = self._logicManage:GetLeagueMarkTable()
    for i = 1, msg.list:Count() do
        local syncLeagueMark = require("Game/League/LeagueMark").new();
        syncLeagueMark.id = msg.list:Get(i).id;
        syncLeagueMark.name = msg.list:Get(i).name;
        syncLeagueMark.description = msg.list:Get(i).description;
        syncLeagueMark.coord = msg.list:Get(i).coord
        syncLeagueMark.publisherid = msg.list:Get(i).publisherId
        syncLeagueMark.publishname = msg.list:Get(i).publistName
        syncLeagueMark.title = msg.list:Get(i).title
        local _tiled = MapService:Instance():GetTiledByIndex(syncLeagueMark.coord)
        if _tiled == nil then
            return;
        end
        local parent = MapService:Instance():GetLayerParent(LayerType.Army);
        if parent == nil then
            return
        end
        _tiled:SetLeagueMark(syncLeagueMark)
        local position = MapService:Instance():GetTiledPosition(_tiled:GetX(), _tiled:GetY());
        if allLeagueMark[syncLeagueMark.id] ~= nil then
            allLeagueMark[syncLeagueMark.id].transform.localPosition = Vector3.New(position.x, position.y - 50, 0)
            allLeagueMark[syncLeagueMark.id].transform.localScale = Vector3.New(1, 1, 1);
        else
            self._drawLoadResourcesPrefab:SetResPath("Map/LeagueFlag")
            self._drawLoadResourcesPrefab:Load(parent, function(battlingObject)
                allLeagueMark[syncLeagueMark.id] = battlingObject
                battlingObject.name = syncLeagueMark.id
                allLeagueMark[syncLeagueMark.id].transform.localPosition = Vector3.New(position.x, position.y - 50, 0)
                self._logicManage:SetFlag(syncLeagueMark.id, battlingObject)
                self._logicManage:_OnShowArmyLayer(battlingObject, parent, _tiled)
            end )
        end
    end
end

function LeagueHandler:HandleRemoveLeagueMarkRespond(msg)
    local allLeagueMark = self._logicManage:GetLeagueMarkTable()
    local _tiled = MapService:Instance():GetTiledByIndex(msg.coord)
    LeagueService:Instance():RemoveLeagueMark(msg.coord)
    if _tiled == nil then
        return;
    end
    self._drawLoadResourcesPrefab:Recovery(allLeagueMark[_tiled:GetLeagueMarkId()])
    allLeagueMark[_tiled:GetLeagueMarkId()] = nil;
    _tiled:SetLeagueMark(nil)

    local baseClass = UIService:Instance():GetUIClass(UIType.UIPmap);
    local isopen = UIService:Instance():GetOpenedUI(UIType.UIPmap);

    if baseClass ~= nil and isopen == true then
        LeagueService:Instance():SendLeagueMarkMessage()
    end
    MapService:Instance():HideTiled()

end

function LeagueHandler:HandleLeagueMarkRespond(msg)

print("--- 添加tongmmgmmmmmmmmmmmmmmmmmm同盟标记返回")

    local allLeagueMark = self._logicManage:GetLeagueMarkTable()
    for i = 1, msg.list:Count() do
        local syncLeagueMark = require("Game/League/LeagueMark").new();
        syncLeagueMark.id = msg.list:Get(i).id;
        syncLeagueMark.name = msg.list:Get(i).name;
        syncLeagueMark.description = msg.list:Get(i).description;
        syncLeagueMark.coord = msg.list:Get(i).coord
        syncLeagueMark.publisherid = msg.list:Get(i).publisherId
        syncLeagueMark.publishname = msg.list:Get(i).publistName
        syncLeagueMark.title = msg.list:Get(i).title
        local _tiled = MapService:Instance():GetTiledByIndex(syncLeagueMark.coord)
        local position = MapService:Instance():GetTiledPosition(_tiled:GetX(), _tiled:GetY());
        if _tiled == nil then
            return;
        end
        local parent = MapService:Instance():GetLayerParent(LayerType.Army);
        if parent == nil then
            return
        end
        if _tiled:GetLeagueMark() ~= nil then
            -- self._drawLoadResourcesPrefab:Recovery(allLeagueMark[_tiled:GetLeagueMarkId()])
        else
            _tiled:SetLeagueMark(syncLeagueMark)
            self._drawLoadResourcesPrefab:SetResPath("Map/LeagueFlag")
            self._drawLoadResourcesPrefab:Load(parent, function(battlingObject)
                allLeagueMark[syncLeagueMark.id] = battlingObject
                battlingObject:SetActive(false)
                battlingObject:SetActive(true)
                battlingObject.transform.localPosition = Vector3.New(position.x, position.y + 200, 0)
                battlingObject.transform:DOLocalMove(Vector3.New(position.x, position.y - 50, 0), .6)
                self._logicManage:SetFlag(syncLeagueMark.id, battlingObject)
                --        self._logicManage:_OnShowArmyLayer(battlingObject, parent, _tiled)
            end )
            if syncLeagueMark.publisherid == PlayerService:Instance():GetPlayerId() then
            end
        end
        MapService:Instance():HideTiled()
    end
end

function LeagueHandler:HandleOpenRevoltRespond(msg)
    local message = msg;
    UIService:Instance():ShowUI(UIType.rebellUI, message)
end

-- 增加同盟分组聊天
function LeagueHandler:HandleBaseLeagueChatTeamInfo(msg)
    if self._logicManage:FindLeagueChatTeam(msg.leaderId) == nil then

        self:HandleBaseLeagueChatTeam(msg);

        local msg1 = require("MessageCommon/Msg/C2Chat/Chat/JoinChannel").new();
        msg1:SetMessageId(C2Chat_Chat.JoinChannel);
        msg1.channelId = ChatType.GroupingChat * 10000 + msg.leaderId;
        NetService:Instance():SendMessage(msg1);

        local baseClass = UIService:Instance():GetUIClass(UIType.UIChat);
        local isopen = UIService:Instance():GetOpenedUI(UIType.UIChat);
        if baseClass ~= nil and isopen == true then
            baseClass:RefreshChannelBtn();
        end

        return;
    end
    self:HandleBaseLeagueChatTeam(msg);
    local baseClass = UIService:Instance():GetUIClass(UIType.UIChat);
    local isopen = UIService:Instance():GetOpenedUI(UIType.UIChat);
    if baseClass ~= nil and isopen == true then
        baseClass:RefreshChannelBtn();
        -- baseClass:ShowChannelBtnRedImage();
    end
end

function LeagueHandler:HandleBaseLeagueChatTeam(msg)
    local ChatTeam = require("Game/League/ChatTeam").new();
    ChatTeam.leaderId = msg.leaderId;
    ChatTeam.name = msg.name;
    ChatTeam.leaderName = msg.leaderName;
    self._logicManage:SetLeagueChatTeam(ChatTeam.leaderId, ChatTeam);

    local baseClass1 = UIService:Instance():GetUIClass(UIType.UIAllianceChat);
    local isopen1 = UIService:Instance():GetOpenedUI(UIType.UIAllianceChat);
    if baseClass1 ~= nil and isopen1 == true then
        UIService:Instance():HideUI(UIType.UIAllianceChat);
    end

    local baseClass2 = UIService:Instance():GetUIClass(UIType.UIAllianceInformation);
    local isopen2 = UIService:Instance():GetOpenedUI(UIType.UIAllianceInformation);
    if baseClass2 ~= nil and isopen2 == true then
        UIService:Instance():HideUI(UIType.UIAllianceInformation);
    end
end

-- 创建同盟分组聊天
function LeagueHandler:HandleOpenLeagueChatTeamRespond(msg)
    self._logicManage:SetChatTeamName(msg.name);
    self._logicManage:SetTeamList(msg.teamList);
    self._logicManage:SetCanInventList(msg.canInventList);
end

-- 离开同盟分组聊天
function LeagueHandler:HandleRemoveLeagueChatTeam(msg)
    self._logicManage:RemoveChatTeam(msg.leaderId);
    ChatService:Instance():RemoveChatTableByChatType(ChatType.GroupingChat * 10000 + msg.leaderId, ChatType.GroupingChat);

    local msg1 = require("MessageCommon/Msg/C2Chat/Chat/LeaveChannel").new();
    msg1:SetMessageId(C2Chat_Chat.LeaveChannel);
    msg1.channelId = ChatType.GroupingChat * 10000 + msg.leaderId;
    NetService:Instance():SendMessage(msg1);

    local baseClass = UIService:Instance():GetUIClass(UIType.UIChat);
    local isopen = UIService:Instance():GetOpenedUI(UIType.UIChat);
    if baseClass ~= nil and isopen == true then
        baseClass:HandleRemoveLeagueChatTeam();
    end

    local baseClass1 = UIService:Instance():GetUIClass(UIType.UIAllianceChat);
    local isopen1 = UIService:Instance():GetOpenedUI(UIType.UIAllianceChat);
    if baseClass1 ~= nil and isopen1 == true then
        UIService:Instance():HideUI(UIType.UIAllianceChat);
    end

    local baseClass2 = UIService:Instance():GetUIClass(UIType.UIAllianceInformation);
    local isopen2 = UIService:Instance():GetOpenedUI(UIType.UIAllianceInformation);
    if baseClass2 ~= nil and isopen2 == true then
        UIService:Instance():HideUI(UIType.UIAllianceInformation);
    end
end

-- 登录同步同盟分组聊天
function LeagueHandler:HandleSyncPlayerBaseLeagueChatTeam(msg)
    -- print("HandleSyncPlayerBaseLeagueChatTeam");
    -- print(msg.list:Count());
    for i = 1, msg.list:Count() do
        local ChatTeam = require("Game/League/ChatTeam").new();
        ChatTeam.leaderId = msg.list:Get(i).leaderId;
        ChatTeam.name = msg.list:Get(i).name;
        ChatTeam.leaderName = msg.list:Get(i).leaderName;
        self._logicManage:SetLeagueChatTeam(ChatTeam.leaderId, ChatTeam);
        local msg1 = require("MessageCommon/Msg/C2Chat/Chat/JoinChannel").new();
        msg1:SetMessageId(C2Chat_Chat.JoinChannel);
        msg1.channelId = ChatType.GroupingChat * 10000 + msg.list:Get(i).leaderId;
        NetService:Instance():SendMessage(msg1);
    end
end

return LeagueHandler;
-- endregion
