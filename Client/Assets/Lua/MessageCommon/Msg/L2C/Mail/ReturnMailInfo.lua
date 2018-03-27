--
-- 逻辑服务器 --> 客户端
-- 邮件信息
-- @author czx
--
local List = require("common/List");

local MailInfo = require("MessageCommon/Msg/L2C/Mail/MailInfo");
local AnnexInfo = require("MessageCommon/Msg/L2C/Mail/AnnexInfo");

local GameMessage = require("common/Net/GameMessage");
local ReturnMailInfo = class("ReturnMailInfo", GameMessage);

--
-- 构造函数
--
function ReturnMailInfo:ctor()
    ReturnMailInfo.super.ctor(self);
    --
    -- 所有个人邮件信息
    --
    self.singleMailInfo = List.new();
    
    --
    -- 所有群发邮件信息
    --
    self.groupMailInfo = List.new();
    
    --
    -- 所有系统邮件信息
    --
    self.systemMailInfo = List.new();
end

--@Override
function ReturnMailInfo:_OnSerial() 
    
    local singleMailInfoCount = self.singleMailInfo:Count();
    self:WriteInt32(singleMailInfoCount);
    for singleMailInfoIndex = 1, singleMailInfoCount, 1 do 
        local singleMailInfoValue = self.singleMailInfo:Get(singleMailInfoIndex);
        
        self:WriteInt64(singleMailInfoValue.mailId);
        self:WriteString(singleMailInfoValue.mailTheme);
        self:WriteInt64(singleMailInfoValue.senderId);
        self:WriteString(singleMailInfoValue.senderName);
        self:WriteInt64(singleMailInfoValue.receiverId);
        self:WriteString(singleMailInfoValue.receiverName);
        self:WriteString(singleMailInfoValue.content);
        self:WriteInt64(singleMailInfoValue.time);
        self:WriteInt32(singleMailInfoValue.isReceiveAnnex);
        self:WriteInt32(singleMailInfoValue.annexCounts);
        
        local singleMailInfoValueAnnexInfoListCount = singleMailInfoValue.annexInfoList:Count();
        self:WriteInt32(singleMailInfoValueAnnexInfoListCount);
        for singleMailInfoValueAnnexInfoListIndex = 1, singleMailInfoValueAnnexInfoListCount, 1 do 
            local singleMailInfoValueAnnexInfoListValue = singleMailInfoValue.annexInfoList:Get(singleMailInfoValueAnnexInfoListIndex);
            
            self:WriteInt32(singleMailInfoValueAnnexInfoListValue.annexType);
            self:WriteString(singleMailInfoValueAnnexInfoListValue.annexContent);
        end
        self:WriteInt32(singleMailInfoValue.isRead);
        self:WriteInt32(singleMailInfoValue.mailType);
        self:WriteInt32(singleMailInfoValue.canCut);
    end
    
    local groupMailInfoCount = self.groupMailInfo:Count();
    self:WriteInt32(groupMailInfoCount);
    for groupMailInfoIndex = 1, groupMailInfoCount, 1 do 
        local groupMailInfoValue = self.groupMailInfo:Get(groupMailInfoIndex);
        
        self:WriteInt64(groupMailInfoValue.mailId);
        self:WriteString(groupMailInfoValue.mailTheme);
        self:WriteInt64(groupMailInfoValue.senderId);
        self:WriteString(groupMailInfoValue.senderName);
        self:WriteInt64(groupMailInfoValue.receiverId);
        self:WriteString(groupMailInfoValue.receiverName);
        self:WriteString(groupMailInfoValue.content);
        self:WriteInt64(groupMailInfoValue.time);
        self:WriteInt32(groupMailInfoValue.isReceiveAnnex);
        self:WriteInt32(groupMailInfoValue.annexCounts);
        
        local groupMailInfoValueAnnexInfoListCount = groupMailInfoValue.annexInfoList:Count();
        self:WriteInt32(groupMailInfoValueAnnexInfoListCount);
        for groupMailInfoValueAnnexInfoListIndex = 1, groupMailInfoValueAnnexInfoListCount, 1 do 
            local groupMailInfoValueAnnexInfoListValue = groupMailInfoValue.annexInfoList:Get(groupMailInfoValueAnnexInfoListIndex);
            
            self:WriteInt32(groupMailInfoValueAnnexInfoListValue.annexType);
            self:WriteString(groupMailInfoValueAnnexInfoListValue.annexContent);
        end
        self:WriteInt32(groupMailInfoValue.isRead);
        self:WriteInt32(groupMailInfoValue.mailType);
        self:WriteInt32(groupMailInfoValue.canCut);
    end
    
    local systemMailInfoCount = self.systemMailInfo:Count();
    self:WriteInt32(systemMailInfoCount);
    for systemMailInfoIndex = 1, systemMailInfoCount, 1 do 
        local systemMailInfoValue = self.systemMailInfo:Get(systemMailInfoIndex);
        
        self:WriteInt64(systemMailInfoValue.mailId);
        self:WriteString(systemMailInfoValue.mailTheme);
        self:WriteInt64(systemMailInfoValue.senderId);
        self:WriteString(systemMailInfoValue.senderName);
        self:WriteInt64(systemMailInfoValue.receiverId);
        self:WriteString(systemMailInfoValue.receiverName);
        self:WriteString(systemMailInfoValue.content);
        self:WriteInt64(systemMailInfoValue.time);
        self:WriteInt32(systemMailInfoValue.isReceiveAnnex);
        self:WriteInt32(systemMailInfoValue.annexCounts);
        
        local systemMailInfoValueAnnexInfoListCount = systemMailInfoValue.annexInfoList:Count();
        self:WriteInt32(systemMailInfoValueAnnexInfoListCount);
        for systemMailInfoValueAnnexInfoListIndex = 1, systemMailInfoValueAnnexInfoListCount, 1 do 
            local systemMailInfoValueAnnexInfoListValue = systemMailInfoValue.annexInfoList:Get(systemMailInfoValueAnnexInfoListIndex);
            
            self:WriteInt32(systemMailInfoValueAnnexInfoListValue.annexType);
            self:WriteString(systemMailInfoValueAnnexInfoListValue.annexContent);
        end
        self:WriteInt32(systemMailInfoValue.isRead);
        self:WriteInt32(systemMailInfoValue.mailType);
        self:WriteInt32(systemMailInfoValue.canCut);
    end
