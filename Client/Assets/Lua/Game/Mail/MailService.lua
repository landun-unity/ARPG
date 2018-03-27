--region *.lua
--Date
local GameService = require("FrameWork/Game/GameService")
local MailHandler = require("Game/Mail/MailHandler")
local MailManage = require("Game/Mail/MailManage");
MailService = class("MailService",GameService)

function MailService:ctor()
    MailService._instance = self;
    MailService.super.ctor(self, MailManage.new(), MailHandler.new());        
end

-- 单例
function MailService:Instance()
    return MailService._instance;
end

--清空数据
function MailService:Clear()
    self._logic:ctor()
end

function MailService:GetMailByType(mailType)
    return self._logic:GetMailByType(mailType);
    
end

function MailService:GetAllTypeUnReadedMailIds()
    return self._logic:GetAllTypeUnReadedMailIds();  
end

function MailService:GetAllUnReadedMailIds(mailType)
    return self._logic:GetAllUnReadedMailIds(mailType);  
end

function MailService:GetAllUnReadedMailCounts()
    return self._logic:GetAllUnReadedMailCounts();  
end

function MailService:GetOneTypeUnReadedMailCounts(mailType)
    return self._logic:GetOneTypeUnReadedMailCounts(mailType);  
end


function MailService:GetLatestUnReadedMailType()
    return self._logic:GetLatestUnReadedMailType();  
end

function MailService:GetSystemMailTitle(mailInfo)
    return self._logic:GetSystemMailTitle(mailInfo);  
end

function MailService:GetSystemMailContent(mailInfo)
    return self._logic:GetSystemMailContent(mailInfo);  
end

return MailService
