local GameManage = require("FrameWork/Game/GameManage")

-- 定义类
local Client = class("Client", GameManage)

require("MessageCommon/Util/Init")

local _instance = nil;

-- 构造函数
function Client:ctor()
    -- body
    Client.super.ctor(self);
end

-- 单例
function Client:Instance()
    -- body
    if self._instance == nil then
        -- body
        self._instance = Client.new();
    end

    return self._instance;
end

-- 注册所有服务
function Client:_RegisterAllService()
    self:_RegisterService(require("Game/Sync/SyncService").new());
    self:_RegisterService(require("Game/Common/LogManager").new());
    self:_RegisterService(require("Game/Login/LoginService").new());
    self:_RegisterService(require("Game/Net/NetService").new());
    self:_RegisterService(require("Game/Map/MapService").new());
    self:_RegisterService(require("Game/UI/UIService").new());
    self:_RegisterService(require("Game/Hero/HeroService").new());
    self:_RegisterService(require("Game/Player/PlayerService").new());
    self:_RegisterService(require("Game/Skill/SkillService").new());
    self:_RegisterService(require("Game/League/LeagueService").new());
    self:_RegisterService(require("Game/Build/BuildingService").new());
    self:_RegisterService(require("Game/Facility/FacilityService").new());
    self:_RegisterService(require("Game/Recruit/RecruitService").new());
    self:_RegisterService(require("Game/Army/ArmyService").new());
    self:_RegisterService(require("Game/Currency/CurrencyService").new());
    self:_RegisterService(require("Game/BattleReport/BattleReportService").new());
    self:_RegisterService(require("Game/Util/EventService").new());
    self:_RegisterService(require("Game/Popupmap/PmapService").new());
    self:_RegisterService(require("Game/Line/LineService").new());
    self:_RegisterService(require("Game/Common/CommonService").new());
    self:_RegisterService(require("Game/Activity/Login/LoginActService").new());
    self:_RegisterService(require("Game/Recharge/RechargeService").new());
    self:_RegisterService(require("Game/Mail/MailService").new());
    self:_RegisterService(require("Game/Chat/ChatService").new());
    self:_RegisterService(require("Game/Task/TaskService").new());
    self:_RegisterService(require("Game/Guide/GuideService").new());
    self:_RegisterService(require("Game/Marquee/MarqueeService").new());
    self:_RegisterService(require("Game/WorldTendency/WorldTendencyService").new());
    self:_RegisterService(require("Game/SourceEvent/SourceEventService").new());
    self:_RegisterService(require("Game/Map/ClickMenu/ClickService").new());
    self:_RegisterService(require("Game/MapMenu/UIMapNameService").new());
    self:_RegisterService(require("Game/NewerPeriod/NewerPeriodService").new());
    self:_RegisterService(require("Game/Effects/EffectsService").new());
    self:_RegisterService(require("Game/RankList/RankListService").new());
    self:_RegisterService(require("Game/DomesticAffairs/DomesticAffairsService").new());
end

return Client