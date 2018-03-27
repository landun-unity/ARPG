--
-- 逻辑服务器 --> 客户端
-- 返回招募到的卡牌列表
-- @author czx
--
local List = require("common/List");

local BatchRecruitCardModel = require("MessageCommon/Msg/L2C/Recruit/BatchRecruitCardModel");

local GameMessage = require("common/Net/GameMessage");
local BatchRecruitCardList = class("BatchRecruitCardList", GameMessage);

--
-- 构造函数
--
function BatchRecruitCardList:ctor()
    BatchRecruitCardList.super.ctor(self);
    --
    -- 招募到的卡牌列表
    --
    self.batchRecruitCardIdList = List.new();
end

--@Override
function BatchRecruitCardList:_OnSerial() 
    
    local batchRecruitCardIdListCount = self.batchRecruitCardIdList:Count();
    self:WriteInt32(batchRecruitCardIdListCount);
    for batchRecruitCardIdListIndex = 1, batchRecruitCardIdListCount, 1 do 
        local batchRecruitCardIdListValue = self.batchRecruitCardIdList:Get(batchRecruitCardIdListIndex);
        
        self:WriteInt64(batchRecruitCardIdListValue.cardId);
        self:WriteInt32(batchRecruitCardIdListValue.cardTableId);
    end
end

--@Override
function BatchRecruitCardList:_OnDeserialize() 
    
    local batchRecruitCardIdListCount = self:ReadInt32();
    for i = 1, batchRecruitCardIdListCount, 1 do 
        local batchRecruitCardIdListValue = BatchRecruitCardModel.new();
        batchRecruitCardIdListValue.cardId = self:ReadInt64();
        batchRecruitCardIdListValue.cardTableId = self:ReadInt32();
        self.batchRecruitCardIdList:Push(batchRecruitCardIdListValue);
    end
end

return BatchRecruitCardList;
