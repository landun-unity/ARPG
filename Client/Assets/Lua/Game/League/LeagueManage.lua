-- LeagueManage 同盟系统管理类
-- Date 16/10/11

local List = require("common/List");
local GamePart = require("FrameWork/Game/GamePart");
local UIService = require("Game/UI/UIService");
local NetService = require("Game/Net/NetService");
local PlayerService = require("Game/Player/PlayerService");
local LeagueTitleType = require("Game/League/LeagueTitleType")
local LeagueManage = class("LeagueManage", GamePart);
local LeaguePlayer = nil;
local UIPic = require("Game/Popupmap/UIPic");

-- 构造函数
function LeagueManage:ctor()

    LeagueManage.super.ctor(self);
    self._relationID = nil;

    self._joinCoolTime = nil;
    self.allLeagueMark = { }

    -- 同盟信息
    self._leagueName = nil;
    self._leagueId = nil;
    self._leaderid = nil;
    self._leadername = "";
    self._name = "";
    self._level = nil;
    self._exp = 0;
    self._memberNum = 0;
    self._province = 0;
    self._cityNum = 0;
    self._influence = 0;
    self._notice = "";
    self._applyNum = 0;

    -- 成员信息
    self._memberList = List.new()
    self.myInfo = nil;


    -- 附近同盟list
    self._roundLeagueList = List.new()

    -- 同盟邀请列表
    self._beInventedList = List.new()

    -- 人物信息
    self.playerid = 0;
    self.name = "";
    self.influence = 0;
    self.leagueName = "";
    self.title = 0;
    self.selfIntroduce = "";

    -- 指定同盟信息
    self._AppleagueId = 0;
    -- 同盟id
    self._AppleagueName = "";
    self._Appleaderid = 0;
    -- 盟主idlea
    self._AppleaderName = "";
    self._Applevel = 0;
    self._Appexp = 0;
    self._AppmemberNum = 0;
    self._Appprovince = 0;
    self._AppcityNum = 0;
    self._Appinfluence = 0;
    self._Appnotice = "";

    -- 基础消息
    self.BaseplayerID = nil;
    self.BaseTargetID = nil;
    self.BaseTitleID = nil;
    self.BaseType = nil;
    -- 存储附近势力消息
    self.roundPlayerList = List:new()
    -----
    self._applyJoinLeaguelList = List:new()
    -- 禅让时间
    self._nextDemiseTime = 0;
    self.applynum = nil;

    -- 同盟信息
    self.League = nil;
    -- 同盟势力信息
    self.LeagueInfluenceList = List:new();
    -- 同盟外交信息
    self.LeagueforeignAll = List:new()

    -- 同盟标记信息
    self.LeagueMarkList = List:new()
    self._PicperfabPath = DataUIConfig[UIType.UIPic].ResourcePath;

    -- 同盟标记旗帜
    self.allFlag = { }

    -- 下属成员n
    self.UnderMemberList = nil;

    -- 野城排名信息
    self.wildBuildingPlayeInfo = nil;

    -- 同盟捐献
    self.donateValue = nil;
    -- 同盟聊天
    self.leagueChatTeam = { };

    self.chatTeamName = "";
    -- 小组成员列表
    self.teamList = List.new();
    -- 能邀请的成员列表
    self.canInventList = List.new();

    -- 同盟职位数量
    self.viceLeaderNum = 0;
    self.commonderNum = 0;
    self.officerNum = 0;

    --简历同盟时间

    --
    self.LeagueForeignRed = false
end

function LeagueManage:GetLeagueMarkTable()
    return self.allLeagueMark
end

function LeagueManage:SetTitleNum()
    for k, v in pairs(self._memberList._list) do
        if v.title == LeagueTitleType.ViceLeader then
            self.viceLeaderNum = self.viceLeaderNum + 1
        end
        if v.title == LeagueTitleType.Command then
            self.commonderNum = self.commonderNum + 1
        end
        if v.title == LeagueTitleType.Officer then
            self.officerNum = self.officerNum + 1
        end
    end

end

function LeagueManage:GetTitleNum()
    return self.viceLeaderNum, self.commonderNum, self.officerNum
end

--同盟中外交的红点
function LeagueManage:SetForeignBool(args)
    self.LeagueForeignRed = args
end

