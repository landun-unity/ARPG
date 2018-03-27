local IOHandler = require("FrameWork/Game/IOHandler")
local MarqueeHandler = class("MarqueeHandler",IOHandler)
local DataHero = require("Game/Table/model/DataHero")
local DataEpicEvent = require("Game/Table/model/DataEpicEvent")
local DataBuilding = require("Game/Table/model/DataBuilding")
local DataTile = require("Game/Table/model/DataTile")

function MarqueeHandler:ctor()
    
    MarqueeHandler.super.ctor(self)
    
end

-- 注册
function MarqueeHandler:RegisterAllMessage()
    self:RegisterMessage(L2C_Marquee.MarqueeRespond, self.ReceiveMarqueeInfos, require("MessageCommon/Msg/L2C/Marquee/MarqueeRespond"));
end

function MarqueeHandler:ReceiveMarqueeInfos(msg)
    --print("跑马灯消息返回    msg.marqueeType"..msg.marqueeType.."  msg.name"..msg.name.."  msg.parmter"..msg.parmter);
    --新手引导期不显示跑马灯
    if GuideServcice:Instance():GetIsFinishGuide() == false then
        LogManager:Instance():Log("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!当前处于新手引导期，不显示跑马灯！");
        return;
    end
    self._logicManage:ReceiveMarqueeInfos(msg); 
end


return MarqueeHandler