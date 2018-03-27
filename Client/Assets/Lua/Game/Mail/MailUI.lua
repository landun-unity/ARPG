-- region *.lua
-- Date
local UIBase = require("Game/UI/UIBase");
local MailUI = class("MailUI", UIBase);

local MailType = require("Game/Mail/MailType");
local List = require("common/List");
local MailWriteUI =  require("Game/Mail/MailWriteUI");
local DataItem = require("Game/Table/model/DataItem");
local AnnexType = require("Game/Mail/AnnexType");

function MailUI:ctor()

    MailUI.super.ctor(self)
    MailUI.instance = self;

    self.notPersonalMailBg = nil;
    self.noneMailText = nil;
    self.personalMailBtn = nil;
    self.groupMailBtn = nil;
    self.systemMailBtn = nil;
    self.personalMailRedPoint = nil;
    self.groupMailRedPoint = nil;
    self.systemMailRedPoint = nil;
    self.madeAllReadBtn = nil;
    self.writeMailBtn = nil;
    self.helpBtn = nil;
    self.replyMailBtn = nil;                               -- 回复邮件按钮 
    self.exitBtn = nil;
    self.gridTransform = nil;                              -- 邮件列表grid
    self.chatGridTransform = nil;                          -- 个人邮件聊天列表grid
    self.chatScrollRect = nil;

    self.replyInput = nil;                                 -- 回复邮件InputField
    self.personalScrollView = nil;                         -- 个人邮件右侧显示
                               
    self.mailDetails = nil;                                -- 非个人邮件右侧显示 
    self.titleText = nil;                                  -- 标题
    self.senderText = nil;                                 -- 发件人
    self.senderSystemBg = nil; 
    self.sendTimeText = nil;
    self.contentText = nil;
     
    self.awardsObj = nil;                                  -- 附件
    self.getAwardBtn = nil;                                -- 领取附件按钮
    self.getAwardBtnText = nil;
    self.getAwardGrayMask = nil;  
    self.awardsGrid = nil;

    self.mailItemObjDic = { };                             -- 邮件预制GameObject
    self.mailChatItemObjDic = { };                         -- 邮件聊天预制GameObject
    self.mailChatItemInfoDic = { };                        -- key: 邮件聊天预制GameObject   value: MailInfo
    self.mailChatItemBaseDic = { };                        -- key: 邮件聊天预制GameObject   value: MailChatItem脚本
    self.mailObjDic = {};                                  -- key:邮件预制GameObject  value: 个人邮件是 MailInfo列表  其它是一个MailInfo
    self.mailObjUIbaseDic = {};                            -- key:邮件预制GameObject  value: 预制上的脚本 MainInfoItem

    self.lastSelectMailTypeBtn = nil;                      -- 上次选定的邮件类型按钮
    self.curSelectMailTypeBtn = nil;                       -- 当前选定的邮件类型按钮 
    self.curSelectMailInfoObj = nil;                       -- 当前选定的邮件obj 
    self.curShowMailType = MailType.PersonalMailType;      -- 当前界面显示的邮件类型（默认进入是个人邮件）  
    self.myPlayerId = nil;                                 -- 自己的id
    self.chatItemHeight = 200;
end

-- 单例
function MailUI:Instance()
    return MailUI.instance;
end