--
--同盟中外交的红点
function LeagueManage:GetForeignBool()
   return self.LeagueForeignRed
end



function LeagueManage:SetChatTeamName(name)
    if name == nil then
        return;
    end

    self.chatTeamName = name;
end

function LeagueManage:GetChatTeamName()
    return self.chatTeamName;
end

function LeagueManage:SetCanInventList(valuelist)
    if valuelist == nil then
        return;
    end
    self.canInventList = valuelist;
end

function LeagueManage:GetCanInventList()
    return self.canInventList;
end

function LeagueManage:SetTeamList(valuelist)
    if valuelist == nil then
        return;
    end
    self.teamList = valuelist;
end

function LeagueManage:GetTeamList()
    return self.teamList;
end

function LeagueManage:SetLeagueChatTeam(id, value)
    if id == nil or value == nil then
        return;
    end

    self.leagueChatTeam[id] = value;
    
    ChatService:Instance():ChangeUnread(ChatType.GroupingChat * 10000 + id, 0);
end

function LeagueManage:GetLeagueChatTeam()
    return self.leagueChatTeam;
end

function LeagueManage:RemoveChatTeam(id)
    if id == nil then
        return;
    end

    self.leagueChatTeam[id] = nil;
end

function LeagueManage:FindLeagueChatTeam(id)
    if id == nil then
        return;
    end

    return self.leagueChatTeam[id];
end

-- 储存本次捐献值
function LeagueManage:SetDonateValue(param)

    self.donateValue = param

end

function LeagueManage:GetDonateValue()

    return self.donateValue

end

-- 野城排名信息
function LeagueManage:SetWildPlayerInfo(args)

    self.wildBuildingPlayeInfo = args;

end

function LeagueManage:GetWildPlayerInfo()

    return self.wildBuildingPlayeInfo;

end

-- 下属成员
function LeagueManage:SetUnderMemberList(args)

    self.UnderMemberList = args

end

function LeagueManage:GetUnderMemberList()

    return self.UnderMemberList

end


function LeagueManage:SetApplyNum(Num)

    self.applynum = Num;
    -- ----print(self.applynum)
end

function LeagueManage:GetApplyNum()

    return self.applynum

end

function LeagueManage:RemoveLeagueMark(coord)
    for k, v in pairs(self.LeagueMarkList._list) do
        if v.coord == coord then
            self.LeagueMarkList:Remove(v);
        end
    end

end

function LeagueManage:SetFlag(k, v)

    self.allFlag[k] = v

end

function LeagueManage:GetFlag(k)

    if self.allFlag[k] == nil then
        return nil;
    end
    return self.allFlag[k]

end



function LeagueManage:GetNextDemiseTime()

    -- ----print(self._nextDemiseTime)
    return self._nextDemiseTime;

end

function LeagueManage:SetNextDemiseTime(time)

    self._nextDemiseTime = time;
    -- ----print(self._nextDemiseTime)

end

function LeagueManage:SetmemberList(memebrList)

    self._memberList = memebrList;
    local size = self._memberList:Count()
    for i = 1, size do
        if self._memberList:Get(i).playerid == PlayerService:Instance():GetPlayerId() then
            self.myInfo = self._memberList:Get(i)
            PlayerService:Instance():SetPlayerTitle(self.myInfo.title)
        end
    end

end

function LeagueManage:GetLeagueMemberList()

    return self._memberList

end

function LeagueManage:GetMyinfo()

    return self.myInfo;

end

function LeagueManage:SetLeague(League)

    self.League = League;

end

function LeagueManage:getBeDimsePlayerID()
    return self.League.beDemisePlayerId
end

function LeagueManage:SetBeDimsePlayerID(id)
     self.League.beDemisePlayerId  = id
end


function LeagueManage:GetLeague()

    return self.League

end

-- 设置同盟实力list
function LeagueManage:SetLeagueInfluence(_list)

    self.LeagueInfluenceList = _list

end


function LeagueManage:GetLeagueInfluenceList()

    return self.LeagueInfluenceList

end


function LeagueManage:RemoveFormInfluenceList(args)
    for k, v in pairs(self.LeagueInfluenceList._list) do

        if v == args then
            self.LeagueInfluenceList:Remove(v)
        end
    end
end

function LeagueManage:AddToLeagueInfluenceList(args)

    self.LeagueInfluenceList:Push(args)

