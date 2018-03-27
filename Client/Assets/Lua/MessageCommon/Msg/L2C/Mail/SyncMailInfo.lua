--
-- 逻辑服务器 --> 客户端
-- 邮件信息
-- @author czx
--
local List = require("common/List");

local AnnexInfo = require("MessageCommon/Msg/L2C/Mail/AnnexInfo");

local GameMessage = require("common/Net/GameMessage");
local SyncMailInfo = class("SyncMailInfo", GameMessage);

--
-- 构造函数
--
function SyncMailInfo:ctor()
    SyncMailInfo.super.ctor(self);
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
    -- 可拆
    --
    self.canCut = 0;
end

--@Override
function SyncMailInfo:_OnSerial() 
    self:WriteInt64(self.mailId);
    self:WriteString(self.mailTheme);
    self:WriteInt64(self.senderId);
    self:WriteString(self.senderName);
    self:WriteInt64(self.receiverId);
    self:WriteString(self.receiverName);
    self:WriteString(self.content);
    self:WriteInt64(self.time);
    self:WriteInt32(self.isReceiveAnnex);
    self:WriteInt32(self.annexCounts);
    
    local annexInfoListCount = self.annexInfoList:Count();
    self:WriteInt32(annexInfoListCount);
    for annexInfoListIndex = 1, annexInfoListCount, 1 do 
        local annexInfoListValue = self.annexInfoList:Get(annexInfoListIndex);
        
        self:WriteInt32(annexInfoListValue.annexType);
        self:WriteString(annexInfoListValue.annexContent);
    end
    self:WriteInt32(self.isRead);
    self:WriteInt32(self.mailType);
    self:WriteInt32(self.canCut);
end

--@Override
function SyncMailInfo:_OnDeserialize() 
    self.mailId = self:ReadInt64();
    self.mailTheme = self:ReadString();
    self.senderId = self:ReadInt64();
    self.senderName = self:ReadString();
    self.receiverId = self:ReadInt64();
    self.receiverName = self:ReadString();
    self.content = self:ReadString();
    self.time = self:ReadInt64();
    self.isReceiveAnnex = self:ReadInt32();
    self.annexCounts = self:ReadInt32();
    
    local annexInfoListCount = self:ReadInt32();
    for i = 1, annexInfoListCount, 1 do 
        local annexInfoListValue = AnnexInfo.new();
        annexInfoListValue.annexType = self:ReadInt32();
        annexInfoListValue.annexContent = self:ReadString();
        self.annexInfoList:Push(annexInfoListValue);
    end
    self.isRead = self:ReadInt32();
    self.mailType = self:ReadInt32();
    self.canCut = self:ReadInt32();
end

return SyncMailInfo;
