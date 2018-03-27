-- 聊天
local UIBase = require("Game/UI/UIBase");
local ChatService = require("Game/Chat/ChatService");
local PlayerService = require("Game/Player/PlayerService")
require("Game/Chat/ChatContentType")
require("Game/League/LeagueTitleType")
require("Game/Chat/ChatsTotalType")
require("Game/Chat/ChatType");
-- require("Game/Table/model/DataBuilding")
-- require("Game/Table/model/DataRegion")
-- require("Game/Table/model/DataConstruction")
-- require("Game/Table/model/DataAlliesMemberAuthority")
local UIChatContentItemBtnItem = class("UIChatContentItemBtnItem", UIBase)

function UIChatContentItemBtnItem:ctor()
    UIChatContentItemBtnItem.super.ctor(self);
    self._chatcontent = nil;
    self._mType = 0;
    self._mchatType = 0;
    self._chatDetailsBtn = nil;
    self._nameText = nil;
    self._detailsText = nil;
    self._timeText = nil;
    self._selfObj = nil;
    self._lineText = nil;
    self._detailsImage = nil;

    self._textWidth = 900;

    self._detailsImageOffest = 10;
    --坐标index
    self._chatCoordinateIndex = 0;
end

function UIChatContentItemBtnItem:OnInit(mType, mchatType)
    self._mType = mType;
    self._mchatType = mchatType;
end

function UIChatContentItemBtnItem:DoDataExchange(mType)
    self._chatDetailsBtn = self:RegisterController(UnityEngine.UI.Button, "ChatButton");
    self._nameText = self:RegisterController(UnityEngine.UI.Text, "NameText");
    self._detailsText = self:RegisterController(UnityEngine.UI.Text, "DetailsText");
    self._timeText = self:RegisterController(UnityEngine.UI.Text, "TimeText");
    self._selfObj = self:RegisterController(UnityEngine.Transform, "");
    self._lineText = self:RegisterController(UnityEngine.UI.Text, "LineText");
    self._detailsImage = self:RegisterController(UnityEngine.UI.Image, "DetailsImage");
end

function UIChatContentItemBtnItem:DoEventAdd()
    self:AddListener(self._chatDetailsBtn, self.OnClickChatDetailsBtn);
end

function UIChatContentItemBtnItem:OnShow(chatType, chatcontent)

    self._lineText.text = "";
    self._chatCoordinateIndex = 0;
    self._chatcontent = chatcontent;
    self._mType = chatcontent.mType;
    self._mchatType = chatType;
    self._timeText.text =  self:_TimeText(PlayerService:Instance():GetLocalTime() / 1000 - chatcontent.sendTime / 1000);
    self:HandlerNameText(chatType, chatcontent);
    self:Handlercontent(chatcontent);
end

function UIChatContentItemBtnItem:GetType()
    return self._mType, self._mchatType;
end

function UIChatContentItemBtnItem:judgeChatContenType(chatContentType)
    if chatContentType == ChatContentType.FightAAType or chatContentType == ChatContentType.FightAWType 
     or chatContentType == ChatContentType.FirstWildBattleWType or chatContentType == ChatContentType.FirstWildBattleSType
     or chatContentType == ChatContentType.BattleReportType or chatContentType == ChatContentType.FallAllianceType then
       return ChatsTotalType.Battle;
    elseif chatContentType == ChatContentType.StringType then
       return ChatsTotalType.String;
    else
       return ChatsTotalType.Event;
    end
end

