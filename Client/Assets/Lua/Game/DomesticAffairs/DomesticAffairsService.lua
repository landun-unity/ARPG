
local GameService = require("FrameWork/Game/GameService")

local DomesticAffairsHandler = require("Game/DomesticAffairs/DomesticAffairsHandler")
local DomesticAffairsManage = require("Game/DomesticAffairs/DomesticAffairsManage");
DomesticAffairsService = class("DomesticAffairsService", GameService)

function DomesticAffairsService:ctor( ... )
	DomesticAffairsService._instance = self;
    DomesticAffairsService.super.ctor(self, DomesticAffairsManage.new(), DomesticAffairsHandler.new());
end
-- 单例
function DomesticAffairsService:Instance()
    return DomesticAffairsService._instance;
end

--清空数据
function DomesticAffairsService:Clear()
    self._logic:ctor()
end

return DomesticAffairsService