end

--@Override
function ReturnMailInfo:_OnDeserialize() 
    
    local singleMailInfoCount = self:ReadInt32();
    for i = 1, singleMailInfoCount, 1 do 
        local singleMailInfoValue = MailInfo.new();
        singleMailInfoValue.mailId = self:ReadInt64();
        singleMailInfoValue.mailTheme = self:ReadString();
        singleMailInfoValue.senderId = self:ReadInt64();
        singleMailInfoValue.senderName = self:ReadString();
        singleMailInfoValue.receiverId = self:ReadInt64();
        singleMailInfoValue.receiverName = self:ReadString();
        singleMailInfoValue.content = self:ReadString();
        singleMailInfoValue.time = self:ReadInt64();
        singleMailInfoValue.isReceiveAnnex = self:ReadInt32();
        singleMailInfoValue.annexCounts = self:ReadInt32();
        
        local singleMailInfoValueAnnexInfoListCount = self:ReadInt32();
        for i = 1, singleMailInfoValueAnnexInfoListCount, 1 do 
            local singleMailInfoValueAnnexInfoListValue = AnnexInfo.new();
            singleMailInfoValueAnnexInfoListValue.annexType = self:ReadInt32();
            singleMailInfoValueAnnexInfoListValue.annexContent = self:ReadString();
            singleMailInfoValue.annexInfoList:Push(singleMailInfoValueAnnexInfoListValue);
        end
        singleMailInfoValue.isRead = self:ReadInt32();
        singleMailInfoValue.mailType = self:ReadInt32();
        singleMailInfoValue.canCut = self:ReadInt32();
        self.singleMailInfo:Push(singleMailInfoValue);
    end
    
    local groupMailInfoCount = self:ReadInt32();
    for i = 1, groupMailInfoCount, 1 do 
        local groupMailInfoValue = MailInfo.new();
        groupMailInfoValue.mailId = self:ReadInt64();
        groupMailInfoValue.mailTheme = self:ReadString();
        groupMailInfoValue.senderId = self:ReadInt64();
        groupMailInfoValue.senderName = self:ReadString();
        groupMailInfoValue.receiverId = self:ReadInt64();
        groupMailInfoValue.receiverName = self:ReadString();
        groupMailInfoValue.content = self:ReadString();
        groupMailInfoValue.time = self:ReadInt64();
        groupMailInfoValue.isReceiveAnnex = self:ReadInt32();
        groupMailInfoValue.annexCounts = self:ReadInt32();
        
        local groupMailInfoValueAnnexInfoListCount = self:ReadInt32();
        for i = 1, groupMailInfoValueAnnexInfoListCount, 1 do 
            local groupMailInfoValueAnnexInfoListValue = AnnexInfo.new();
            groupMailInfoValueAnnexInfoListValue.annexType = self:ReadInt32();
            groupMailInfoValueAnnexInfoListValue.annexContent = self:ReadString();
            groupMailInfoValue.annexInfoList:Push(groupMailInfoValueAnnexInfoListValue);
        end
        groupMailInfoValue.isRead = self:ReadInt32();
        groupMailInfoValue.mailType = self:ReadInt32();
        groupMailInfoValue.canCut = self:ReadInt32();
        self.groupMailInfo:Push(groupMailInfoValue);
    end
    
    local systemMailInfoCount = self:ReadInt32();
    for i = 1, systemMailInfoCount, 1 do 
        local systemMailInfoValue = MailInfo.new();
        systemMailInfoValue.mailId = self:ReadInt64();
        systemMailInfoValue.mailTheme = self:ReadString();
        systemMailInfoValue.senderId = self:ReadInt64();
        systemMailInfoValue.senderName = self:ReadString();
        systemMailInfoValue.receiverId = self:ReadInt64();
        systemMailInfoValue.receiverName = self:ReadString();
        systemMailInfoValue.content = self:ReadString();
        systemMailInfoValue.time = self:ReadInt64();
        systemMailInfoValue.isReceiveAnnex = self:ReadInt32();
        systemMailInfoValue.annexCounts = self:ReadInt32();
        
        local systemMailInfoValueAnnexInfoListCount = self:ReadInt32();
        for i = 1, systemMailInfoValueAnnexInfoListCount, 1 do 
            local systemMailInfoValueAnnexInfoListValue = AnnexInfo.new();
            systemMailInfoValueAnnexInfoListValue.annexType = self:ReadInt32();
            systemMailInfoValueAnnexInfoListValue.annexContent = self:ReadString();
            systemMailInfoValue.annexInfoList:Push(systemMailInfoValueAnnexInfoListValue);
        end
        systemMailInfoValue.isRead = self:ReadInt32();
        systemMailInfoValue.mailType = self:ReadInt32();
        systemMailInfoValue.canCut = self:ReadInt32();
        self.systemMailInfo:Push(systemMailInfoValue);
    end
end

return ReturnMailInfo;