function UIChatContentItemBtnItem:HandlerNameText(chatType, chatcontent)
    if (self:judgeChatContenType(chatcontent.mType) == ChatsTotalType.Event or 
    self:judgeChatContenType(chatcontent.mType) == ChatsTotalType.Battle) and 
    (chatType == ChatType.StateChat or chatType == ChatType.SystemChat) then
        self._nameText.text = "<color=#6eaf47>事件</color>";
        return;
    end

    if self:judgeChatContenType(chatcontent.mType) == ChatsTotalType.Battle and (chatType == ChatType.WorldChat or chatType == ChatType.GroupingChat) then
        self._nameText.text = "<color=#a2341f>战况</color>";
        return;
    end
    
    --同盟
    local leagueName = "";
    local countryName = "";
    local stateName = "";
    local playerName = "";
    local zoneName = "";
    if chatcontent.playerId ~= PlayerService:Instance():GetPlayerId() then
        if chatType == ChatType.WorldChat or chatType == ChatType.StateChat then
            if chatcontent.country ~= 0 then
                countryName = "<color=#6eaf47>【"..chatcontent.leagueName.."】</color>";
            else
                countryName = "<color=#6eaf47>【在野】</color>";
            end
        end

        if chatcontent.leadership ~= LeagueTitleType.Nomal and chatcontent.leadership ~= nil and chatcontent.leadership ~= 0 then
           leagueName = "<color=#6eaf47>【"..ChatService:Instance():GetAlliesMemberAuthority(chatcontent.leadership).AlliesMember.."】</color>";
        end
        if chatcontent.state ~= 0 then
           stateName = "<color=#6eaf47>【"..DataState[chatcontent.state].Name.."】</color>";
        end

        playerName = "<color=#e2bd75>"..chatcontent.playerName.."</color>";
        
        if chatType == ChatType.CompetitionChat then
            if chatcontent.zoneId ~= 0 then
                zoneName = "<color=#6eaf47>【"..chatcontent.zoneId.."】</color>";
            end
        end
        self._timeText.text = "<color=#6eaf47>"..self._timeText.text.."</color>";
    else
        playerName = "<color=#6eaf47>".."我".."</color>";
        self._timeText.text = "<color=#6eaf47>"..self._timeText.text.."</color>";
    end

    self._nameText.text = zoneName..stateName..countryName..leagueName..playerName;
end

