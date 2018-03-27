--region *.lua
--Date
--此文件由[BabeLua]插件自动生成
local CardModel=require("MessageCommon/Msg/L2C/Model/CardModel");
local GameMessage = require("common/Net/GameMessage");
local List=require("common/List");
local RemoveCardRespond = class("RemoveCardRespond", GameMessage);
   
function RemoveCardRespond:ctor()

    RemoveCardRespond.super.ctor(self);
    -- 卡牌list
    self.removeedCardList=List.new();

end

-- @override
function RemoveCardRespond:_OnSerial()

	local size=self.removeedCardList:Count()
	self:WriteInt32(size);

	for i=1,size  do
		local model=self.removeedCardList:Get(i);
		while true do
			if model == nil then 
				break
			end

			self:WriteInt64(model.iD)
			break
		end

    end    

	self.removeedCardList:Clear();

end


-- @override
function RemoveCardRespond:_OnDeserialize()

	self.removeedCardList:Clear();
	local count = self:ReadInt32();

	for index=1,count do
		local model=CardModel.new();
		model.iD = self:ReadInt64();

	end

end

return RemoveCardRespond;


--endregion
