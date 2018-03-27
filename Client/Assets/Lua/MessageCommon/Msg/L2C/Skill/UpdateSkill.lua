--
-- 逻辑服务器 --> 客户端
-- 技能进度信息
-- @author czx
--
local List = require("common/List");

local GameMessage = require("common/Net/GameMessage");
local UpdateSkill = class("UpdateSkill", GameMessage);

--
-- 构造函数
--
function UpdateSkill:ctor()
    UpdateSkill.super.ctor(self);
    --
    -- 技能Id
    --
    self.id = 0;
    
    --
    -- 表Id
    --
    self.tableID = 0;
    
    --
    -- 进度
    --
    self.progress = 0;
    
    --
    -- 学习的卡牌列表
    --
    self.learnHeroID = List.new();
end

--@Override
function UpdateSkill:_OnSerial() 
    self:WriteInt64(self.id);
    self:WriteInt32(self.tableID);
    self:WriteInt32(self.progress);
    
    local learnHeroIDCount = self.learnHeroID:Count();
    self:WriteInt32(learnHeroIDCount);
    for learnHeroIDIndex = 1, learnHeroIDCount, 1 do 
        self:WriteInt64(self.learnHeroID:Get(learnHeroIDIndex));
    end
end

--@Override
function UpdateSkill:_OnDeserialize() 
    self.id = self:ReadInt64();
    self.tableID = self:ReadInt32();
    self.progress = self:ReadInt32();
    
    local learnHeroIDCount = self:ReadInt32();
    for i = 1, learnHeroIDCount, 1 do 
        self.learnHeroID:Push(self:ReadInt64());
    end
end

return UpdateSkill;
