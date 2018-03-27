

local GameMessage = require("common/Net/GameMessage")

local SkillMsgModel = require("MessageCommon/Msg/L2C/Model/SkillMsgModel")

local UpdateSkillInfoRespond = class("UpdateSkillInfoRespond", GameMessage)
local List = require("common/List")

function UpdateSkillInfoRespond:ctor()
    self.id = nil;
    self.tableID = nil;
    self.progress = nil;
    self.learnHeroID = List.new();
end

function UpdateSkillInfoRespond:_OnSerial()
	self:WriteInt64(self.id)
	self:WriteInt32(self.tableID)
	self:WriteInt32(self.progress)
	local count = self.learnHeroID:Count()
	self:WriteInt32(count)
	for j = 1,count do
		self:WriteInt64(self.learnHeroID:Get(j))
	end
end



function UpdateSkillInfoRespond:_OnDeserialize()
    self.id = self:ReadInt64()
    print(self.id)
    self.progress = self:ReadInt32()
    print(self.progress)
    self.tableID = self:ReadInt32()
    print(self.tableID)
    local heroCount = self:ReadInt32()
    print(heroCount)
    for index = 1,heroCount do
    	local heroID = ReadInt64()
    	self.learnHeroID:Push(heroID)
        print(self.learnHeroID)
    end
end

return UpdateSkillInfoRespond;
