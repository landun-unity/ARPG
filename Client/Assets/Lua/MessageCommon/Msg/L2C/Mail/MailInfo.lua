--
-- 逻辑服务器 --> 客户端
-- 邮件信息
-- @author czx
--
local List = require("common/List");

local AnnexInfo = require("MessageCommon/Msg/L2C/Mail/AnnexInfo");

local MailInfo = class("MailInfo");

function MailInfo:ctor()
    --
    -- 唯一ID
    --
    self.mailId = 0;
    
    --
    -- 邮件标题
    --
    self.mailTheme = "";
    
    --
    -- 邮件发件人
    --
    self.senderId = 0;
    
    --
    -- 邮件发件人名字
    --
    self.senderName = "";
    
    --
    -- 邮件收件人
    --
    self.receiverId = 0;
    
    --
    -- 邮件收件人名字
    --
    self.receiverName = "";
    
    --
    -- 邮件正文
    --
    self.content = "";
    
    --
    -- 邮件发送时间
    --
    self.time = 0;
    
    --
    -- 是否接收附件
    --
    self.isReceiveAnnex = 0;
    
    --
    -- 附件数量
    --
    self.annexCounts = 0;
    
    --
    -- 附件类型列表
    --
    self.annexInfoList = List.new();
    
    --
    -- 是否已读
    --
    self.isRead = 0;
    
    --
    -- 邮件类型
    --
    self.mailType = 0;
    
    --
    -- 参数可拆
    --
    self.canCut = 0;
end

return MailInfo;
