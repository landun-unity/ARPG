--[[游戏主界面]]

local UIBase= require("Game/UI/UIBase");
local UISourceEventManage=class("UISourceEventManage",UIBase);
local List = require("common/List");

local UIType = require("Game/UI/UIType");
local UIConfigTable = require("Game/Table/model/DataUIConfig");
local SourceEventItem = require("Game/SourceEvent/SourceEventItem");
function UISourceEventManage:ctor()
    UISourceEventManage.super.ctor(self)
    
    self.UISourceEventList = List.new();

    self.UISourceEventDic = {};
    self.UISourceEventObjDic = {};

    self.SourceEventPrefab = UIConfigTable[UIType.SourceEventItem].ResourcePath;
    self.Parent = nil;
end

--注册控件
function UISourceEventManage:DoDataExchange()

end

--注册控件点击事件
function UISourceEventManage:DoEventAdd()
    
end

function UISourceEventManage:RegisterAllNotice()

end

function UISourceEventManage:AddUISourceEvent(info)
    if info == nil then
        return;
    end
    self.Parent = MapService:Instance():GetSourceEventParent();
    if self.UISourceEventDic[info._iD] == nil then        
        local mSourceEventItem = SourceEventItem.new();
        GameResFactory.Instance():GetUIPrefab(self.SourceEventPrefab,self.Parent,mSourceEventItem,function (go)
            mSourceEventItem:Init();
            mSourceEventItem:InitSourceEventItem(info,go)
            self.UISourceEventDic[info._iD] = mSourceEventItem;
            self.UISourceEventObjDic[info._iD] = mSourceEventItem.gameObject;
        end);
    else
        print("!!!!!!!!!!error  已经存在id为："..info._iD.." 的资源地事件了，你告诉我怎么还加！")
    end
end

function UISourceEventManage:DeleteUISourceEvent(id)
    if self.UISourceEventDic[id] ~= nil then
       self.UISourceEventDic[id] = nil; 
    end
    if self.UISourceEventObjDic[id] ~= nil then
        self.UISourceEventObjDic[id]:SetActive(false);
    end
end

return UISourceEventManage;