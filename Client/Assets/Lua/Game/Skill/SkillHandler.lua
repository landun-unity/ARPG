local IOHandler = require("FrameWork/Game/IOHandler")

local SkillHandler = class("SkillHandler", IOHandler)

function SkillHandler:ctor()
	SkillHandler.super.ctor(self)
end

-- 注册所有消息
function SkillHandler:RegisterAllMessage()
    self:RegisterMessage(L2C_Skill.GetOnePlayerSkillListRespond,self.GetOnePlayerSkillList,require("MessageCommon/Msg/L2C/Skill/GetOnePlayerSkillListRespond"));
    self:RegisterMessage(L2C_Skill.UpdateSkill,self.UpdateSkill,require("MessageCommon/Msg/L2C/Skill/UpdateSkill"));
    self:RegisterMessage(L2C_Skill.DeleteOneSkillRespond,self.DeleteSkillInfo,require("MessageCommon/Msg/L2C/Skill/DeleteOneSkillRespond"));
    self:RegisterMessage(L2C_Skill.LearnSkillResult,self.LearnSkillResult,require("MessageCommon/Msg/L2C/Skill/LearnSkillResult"));
    self:RegisterMessage(L2C_Skill.SkillEnhanceResult,self.SkillEnhanceResult,require("MessageCommon/Msg/L2C/Skill/SkillEnhanceResult"));
end

--将roleId发送到逻辑服
function SkillHandler:RequestPlayerSkillList(roleId)
	local msg = require("MessageCommon/Msg/C2L/Skill/GetOnePlayerSkillList").new()
    msg:SetMessageId(C2L_Skill.GetOnePlayerSkillList)
    NetService:Instance():SendMessage(msg)
end

--获取玩家战法列表
function SkillHandler:GetOnePlayerSkillList(msg)
	self._logicManage:SetSkillInfoList(msg.allSkillList)
	LoginService:Instance():EnterState(LoginStateType.RequestSourceEvent);
end

--更新战法信息
function SkillHandler:UpdateSkill(msg)
	self._logicManage:UpdateSkill(msg)
end

--删除战法信息
function SkillHandler:DeleteSkillInfo(msg)
	self._logicManage:DeleteSkillInfo(msg)
end

function SkillHandler:LearnSkillResult(msg)
    ----print(msg.result);
end

function SkillHandler:SkillEnhanceResult(msg)
    ----print(msg.result);
end


return SkillHandler