end

-- 同盟外交
function LeagueManage:SetLeagueForeignAll(_list)

    self.LeagueforeignAll = _list


end

function LeagueManage:GetLeagueForeignAll()

    return self.LeagueforeignAll

end


-- 反叛捐献
function LeagueManage:RebellDonate(leagueid, wood, iron, grain, stone)

    local msg = require("MessageCommon/Msg/C2L/League/RevoltRequest").new();
    msg:SetMessageId(C2L_League.RevoltRequest)
    msg.leagueId = leagueid;
    msg.wood = wood;
    msg.iron = iron
    msg.grain = grain
    msg.stone = stone;
    NetService:Instance():SendMessage(msg)

end


-- 刷新公告
function LeagueManage:RefreshLeagueNotice(notice)
    local msg = require("MessageCommon/Msg/C2L/League/RefreshLeagueNotice").new();
    msg:SetMessageId(C2L_League.RefreshLeagueNotice)
    msg.notice = notice;
    NetService:Instance():SendMessage(msg)
end


-- 打开反叛界面请求
function LeagueManage:SendOpenRebellMsg()

    local msg = require("MessageCommon/Msg/C2L/League/OpenRevoltRequest").new();
    msg:SetMessageId(C2L_League.OpenRevoltRequest)

    NetService:Instance():SendMessage(msg)

end



-- 确认反叛
function LeagueManage:SendEnsureRevoltRequest()

    local msg = require("MessageCommon/Msg/C2L/League/EnsureRevoltRequest").new();
    msg:SetMessageId(C2L_League.EnsureRevoltRequest)

    NetService:Instance():SendMessage(msg)
    ----print("反叛")
end


function LeagueManage:_OnInit()


end


-- 发送打开同盟消息
function LeagueManage:_SendOpenLeagueMessage(playerId)

    local msg = require("MessageCommon/Msg/C2L/League/RequestOpenLeague").new();
    msg:SetMessageId(C2L_League.RequestOpenLeague)

    NetService:Instance():SendMessage(msg)

end


-- 同盟不存在情况
function LeagueManage:_IsNoLeague(msg)
    self._joinCoolTime = msg.joinCoolingTime;

end

function LeagueManage:GetJoinTime()
    
    return self._joinCoolTime;

end




-- 储存同盟信息
function LeagueManage:SetLeagueInfo(msg)
    self._leagueId = msg.leagueId;
    self._leaderid = msg.leaderid;
    self._leadername = msg.leaderName;
    self._leagueName = msg.leagueName;
    self._level = msg.level;
    self._exp = msg.exp;
    self._memberNum = msg.memberNum;
    self._province = msg.province;
    self._cityNum = msg.cityNum;
    self._influence = msg.influence;
end

function LeagueManage:GetLeagueInfo()

    local data = { leaugeId = self._leagueId, leaderid = self._leaderid, leaderName = self._leadername, leagueName = self._leagueName, level = self._level, exp = self._exp, memberNum = self._memberNum, province = self._province, cityNum = self._cityNum, influence = self._influence };
    return data;

end


-- 请求打开同盟成员界面
function LeagueManage:_SendOpenLeagueMemberMessage(playerId)

    local msg = require("MessageCommon/Msg/C2L/League/RequestOpenLeagueMembers").new();
    msg:SetMessageId(C2L_League.RequestOpenLeagueMembers)


    NetService:Instance():SendMessage(msg)

end


function LeagueManage:ImmediateInviteOther(playerId, targetId)

    local msg = require("MessageCommon/Msg/C2L/League/ImmediateInviteOther").new();
    msg:SetMessageId(C2L_League.ImmediateInviteOther)

    msg.targetPlayerName = targetId;
    NetService:Instance():SendMessage(msg)

end


-- 请求下属成员
function LeagueManage:SendUnderMemberMessage()

    local msg = require("MessageCommon/Msg/C2L/League/OpenUnderMemberRequest").new();
    msg:SetMessageId(C2L_League.OpenUnderMemberRequest)


    NetService:Instance():SendMessage(msg)

end


-- 储存同盟成员信息
function LeagueManage:_SetLeagueMemberinfo(msg)

    self._memberList:Clear()
    local size = msg.list:Count();
    for i = 1, size do
        self._memberList:Push(msg.list:Get(i))
    end


