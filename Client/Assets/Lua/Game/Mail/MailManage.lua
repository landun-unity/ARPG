--region *.lua
--Date
local GamePart = require("FrameWork/Game/GamePart")
local MailManage = class("MailManage",GamePart)
local MailType = require("Game/Mail/MailType");
local MailSystemType = require("Game/Mail/MailSystemType");
local List = require("common/List");
local MaiInfo = require("MessageCommon/Msg/L2C/Mail/MailInfo")

function MailManage:ctor()  
    MailManage.super.ctor(self)
      
    self.allMailInfo = {};                  --所有的邮件
end

--保存所有的邮件信息 personalMail是List  其余是table{}
function MailManage:SaveAllMailInfo(personalMail,groupMail,systemMail)
    local myPlayerId = PlayerService:Instance():GetPlayerId();
    --print("收到的个人邮件数量:".. personalMail:Count());
    if personalMail:Count()~= 0 then        
        for i=1,personalMail:Count() do
            --print("id:"..personalMail:Get(i).mailId);
            if myPlayerId == personalMail:Get(i).senderId then 
                personalMail:Get(i).isRead = 1;
            end
        end
        self:SortInMailListNear(personalMail);
        self.allMailInfo[MailType.PersonalMailType] = personalMail;
    end
    if #groupMail~= 0 then
        self:SortInMailListNear(groupMail);
        for i=1,#groupMail do
            if myPlayerId == groupMail[i].senderId then 
                groupMail[i].isRead = 1;
            end
        end
        self.allMailInfo[MailType.GroupMailType] = groupMail;
    end
    if #systemMail~= 0 then
        self:SortInMailListNear(systemMail);
        self.allMailInfo[MailType.SystemMailType] = systemMail;
    end 
end

--读邮件返回刷新已读状态
function MailManage:RefreshMailReadState(mailIdList,mailType)
    for i=1,mailIdList:Count() do
        --print(mailIdList:Get(i))
        local findedMailInfo = self:GetOneMailByType(mailType,mailIdList:Get(i));   
        if findedMailInfo ~= nil then
            --print("senderName:  "..findedMailInfo.senderName.."   receiverName:"..findedMailInfo.receiverName.." isRead: "..findedMailInfo.isRead);
            findedMailInfo.isRead =1;
        else
            print("could't find mailInfo which id:"..mailIdList:Get(i).." and mailType:"..mailType);
        end
    end
end

--领取邮件附件奖励返回刷新已读状态
function MailManage:RefreshMailAwardState(mailId,mailType)
    local findedMailInfo = self:GetOneMailByType(mailType,mailId);   
    if findedMailInfo ~= nil then 
        findedMailInfo.isReceiveAnnex = 1;
    else
        print("could't find mailInfo which id:"..mailId.." and mailType:"..mailType);
    end
end

