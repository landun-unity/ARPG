
-- 获取战法回复

local GameMessage = require("common/Net/GameMessage")

local SkillMsgModel = require("MessageCommon/Msg/L2C/Model/SkillMsgModel")

local List = require("common/List")

local GetOnePlayerSkillListRespond = class("GetOnePlayerSkillListRespond", GameMessage)
   
function GetOnePlayerSkillListRespond:ctor()
  self._skillModelList = List.new()

end

function GetOnePlayerSkillListRespond:_OnSerial()

    local size=self._skillModelList:Count()
	self:WriteInt32(size)
	for i = 1,size do
		local model = self._skillModelList:Get(i)
		if model ~= nil then
			self:WriteInt64(model.id)
			self:WriteInt32(model.tableID)
			self:WriteInt32(model.progress)
			local count = model.learnHeroID:Count()
			self:WriteInt32(count)
			for j = 1,count do
				self:WriteInt64(model.learnHeroID:Get(j))
			end
		end
	end
	self._skillModelList = nil

end



function GetOnePlayerSkillListRespond:_OnDeserialize()

    local modelcount = self:ReadInt32();
    for index = 1,modelcount do
    	local model = SkillMsgModel.new()
    	model.id = self:ReadInt64()
    	print(model.id)
    	model.tableID = self:ReadInt32()
    	print(model.tableID)
    	model.progress = self:ReadInt32()
    	print(model.progress)
    	local heroCount = self:ReadInt32()
    	print(heroCount)
    	for index = 1,heroCount do
    		local heroID = ReadInt64()
    		model.learnHeroID:Push(heroID)
    	end
    	print(model)
    	self._skillModelList:Push(model)
    end

end

return GetOnePlayerSkillListRespond;