end

-- 打开同盟成员界面
function LeagueManage:_OpenLeagueMemberUI(memberlist)

    UIService:Instance():HideUI(UIType.LeagueExistUI)
    UIService:Instance():ShowUI(UIType.LeagueMemberUI, memberlist)

end


-- 请求创建同盟信息
function LeagueManage:_SendCreatLeagueMessage(playerId, name)


    local msg = require("MessageCommon/Msg/C2L/League/CreateLeague").new();
    -- ----print(msg);
    msg:SetMessageId(C2L_League.CreateLeague)

    msg.name = name;

    NetService:Instance():SendMessage(msg)

end

-- 创建同盟成功,打开同盟
function LeagueManage:_CreatLeagueSucessOPenLeague(msg)

    self:_SendOpenLeagueMessage(PlayerService:Instance():GetPlayerId())

end

-- 请求附近同盟信息
function LeagueManage:_SendOpenAroundLeagueMessage(playerId)

    local msg = require("MessageCommon/Msg/C2L/League/OpenRoundLeagueList").new();
    msg:SetMessageId(C2L_League.OpenRoundLeagueList)

    NetService:Instance():SendMessage(msg)

end

function LeagueManage:_SetAroundLeague(msg)

    self._roundLeagueList:Clear()
    local size = msg._roundLeagueList:Count();
    for i = 1, size do
        self._roundLeagueList:Push(msg._roundLeagueList:Get(i))
    end

end

function LeagueManage:_OpenLeagueAddUI(msg)

    UIService:Instance():HideUI(UIType.LeagueDisExistUI)
    UIService:Instance():ShowUI(UIType.LeagueAddUI, msg)

end

-- 关闭入盟申请
function LeagueManage:_SendShutMsg(playerId, _isShut)

    local msg = require("MessageCommon/Msg/C2L/League/ShutJoinApplyLeague").new();
    msg:SetMessageId(C2L_League.ShutJoinApplyLeague)
    -- msg:SetRelationId(self._relationID)
    msg.isShut = _isShut
    NetService:Instance():SendMessage(msg)
    -- ----print("closeOpem")
end


-- 直接申请

function LeagueManage:_ImmediateApplyJoinMsg(playerId, name)

    local msg = require("MessageCommon/Msg/C2L/League/ImmediateApplyJoin").new();
    msg:SetMessageId(C2L_League.ImmediateApplyJoin)

    msg.name = name
    NetService:Instance():SendMessage(msg)

end

-- 请求同盟邀请消息
function LeagueManage:_SendBeInviteMessage(playerId)

    local msg = require("MessageCommon/Msg/C2L/League/OpenBeInventLeague").new();
    msg:SetMessageId(C2L_League.OpenBeInventLeague)

    NetService:Instance():SendMessage(msg)

end

function LeagueManage:_SetBeInviteLeagueList(msg)

    self._beInventedList:Clear()
    local size = msg._beInventedList:Count();
    for i = 1, size do
        self._beInventedList:Push(msg._beInventedList:Get(i))
    end

end

function LeagueManage:_OpenLeagueInviteUI(msg)

    UIService:Instance():ShowUI(UIType.LeagueInviteUI, msg)

end


-- 发送请求人物信息
function LeagueManage:_SendPlayerInfoInLeague(playerId, targetId)

    local msg = require("MessageCommon/Msg/C2L/League/OpenPlayerInfoInLeague").new();
    msg:SetMessageId(C2L_League.OpenPlayerInfoInLeague)

    msg.targetId = targetId
    NetService:Instance():SendMessage(msg)

end

-- 取消申请
function LeagueManage:_SendCancelApplyJoin(playerId, targetId)

    local msg = require("MessageCommon/Msg/C2L/League/CancelApplyJoin").new();
    msg:SetMessageId(C2L_League.CancelApplyJoin)

    msg.leagueId = targetId
    NetService:Instance():SendMessage(msg)

end



-- 储存人物信息
function LeagueManage:_SetPlayerInfoInLeague(msg)

    self.playerid = msg.playerid;
    self.name = msg.name;
    self.influence = msg.influence;
    self.leagueName = msg.leagueName;
    self.title = msg.title;
    self.selfIntroduce = msg.selfIntroduce;

end

