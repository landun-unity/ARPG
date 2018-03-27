--[[ 游戏主界面 ]]

local UIBase = require("Game/UI/UIBase");
local SourceEventItem = class("SourceEventItem", UIBase);

local SourceEventType = require("Game/SourceEvent/SourceEventType");
local DataCardSet = require("Game/Table/model/DataCardSet");
local DataExperienceBook = require("Game/Table/model/DataExperienceBook");
local DataTileEvent = require("Game/Table/model/DataTileEvent");
local Client = require("Game/Client")
local DeleteSourceEvent = require("MessageCommon/Msg/C2L/SourceEvent/DeleteSourceEvent");

function SourceEventItem:ctor()
    SourceEventItem.super.ctor(self)
    self.Id = 0;

    self.cardWidth = 79;
    self.cardHeight = 113;
    self.expBookWidth = 127;
    self.expBookHeight = 113;
end

-- 注册控件
function SourceEventItem:DoDataExchange()
    self.Image = self:RegisterController(UnityEngine.UI.Image, "Image")
    self.ImageTransform = self:RegisterController(UnityEngine.RectTransform, "Image")
    self.ExpEffect = self:RegisterController(UnityEngine.Transform, "ExpEffect")
    self.Cardeffect = self:RegisterController(UnityEngine.Transform, "Cardeffect")
    self.timelabel = self:RegisterController(UnityEngine.UI.Text, "TimeLabel")
end

-- 注册控件点击事件
function SourceEventItem:DoEventAdd()

end

function SourceEventItem:InitSourceEventItem(info,go)
    self.Id = info._iD;
    -- self._eventType = 0;
    -- self._eventTableID = 0;
    -- self._endTime = 0;
    local x = info._positionX;
    local y = info._positionY;
    --self.ThisGameObject.transform.localPosition = MapService:Instance():GetTiledPosition(x, y);
    go.transform.localPosition = MapService:Instance():GetTiledPosition(x, y);
    go.name = "id:"..info._iD.." X:"..x.." Y:"..y;
    local data = nil;
    if info._eventType == SourceEventType.ExperienceBook then
        data = DataExperienceBook[info._eventTableID];
        self.ExpEffect.gameObject:SetActive(true);
        self.Cardeffect.gameObject:SetActive(false);

        self.Image.sprite = GameResFactory.Instance():GetResSprite(data.ExperienceIcon);
        self.ImageTransform.sizeDelta = Vector2.New(self.expBookWidth, self.expBookHeight);
        --self.timelabel.text = "经验书_"..data.ID;
    elseif info._eventType == SourceEventType.CardSet then
        data = DataCardSet[info._eventTableID];
        self.ExpEffect.gameObject:SetActive(false);
        self.Cardeffect.gameObject:SetActive(true);
        self.Image.sprite = GameResFactory.Instance():GetResSprite(data.CardSetIcon)
        self.ImageTransform.sizeDelta = Vector2.New(self.cardWidth, self.cardHeight);
        --self.timelabel.text = "卡包"..data.ID;
    elseif info._eventType == SourceEventType.Thief then
        print("获取的贼兵事件 表id："..info._eventTableID);
        data = DataTileEvent[info._eventTableID];
        if data == nil then
            print("获取的贼兵事件 表id："..info._eventTableID.." 数据是空的！！！！！！！！！！");
            return;
        end
        self.ExpEffect.gameObject:SetActive(false);
        self.Cardeffect.gameObject:SetActive(false);
        --self.Image.sprite = GameResFactory.Instance():GetResSprite(data.Pic)
        self.ImageTransform.sizeDelta = Vector2.New(self.cardWidth, self.cardHeight);
        --self.timelabel.text = "贼兵"..data.ID;
        --self.timelabel.text = "贼兵";
    end
end

-- 时间结束后发送消息
function SourceEventItem:SendTimeOverMessage()
    local msg = DeleteSourceEvent.new();
    msg:SetMessageId(C2L_SourceEvent.DeleteSourceEvent);
    msg.iD = self.Id;
    NetService:Instance():SendMessage(msg);
    -- print("发送了资源地结束领的消息")
end

return SourceEventItem;