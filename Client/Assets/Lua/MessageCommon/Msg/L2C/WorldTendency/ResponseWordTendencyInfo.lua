--
-- 逻辑服务器 --> 客户端
-- 请求天下大势信息回复
-- @author czx
--
local List = require("common/List");

local WordTendencyInfoItemData = require("MessageCommon/Msg/L2C/WorldTendency/WordTendencyInfoItemData");
local WorldTendencyParamTwoData = require("MessageCommon/Msg/L2C/WorldTendency/WorldTendencyParamTwoData");

local GameMessage = require("common/Net/GameMessage");
local ResponseWordTendencyInfo = class("ResponseWordTendencyInfo", GameMessage);

--
-- 构造函数
--
function ResponseWordTendencyInfo:ctor()
    ResponseWordTendencyInfo.super.ctor(self);
    --
    -- 已经更新的天下大势信息列表
    --
    self.wordTendencyInfoList = List.new();
end

--@Override
function ResponseWordTendencyInfo:_OnSerial() 
    
    local wordTendencyInfoListCount = self.wordTendencyInfoList:Count();
    self:WriteInt32(wordTendencyInfoListCount);
    for wordTendencyInfoListIndex = 1, wordTendencyInfoListCount, 1 do 
        local wordTendencyInfoListValue = self.wordTendencyInfoList:Get(wordTendencyInfoListIndex);
        
        self:WriteInt32(wordTendencyInfoListValue.tableId);
        self:WriteInt32(wordTendencyInfoListValue.isOpen);
        self:WriteInt64(wordTendencyInfoListValue.endTime);
        self:WriteInt32(wordTendencyInfoListValue.paramValueOne);
        
        local wordTendencyInfoListValueparamValueTwoCount = wordTendencyInfoListValue.paramValueTwo:Count();
        self:WriteInt32(wordTendencyInfoListValueparamValueTwoCount);
        for wordTendencyInfoListValueparamValueTwoIndex = 1, wordTendencyInfoListValueparamValueTwoCount, 1 do 
            local wordTendencyInfoListValueparamValueTwoValue = wordTendencyInfoListValue.paramValueTwo:Get(wordTendencyInfoListValueparamValueTwoIndex);
            
            self:WriteString(wordTendencyInfoListValueparamValueTwoValue.name);
        end
        self:WriteInt32(wordTendencyInfoListValue.isDone);
        self:WriteInt64(wordTendencyInfoListValue.doneTime);
        self:WriteInt32(wordTendencyInfoListValue.couldGetAward);
        self:WriteInt32(wordTendencyInfoListValue.isGetAward);
    end
end

--@Override
function ResponseWordTendencyInfo:_OnDeserialize() 
    
    local wordTendencyInfoListCount = self:ReadInt32();
    for i = 1, wordTendencyInfoListCount, 1 do 
        local wordTendencyInfoListValue = WordTendencyInfoItemData.new();
        wordTendencyInfoListValue.tableId = self:ReadInt32();
        wordTendencyInfoListValue.isOpen = self:ReadInt32();
        wordTendencyInfoListValue.endTime = self:ReadInt64();
        wordTendencyInfoListValue.paramValueOne = self:ReadInt32();
        
        local wordTendencyInfoListValueparamValueTwoCount = self:ReadInt32();
        for i = 1, wordTendencyInfoListValueparamValueTwoCount, 1 do 
            local wordTendencyInfoListValueparamValueTwoValue = WorldTendencyParamTwoData.new();
            wordTendencyInfoListValueparamValueTwoValue.name = self:ReadString();
            wordTendencyInfoListValue.paramValueTwo:Push(wordTendencyInfoListValueparamValueTwoValue);
        end
        wordTendencyInfoListValue.isDone = self:ReadInt32();
        wordTendencyInfoListValue.doneTime = self:ReadInt64();
        wordTendencyInfoListValue.couldGetAward = self:ReadInt32();
        wordTendencyInfoListValue.isGetAward = self:ReadInt32();
        self.wordTendencyInfoList:Push(wordTendencyInfoListValue);
    end
end

return ResponseWordTendencyInfo;