-- 打开人物信息界面
function LeagueManage:_OpenPlayerInfoUI()

    UIService:Instance():ShowUI(UIType.PlayerInfoUI)

end

-- 发送同意加入同盟消息
function LeagueManage:_SendAgreeJoinMsg(playerId, targetId)

    local msg = require("MessageCommon/Msg/C2L/League/AgreeJoin").new();
    msg:SetMessageId(C2L_League.AgreeJoin)

    msg.targetId = targetId
    NetService:Instance():SendMessage(msg)

end

--- 玩家同一加入同盟
function LeagueManage:_SendplayerAgreeJoinMsg(playerId, _leagueId)

    local msg = require("MessageCommon/Msg/C2L/League/PlayerAgreeJoinInvent").new();
    msg:SetMessageId(C2L_League.PlayerAgreeJoinInvent)

    msg.leagueId = _leagueId
    NetService:Instance():SendMessage(msg)
    -- ----print("MessageCommon/Msg/C2L/League/PlayerAgreeJoinInvent")
end



-- 发送请求加入同盟消息
function LeagueManage:_SendApplyJoinMsg(playerid, _leagueId)

    local msg = require("MessageCommon/Msg/C2L/League/ApplyJoin").new();
    msg:SetMessageId(C2L_League.ApplyJoin)

    msg.leagueId = _leagueId
    NetService:Instance():SendMessage(msg)

end


-- 发送打开指定同盟消息
function LeagueManage:_SendOpenAppiontLeague(playerId, _leagueId)

    local msg = require("MessageCommon/Msg/C2L/League/RequestOpenAppointLeague").new();
    msg:SetMessageId(C2L_League.RequestOpenAppointLeague)

    msg.leagueId = _leagueId
    NetService:Instance():SendMessage(msg)

end

-- 储存指定同盟消息
function LeagueManage:_SetAppiontLeague(msg)

    self._AppleagueId = msg._leagueId;
    -- 同盟id
    self._AppleagueName = msg._leagueName;
    self._Appleaderid = msg._leaderid;
    -- 盟主id
    self._AppleaderName = msg._leaderName;
    self._Applevel = msg._level;
    self._Appexp = msg._exp;
    self._AppmemberNum = msg._memberNum;
    self._Appprovince = msg._province;
    self._AppcityNum = msg._cityNum;
    self._Appinfluence = msg._influence
    self._Appnotice = msg._notice;

end


function LeagueManage:_SetTargetId(targetID)

    self.targetid_power = targetID;

end
-- 发送任命官员信息
function LeagueManage:_SendAppiontOfficer(playerId, targetId, title)

    local msg = require("MessageCommon/Msg/C2L/League/AppointOfficer").new();
    msg:SetMessageId(C2L_League.AppointOfficer)

    msg.targetId = targetId
    msg.titleId = title;
    NetService:Instance():SendMessage(msg)

end

-- 任命官员返回
function LeagueManage:_HideLeagueOfficePosUI()

    UIService:Instance():HideUI(UIType.LeagueOfficePosUI)

end

-- 踢人消息
function LeagueManage:_SendKickMemberMsg(playerId, targetId)

    local msg = require("MessageCommon/Msg/C2L/League/KickOneMember").new();
    msg:SetMessageId(C2L_League.KickOneMember)

    msg.targetid = targetId
    NetService:Instance():SendMessage(msg)

end

-- 踢人返回
function LeagueManage:_HideLeaderOtherPowerUI()

    UIService:Instance():HideUI(UIType.LeaderOtherPowerUI)

end

-- 罢免官员消息
function LeagueManage:_SendReCallOfficeMsg(playerId, targetId)

    local msg = require("MessageCommon/Msg/C2L/League/RecallOfficer").new();
    msg:SetMessageId(C2L_League.RecallOfficer)

    msg.targetId = targetId
    NetService:Instance():SendMessage(msg)

end

-- 任命太守消息
function LeagueManage:_SendAppiontChiefMsg(playerId, targetId, chiefId)

    local msg = require("MessageCommon/Msg/C2L/League/AppointChief").new();
    msg:SetMessageId(C2L_League.AppointChief)

    msg.targetId = targetId
    msg.chiefId = chiefId;
    NetService:Instance():SendMessage(msg)

end

