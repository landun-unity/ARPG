--
-- 逻辑服务器 --> 客户端
-- 玩家技能回复
-- @author czx
--
local List = require("common/List");

local SkillMsgModel = require("MessageCommon/Msg/L2C/Skill/SkillMsgModel");

local GameMessage = require("common/Net/GameMessage");
local GetOnePlayerSkillListRespond = class("GetOnePlayerSkillListRespond", GameMessage);

--
-- 构造函数
--
function GetOnePlayerSkillListRespond:ctor()
    GetOnePlayerSkillListRespond.super.ctor(self);
    --
    -- 所有的技能列表
    --
    self.allSkillList = List.new();
end

--@Override
function GetOnePlayerSkillListRespond:_OnSerial() 
    
    local allSkillListCount = self.allSkillList:Count();
    self:WriteInt32(allSkillListCount);
    for i = 1, allSkillListCount, 1 do 
        local allSkillListValue = self.allSkillList:Get(i);
        
        self:WriteInt64(allSkillListValue.id);
        self:WriteInt32(allSkillListValue.tableID);
        self:WriteInt32(allSkillListValue.progress);
        
        local allSkillListValueLearnHeroIDCount = allSkillListValue.learnHeroID:Count();
        self:WriteInt32(allSkillListValueLearnHeroIDCount);
        for i = 1, allSkillListValueLearnHeroIDCount, 1 do 
            self:WriteInt64(allSkillListValue.learnHeroID:Get(i));
        end
    end
end

--@Override
function GetOnePlayerSkillListRespond:_OnDeserialize() 
    
    local allSkillListCount = self:ReadInt32();
    for i = 1, allSkillListCount, 1 do 
        local allSkillListValue = SkillMsgModel.new();
        allSkillListValue.id = self:ReadInt64();
        allSkillListValue.tableID = self:ReadInt32();
        allSkillListValue.progress = self:ReadInt32();
        
        local allSkillListValueLearnHeroIDCount = self:ReadInt32();
        for i = 1, allSkillListValueLearnHeroIDCount, 1 do 
            allSkillListValue.learnHeroID:Push(self:ReadInt64());
        end
        self.allSkillList:Push(allSkillListValue);
    end
end

return GetOnePlayerSkillListRespond;
