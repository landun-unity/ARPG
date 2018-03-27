local GameService = require("FrameWork/Game/GameService")
local MarqueeHandler = require("Game/Marquee/MarqueeHandler")
local MarqueeManage = require("Game/Marquee/MarqueeManage");

MarqueeService = class("MarqueeService",GameService)

-- 构造函数
function MarqueeService:ctor( )
    MarqueeService._instance = self;
    MarqueeService.super.ctor(self, MarqueeManage.new(), MarqueeHandler.new());
end

-- 单例
function MarqueeService:Instance()
    return MarqueeService._instance;
end

--清空数据
function MarqueeService:Clear()
    self._logic:ctor()
end

return MarqueeService