-- 放弃副盟主
function LeagueManage:_SendGiveUpLeaderMsg(playerId)

    local msg = require("MessageCommon/Msg/C2L/League/GiveUpMyViceLeader").new();
    msg:SetMessageId(C2L_League.GiveUpMyViceLeader)
    NetService:Instance():SendMessage(msg)

end

-- 禅让盟主
function LeagueManage:_SendApplyDemiseMsg(playerId, targetId)

    local msg = require("MessageCommon/Msg/C2L/League/ApplyDemise").new();
    msg:SetMessageId(C2L_League.ApplyDemise)

    msg.targetPlayerid = targetId
    NetService:Instance():SendMessage(msg)

end

-- 取消禅让
function LeagueManage:_SendCancelDemiseMsg(playerId, targetId)

    local msg = require("MessageCommon/Msg/C2L/League/CancelDemise").new();
    msg:SetMessageId(C2L_League.CancelDemise)

    msg.targetPlayerid = targetId

    NetService:Instance():SendMessage(msg)

end


-- 退出同盟
function LeagueManage:_SendQiutLeagueMsg(playerId)

    local msg = require("MessageCommon/Msg/C2L/League/QuitLeague").new();
    msg:SetMessageId(C2L_League.QuitLeague)

    NetService:Instance():SendMessage(msg)

end


-- 解散同盟
function LeagueManage:_SendDissloveLeague(playerId)

    local msg = require("MessageCommon/Msg/C2L/League/DissolveLeague").new();
    msg:SetMessageId(C2L_League.DissolveLeague)

    NetService:Instance():SendMessage(msg)

end

-- 拒绝加入
function LeagueManage:_SendRefuseJoin(playerId, targetId)

    local msg = require("MessageCommon/Msg/C2L/League/RefuseJoin").new();
    msg:SetMessageId(C2L_League.RefuseJoin)

    msg.targetId = targetId;
    NetService:Instance():SendMessage(msg)

end

function LeagueManage:_SetBaseMsg(Basetype, targetId, titleId)

    self.BaseType = Basetype;
    self.BaseTargetID = targetId;
    self.BaseTitleID = titleId;

end

-- 请求附近势力
function LeagueManage:_SendAroundPlayerMsg(PlayerId)

    -- ----print("getRoundPlauyer")
    local msg = require("MessageCommon/Msg/C2L/League/OpenRoundPlayer").new();

    msg:SetMessageId(C2L_League.OpenRoundPlayer)

    NetService:Instance():SendMessage(msg)

end



function LeagueManage:_OpenRoundPlayerUI(msg)

    UIService:Instance():ShowUI(UIType.LeagueMemberAddUI, msg)

end
------------请求玩家加入

function LeagueManage:_SendInvitePlayerMsg(playerId, targetId)

    local msg = require("MessageCommon/Msg/C2L/League/InviteOther").new();
    msg:SetMessageId(C2L_League.InviteOther)

    msg.targetPlayerid = targetId
    NetService:Instance():SendMessage(msg)

end

-- 请求申请列表
function LeagueManage:_SendOpenApplyList(playerId)

    local msg = require("MessageCommon/Msg/C2L/League/OpenApplyList").new();
    msg:SetMessageId(C2L_League.OpenApplyList)

    NetService:Instance():SendMessage(msg)

end

function LeagueManage:_SetApplyLeagueList(msg)

    self._applyJoinLeaguelList:Clear()
    local size = msg._applyJoinLeaguelList:Count();
    for i = 1, size do
        self._applyJoinLeaguelList:Push(msg._applyJoinLeaguelList:Get(i))
    end

end

function LeagueManage:_OpenRequireUI(msg)

    UIService:Instance():ShowUI(UIType.LeagueRequireInUI, msg)

end


function LeagueManage:LeagueMarkBack(_index)

    local _tiled = MapService:Instance():GetTiledByIndex(_index)
    local mPic = UIPic.new()
    GameResFactory.Instance():GetUIPrefab(self._PicperfabPath, _tiled.gameObject.transform, mPic, function(go)
        mPic:Init();
        local data = { };
        mPic:SetPicMessage(PointPicList:Get(index))
    end )

end

function LeagueManage:SendOpenImmLeague(_name)

    local msg = require("MessageCommon/Msg/C2L/League/HandleRequestImmediateOpenAppointLeague").new();
    msg:SetMessageId(C2L_League.HandleRequestImmediateOpenAppointLeague)
    msg.name = _name
    NetService:Instance():SendMessage(msg)
    -- ----print("打开指定名称同盟")
