-- region *.lua
-- 同盟系统服务类
-- Date16/10/12

local GameService = require("FrameWork/Game/GameService");

local LeagueHandler = require("Game/League/LeagueHandler");
local LeagueManage = require("Game/League/LeagueManage");

LeagueService = class("LeagueService", GameService);


function LeagueService:ctor()

    print("LeagueService:ctor")
    LeagueService._instance = self;
    LeagueService.super.ctor(self, LeagueManage.new(), LeagueHandler.new());

end




function LeagueService:Instance()
    return LeagueService._instance;
end

--同盟外交的红点
function LeagueService:SetForeignBool(args)
 self._logic:SetForeignBool(args);
end

function LeagueService:GetForeignBool()
  return self._logic:GetForeignBool();
end

function LeagueService:GetChatTeamName()
    return self._logic:GetChatTeamName();
end

function LeagueService:GetCanInventList()
    return self._logic:GetCanInventList();
end

-- 被善让者
function LeagueService:getBeDimsePlayerID()
    return self._logic:getBeDimsePlayerID();
end


function LeagueService:GetTeamList()
    return self._logic:GetTeamList();
end

function LeagueService:GetLeagueChatTeam()
    return self._logic:GetLeagueChatTeam();
end

function LeagueService:FindLeagueChatTeam(id)
    return self._logic:FindLeagueChatTeam(id);
end

-- 清空数据
function LeagueService:Clear()
    self._logic:ctor()
end

-- 刷新公告
function LeagueService:RefreshLeagueNotice(notice)
    self._logic:RefreshLeagueNotice(notice)
end

function LeagueService:SetApplyNum(num)

    self._logic:SetApplyNum(num)

end

-- 获取同盟职位的数量
function LeagueService:GetTitleNum()
    return self._logic:GetTitleNum()
end

function LeagueService:RemoveLeagueMark(coord)
    self._logic:RemoveLeagueMark(coord)
end

function LeagueService:SetBeDimsePlayerID(id)
    self._logic:SetBeDimsePlayerID(id)
end

function LeagueService:GetApplyNum()

    return self._logic:GetApplyNum()

end


function LeagueService:GetMyLeagueInfo()

    return self._logic:GetLeague()

end

-- 同盟势力信息

function LeagueService:GetLeagueInfluenceList()

    return self._logic:GetLeagueInfluenceList()

end

-- 同盟外交信息
function LeagueService:GetLeagueForeignAll()

    return self._logic:GetLeagueForeignAll()

end

function LeagueService:GetLeagueforeignfriend()

    return self._logic:GetLeagueforeignfriend()

end

function LeagueService:GetLeagueforeignenemy()

    return self._logic:GetLeagueforeignenemy()

end


-- 添加同盟标记

function LeagueService:SendAddLeagueMarkMessage(_name, _coord, _description)

    self._logic:SendAddLeagueMarkMessage(_name, _coord, _description)

end

-- 同盟标记
function LeagueService:SendLeagueMarkMessage()

    self._logic:SendOpenLeagueMarkQuest()

end

-- 设置首战信息
function LeagueService:SetWildPlayerInfo(a)
    self._logic:SetWildPlayerInfo(a)
end


function LeagueService:GetLeagueMarkList()

    return self._logic:GetLeagueMarkList()

end

function LeagueService:GetWildPlayerInfo()

    return self._logic:GetWildPlayerInfo()
end



function LeagueService:GetJoinTime()
    return self._logic:GetJoinTime()
end

-- 打开反叛界面
function LeagueService:SendOpenRebellMsg()

    self._logic:SendOpenRebellMsg()

end

--- 发送点击也称请求
function LeagueService:SendRequestOccupyLeagueInfo(tiledIndex)

    self._logic:SendRequestOccupyLeagueInfo(tiledIndex)

end

-- 取消申请消息
function LeagueService:CancelApplyJoin(PlayerID, targetId)

    self._logic:_SendCancelApplyJoin(PlayerID, targetId)
end

-- 打开同盟消息
function LeagueService:SendLeagueMessage(PlayerID)

    self._logic:_SendOpenLeagueMessage(PlayerID)
end

-- 打开同盟成员信息
function LeagueService:SendLeagueMemberMessage(playerId)

    self._logic:_SendOpenLeagueMemberMessage(playerId)

end

-- 请求反叛
function LeagueService:RebellDonate(leagueid, wood, iron, grain, stone)

    self._logic:RebellDonate(leagueid, wood, iron, grain, stone)

end

-- 确认反叛
function LeagueService:SendEnsureRevoltRequest()

    self._logic:SendEnsureRevoltRequest()

end



function LeagueService:GetUnderMemberList()


    return self._logic:GetUnderMemberList()

end

-- 打开下属成员
function LeagueService:SendUnderMemberMessage()

    self._logic:SendUnderMemberMessage()

end

-- 创建同盟消息
function LeagueService:SendCreatLeagueMessage(playerId, name)

    self._logic:_SendCreatLeagueMessage(playerId, name)

end

-- 请求附近同盟
function LeagueService:SendAroundLeagueList(playerId)

    self._logic:_SendOpenAroundLeagueMessage(playerId)

end

-- 同盟邀请消息
function LeagueService:SendBeInviteLeague(playerId)

    self._logic:_SendBeInviteMessage(playerId)

end

-- 请求人物信息
function LeagueService:SendPlayerInfo(playerId, targetId)

    self._logic:_SendPlayerInfoInLeague(playerId, targetId)

