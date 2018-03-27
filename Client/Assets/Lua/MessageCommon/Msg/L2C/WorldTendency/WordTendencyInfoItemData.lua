--
-- 逻辑服务器 --> 客户端
-- 天下大势进度信息结构
-- @author czx
--
local List = require("common/List");

local WorldTendencyParamTwoData = require("MessageCommon/Msg/L2C/WorldTendency/WorldTendencyParamTwoData");

local WordTendencyInfoItemData = class("WordTendencyInfoItemData");

function WordTendencyInfoItemData:ctor()
    --
    -- 表ID
    --
    self.tableId = 0;
    
    --
    -- 是否开启
    --
    self.isOpen = 0;
    
    --
    -- 结束时间
    --
    self.endTime = 0;
    
    --
    -- 进度值
    --
    self.paramValueOne = 0;
    
    --
    -- 达成者的信息List
    --
    self.paramValueTwo = List.new();
    
    --
    -- 是否达成
    --
    self.isDone = 0;
    
    --
    -- 达成时间
    --
    self.doneTime = 0;
    
    --
    -- 是否可以领取奖励
    --
    self.couldGetAward = 0;
    
    --
    -- 是否领奖
    --
    self.isGetAward = 0;
end

return WordTendencyInfoItemData;