function MailUI:DoDataExchange()
    self.notPersonalMailBg = self:RegisterController(UnityEngine.Transform, "OneBottomImage/MailDetailsBg");
    self.noneMailText = self:RegisterController(UnityEngine.RectTransform, "OneBottomImage/NoneMailText");
    self.personalMailBtn = self:RegisterController(UnityEngine.UI.Button, "OneBottomImage/MailButtonObj/PersonalMailButton");
    self.groupMailBtn = self:RegisterController(UnityEngine.UI.Button, "OneBottomImage/MailButtonObj/GroupMailButton");
    self.systemMailBtn = self:RegisterController(UnityEngine.UI.Button, "OneBottomImage/MailButtonObj/SystemButton");
    self.personalMailRedPoint = self:RegisterController(UnityEngine.RectTransform, "OneBottomImage/MailButtonObj/PersonalMailButton/RedPoint");
    self.groupMailRedPoint = self:RegisterController(UnityEngine.RectTransform, "OneBottomImage/MailButtonObj/GroupMailButton/RedPoint");
    self.systemMailRedPoint = self:RegisterController(UnityEngine.RectTransform, "OneBottomImage/MailButtonObj/SystemButton/RedPoint");
    self.madeAllReadBtn = self:RegisterController(UnityEngine.UI.Button, "OneBottomImage/MailButtonObj/MailButton4");
    self.writeMailBtn = self:RegisterController(UnityEngine.UI.Button, "OneBottomImage/MailButtonObj/MailButton5");
    self.helpBtn = self:RegisterController(UnityEngine.UI.Button, "OneBottomImage/MailButtonObj/MailButton6");
    self.replyMailBtn = self:RegisterController(UnityEngine.UI.Button, "OneBottomImage/ReplyBtn");
    self.exitBtn = self:RegisterController(UnityEngine.UI.Button, "OneBottomImage/XButton");
    self.gridTransform = self:RegisterController(UnityEngine.RectTransform, "OneBottomImage/Scroll View/Viewport/Content");
    self.chatGridTransform = self:RegisterController(UnityEngine.RectTransform, "OneBottomImage/PersonalScrollView/Viewport/Content");
    self.chatScrollRect = self:RegisterController(UnityEngine.UI.ScrollRect, "OneBottomImage/PersonalScrollView");

    self.replyInput = self:RegisterController(UnityEngine.UI.InputField, "OneBottomImage/ReplyInput");
    self.personalScrollView = self:RegisterController(UnityEngine.RectTransform, "OneBottomImage/PersonalScrollView");
    self.mailDetails = self:RegisterController(UnityEngine.RectTransform, "OneBottomImage/MailDetails");
    self.titleText = self:RegisterController(UnityEngine.UI.Text, "OneBottomImage/MailDetails/GeadlineObj/Image/TitleText");

    self.senderSystemBg = self:RegisterController(UnityEngine.Transform, "OneBottomImage/MailDetails/SystemBg");
    self.senderText = self:RegisterController(UnityEngine.UI.Text, "OneBottomImage/MailDetails/SenderText");
    self.sendTimeText = self:RegisterController(UnityEngine.UI.Text, "OneBottomImage/MailDetails/Time");
    self.contentText = self:RegisterController(UnityEngine.UI.Text, "OneBottomImage/MailDetails/ScrollView/Viewport/Content/Text");

    self.awardsObj = self:RegisterController(UnityEngine.RectTransform, "OneBottomImage/MailDetails/Awards");
    self.getAwardBtn = self:RegisterController(UnityEngine.UI.Button, "OneBottomImage/MailDetails/Awards/GetAwardBtn");
    self.getAwardBtnText = self:RegisterController(UnityEngine.UI.Text, "OneBottomImage/MailDetails/Awards/GetAwardBtn/Text");
    self.getAwardGrayMask = self:RegisterController(UnityEngine.RectTransform, "OneBottomImage/MailDetails/Awards/GetAwardBtn/GrayMask");
    self.awardsGrid = self:RegisterController(UnityEngine.RectTransform, "OneBottomImage/MailDetails/Awards/Grid");

end

function MailUI:DoEventAdd()
    self:AddListener(self.personalMailBtn, self.OnCilckPersonalMailBtn);
    self:AddListener(self.groupMailBtn, self.OnCilckGroupMailBtn);
    self:AddListener(self.systemMailBtn, self.OnCilckSystemMailBtn);
    self:AddListener(self.madeAllReadBtn, self.OnCilckMadeAllReadBtn);
    self:AddListener(self.writeMailBtn, self.OnCilckWriteMailBtn);
    self:AddListener(self.helpBtn, self.OnCilckHelpBtn);
    self:AddListener(self.replyMailBtn, self.OnCilckreplyMailBtn);
    self:AddOnClick(self.exitBtn, self.OnCilckExitBtn);
    self:AddListener(self.getAwardBtn, self.OnCilckAwardBtn);
end

function MailUI:OnShow(showType)
    
    self.myPlayerId = PlayerService:Instance():GetPlayerId(); 
    --LogManager:Instance():Log("++++++++++++++++++++++++++++++++自己的myPlayerId:"..self.myPlayerId);
    if showType == nil then 
        self.curShowMailType = MailType.PersonalMailType;
    else
        self.curShowMailType = showType;
    end                
    if self.curShowMailType == MailType.PersonalMailType then
        self.curSelectMailTypeBtn = self.personalMailBtn.transform;
    elseif  self.curShowMailType == MailType.GroupMailType then
        self.curSelectMailTypeBtn = self.groupMailBtn.transform;
    elseif  self.curShowMailType == MailType.SystemMailType then
        self.curSelectMailTypeBtn = self.systemMailBtn.transform;
    end

    self:SetMailTypeBtnState();                      
    self:ShowCurMailInfo();