function UIChatContentItemBtnItem:HandlerEventContent(chatcontent)
    if chatcontent.mType == ChatContentType.SignAllianceType then
        self._detailsText.text = ChatService:Instance():HandlerString(chatcontent.mType, chatcontent.content);
        return;
    elseif chatcontent.mType == ChatContentType.PlayerFacilityType then
        local x, y = MapService:Instance():GetTiledCoordinate(tonumber(chatcontent.buildingIndex));
        self._detailsText.text = ChatService:Instance():HandlerString(chatcontent.mType, 
            ChatService:Instance():GetBuilding(chatcontent.buildingId).Name, 
            chatcontent.buildingName, x, y);
        return;
    elseif chatcontent.mType == ChatContentType.JoinAllianceType then
        self._detailsText.text = ChatService:Instance():HandlerString(chatcontent.mType, chatcontent.content);
        return;
    elseif chatcontent.mType == ChatContentType.EstablishType then
        self._detailsText.text = ChatService:Instance():HandlerString(chatcontent.mType, chatcontent.content, 
            DataState[chatcontent.otherLeagueState].Name, 
            ChatService:Instance():GetRegion(chatcontent.buildingId).Name);
        return;
    elseif chatcontent.mType == ChatContentType.LandBattleType then
        self._detailsText.text = ChatService:Instance():HandlerString(chatcontent.mType, chatcontent.content);
        return;
    elseif chatcontent.mType == ChatContentType.FightAAType then
        local name = "";
        if chatcontent.otherLeagueState == 1 then
            name = "在野";
        elseif chatcontent.otherLeagueState == 2 then
            name = "同盟";
        end
        self._detailsText.text = ChatService:Instance():HandlerString(chatcontent.mType, 
        DataState[chatcontent.buildingId].Name,
        chatcontent.otherTPlayerName, 
        DataState[chatcontent.buildingIndex].Name,
        name,
        chatcontent.otherLeagueName);
        return;
    elseif chatcontent.mType == ChatContentType.FightAWType then
        self._detailsText.text = ChatService:Instance():HandlerString(chatcontent.mType, 
        DataState[chatcontent.otherLeagueState].Name, chatcontent.otherLeagueName,
        DataState[ChatService:Instance():GetBuilding(chatcontent.buildingId).StateCN[1]].Name, 
        ChatService:Instance():GetBuilding(chatcontent.buildingId).Name, 
        ChatService:Instance():GetBuilding(chatcontent.buildingId).level);
        return;
    elseif chatcontent.mType == ChatContentType.FirstWildBattleWType then
        self._detailsText.text = ChatService:Instance():HandlerString(chatcontent.mType, 
        DataState[chatcontent.otherLeagueState].Name, chatcontent.otherLeagueName,
        DataState[ChatService:Instance():GetBuilding(chatcontent.buildingId).StateCN[1]].Name, 
        ChatService:Instance():GetBuilding(chatcontent.buildingId).Name, 
        ChatService:Instance():GetBuilding(chatcontent.buildingId).level,
        chatcontent.otherOPlayerName, chatcontent.otherTPlayerName);
        return;
    elseif chatcontent.mType == ChatContentType.FirstWildBattleSType then
        self._detailsText.text = ChatService:Instance():HandlerString(chatcontent.mType, 
        DataState[chatcontent.otherLeagueState].Name, chatcontent.otherLeagueName,
        DataState[ChatService:Instance():GetBuilding(chatcontent.buildingId).StateCN[1]].Name, 
        ChatService:Instance():GetBuilding(chatcontent.buildingId).Name, 
        ChatService:Instance():GetBuilding(chatcontent.buildingId).level);
        return;
    elseif chatcontent.mType == ChatContentType.BattleReportType then
        local x,y =  MapService:Instance():GetTiledCoordinate(chatcontent.tileIndex);
        self._detailsText.text = ChatService:Instance():HandlerString(chatcontent.mType, 
        HeroService:Instance():GetHeroNameById(chatcontent.aCardTableID), 
        HeroService:Instance():GetHeroNameById(chatcontent.dCardTableID),
        DataState[PmapService:Instance():GetStateIDbyIndex(chatcontent.tileIndex)].Name,
        BattleReportService:Instance():GetTiledName(chatcontent.tileIndex, chatcontent.placeType, chatcontent.buildingId, chatcontent.buildingName).."("..x..","..y..")");
        self:HandlerLineText();
        return;
    elseif chatcontent.mType == ChatContentType.FacilityType then
        self._detailsText.text = ChatService:Instance():HandlerString(chatcontent.mType, chatcontent.buildingName, 
            ChatService:Instance():GetConstruction(chatcontent.buildingId).Name, chatcontent.otherLeagueState);
        return;
    elseif chatcontent.mType == ChatContentType.CardType then
        local x,y =  MapService:Instance():GetTiledCoordinate(chatcontent.buildingIndex);
        self._detailsText.text = ChatService:Instance():HandlerString(chatcontent.mType, 
        HeroService:Instance():GetHeroNameById(chatcontent.buildingId),
        chatcontent.buildingName, "("..x..","..y..")",
        ChatService:Instance():GetCardType(chatcontent.otherLeagueState).Name);
        return;
    elseif chatcontent.mType == ChatContentType.ExperienceType then
        local x,y =  MapService:Instance():GetTiledCoordinate(chatcontent.buildingIndex);
        self._detailsText.text = ChatService:Instance():HandlerString(chatcontent.mType, 
        HeroService:Instance():GetHeroNameById(chatcontent.buildingId),
        tonumber(chatcontent.buildingName), "("..x..","..y..")",
        tonumber(ChatService:Instance():GetExperienceType(chatcontent.otherLeagueState).Experience));
        return;
    elseif chatcontent.mType == ChatContentType.RescueType then
        self._detailsText.text = ChatService:Instance():HandlerString(chatcontent.mType, 
        DataState[chatcontent.buildingIndex].Name,
        chatcontent.otherLeagueName,
        chatcontent.buildingName,
        DataState[chatcontent.buildingId].Name,
        chatcontent.otherOPlayerName);
        return;
    elseif chatcontent.mType == ChatContentType.FallAllianceType then
        self._detailsText.text = ChatService:Instance():HandlerString(chatcontent.mType, 
        DataState[chatcontent.buildingId].Name,
        chatcontent.otherTPlayerName,
        chatcontent.otherOPlayerName,
        DataState[chatcontent.buildingIndex].Name,
        chatcontent.otherLeagueName,
        chatcontent.buildingName);
    elseif chatcontent.mType == ChatContentType.PlayerFallType then
        self._detailsText.text = ChatService:Instance():HandlerString(chatcontent.mType, 
        DataState[chatcontent.buildingIndex].Name,
        chatcontent.otherLeagueName,
        chatcontent.buildingName);
        return;
    end
