--region *.lua
--Date

local CardModel=require("MessageCommon/Msg/L2C/Model/CardModel");
local GameMessage = require("common/Net/GameMessage");
local List=require("common/List");
local OnePlayerAddOneCardRespond = class("OnePlayerAddOneCardRespond", GameMessage);
   
function OnePlayerAddOneCardRespond:ctor()

    OnePlayerAddOneCardRespond.super.ctor(self);
    -- 卡牌list
    

end




-- @override
function OnePlayerAddOneCardRespond:_OnSerial()

        local size=self._cardModelList:Count()
		self:WriteInt32(size);

        for i=1,size  do

        local model=self._cardModelList:Get(i);
        --实现continue
        while true do

        if model == nil then 
        break
         end

        self:WriteInt64(model.iD);
		self:WriteInt32(model._tableID);
		self:WriteInt64(model._exp);
	    self:WriteInt32(model._level);
		self:WriteInt32(model.advancedTime);
		self:WriteInt32(model.power);
		self:WriteInt32(model.troop);
		self:WriteInt32(model.point);
		self:WriteInt32(model.attacktPoint);
		self:WriteInt32(model.defensePoint);
		self:WriteInt32(model.strategyPoint);
		self:WriteInt32(model.speedPoint);
		self:WriteBoolean(model.isProtect);
		self:WriteBoolean(model.isAwaken);
		self:WriteInt32(model.skillIDOne);
		self:WriteInt32(model.SkillOneLevel);
		self:WriteInt32(model.SkillTwoID);
		self:WriteInt32(model.SkillTwoLevel);
		self:WriteInt32(model.SkillThreeID);
		self:WriteInt32(model.SkillThreeLevel);
        
        break
    end

        end
        
		 self._cardModelList:Clear();

end


-- @override
function OnePlayerAddOneCardRespond:_OnDeserialize()

        self._cardModelList:Clear();
		local count = self:ReadInt32();
--		 model=nil;

        for index=1,count do

           local model=CardModel.new();
			model.iD = self:ReadInt64();
			model._tableID = self:ReadInt32();
			model._exp = self:ReadInt64();
            model._level=self:ReadInt32();
			model.advancedTime = self:ReadInt32();
			model.power = self:ReadInt32();
			model.troop = self:ReadInt32();
			model.point = self:ReadInt32();
			model.attacktPoint = self:ReadInt32();
			model.defensePoint = self:ReadInt32();
			model.strategyPoint = self:ReadInt32();
			model.speedPoint = self:ReadInt32();
			model.isProtect = self:ReadBoolean();
			model.isAwaken = self:ReadBoolean();
			model.skillIDOne = self:ReadInt32();
			model.SkillOneLevel = self:ReadInt32();
			model.SkillTwoID = self:ReadInt32();
			model.SkillTwoLevel = self:ReadInt32();
			model.SkillThreeID = self:ReadInt32();
			model.SkillThreeLevel = self:ReadInt32();
			--print(model._tableID);
			 self._cardModelList:Push(model);
		end

end

return OnePlayerAddOneCardRespond;



--endregion