end

-- 更新显示邮件（按类型）
function MailUI:ShowCurMailInfo() 
    local  mailType = self.curShowMailType;

    local showList = MailService:Instance():GetMailByType(mailType);
    self:SetMailRedPointState();

    if showList == nil then
        LogManager:Instance():Log(mailType.."  emails is nil ")
        self.noneMailText.gameObject:SetActive(true);
        local objPrefabCount = #self.mailItemObjDic;
        LogManager:Instance():Log("objPrefabCount:"..objPrefabCount)
        for index = 1, objPrefabCount do
            self.mailItemObjDic[index].gameObject:SetActive(false);
        end
        self:SetShowTypeObj(false,mailType);
        self:ShowRight(false,false,mailType);
    else
        LogManager:Instance():Log("showList:count"..#showList)
        self.noneMailText.gameObject:SetActive(false);
        --邮件类型按钮显示
        self:SetShowTypeObj(true,mailType);

        local lastSelectInfo = nil;
        if self.curSelectMailInfoObj ~= nil then
            if mailType == MailType.PersonalMailType then
                local allList = self.mailObjDic[self.curSelectMailInfoObj];
                lastSelectInfo = allList[#allList];
            else
                lastSelectInfo = self.mailObjDic[self.curSelectMailInfoObj];
            end                                 
        end

        local indexCount =1;
        for k,v in pairs(showList) do 
            --LogManager:Instance():Log("________________________________________________"..k.."   "..#v);
            if v == nil then 
                --LogManager:Instance():Log("v is nil")
                break;
            end
            if self.mailItemObjDic[indexCount] == nil then    
                local dataUIConfig = DataUIConfig[UIType.MailInfoItem];
                local uiBase = require(dataUIConfig.ClassName).new();
                GameResFactory.Instance():GetUIPrefab(dataUIConfig.ResourcePath, self.gridTransform, uiBase, function(go)
                    if uiBase.gameObject then
                        uiBase:Init();
                        uiBase.gameObject.name = uiBase.gameObject.name..indexCount;
                        --此处要取出时间最近的一封去显示                    
                        self.mailItemObjDic[indexCount] = uiBase.gameObject;
                        self.mailObjDic[uiBase.gameObject] = v;
                        if self.curShowMailType == MailType.PersonalMailType then                             
--                            for k1,v1 in pairs(v) do
--                                LogManager:Instance():Log("))))))))))))   "..k1.."   v1.senderId:"..v1.senderId.."  v1.receiverId:"..v1.receiverId.."  v1.time"..v1.time.."  v1.content"..v1.content);
--                            end
                            uiBase:SetMailInfo(v[#v],mailType);
                        else
                            --LogManager:Instance():Log("   v.senderId:"..v.senderId.."  v.receiverId:"..v.receiverId.."  v.time"..v.time.."  v.content"..v.content.."  v.mailType"..v.mailType.." v.senderName"..v.senderName)                        
                            uiBase:SetMailInfo(v,mailType);
                        end
                        self.mailObjUIbaseDic[uiBase.gameObject] = uiBase;

                        --默认显示第一条
                        if self.curSelectMailInfoObj == nil then 
                            self.curSelectMailInfoObj = self.mailItemObjDic[1];
                        end
                        if indexCount ==1 and self.mailItemObjDic[indexCount] == self.curSelectMailInfoObj then                
                            self:ShowRight(false,true,mailType,self.curSelectMailInfoObj);
                        end

                        indexCount = indexCount + 1;
                    end              
                end );
            else
                --刷新新数据
                self.mailItemObjDic[indexCount]:SetActive(true);
                if self.curSelectMailInfoObj == nil then 
                    self.curSelectMailInfoObj = self.mailItemObjDic[1];
                else
                    if lastSelectInfo ~= nil then
                        if mailType == MailType.PersonalMailType then
                            if v[#v].receiverId == lastSelectInfo.receiverId and  v[#v].senderId == lastSelectInfo.senderId then
                                self.curSelectMailInfoObj  = self.mailItemObjDic[indexCount];
                            end
                        else
                            if v.receiverId == lastSelectInfo.receiverId and  v.senderId == lastSelectInfo.senderId and v.content == lastSelectInfo.content then
                                self.curSelectMailInfoObj  = self.mailItemObjDic[indexCount];
                            end
                        end
                    end
                end

                self.mailObjDic[self.mailItemObjDic[indexCount]] = v;
                if self.curShowMailType == MailType.PersonalMailType then                    
                    self.mailObjUIbaseDic[self.mailItemObjDic[indexCount]]:SetMailInfo(v[#v],mailType);
                else
                    self.mailObjUIbaseDic[self.mailItemObjDic[indexCount]]:SetMailInfo(v,mailType);
                end
                
                
                if self.mailItemObjDic[indexCount] == self.curSelectMailInfoObj then                
                    self:ShowRight(false,true,mailType,self.curSelectMailInfoObj);
                end
                indexCount = indexCount + 1;                           
            end
        end

        --若预制物体多出则隐藏
        local objPrefabCount = #self.mailItemObjDic;
        if objPrefabCount > indexCount -1 then 
            for index = 1, objPrefabCount - indexCount + 1 do
                self.mailItemObjDic[indexCount-1 + index].gameObject:SetActive(false);
            end
        end
    end
end

--设置邮件小红点提示状态
function MailUI:SetMailRedPointState()    
    local personalCount = MailService:Instance():GetOneTypeUnReadedMailCounts(MailType.PersonalMailType);
    local groupCount =  MailService:Instance():GetOneTypeUnReadedMailCounts(MailType.GroupMailType);
    local systemCount = MailService:Instance():GetOneTypeUnReadedMailCounts(MailType.SystemMailType);
    --LogManager:Instance():Log("personalCount:"..personalCount.."    groupCount:"..groupCount.."    systemCount:"..systemCount);
    if personalCount > 0 then
        self.personalMailRedPoint.gameObject:SetActive(true);
    else
        self.personalMailRedPoint.gameObject:SetActive(false);
    end
    if groupCount > 0 then
        self.groupMailRedPoint.gameObject:SetActive(true);
    else
        self.groupMailRedPoint.gameObject:SetActive(false);
    end
    if systemCount > 0 then
        self.systemMailRedPoint.gameObject:SetActive(true);
    else
        self.systemMailRedPoint.gameObject:SetActive(false);
    end
    local allUnReadCounts = MailService:Instance():GetAllUnReadedMailCounts();
    if allUnReadCounts == 0 then
        self.madeAllReadBtn.gameObject:SetActive(false);
    else
        self.madeAllReadBtn.gameObject:SetActive(true);
    end
end   

function MailUI:CheckHaveUnReadedMail(mailType,mailInfoItemObj)
    local mailData = self.mailObjDic[mailInfoItemObj];
    if mailType == MailType.PersonalMailType then        
        for k,v in pairs(mailData) do 
            if v.isRead == 0 then 
                return true;
            end
        end
    else
        if mailData.isRead == 0 then 
            return true;
        end
    end
    return false;
end

function MailUI:GetUnReadedMail(mailType,mailInfoItemObj)
    local IDList= List.new();
    local mailData = self.mailObjDic[mailInfoItemObj];
    if mailType == MailType.PersonalMailType then        
        for k,v in pairs(mailData) do 
            if v.isRead == 0 then 
                IDList:Push(v.mailId);
            end
        end
    else
        if mailData.isRead ==0 then 
            IDList:Push(mailData.mailId);
        end
    end
    return IDList;
end

--发送读邮件消息
function MailUI:SendReadMailsMsg(idList)
    if idList~= nil and idList:Count()<=0 then
        LogManager:Instance():Log("error !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!")
        return;
    end
    local msg = require("MessageCommon/Msg/C2L/Mail/RequestIsRead").new();    
    msg:SetMessageId(C2L_Mail.RequestIsRead);
    msg.mailId = idList;
    NetService:Instance():SendMessage(msg)
    --LogManager:Instance():Log("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!发送读邮件消息 ".."  count:"..idList:Count());
end

--右侧详情显示 isClickShow 是否是点击左侧邮箱item  isShow 是否显示  
function MailUI:ShowRight(isClickShow,isShow,mailType,mailInfoItemObj)
    if isShow == true then        
        if mailInfoItemObj~= nil then
            if self.curSelectMailInfoObj~= nil then
                
                if self.curSelectMailInfoObj == mailInfoItemObj then
                    self.mailObjUIbaseDic[self.curSelectMailInfoObj]:SetSelectState(true);
                    if  isClickShow == true then
                        LogManager:Instance():Log("you are showing this mail, return!!!!!");
                        return;
                    end
                else
                    self.mailObjUIbaseDic[self.curSelectMailInfoObj]:SetSelectState(false);
                end 
            end 
            self.curSelectMailInfoObj = mailInfoItemObj;
            --如果未读则发送读邮件消息
            if self:CheckHaveUnReadedMail(mailType,mailInfoItemObj) == true then 
                self:SendReadMailsMsg(self:GetUnReadedMail(mailType,mailInfoItemObj));
            end
            self.mailObjUIbaseDic[self.curSelectMailInfoObj]:SetSelectState(true);
        end
        if mailType == MailType.PersonalMailType then 
            --input清空
            self.replyInput.text = "";
            self.notPersonalMailBg.gameObject:SetActive(false);
            --显示个人邮件聊天对话列表详情           
            --默认显示列表中第一个
            local mailList = self.mailObjDic[mailInfoItemObj];
            if mailList == nil then 
                LogManager:Instance():Log("mailList is nil ")
                return;
            end

            local indexChatCount =1;
            for k,v in pairs(mailList) do 
                if self.mailChatItemObjDic[indexChatCount] == nil then 
                    local dataUIConfig = DataUIConfig[UIType.MailChatItem];
                    local uiBase = require(dataUIConfig.ClassName).new();
                    GameResFactory.Instance():GetUIPrefab(dataUIConfig.ResourcePath, self.chatGridTransform, uiBase, function(go)
                        if uiBase.gameObject then
                            uiBase:Init();
                            uiBase.gameObject.name = uiBase.gameObject.name..indexChatCount;
                            uiBase:SetMailInfo(v);
                            self.mailChatItemObjDic[indexChatCount] = uiBase.gameObject;
                            self.mailChatItemBaseDic[uiBase.gameObject] = uiBase;
                            self.mailChatItemInfoDic[uiBase.gameObject] = v;              
                        end              
                    end );
                else
                --刷新新数据
                    self.mailChatItemObjDic[indexChatCount]:SetActive(true);
                    self.mailChatItemInfoDic[self.mailChatItemObjDic[indexChatCount]] = v;
                    self.mailChatItemBaseDic[self.mailChatItemObjDic[indexChatCount]]:SetMailInfo(v);
                end
                indexChatCount = indexChatCount+1;
            end
            --移动到聊天列表的最下面
            local newPosition = Vector3.New(self.chatGridTransform.localPosition.x, self.chatItemHeight*indexChatCount,self.chatGridTransform.localPosition.z);
            self.chatGridTransform.transform.localPosition = newPosition;

            --超出的隐藏
            local objPrefabCount = #self.mailChatItemObjDic;
            if objPrefabCount > indexChatCount-1 then 
                for index = 1, objPrefabCount - indexChatCount + 1 do
                    self.mailChatItemObjDic[indexChatCount -1 + index].gameObject:SetActive(false);
                end
            end

        else
            --LogManager:Instance():Log("非个人邮件右侧显示");
            self.notPersonalMailBg.gameObject:SetActive(true);
            local mailInfo = self.mailObjDic[self.curSelectMailInfoObj];
            if mailInfo~= nil then
               
                --LogManager:Instance():Log("当前邮件类型：   "..mailInfo.mailType)
                --LogManager:Instance():Log("mailInfo.senderName "..mailInfo.senderName.."  mailInfo.mailTheme "..mailInfo.mailTheme.."  mailInfo.content "..mailInfo.content.."  mailInfo.receiverName "..mailInfo.receiverName.." mailInfo.canCut:"..mailInfo.canCut);            
                if mailInfo.mailType == MailType.SystemMailType then 
                    self.replyMailBtn.gameObject:SetActive(false);
                end
                if mailInfo.mailType == MailType.SystemMailType then
                    self.senderSystemBg.gameObject:SetActive(true);
                    self.senderText.text = "<color=#FF612a>"..mailInfo.senderName.."</color>";
                    local title = MailService:Instance():GetSystemMailTitle(mailInfo);
                    local content =  MailService:Instance():GetSystemMailContent(mailInfo);
                    --LogManager:Instance():Log("title :"..title)
                    --LogManager:Instance():Log(" content: "..content)
                    self.titleText.text = title;
                    self.contentText.text = content;
                else
                    self.senderSystemBg.gameObject:SetActive(false);
                    LogManager:Instance():Log(mailInfo.senderId.."   "..self.myPlayerId)
                    if mailInfo.senderId == self.myPlayerId then
                        self.senderText.text = "<color=#FFFF00>我</color>";
                        self.replyMailBtn.gameObject:SetActive(false);
                    else
                        self.senderText.text = "<color=#FFFF00>"..mailInfo.senderName.."</color>";
                        self.replyMailBtn.gameObject:SetActive(true);
                    end
                    if mailInfo.mailTheme ~= "" then
                        self.titleText.text = mailInfo.mailTheme;
                    else
                        self.titleText.text = "来自【"..mailInfo.senderName.."】的邮件(对全体)";
                    end
                    self.contentText.text = mailInfo.content;
                end
                self.sendTimeText.text = os.date("%Y年%m月%d日 %H:%M:%S",mailInfo.time/1000);
                
                if mailInfo.annexCounts > 0 then 
                    self.awardsObj.gameObject:SetActive(true);
                    --self.replyMailBtn.gameObject:SetActive(false);
                    self:SetMailAwards(mailInfo);
                else
                    self.awardsObj.gameObject:SetActive(false);
                    --self.replyMailBtn.gameObject:SetActive(true);
                 end
            else
                LogManager:Instance():Log("mailInfo is nil ");
            end
        end
    else
        if mailType == MailType.PersonalMailType then
            local objPrefabCount = #self.mailChatItemObjDic;
            --LogManager:Instance():Log("右侧聊天预制数量 "..objPrefabCount);
            for index = 1, objPrefabCount do
                self.mailChatItemObjDic[index].gameObject:SetActive(false);
            end
        else
            self.notPersonalMailBg.gameObject:SetActive(true);
        end
    end
end

--附件奖励显示
function MailUI:SetMailAwards(mailInfo)
    if mailInfo.isReceiveAnnex == 0 then
        self.getAwardBtnText.text = "领取";
        self.getAwardGrayMask.gameObject:SetActive(false);
    else
        self.getAwardBtnText.text = "已领取";
        self.getAwardGrayMask.gameObject:SetActive(true);
    end
    if mailInfo.annexInfoList == nil then 
        LogManager:Instance():Log("annexInfoList is nil  不科学")
    else
        for i =1 ,self.awardsGrid.childCount do
            local item = self.awardsGrid:GetChild(i-1);
            if i <=  mailInfo.annexCounts then 
                item.gameObject:SetActive(true);
                local oneAward = mailInfo.annexInfoList:Get(i);
                --print("annexType: "..oneAward.annexType.."   annexContent: "..oneAward.annexContent)
                local splitString = CommonService:Instance():StringSplit(oneAward.annexContent,"|");
                
                if oneAward.annexType == AnnexType.Card then
                    local dataItem = DataItem[14];
                    if dataItem~= nil then
                        local heroData = DataHero[tonumber(splitString[#splitString-2])];
                        if heroData ~= nil then
                            if heroData.Star <= 4 then
                                item.transform:GetChild(0):GetComponent(typeof(UnityEngine.UI.Image)).sprite = GameResFactory.Instance():GetResSprite(dataItem.Icon1);
                            else
                                item.transform:GetChild(0):GetComponent(typeof(UnityEngine.UI.Image)).sprite = GameResFactory.Instance():GetResSprite(dataItem.Icon2);
                            end
                            item.transform:GetChild(1):GetComponent(typeof(UnityEngine.UI.Text)).text = heroData.Name;
                            item.transform:GetChild(2).gameObject:SetActive(false);
                        end
                    end
                else
                    local dataItemId = tonumber(splitString[#splitString-1]);
                    local dataItem = DataItem[dataItemId+1];
                    if dataItem~= nil then
                        item.transform:GetChild(0):GetComponent(typeof(UnityEngine.UI.Image)).sprite = GameResFactory.Instance():GetResSprite(dataItem.Icon1);
                        item.transform:GetChild(1):GetComponent(typeof(UnityEngine.UI.Text)).text = dataItem.Name;
                        item.transform:GetChild(2):GetComponent(typeof(UnityEngine.UI.Text)).text = splitString[#splitString];
                    end
                end
            else
                item.gameObject:SetActive(false);
            end
        end
    end
end

--不同邮件类型显示切换  isShow 是否显示
function MailUI:SetShowTypeObj(isShow,mailType)
    if isShow == true then 
        if mailType == MailType.PersonalMailType then 
            self.replyInput.gameObject:SetActive(true);        
            self.replyMailBtn.gameObject:SetActive(true);           
            self.personalScrollView.gameObject:SetActive(true);
            self.mailDetails.gameObject:SetActive(false);
        else
            self.replyInput.gameObject:SetActive(false);
            if mailType == MailType.GroupMailType then
                self.replyMailBtn.gameObject:SetActive(true);
            else
                self.replyMailBtn.gameObject:SetActive(false);
            end 
            self.personalScrollView.gameObject:SetActive(false);
            self.mailDetails.gameObject:SetActive(true);
        end
    else
        if mailType == MailType.PersonalMailType then 
            self.replyInput.gameObject:SetActive(false);
            self.replyMailBtn.gameObject:SetActive(false);
            self.personalScrollView.gameObject:SetActive(false);
            self.mailDetails.gameObject:SetActive(false); 
        else
            self.replyInput.gameObject:SetActive(false);
            self.replyMailBtn.gameObject:SetActive(false);
            self.personalScrollView.gameObject:SetActive(false);
            self.mailDetails.gameObject:SetActive(false);         
        end
    end
end


--个人聊天item上点击
function MailUI:OnClickChatItem(itemObj)
    local clickMailInfo = self.mailChatItemInfoDic[itemObj];   
    --LogManager:Instance():Log("点击了邮件聊天item：  senderId:"..clickMailInfo.senderId.."   senderName:"..clickMailInfo.senderName);
    if clickMailInfo.senderId ==  self.myPlayerId then 
        return;
    end

    local params = {};
    params[1] = clickMailInfo.senderId;
    params[2] = clickMailInfo.senderName;
    UIService:Instance():ShowUI(UIType.OperationUI,params);
end

-- 点击个人邮件按钮
function MailUI:OnCilckPersonalMailBtn()
    if self.curShowMailType == MailType.PersonalMailType then
        return;
    end

    self.lastSelectMailTypeBtn = self.curSelectMailTypeBtn;                   
    self.curSelectMailTypeBtn = self.personalMailBtn.transform;
    self:SetMailTypeBtnState();
    self.curShowMailType = MailType.PersonalMailType;
    self.curSelectMailInfoObj = nil;
    self:ShowCurMailInfo();
end

-- 点击群邮件
function MailUI:OnCilckGroupMailBtn()
    if self.curShowMailType == MailType.GroupMailType then
        return;
    end
    self.lastSelectMailTypeBtn = self.curSelectMailTypeBtn;                   
    self.curSelectMailTypeBtn = self.groupMailBtn.transform;
    self:SetMailTypeBtnState();
    self.curShowMailType = MailType.GroupMailType;
    self.curSelectMailInfoObj = nil;
    self:ShowCurMailInfo();
end

-- 点击系统邮件
function MailUI:OnCilckSystemMailBtn()
    if self.curShowMailType == MailType.SystemMailType then
        return;
    end
    self.lastSelectMailTypeBtn = self.curSelectMailTypeBtn;                   
    self.curSelectMailTypeBtn = self.systemMailBtn.transform;
    self:SetMailTypeBtnState();
    self.curShowMailType = MailType.SystemMailType;
    self.curSelectMailInfoObj = nil;
    self:ShowCurMailInfo();
end

function MailUI:SetMailTypeBtnState()
    if self.lastSelectMailTypeBtn ~= nil then
        self.lastSelectMailTypeBtn:GetChild(0).gameObject:SetActive(false);
    end
    if self.curSelectMailTypeBtn ~= nil then
        self.curSelectMailTypeBtn:GetChild(0).gameObject:SetActive(true);
    end
end 

-- 点击全部标为已读
function MailUI:OnCilckMadeAllReadBtn()
    self:SendReadMailsMsg(MailService:Instance():GetAllTypeUnReadedMailIds());
end 

-- 点击写邮件
function MailUI:OnCilckWriteMailBtn()
    UIService:Instance():ShowUI(UIType.MailWriteUI,false);
end

-- 点击帮助
function MailUI:OnCilckHelpBtn()  
    local params = {};
    params[1] = "说明";
    params[2] = "两周后，邮件会被自动删除";
    UIService:Instance():ShowUI(UIType.UICommonTipSmall,params);
end

-- 点击回复按钮
function MailUI:OnCilckreplyMailBtn()
    local mailInfo = nil;
    --个人邮件回复 
    if self.curShowMailType == MailType.PersonalMailType then
        if self.replyInput.text == "" then
            UIService:Instance():ShowUI(UIType.UICueMessageBox,128);
            return;
        end
        --去掉2边的空格
        local newInput = string.gsub(self.replyInput.text, "^%s*(.-)%s*$", "%1");
        if newInput == "" then
            UIService:Instance():ShowUI(UIType.UICueMessageBox,128);
            return;
        end
        --非法字符检测
        if CommonService:Instance():LimitText(self.replyInput.text) == true then
            return;
        end       
        mailInfo = self.mailObjDic[self.curSelectMailInfoObj][1];
        --LogManager:Instance():Log("myPlayerId:"..self.myPlayerId.."   mailInfo.receiverId:"..mailInfo.receiverId.." mailInfo.senderId:"..mailInfo.senderId.." mailInfo.SenderName:"..mailInfo.senderName.." mailInfo.receiverName"..mailInfo.receiverName); 

        local msg = require("MessageCommon/Msg/C2L/Mail/RequestSendMail").new();    
        msg:SetMessageId(C2L_Mail.RequestSendMail);
        --收件人id List
        local receiverId  = 0;
        if self.myPlayerId ==  mailInfo.receiverId then 
            receiverId = mailInfo.senderId;
        else
            receiverId = mailInfo.receiverId;
        end
        msg.receiverIdList:Push(receiverId);
        msg.mailContent = self.replyInput.text;
        NetService:Instance():SendMessage(msg)
        --LogManager:Instance():Log("发送邮件消息 ".."  msg.mailTheme:"..msg.mailTheme.." msg.receiverName:"..msg.receiverName.." msg.mailContent:"..msg.mailContent);
    elseif self.curShowMailType == MailType.GroupMailType then
        --群发邮件回复 
        mailInfo = self.mailObjDic[self.curSelectMailInfoObj];
        UIService:Instance():ShowUI(UIType.MailWriteUI,true);
        MailWriteUI:Instance():SetPersonalReceiveInfo(mailInfo.senderName);
    end
end

--领取附件成功，界面显示
function MailUI:ShowGetAwardInfo()
    local mailInfo = self.mailObjDic[self.curSelectMailInfoObj];
    if mailInfo == nil then
        return;
    end
    for i=1,mailInfo.annexCounts do
        local oneAward = mailInfo.annexInfoList:Get(i);
        local splitString = CommonService:Instance():StringSplit(oneAward.annexContent,"|");
        if oneAward.annexType == AnnexType.Card then
            local dataItem = DataItem[14];
            if dataItem~= nil then
                local heroData = DataHero[tonumber(splitString[#splitString-2])];
                if heroData ~= nil then
                    local param = {};
                    param.name =  heroData.Name;
                    param.count = 1;
                    UIService:Instance():ShowUI(UIType.UIGetItemManage, param);
                end
            end
        else
            local dataItemId = tonumber(splitString[#splitString-1]);
            local dataItem = DataItem[dataItemId+1];
            if dataItem~= nil then
                local param = {};
                param.name = dataItem.Name;
                param.count = splitString[#splitString];
                UIService:Instance():ShowUI(UIType.UIGetItemManage, param);
            end
        end
    end
end

--点击领取附件按钮
function MailUI:OnCilckAwardBtn()
    local mailInfo = self.mailObjDic[self.curSelectMailInfoObj];
    if mailInfo == nil then 
        LogManager:Instance():Log("mailInfo is nil");
        return;
    end
    if mailInfo.isReceiveAnnex == 1 then
        LogManager:Instance():Log("已领取")
        return;
    end
    --发送领取附件奖励消息
    local msg = require("MessageCommon/Msg/C2L/Mail/RequestReceive").new();    
    msg:SetMessageId(C2L_Mail.RequestReceive);
    msg.mailId = mailInfo.mailId;
    NetService:Instance():SendMessage(msg)
    --LogManager:Instance():Log("发送领取附件奖励消息 ".."  msg.mailId:"..msg.mailId);
end

--关闭邮件界面
function MailUI:OnCilckExitBtn()
    UIService:Instance():HideUI(UIType.MailUI);
    if self.curSelectMailTypeBtn ~= nil then
        self.curSelectMailTypeBtn:GetChild(0).gameObject:SetActive(false);
    end
    UIService:Instance():ShowUI(UIType.UIGameMainView);
end

return MailUI