end

function UIChatContentItemBtnItem:HandlerTextSizeDelta(width)
    if width > self._textWidth then
        --local height = self._detailsText.preferredHeight;
        self._detailsText.gameObject:GetComponent(typeof(UnityEngine.UI.ContentSizeFitter)).enabled = false;
        self._detailsText.gameObject:GetComponent(typeof(UnityEngine.RectTransform)).sizeDelta = Vector2.New(self._textWidth, 100);
        return self._textWidth + self._detailsImageOffest;
    end
    return self._detailsText.preferredWidth + self._detailsImageOffest;
end

function UIChatContentItemBtnItem:HandlerImage()
    self._detailsText.gameObject:GetComponent(typeof(UnityEngine.UI.ContentSizeFitter)).enabled = true;
   
    local mwidth = self._detailsText.preferredWidth;
    local width = self:HandlerTextSizeDelta(mwidth);
    local height = self._detailsText.preferredHeight + self._detailsImageOffest;
    self._detailsImage.gameObject:GetComponent(typeof(UnityEngine.RectTransform)).sizeDelta = Vector2.New(width, height);
end

function UIChatContentItemBtnItem:HandlerLineText()
    self._detailsText.gameObject:GetComponent(typeof(UnityEngine.UI.ContentSizeFitter)).enabled = true;
    local x = "_";
    self._lineText.text = x;


    local width = self._detailsText.preferredWidth;
    local perlineWidth = self._lineText.preferredWidth;
    local lineCount = math.floor(width / perlineWidth);

    for i = 1, lineCount do
        self._lineText.text = self._lineText.text..x;
    end

    self._lineText.text = "<color=#6eaf47>"..self._lineText.text.."</color>";
    self:HandlerTextSizeDelta(width);
end

function UIChatContentItemBtnItem:Handlercontent(chatcontent)
    if chatcontent.mType ~= ChatContentType.StringType then
        self:HandlerEventContent(chatcontent);
        return;
    end

    local chatContent = chatcontent.content;

    --变色
    chatContent = self:HandlerTextColor(chatContent);
    --坐标
    chatContent = self:HandlerCoordinate(chatContent);
    --最终
    self._detailsText.text = "<color=#472a12>"..chatContent.."</color>";

    self:HandlerImage();
end

--处理变色
function UIChatContentItemBtnItem:HandlerTextColor(content)
    if content == nil then
        return;
    end

    content = self:HandlerText(content, "@");
    content = self:HandlerText(content, "~", "@");

    return content;
end

function UIChatContentItemBtnItem:HandlerText(content, value, mvalue)
    local index,b = string.find(content, value);
    local indexB = 0;
    if index then
        if tostring(self:_StringNumber(content, index + 1)) ~= nil then
            indexB = index;
            repeat
                indexB = indexB + 1;
            until(self:_StringNumber(content, indexB + 1) == "" or
             self:_StringNumber(content, indexB + 1) == nil or 
             tostring(self:_StringNumber(content, indexB + 1)) == nil or 
             tostring(self:_StringNumber(content, indexB + 1)) == value or 
             tostring(self:_StringNumber(content, indexB + 1)) == mvalue);
        end
    end

    if index ~= nil and tostring(self:_StringNumber(content, indexB + 1)) == value then
        local color = "";
        if value == "~" then
            color = "<color=#6eaf47>";
        elseif value == "@" then
            color = "<color=#e2bd75>";
        end
        return string.sub(content, 1, index - 1)..color..string.sub(content, index + 1, indexB).."</color>"..string.sub(content, indexB + 2); 
    end

    return content;
end