--更新一封新邮件
function MailManage:SaveOneMailInfo(MailId,MailTheme,SenderId,SenderName,ReceiverId,ReceiverName,Content,Time,IsReceiveAnnex,AnnexCounts,AnnexInfoList,IsRead,mailType,canCut)
    --print("MailId:"..MailId.."  SenderName:"..SenderName.."  ReceiverName:"..ReceiverName.." Content:"..Content.." Time"..Time.."  IsRead"..IsRead.."  mailType"..mailType.." canCut:"..canCut);
    local findMailInfo = self:GetOneMailByType(mailType,MailId);
    if findMailInfo ~= nil then
        --print("邪门了！！！！！！！！！竟然存在该邮件 id："..MailId.."   type:"..mailType.."  returnn!");
        return;
    end
    local addMail = MaiInfo.new();
    addMail.mailId = MailId;
    addMail.mailTheme = MailTheme;
    addMail.senderId = SenderId;
    addMail.senderName = SenderName;
    addMail.receiverId = ReceiverId;
    addMail.receiverName = ReceiverName;
    addMail.content = Content;
    addMail.time = Time;
    addMail.isReceiveAnnex = IsReceiveAnnex;
    addMail.annexCounts = AnnexCounts;
    addMail.annexInfoList = AnnexInfoList;
    local myPlayerId = PlayerService:Instance():GetPlayerId();   
    addMail.isRead = IsRead;
    if myPlayerId == SenderId then 
        addMail.isRead = 1;
    end
    addMail.mailType = mailType;        
    if self.allMailInfo[mailType] ~= nil then
        if mailType == MailType.PersonalMailType then
            self.allMailInfo[mailType]:Push(addMail);
        else
            self.allMailInfo[mailType][#self.allMailInfo[mailType]+1] = addMail;
        end 
    else
        if mailType == MailType.PersonalMailType then
            self.allMailInfo[mailType] = List.new();
            self.allMailInfo[mailType]:Push(addMail);
        else
            self.allMailInfo[mailType] = {};
            self.allMailInfo[mailType][1] = addMail;
        end
    end
    addMail.canCut = canCut;
    self:SortInMailListNear(self.allMailInfo[mailType]);
end

function MailManage:GetOneMailByType(mailType,mailId)
    if mailType == MailType.GroupMailType or mailType == MailType.SystemMailType then  
        if self.allMailInfo[mailType] ~= nil then 
            for i=1 ,#self.allMailInfo[mailType] do 
                if self.allMailInfo[mailType][i].mailId == mailId then
                    return self.allMailInfo[mailType][i];
                end
            end 
        end
    elseif mailType == MailType.PersonalMailType then
        local allPersonals = self.allMailInfo[mailType];
        if allPersonals~= nil then
            for i=1,allPersonals:Count() do
                local mailInfo = allPersonals:Get(i);
                if mailInfo.mailId == mailId then
                    return mailInfo;
                end
            end
        end
    end
    return nil;
end

--个人邮件返回的是table  senderDics （调用需要排序）
function MailManage:GetMailByType(mailType)
    if mailType == MailType.GroupMailType or mailType == MailType.SystemMailType then  
        if self.allMailInfo[mailType] ~= nil then 
            return  self.allMailInfo[mailType];     
        end
    elseif mailType == MailType.PersonalMailType then
        local allPersonals = self.allMailInfo[mailType];
        if allPersonals~= nil then
            local myPlayerId = PlayerService:Instance():GetPlayerId();            
            --个人邮件所有分类后的总列表
            --  内层： 键：发件人ID(不是自己)    值：邮件List(包括所有这个发件人发的 和 自己发给这个发件人的)
            local senderDics = {};
            --print("myPlayerId:"..myPlayerId.."    allPersonals:Count(): "..allPersonals:Count());
            --mailInfo: MailInfo
            for i=1,allPersonals:Count() do
                local mailInfo = allPersonals:Get(i);
                if mailInfo.senderId ~= myPlayerId then
                    if senderDics[mailInfo.senderId] == nil then
                        local oneTable = {};
                        oneTable[1]= mailInfo;
                        senderDics[mailInfo.senderId] = oneTable;
                    else
                        senderDics[mailInfo.senderId][#senderDics[mailInfo.senderId]+1] = mailInfo;
                    end
                    self:SortInMailList(senderDics[mailInfo.senderId]);
                else
                    if senderDics[mailInfo.receiverId] == nil then
                        local oneTable = {};
                        oneTable[1]= mailInfo;
                        senderDics[mailInfo.receiverId] = oneTable;
                    else
                        senderDics[mailInfo.receiverId][#senderDics[mailInfo.receiverId]+1] = mailInfo;
                    end
                    self:SortInMailList(senderDics[mailInfo.receiverId]);
                end
            end
            senderDics = self:SortOutMailList(senderDics,myPlayerId);
            return senderDics;                                       
        end
    end
    return nil;
end

--获取一个类型所有未读邮件的ID列表
function MailManage:GetAllUnReadedMailIds(mailType)
    local IDList= List.new();
    if mailType == MailType.GroupMailType or mailType == MailType.SystemMailType then  
        if self.allMailInfo[mailType] ~= nil then 
            for i=1 ,#self.allMailInfo[mailType] do 
                if self.allMailInfo[mailType][i].isRead == 0 then
                    IDList:Push(self.allMailInfo[mailType][i].mailId);
                end
            end
        end
    elseif mailType == MailType.PersonalMailType then
        local allPersonals = self.allMailInfo[mailType];
        if allPersonals~= nil then
            for i=1,allPersonals:Count() do
                local mailInfo = allPersonals:Get(i);
                if mailInfo.isRead == 0 then
                    IDList:Push(mailInfo.mailId);
                end
            end
        end
    end
    return IDList;   
end

function MailManage:GetAllTypeUnReadedMailIds()
    local IDList = List.new();
    local personList = self:GetAllUnReadedMailIds(MailType.PersonalMailType);
    local groupList = self:GetAllUnReadedMailIds(MailType.GroupMailType);
    local systemList = self:GetAllUnReadedMailIds(MailType.SystemMailType);
    for i = 1 , personList:Count() do
        IDList:Push(personList:Get(i));
    end
    for i = 1 , groupList:Count() do
        IDList:Push(groupList:Get(i));
    end
    for i = 1 , systemList:Count() do
        IDList:Push(systemList:Get(i));
    end
    return IDList;
end

--获取一个类型未读邮件的个数
function MailManage:GetOneTypeUnReadedMailCounts(mailType)
    local IdList = self:GetAllUnReadedMailIds(mailType);
    return IdList:Count();
end

--获取所有未读邮件的个数
function MailManage:GetAllUnReadedMailCounts()
    local allUnReadMails = self:GetAllUnReadedMailLists();
    if allUnReadMails~=nil then 
        return #allUnReadMails;
    else
       return 0;
    end
end


--获取最近的一封邮件的邮件类型
function MailManage:GetLatestUnReadedMailType()
    local allUnReadMails = self:GetAllUnReadedMailLists();
    if allUnReadMails~=nil and #allUnReadMails>0 then 
        self:SortInMailListNear(allUnReadMails);
        return allUnReadMails[1].mailType;
    else
       return MailType.PersonalMailType;
    end
end

--获取所有的未读邮件
function MailManage:GetAllUnReadedMailLists()
    --local allCount = 0;
    local allUnReadMails = {};
    if self.allMailInfo[MailType.GroupMailType] ~= nil then 
        for i=1 ,#self.allMailInfo[MailType.GroupMailType] do 
            if self.allMailInfo[MailType.GroupMailType][i].isRead == 0 then
                --allCount = allCount + 1;
                allUnReadMails[#allUnReadMails+1] = self.allMailInfo[MailType.GroupMailType][i];
            end
        end 
    end
    if self.allMailInfo[MailType.SystemMailType] ~= nil then 
        for i=1 ,#self.allMailInfo[MailType.SystemMailType] do 
            if self.allMailInfo[MailType.SystemMailType][i].isRead == 0 then
                --allCount = allCount + 1;
                allUnReadMails[#allUnReadMails+1] = self.allMailInfo[MailType.SystemMailType][i];
            end
        end 
    end
    if self.allMailInfo[MailType.PersonalMailType] ~= nil then
        for i=1,self.allMailInfo[MailType.PersonalMailType]:Count() do
            local mailInfo = self.allMailInfo[MailType.PersonalMailType]:Get(i);
            if mailInfo.isRead == 0 then
                --allCount = allCount + 1;
                allUnReadMails[#allUnReadMails+1] = mailInfo;
            end
        end
    end
    return allUnReadMails;
end

--检测某类型邮件是否有未读的
function MailManage:CheckHaveUnReadedMail(mailType)
    local IDList= List.new();
    if mailType == MailType.GroupMailType or mailType == MailType.SystemMailType then  
        if self.allMailInfo[mailType] ~= nil then 
            for i=1 ,#self.allMailInfo[mailType] do 
                if self.allMailInfo[mailType][i].isRead == 0 then
                    return true;
                end
            end 
        end
    elseif mailType == MailType.PersonalMailType then
        local allPersonals = self.allMailInfo[mailType];
        if allPersonals~= nil then
            for i=1,allPersonals:Count() do
                local mailInfo = allPersonals:Get(i);
                if mailInfo.isRead == 0 then
                    return true;
                end
            end
        end
    end
    return false;   
end


--时间近的在前
function MailManage:SortInMailListNear(senderDics)    
    table.sort(senderDics, function(a, b) return a.time > b.time end);
end

--时间远的在前
function MailManage:SortInMailList(senderDics)    
    table.sort(senderDics, function(a, b) return a.time < b.time end);
end

--时间近的在前  
function MailManage:SortOutMailList(allDics,myPlayerId)
    local newTable = {};
    local firstTable = {};
    for k,v in pairs(allDics)do
        table.insert(firstTable,v[#v]);
    end
    table.sort(firstTable, function(a, b) return a.time > b.time end);
    for k,v in pairs(firstTable)do
        if v.senderId == myPlayerId then
            table.insert(newTable,allDics[v.receiverId]);
        else
            table.insert(newTable,allDics[v.senderId]);
        end
    end
    return newTable;
end

function MailManage:GetSystemMailTitle(mailInfo)
    if mailInfo.canCut == 0 then
        return mailInfo.mailTheme;
    else
        local contentTabel = CommonService:Instance():StringSplit(mailInfo.content,"|");
        local systemType = tonumber(contentTabel[1]);
        local title = "";
        if systemType == MailSystemType.FirstOccupation then
            local buildingData = DataBuilding[contentTabel[3]];
            title = title.."首占奖励-"..buildingData.Name.."("..buildingData.level..")";
        elseif systemType == MailSystemType.KillEnemy then
            local buildingData = DataBuilding[contentTabel[3]];
            title = title.."杀敌奖励-"..buildingData.Name.."("..buildingData.level..")";
        elseif systemType == MailSystemType.Demolition then
            print("MailSystemType.Demolition")
            local buildingData = DataBuilding[contentTabel[3]];
            title = title.."拆迁奖励-"..buildingData.Name.."("..buildingData.level..")";
        elseif systemType == MailSystemType.OfficialAppointment then
            print("MailSystemType.OfficialAppointment")
            title = title.."官位任命通告";
        elseif systemType == MailSystemType.OfficialRecall then
             print("MailSystemType.OfficialRecall")
            title = title.."官位罢免通告";
        elseif systemType == MailSystemType.PrefectAppointment then
            title = title.."太守任命通告";
        elseif systemType == MailSystemType.PrefectRecall then
            title = title.."太守罢免通告";
        elseif systemType == MailSystemType.InLeagueGroup then
            title = title.."加入同盟分组";
        elseif systemType == MailSystemType.OutLeagueGroup then
            title = title.."退出同盟分组";
        elseif systemType == MailSystemType.DissolutionLeagueGroup or systemType == MailSystemType.DissolutionedLeagueGroup then
            title = title.."同盟分组解散";
        elseif systemType == MailSystemType.InChatGroup then
            title = title.."加入分组聊天";
        elseif systemType == MailSystemType.OutChatGroup then
            title = title.."退出分组聊天";
        elseif systemType == MailSystemType.DissolutionChatGroup then
            title = title.."主动解散分组聊天";
        elseif systemType == MailSystemType.DissolutionedChatGroup then
            title = title.."被动解散分组聊天";
        elseif systemType == MailSystemType.LeaderAppointment then
            title = title.."禅让盟主";
        elseif systemType == MailSystemType.WorldTendency then
            local worldTendencyData = DataEpicEvent[contentTabel[2]];
            title = title.."天下大势-"..worldTendencyData.Name;
        elseif systemType == MailSystemType.Maneuver then
            title = title.."演武活动奖励";
        elseif systemType == MailSystemType.CameBack then
            title = title.."回归奖励";
        elseif systemType == MailSystemType.DeleteLeagueSign then
            title = title.."同盟标记被删除提示";
        end
        return title;
    end
end


function MailManage:GetSystemMailContent(mailInfo)
    if mailInfo.canCut == 0 then
        return mailInfo.content;
    else
        local contentTabel = CommonService:Instance():StringSplit(mailInfo.content,"|");
        local systemType = tonumber(contentTabel[1]);
        local content = "";
        if systemType == MailSystemType.FirstOccupation then
            local leagueName = contentTabel[2];
            local buildingData = DataBuilding[contentTabel[3]];
            local stateID = DataBuilding[contentTabel[3]].StateCN[1];
            local stateData = DataState[stateID];
            content = content.."恭喜【同盟】"..leagueName.."首占"..stateData.Name.." "..buildingData.Name.."("..buildingData.level..")".."，请点击领取奖励";
        elseif systemType == MailSystemType.KillEnemy then
            local ranking = contentTabel[2];
            local buildingData = DataBuilding[contentTabel[3]];
            local stateID = DataBuilding[contentTabel[3]].StateCN[1];
            local stateData = DataState[stateID];
            content = content.."恭喜您在攻占"..stateData.Name.." "..buildingData.Name.."("..buildingData.level..")".."中杀敌排名第"..ranking.."，请点击领取奖励";
        elseif systemType == MailSystemType.Demolition then
            local ranking = contentTabel[2];
            local buildingData = DataBuilding[contentTabel[3]];
            local stateID = DataBuilding[contentTabel[3]].StateCN[1];
            local stateData = DataState[stateID];
            content = content.."恭喜您在攻占"..stateData.Name.." "..buildingData.Name.."("..buildingData.level..")".."中拆迁排名第"..ranking.."，请点击领取奖励";
        elseif systemType == MailSystemType.OfficialAppointment or systemType == MailSystemType.OfficialRecall 
                or systemType == MailSystemType.PrefectAppointment or systemType == MailSystemType.PrefectRecall then
            local firstName = contentTabel[2];
            local secondName = contentTabel[3];
            local position = tonumber(contentTabel[4]);
            if systemType == MailSystemType.OfficialAppointment then
                content = content..firstName.."于"..self:FormatDataTime(mailInfo.time).."将"..secondName.."任命为"..CommonService:Instance():GetLeaguePositionName(position);
            elseif systemType == MailSystemType.OfficialRecall then
                content = content..firstName.."于"..self:FormatDataTime(mailInfo.time).."罢免了"..secondName.."的"..CommonService:Instance():GetLeaguePositionName(position).."职位";
            elseif systemType == MailSystemType.PrefectAppointment then
                content = content..firstName.."于"..self:FormatDataTime(mailInfo.time).."将"..secondName.."任命为"..CommonService:Instance():GetLeaguePositionName(position);
            elseif systemType == MailSystemType.PrefectRecall then
                content = content..firstName.."于"..self:FormatDataTime(mailInfo.time).."罢免了"..secondName.."的太守职位";
            end
        elseif systemType == MailSystemType.InLeagueGroup then
            local param1 = contentTabel[2];
            local param2 = contentTabel[3];
            local param3 = contentTabel[4];
            content = content..param1.."于"..self:FormatDataTime(mailInfo.time).."将您加入分组"..param2.."，分组管理为"..param3;
        elseif systemType == MailSystemType.OutLeagueGroup then
            local param1 = contentTabel[2];
            local param2 = contentTabel[3];
            content = content..param1.."于"..self:FormatDataTime(mailInfo.time).."将您移出分组"..param2;
        elseif systemType == MailSystemType.DissolutionLeagueGroup then
            local param1 = contentTabel[2];
            local param2 = contentTabel[3];
            content = content..param1.."于"..self:FormatDataTime(mailInfo.time).."解散分组"..param2;
        elseif systemType == MailSystemType.DissolutionedLeagueGroup then
            local param1 = contentTabel[2];
            local param2 = contentTabel[3];
            content = content.."由于"..param1.."于"..self:FormatDataTime(mailInfo.time).."被罢免，"..param2.."分组自动解散";
        elseif systemType == MailSystemType.InChatGroup then
            local param1 = contentTabel[2];
            local param2 = contentTabel[3];
            content = content..param1.."于"..self:FormatDataTime(mailInfo.time).."将您加入分组聊天"..param2;
        elseif systemType == MailSystemType.OutChatGroup then
            local param1 = contentTabel[2];
            local param2 = contentTabel[3];
            content = content..param1.."于"..self:FormatDataTime(mailInfo.time).."将您移出分组聊天"..param2;
        elseif systemType == MailSystemType.DissolutionChatGroup then
            local param1 = contentTabel[2];
            local param2 = contentTabel[3];
            content = content..param1.."于"..self:FormatDataTime(mailInfo.time).."解散分组聊天频道"..param2;
        elseif systemType == MailSystemType.DissolutionedChatGroup then
            local param1 = contentTabel[2];
            local param2 = contentTabel[3];
            content = content.."由于"..param1.."于"..self:FormatDataTime(mailInfo.time).."被罢免，"..param2.."聊天分组自动解散";
        elseif systemType == MailSystemType.LeaderAppointment then
            local param1 = contentTabel[2];
            local param2 = contentTabel[3];
            content = content.."盟主之位于"..self:FormatDataTime(mailInfo.time).."从"..param1.."禅让予"..param2;
        elseif systemType == MailSystemType.WorldTendency then
            local worldTendencyData = DataEpicEvent[contentTabel[2]];
            content = content..worldTendencyData.NameDisplay.."达成天下大势"..worldTendencyData.Name;        
        elseif systemType == MailSystemType.Maneuver then
            content = content.."由于您于"..self:FormatDataTime(mailInfo.time).."通关演武第10关，请点击领取奖励";
        elseif systemType == MailSystemType.CameBack then
            content = content.."欢迎再次回来，我们给您准备了一些小礼物，请点击领取。";
        elseif systemType == MailSystemType.DeleteLeagueSign then
            local param1 = contentTabel[2];
            local param2 = contentTabel[3];
            content = content..param1.."于"..self:FormatDataTime(mailInfo.time).."将你的同盟标记"..param2.."删除。";
        end
        return  content;
    end
end

function MailManage:FormatDataTime(timeMillions)
    return os.date("%Y年%m月%d日 %H:%M:%S",timeMillions/1000);
end

return MailManage