end

-- 玩家同意加入
function LeagueService:SendplayerAgreeJoinMsg(playerId, targetId)
    -- print("SendPlayerAgreeMsg..........................................")
    self._logic:_SendplayerAgreeJoinMsg(playerId, targetId)

end
-- 同意加入同盟
function LeagueService:SendAgreeJoin(playerId, targetId)

    self._logic:_SendAgreeJoinMsg(playerId, targetId);

end

-- 禅让盟主
function LeagueService:SendApplyDemiseMsg(playerId, targetId)

    self._logic:_SendApplyDemiseMsg(playerId, targetId);

end

function LeagueService:SendRefuseJoin(playerId, targetId)

    self._logic:_SendRefuseJoin(playerId, targetId);

end

-- 申请加入同盟消息
function LeagueService:SendApplyJoin(playerId, targetId)
    -- print()
    self._logic:_SendApplyJoinMsg(playerId, targetId);

end

-- 打开指定同盟
function LeagueService:SendOpenAppiontLeague(playerId, targetId)

    self._logic:_SendOpenAppiontLeague(playerId, targetId);

end



function LeagueService:SendShutMsg(playerId, isShut)

    self._logic:_SendShutMsg(playerId, isShut);

end



function LeagueService:ImmediateApply(playerId, name)

    self._logic:_ImmediateApplyJoinMsg(playerId, name);

end


function LeagueService:SetTargetId(TargetId)

    self._logic:_SetTargetId(TargetId);

end

-- 任命官员消息
function LeagueService:SendAppiontOfficerMsg(playerId, targetId, title)

    self._logic:_SendAppiontOfficer(playerId, targetId, title);

end
-- 踢人消息
function LeagueService:SendKickMemberMsg(playerId, targetId)

    self._logic:_SendKickMemberMsg(playerId, targetId)

end

-- 罢免官员消息
function LeagueService:SendReCallOfficeMsg(playerId, targetId)

    self._logic:_SendReCallOfficeMsg(playerId, targetId)

end

-- 任命太守

function LeagueService:SendAppiontChiefMsg(playerId, targetId, chifeid)

    self._logic:_SendAppiontChiefMsg(playerId, targetId, chiefid)

end

-- 禅让盟主
function LeagueService:SendGiveUpLeaderMsg(playerId)

    self._logic:_SendGiveUpLeaderMsg(playerId)

end

-- 退出同盟
function LeagueService:SendQuitLeague(playerId)

    self._logic:_SendQiutLeagueMsg(playerId)

end

-- 解散同盟
function LeagueService:SendDissloveLeague(playerId)

    self._logic:_SendDissloveLeague(playerId)

end

-- 存储基础消息
function LeagueService:SetBaseMsg(playerId, targetId, titleId)

    self._logic:_SetBaseMsg(playerId, targetId, titleId)

end
-- 发送附近玩家消息
function LeagueService:SendRoundPlayerMsg(playerId)

    self._logic:_SendAroundPlayerMsg(playerId);

end


function LeagueService:ImmediateInvite(playerId, targetId)

    self._logic:ImmediateInviteOther(playerId, targetId);

end


-- 发送附近玩家消息
function LeagueService:SendCancelDemise(playerId, targetId)

    self._logic:_SendCancelDemiseMsg(playerId, targetId);

end

-- 发送移除同盟标记
function LeagueService:RemoveLeagueMark(markIndex)

    self._logic:RemoveLeagueMark(markIndex);

end

-- 发送邀请消息

function LeagueService:SendInviteMsg(playerId, targetId)

    self._logic:_SendInvitePlayerMsg(playerId, targetId);

end


--
function LeagueService:GetMyinfo()

    return self._logic:GetMyinfo()

end

function LeagueService:GetLeagueInfo()

    return self._logic:GetLeagueInfo()

end

-- 发送请求加入消息

function LeagueService:SendOpenApplyList(playerId)

    self._logic:_SendOpenApplyList(playerId);

end



function LeagueService:GetNextDemiseTime()

    return self._logic:GetNextDemiseTime()

end

function LeagueService:SetNextDemiseTime(time)

    self._logic:SetNextDemiseTime(time);
end


-- 发送同盟捐献信息

function LeagueService:SendLeagueDonate(_leagueid, _wood, _iron, _grain, _stone)

    self._logic:SendLeagueDonate(_leagueid, _wood, _iron, _grain, _stone)

end

-- 打开拥有野外建筑请求

function LeagueService:SendOpenWildBDingMessage()
    self._logic:SendOpenWildBDingMessage()
end


-- 打开同盟外交
function LeagueService:SendLeagueForiegn()

    self._logic:SendLeagueForiegn()
end

-- 请求成员列表
function LeagueService:GetLeagueMemberList()

    return self._logic:GetLeagueMemberList()

end

-- 设置同盟关系
function LeagueService:SendLeagueRelationMsg(id, relationtype)

    self._logic:SendLeagueRelationMsg(id, relationtype)

end

function LeagueService:SendOpenImmLeague(_name)

    self._logic:SendOpenImmLeague(_name)

end 


function LeagueService:GetFlag(args)

    return self._logic:GetFlag(args)

end

-- 存储本次捐献值
function LeagueService:SetDonateValue(param)

    self._logic:SetDonateValue(param)

end

function LeagueService:GetDonateValue()

    return self._logic:GetDonateValue()

end


return LeagueService
-- endregion