--处理坐标
function UIChatContentItemBtnItem:HandlerCoordinate(content)
    local index,b = string.find(content, ",");
    --print(content[index + 1])
    local stringCoordinateF = "";
    local indexF = 0;
    local stringCoordinateB = "";
    local indexB = 0;
    if index then
        if tonumber(self:_StringNumber(content, index + 1)) ~= nil then
            indexB = index;
            repeat
                indexB = indexB + 1;
                stringCoordinateB = stringCoordinateB..self:_StringNumber(content, indexB);
            until(tonumber(self:_StringNumber(content, indexB + 1)) == nil 
                or tonumber(stringCoordinateB..self:_StringNumber(content, indexB + 1)) >= 1600 
                or tonumber(stringCoordinateB..self:_StringNumber(content, indexB + 1)) <= 0);
        end
        
        if tonumber(self:_StringNumber(content, index - 1)) ~= nil then
            indexF = index;
            repeat
                indexF = indexF - 1;
                stringCoordinateF = self:_StringNumber(content, indexF)..stringCoordinateF;
            until(tonumber(self:_StringNumber(content, indexF - 1)) == nil or
             tonumber(self:_StringNumber(content, indexF - 1)..stringCoordinateF) >= 1600 
              or tonumber(self:_StringNumber(content, indexF - 1)..stringCoordinateF) <= 0);
        end
    end

    if tonumber(stringCoordinateB) ~= nil and tonumber(stringCoordinateB) < 1600 and tonumber(stringCoordinateB) > 0 and
        tonumber(stringCoordinateF) ~= nil and tonumber(stringCoordinateF) < 1600 and tonumber(stringCoordinateF) > 0 and index ~= nil then
       self._chatCoordinateIndex = MapService:Instance():GetTiledIndex(tonumber(stringCoordinateF), tonumber(stringCoordinateB));
       return string.sub(content, 1, indexF - 1).."<color=#6eaf47>("..string.sub(content, indexF, indexB)..")</color>"..string.sub(content, indexB + 1); 
    else
       return content;
    end
end

function UIChatContentItemBtnItem:_StringNumber(content, index)
   return string.sub(content, index, index);
end

function UIChatContentItemBtnItem:_TimeText(mtime)
    local time = math.floor(mtime);
    local h = math.floor(time / 3600);
    local m = math.floor(math.floor(time % 3600) / 60);
    if h >= 24 then
       if h >= 24 and h <= 48 then
           return "昨天";
       else
           --日期
           return os.date("%m-%d");
       end
    elseif  h > 0 then
       return h.."小时前";
    elseif h == 0 then
       if m > 0 then
           return m.."分钟前";
       else
           return "刚刚";
       end
    elseif h < 0 then
       return "刚刚";
    end
end

function UIChatContentItemBtnItem:OnClickChatDetailsBtn()
    if self._chatcontent.mType == ChatContentType.StringType then
        local params = {};
        params[1] = self._chatcontent.playerId;
        params[2] = self._chatcontent.playerName;
        params[3] = self._chatCoordinateIndex;
        if PlayerService:Instance():GetPlayerId() == self._chatcontent.playerId and self._chatCoordinateIndex == 0 then
           return;
        end
        UIService:Instance():ShowUI(UIType.OperationUI, params);
    elseif self._chatcontent.mType == ChatContentType.BattleReportType then
        local params = {};
        params[1] = self._chatcontent.playerId;
        params[2] = self._chatcontent.playerName;
        params[5] = self._chatcontent;
        UIService:Instance():ShowUI(UIType.OperationUI, params);
    else
        UIService:Instance():ShowUI(UIType.UICueMessageBox,104);
    end
end

function UIChatContentItemBtnItem:Hide()
    self._selfObj.gameObject:SetActive(false);
    self._detailsImage.gameObject:GetComponent(typeof(UnityEngine.RectTransform)).sizeDelta = Vector2.New(0, 0);
end

function UIChatContentItemBtnItem:ClearContentSizeFitter()
     self._detailsImage.gameObject:GetComponent(typeof(UnityEngine.RectTransform)).sizeDelta = Vector2.New(0, 0);
    self._detailsText.gameObject:GetComponent(typeof(UnityEngine.UI.ContentSizeFitter)).enabled = false;
    self._detailsText.gameObject:GetComponent(typeof(UnityEngine.RectTransform)).sizeDelta = Vector2.New(self._textWidth, 200);
end

return UIChatContentItemBtnItem;