end

function LeagueManage:SendOpenLeagueMarkQuest()

    local msg = require("MessageCommon/Msg/C2L/League/OpenLeagueMarkRequest").new();
    msg:SetMessageId(C2L_League.OpenLeagueMarkRequest)

    NetService:Instance():SendMessage(msg)

end

--- t同盟标记信息存储

function LeagueManage:SetLeagueMarkList(_list)

    self.LeagueMarkList = _list;

end

function LeagueManage:GetLeagueMarkList()

    return self.LeagueMarkList;

end

function LeagueManage:InsertLeagueMark(_mark)

    self.LeagueMarkList:Push(_mark)

end

function LeagueManage:_GetLeagueMarkByID(id)
    for i = 1, self.LeagueMarkList:Count() do
        if self.LeagueMarkList:Get(i).id == id then
            return self.LeagueMarkList:Get(i)
        end
    end
end

function LeagueManage:SendRequestOccupyLeagueInfo(tiledIndex)
    local msg = require("MessageCommon/Msg/C2L/League/RequestOccupyLeagueInfo").new();
    msg:SetMessageId(C2L_League.RequestOccupyLeagueInfo)
    msg.wildBuildingTiledIndex = tiledIndex
    NetService:Instance():SendMessage(msg)
end



-- 发送同盟标记信息
function LeagueManage:SendAddLeagueMarkMessage(_name, _coord, _description)
    local msg = require("MessageCommon/Msg/C2L/League/AddLeagueMark").new();
    msg:SetMessageId(C2L_League.AddLeagueMark)
    msg.name = _name
    msg.coord = _coord
    msg.description = _description
    NetService:Instance():SendMessage(msg)
    -- ----print("AddLeagueMark")
end


-- 发送同盟捐献信息

function LeagueManage:SendLeagueDonate(_leagueid, _wood, _iron, _grain, _stone)
    local msg = require("MessageCommon/Msg/C2L/League/DonateRequest").new();
    msg:SetMessageId(C2L_League.DonateRequest)
    msg.leagueId = _leagueid
    msg.wood = _wood
    msg.iron = _iron
    msg.grain = _grain
    msg.stone = _stone
    NetService:Instance():SendMessage(msg)
    -- ----print("发送同盟捐献消息")
end


-- 打开同盟外交
function LeagueManage:SendLeagueForiegn()

    local msg = require("MessageCommon/Msg/C2L/League/OpenDiplomacyLeagueRequest").new();
    msg:SetMessageId(C2L_League.OpenDiplomacyLeagueRequest)
    NetService:Instance():SendMessage(msg)
    -- ----print("发送同盟外交消息")

end


-- 打开拥有野外建筑请求

function LeagueManage:SendOpenWildBDingMessage()

    local msg = require("MessageCommon/Msg/C2L/League/OpenOwnWildBuildRequest").new();
    msg:SetMessageId(C2L_League.OpenOwnWildBuildRequest)

    NetService:Instance():SendMessage(msg)
    -- ----print("发送建筑物消息")

end

function LeagueManage:RemoveLeagueMark(markIndex)
    -- ----print("lala")
    local msg = require("MessageCommon/Msg/C2L/League/RemoveLeagueMark").new();
    msg:SetMessageId(C2L_League.RemoveLeagueMark)
    msg.markIndex = markIndex
    NetService:Instance():SendMessage(msg)
end


function LeagueManage:SendLeagueRelationMsg(id, relationtype)
    local msg = require("MessageCommon/Msg/C2L/League/ConfigRelationRequest").new();
    msg:SetMessageId(C2L_League.ConfigRelationRequest)
    msg.leagueId = id
    msg.diplomacyType = relationtype
    NetService:Instance():SendMessage(msg)
end


-- 显示部队行为层
function LeagueManage:_OnShowArmyLayer(battlingObject, parent, tiled)
    local position = MapService:Instance():GetTiledPosition(tiled:GetX(), tiled:GetY());
    tiled:SetTiledImage(LayerType.Army, battlingObject.transform);
    battlingObject.transform.localScale = Vector3.one;
end

return LeagueManage;


-- endregion
