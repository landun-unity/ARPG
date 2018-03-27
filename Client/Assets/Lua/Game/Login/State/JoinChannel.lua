
local BaseState = require("Game/State/BaseState")

local JoinChannel = class("JoinChannel", BaseState)

-- 构造函数
function JoinChannel:ctor(...)
    JoinChannel.super.ctor(self, ...);
end

-- 进入操作
function JoinChannel:OnEnterState(...)
    local msg = require("MessageCommon/Msg/C2Chat/Chat/RegisterChat").new();
    msg:SetMessageId(C2Chat_Chat.RegisterChat);
    msg.zoneId = 1;
    msg.country = PlayerService:Instance():GetLeagueId();
    msg.state = PlayerService:Instance():GetSpawnState();
    msg.playerName = PlayerService:Instance():GetName();
    msg.leagueName = PlayerService:Instance():GetLeagueName();
    msg.leadership = PlayerService:Instance():GetPlayerTitle();
    NetService:Instance():SendMessage(msg);
    
    --世界
    local msg = require("MessageCommon/Msg/C2Chat/Chat/JoinChannel").new();
    msg:SetMessageId(C2Chat_Chat.JoinChannel);
    msg.channelId = ChatType.WorldChat * 10000;
    NetService:Instance():SendMessage(msg);
    --州
    local msg = require("MessageCommon/Msg/C2Chat/Chat/JoinChannel").new();
    msg:SetMessageId(C2Chat_Chat.JoinChannel);
    msg.channelId = ChatType.StateChat * 10000 + PlayerService:Instance():GetSpawnState();
    NetService:Instance():SendMessage(msg);
    --事件
    local msg = require("MessageCommon/Msg/C2Chat/Chat/JoinChannel").new();
    msg:SetMessageId(C2Chat_Chat.JoinChannel);
    msg.channelId = ChatType.SystemChat * 10000 + PlayerService:Instance():GetPlayerId();
    NetService:Instance():SendMessage(msg);

    if PlayerService:Instance():GetLeagueId() == 0 then
        return;
    end
    --同盟
    local msg = require("MessageCommon/Msg/C2Chat/Chat/JoinChannel").new();
    msg:SetMessageId(C2Chat_Chat.JoinChannel);
    msg.channelId = ChatType.AllianceChat * 10000 + PlayerService:Instance():GetLeagueId();
    NetService:Instance():SendMessage(msg);
    --请求同盟分组
    local msg = require("MessageCommon/Msg/C2L/League/BaseLeagueChatTeamQuest").new();
    msg:SetMessageId(C2L_League.BaseLeagueChatTeamQuest);
    NetService:Instance():SendMessage(msg);

    -- --同盟分组
    -- local msg = require("MessageCommon/Msg/C2Chat/Chat/JoinChannel").new();
    -- print(C2Chat_Chat.GroupingChat)
    -- msg:SetMessageId(C2Chat_Chat.GroupingChat);
    -- msg.channelId = ChatType.GroupingChat * 10000 + PlayerService:Instance():GetLeagueId() + PlayerService:Instance():GetPlayerId();
    -- NetService:Instance():SendMessage(msg);
    --赛季
    -- local msg = require("MessageCommon/Msg/C2Chat/Chat/JoinChannel").new();
    -- print(C2Chat_Chat.CompetitionChat)
    -- msg:SetMessageId(C2Chat_Chat.CompetitionChat);
    -- msg.channelId = ChatType.CompetitionChat * 10000 + PlayerService:Instance():GetPlayerId();
    -- NetService:Instance():SendMessage(msg);
end

function JoinChannel:CanEnterState(stateType)
	print(stateType)
    -- if stateType >= LoginStateType.CreateRole then
        return true;
    -- end
    -- return false;
end

-- 离开操作
function JoinChannel:OnLeaveState(...)

end

return JoinChannel;