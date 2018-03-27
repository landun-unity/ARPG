--[[ 游戏主界面 ]]

local UIBase = require("Game/UI/UIBase");
local UIService = require("Game/UI/UIService");
local UIType = require("Game/UI/UIType");
local UIConfigTable = require("Game/Table/model/DataUIConfig");
local UIBattleReport = class("UIBattleReport", UIBase);
local List = require("common/List");
local ReportItem = require("Game/BattleReport/UIBattleReport/UIBattleReportItem");
local BattleReportType = require("Game/BattleReport/BattleReportType");
local ReportGroup = require("Game/BattleReport/UIBattleReport/ReportGroup");
local SetBattleReportRead = require("MessageCommon/Msg/C2L/BattleReport/SetBattleReportRead");
local GetBattleReport = require("MessageCommon/Msg/C2L/BattleReport/GetBattleReport");

local AddY = -188;
local MaxItemNum = 15;
local preRow = 0;
local curRow = 0;
local rectWidth = 1230
local itemHeight = 180;

function UIBattleReport:ctor()
    UIBattleReport.super.ctor(self)

    self._Parent = nil;
    --self._SV = nil;
    self._scrollRect = nil;
    self._VerticalLayout = nil;
    --self._ContentSizeFitter = nil;
    self._allReadBtn = nil;
    self._ReportSwitchBtn = nil;
    self._ReportSwitchBtnLabel = nil;
    self.backBtn = nil;
    self._AllReportBtn = nil;
    self._AttackReportBtn = nil;
    self._AttackCityReportBtn = nil;
    self._DefenceReportBtn = nil;    
    self.ReportItemPrefab = nil;
    self.NoReportText = nil;

    self.ReportGroup = ReportGroup.Persion;
    
    self.ReportType = nil;
    self.Unread = false;
    
    self.isFirstOpen = true;
    self.firstPosy = 0;
    self.allPageCount = 1;
    self.pageCount = 1;
    self.ShowCount = 0;

    self._AllItemList = List.new();
    self._ReportInfoList = nil;

    self.allItemObjs = {};
    self.OnePageCountMax = 15;          -- 一页战报的最大条数
    self.CurClickItemBase = nil;        -- 当前点击的UIBattleReportItem脚本

    self.layoutHeight = 15 * itemHeight;

    self.couldRestRectPosition = true;
end

-- 注册控件
function UIBattleReport:DoDataExchange()
    self.backBtn = self:RegisterController(UnityEngine.UI.Button, "backBtn")
    self._Parent = self:RegisterController(UnityEngine.Transform, "ScrolObj/ScrollView/Viewport/Layout")
    self._VerticalLayout = self:RegisterController(UnityEngine.RectTransform, "ScrolObj/ScrollView/Viewport/Layout")
    self._scrollRect = self:RegisterController(UnityEngine.UI.ScrollRect, "ScrolObj/ScrollView")
    self.NoReportText = self:RegisterController(UnityEngine.UI.Text,"NoReport");
    self._ReportSwitchBtn = self:RegisterController(UnityEngine.UI.Button, "AllBtns/RightCorner/ReportSwitchBtn")
    self._ReportSwitchBtnLabel = self:RegisterController(UnityEngine.UI.Text, "AllBtns/RightCorner/ReportSwitchBtn/Text")
    self._allReadBtn = self:RegisterController(UnityEngine.UI.Button, "AllBtns/RightCorner/SettoReadBtn")
    self._AllReportBtn = self:RegisterController(UnityEngine.UI.Button, "AllBtns/AllReportBtn")
    self._AttackReportBtn = self:RegisterController(UnityEngine.UI.Button, "AllBtns/AttackReportBtn")
    self._AttackCityReportBtn = self:RegisterController(UnityEngine.UI.Button, "AllBtns/AttackCityReportBtn")
    self._DefenceReportBtn = self:RegisterController(UnityEngine.UI.Button, "AllBtns/DefenceReportBtn")
    --self._ContentSizeFitter = self._Parent.gameObject:GetComponent(typeof(UnityEngine.UI.ContentSizeFitter));
    --self._SV = self:RegisterController(UnityEngine.UI.Scrollbar, "ScrolObj/Scrollbar")
end

-- 注册控件点击事件
function UIBattleReport:DoEventAdd()
    self:AddListener(self.backBtn, self.OnClickbackBtn)
    self:AddListener(self._allReadBtn, self.OnClickAllReadBtn)
    self:AddListener(self._ReportSwitchBtn, self.OnClickReportSwitchBtn)
    self:AddListener(self._AllReportBtn, self.OnClickAllReportBtn)
    self:AddListener(self._AttackReportBtn, self.OnClickAttackReportBtn)
    self:AddListener(self._DefenceReportBtn, self.OnClickDefenceReportBtn)
    self:AddListener(self._AttackCityReportBtn, self.OnClickAttackCityReportBtn)
    --self:AddScrollbarOnValueChange(self._SV, self.OnRectUp);

    self:AddOnValueChanged(self._scrollRect, self.OnScrollRectChange);
    self:AddOnUp(self._scrollRect, self.OnScrollRectUp);
end

-- 注册所有的事件
function UIBattleReport:RegisterAllNotice()
    --self:RegisterNotice(L2C_BattleReport.AllBattleReport, self.ShowReportList);
    self:RegisterNotice(L2C_BattleReport.BattleReportUnReadCount, self.SetReadBtnActive);
end

--初始化所有列表
function UIBattleReport:OnInit()
    self.ReportItemPrefab = UIConfigTable[UIType.UIBattleReportItem].ResourcePath;
    BattleReportService:Instance():SetGroup(self.ReportGroup);
    for index = 1, MaxItemNum do
        local mReportItem = ReportItem.new();
        GameResFactory.Instance():GetUIPrefab(self.ReportItemPrefab, self._Parent, mReportItem, function(go) 
            mReportItem:Init();

            mReportItem:Setgo(go);
            mReportItem:SetCallBack(self, self.ShowOrHide);

            mReportItem:SetDragUpCallBack(self, self.OnDragScrollRect);
            self._AllItemList:Push(mReportItem);
            mReportItem:SetUIBattleReport(self);
            self:SetItemPos(mReportItem.gameObject, index)
            if mReportItem.gameObject then
                self.allItemObjs[#self.allItemObjs+1] = mReportItem.gameObject;
            end
            mReportItem.gameObject:SetActive(false);
        end );
    end
end

function UIBattleReport:OnShow()
    self.ReportType = BattleReportType.All;
    self:SetReportTypeText();
    self:OnClickAllReportBtn(true);
    self:SetGuideState();
end

-- 刷新战报列表
function UIBattleReport:ShowReportList(openInfo,row)
    self._ReportInfoList = BattleReportService:Instance():GetAllReportListByType(self.ReportType,openInfo);
    
    if self._ReportInfoList == nil then
        self.NoReportText.gameObject:SetActive(true);
        return;
    else
        self.NoReportText.gameObject:SetActive(false);
    end
    --print("#############: "..self._ReportInfoList:Count())
    if openInfo == nil then
        self.ShowCount = self._ReportInfoList:Count();
    else
        if openInfo._isOpen == true  then
            --print("打开")
            if  self.pageCount == self.allPageCount then
                self.ShowCount = self._ReportInfoList:Count() - openInfo._continueReportCount;
            end
        else
            --print("关闭")
            self.ShowCount = self._ReportInfoList:Count();
        end
    end
    if curRow < 0 then
        curRow = 0;
    end
    --print("刷新列表 curRow:  "..curRow.."  self.ShowCount:"..self.ShowCount);
    self:SetLayoutPosition(openInfo,row);
    self:RefreshShow(true);
    self:JudgeIfAllRead();
    self.isFirstOpen = false;
end

function UIBattleReport:SetGuideState()
    if GuideServcice:Instance():GetIsFinishGuide() == false then
        GuideServcice:Instance():GoToNextStep();
        self._scrollRect.vertical = false;
    else
        self._scrollRect.vertical = true;
    end
end

function UIBattleReport:SetReportTypeText()
    local bassClass = UIService:Instance():GetUIClass(UIType.LeagueExistUI);
    local isopen = UIService:Instance():GetOpenedUI(UIType.LeagueExistUI);
    if bassClass ~= nil and isopen then
        self.ReportGroup = ReportGroup.Alliance;
        self._ReportSwitchBtnLabel.text = "个人战报";
        self._AttackCityReportBtn.gameObject:SetActive(true);
    else
        self.ReportGroup = ReportGroup.Persion;
        self._ReportSwitchBtnLabel.text = "同盟战报";
        self._AttackCityReportBtn.gameObject:SetActive(false);
    end
    self.NoReportText.gameObject:SetActive(false);
    local MyLeagueInfo = PlayerService:Instance():GetLeagueId()
    if MyLeagueInfo == 0 then
        self._ReportSwitchBtn.gameObject:SetActive(false);
    else
        self._ReportSwitchBtn.gameObject:SetActive(true);
    end
end

function UIBattleReport:OnScrollRectUp()
   self:OnRectUp();
end

function UIBattleReport:OnScrollRectChange()
    --print("滑动块值有变化")
    self:OnDragScrollRect();
end

function UIBattleReport:OnDragScrollRect()
    if self.couldRestRectPosition == true then
        self:SetCurRow();
    end
    if curRow ~= preRow then
        preRow = curRow;
        self:RefreshShow();
        self:OnRectUp();
    end
end

function UIBattleReport:SetCurRow()
    local scorllPos = math.floor(self._Parent.localPosition.y + self.layoutHeight / 2);
    curRow = math.floor(scorllPos/-AddY);
    --print("curRow: "..curRow)
end

function UIBattleReport:RefreshShow(isRefreshData)
    --print("Do   RefreshShow");
--    if isRefreshData == nil then
--        return;
--    end
    for index = 1, MaxItemNum do
        --print("index:"..index.."   curRow:"..curRow.."  self.pagecount:"..self.pageCount);
        local uiBase = self._AllItemList:Get(index);
        local dataIndex = 0;
        if curRow <= MaxItemNum-4 then
            dataIndex = 0;
        else
            local count = self.ShowCount%MaxItemNum;
            dataIndex = (self.pageCount-1)*MaxItemNum+ count;
        end
        if self._ReportInfoList ~= nil then
            if self._ReportInfoList:Get(index+dataIndex) ~= nil then
                local reportItemInfo = self._ReportInfoList:Get(index + dataIndex);
                if uiBase ~= nil then
                    uiBase.gameObject:SetActive(true);
                    self:SetItemPos(uiBase.gameObject,index + dataIndex);
                    if isRefreshData ~= nil and isRefreshData == true then
                        
                        uiBase:RefreshItem(reportItemInfo);
                    end
                end
            end
        end
        self.couldRestRectPosition = true;
        self.couldRefreshChangeData = true;
    end
end

-- 判断是否达到一页的最底部位置来决定是否发送消息和服务器要下一页战报
function UIBattleReport:OnRectUp()
    local limitCount = 4;
    if (curRow + limitCount) >= self.allPageCount * MaxItemNum then
        if (curRow + limitCount) <= self.ShowCount and (curRow + limitCount) % self.OnePageCountMax == 0 then
            --print("@@@@@@@@@@@@@@@@@@@@@@@@@@@请求下一页战报!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!  curRow:"..curRow);
            self:SendToGetReport(true);
            self.couldRestRectPosition = false;
        end
    end
end

--设置Item的位置
function UIBattleReport:SetItemPos(obj, i)
    --local y = self.layoutHeight/2 + itemHeight/2 + i * AddY;
    local y = self.firstPosy + i * AddY;
    obj.transform.localPosition = Vector3.New(0, y, 0)
end

function UIBattleReport:SetLayoutPosition(openInfo,row)
    self:SetMaxPage(openInfo);
    if self.ShowCount < self.OnePageCountMax then
        if self.ShowCount <= 3 then
            self.layoutHeight = 3 * itemHeight;
        else
            self.layoutHeight = self.ShowCount  * itemHeight + ((-AddY)- itemHeight)*self.ShowCount;
        end
    else
        self.layoutHeight = self.ShowCount * itemHeight + ((-AddY)- itemHeight)*self.ShowCount;   
    end    
    --print("#####################self.ShowCount:"..self.ShowCount.."    self.layoutHeight:"..self.layoutHeight.."  curRow: "..curRow.."   msg.pageCount:"..self.pageCount)
    self._VerticalLayout.sizeDelta = Vector2.New(rectWidth, self.layoutHeight);
    if self.ShowCount <= self.OnePageCountMax then
        self._Parent.localPosition = Vector3.New(0, - self.layoutHeight/2, 0);
    else
        if row ~= nil then
            self._Parent.localPosition = Vector3.New(0, - self.layoutHeight/2 + row * itemHeight, 0);
        else
            self._Parent.localPosition = Vector3.New(0, - self.layoutHeight/2 + (self.pageCount * MaxItemNum + self.ShowCount % MaxItemNum) * itemHeight, 0);
        end 
    end
    self.firstPosy = self.layoutHeight / 2 + itemHeight / 2;
end

function UIBattleReport:SetMaxPage(openInfo)
    if self.ShowCount <= self.OnePageCountMax then
        self.allPageCount = 1;
    else
        if openInfo == nil then
            self.allPageCount = math.ceil(self.ShowCount / self.OnePageCountMax);
        end
    end
    --print("   当前战报数:"..self.ShowCount.."         当前最大页数:"..self.allPageCount)
end

function UIBattleReport:SerCurPage()
    local curPage = 1;    
    if curRow > self.OnePageCountMax then
        curPage = math.ceil(curRow / self.OnePageCountMax);
    end
    if curPage > self.allPageCount then
        curPage = self.allPageCount;
    end
    self.pageCount = curPage;
    --print("curPage: "..curPage.." curRow:"..curRow)
end

function UIBattleReport:SetReadBtnActive()
    local unread = BattleReportService:Instance():GetUnReadCount();
    if (unread <= 0) then
        self._allReadBtn.gameObject:SetActive(false);
    end
end

-- 点击关闭按钮逻辑
function UIBattleReport:OnClickbackBtn()
    UIService:Instance():ShowUI(UIType.UIGameMainView)
    UIService:Instance():HideUI(UIType.UIBattleReport)
    BattleReportService:Instance():ClearAllReport();
    self:SetAllFalse();
end

-- 把所有的隐藏
function UIBattleReport:SetAllFalse()
    for index = 1, self._AllItemList:Count() do
        local mReportItem = self._AllItemList:Get(index);
        mReportItem.gameObject:SetActive(false);
    end
    self.ShowCount = 0;
    self.pageCount = 1;
    curRow = 0;
    self._ReportInfoList = nil;
end

-- 全部设为已读
function UIBattleReport:OnClickAllReadBtn()
    self._allReadBtn.gameObject:SetActive(false);
    local msg = SetBattleReportRead.new();
    msg:SetMessageId(C2L_BattleReport.SetBattleReportRead);
    msg.battleReportGroup = self.ReportGroup;
    NetService:Instance():SendMessage(msg);
    BattleReportService:Instance():SetAllBattleReportRead();
    self:SetAllRead();
end

-- 把所有的战报设为已读
function UIBattleReport:SetAllRead()
    for index = 1, self._AllItemList:Count() do
        local mReportItem = self._AllItemList:Get(index);
        if (mReportItem) then
            mReportItem:SetUnReadNum(0);
            mReportItem:SetIfRead(true);
        end
    end
end

-- 切换联盟个人
function UIBattleReport:OnClickReportSwitchBtn()
    self._ReportInfoList:Clear();
    --self.NoReportText.gameObject:SetActive(true);
    if (self.ReportGroup == ReportGroup.Alliance) then
        self.ReportGroup = ReportGroup.Persion;
        self._ReportSwitchBtnLabel.text = "同盟战报";
        self._AttackCityReportBtn.gameObject:SetActive(false);
        self._allReadBtn.gameObject:SetActive(false);
    else
        self.ReportGroup = ReportGroup.Alliance;
        self._ReportSwitchBtnLabel.text = "个人战报";
        self._AttackCityReportBtn.gameObject:SetActive(true);
        self._allReadBtn.gameObject:SetActive(false);
    end
    self:SetAllFalse();
    BattleReportService:Instance():SetGroup(self.ReportGroup);
    self.ReportType = BattleReportType.All;
    BattleReportService:Instance():ClearAllReport();
    self:InitBtnsSprite();
    self:SendToGetReport();
end

function UIBattleReport:InitBtnsSprite()
    self._AllReportBtn.gameObject:GetComponent(typeof(UnityEngine.UI.Image)).sprite = GameResFactory.Instance():GetResSprite("ChatButton");
    self._AttackReportBtn.gameObject:GetComponent(typeof(UnityEngine.UI.Image)).sprite = GameResFactory.Instance():GetResSprite("ChatButton1");
    self._AttackCityReportBtn.gameObject:GetComponent(typeof(UnityEngine.UI.Image)).sprite = GameResFactory.Instance():GetResSprite("ChatButton1");
    self._DefenceReportBtn.gameObject:GetComponent(typeof(UnityEngine.UI.Image)).sprite = GameResFactory.Instance():GetResSprite("ChatButton1");
end

-- 发送消息要新的战报
function UIBattleReport:SendToGetReport(isNext)
    self:SerCurPage();
    local msg = GetBattleReport.new();
    msg:SetMessageId(C2L_BattleReport.GetBattleReport);
    msg.battleReportGroup = self.ReportGroup;
    msg.battleReportType = self.ReportType;
    if isNext~= nil and isNext == true then
        msg.pageCount =  self.pageCount + 1;
    else
        msg.pageCount =  self.pageCount;
    end
    NetService:Instance():SendMessage(msg,false);
end

function UIBattleReport:SetClickBtnState(obj,isSelect)
    obj.transform:Find("Image"):GetComponent(typeof(UnityEngine.Transform)).gameObject:SetActive(isSelect);
end

-- 点击所有战报按钮
function UIBattleReport:OnClickAllReportBtn(isFirst)
    if  isFirst == nil then  
        if self.ReportType == BattleReportType.All then
            return;
        end
    end
    self:ClearData();
    self.ReportType = BattleReportType.All;
    self:SetClickBtnState(self._AllReportBtn.gameObject,true);
    self:SetClickBtnState(self._AttackReportBtn.gameObject,false);
    self:SetClickBtnState(self._AttackCityReportBtn.gameObject,false);
    self:SetClickBtnState(self._DefenceReportBtn.gameObject,false);
    self:ClickBtnOver();
end

-- 点击攻击战报按钮
function UIBattleReport:OnClickAttackReportBtn()
    if self.ReportType == BattleReportType.Attack then
        return;
    end
    self:ClearData();
    self.ReportType = BattleReportType.Attack;
    self:SetClickBtnState(self._AllReportBtn.gameObject,false);
    self:SetClickBtnState(self._AttackReportBtn.gameObject,true);
    self:SetClickBtnState(self._AttackCityReportBtn.gameObject,false);
    self:SetClickBtnState(self._DefenceReportBtn.gameObject,false);
    self:ClickBtnOver();
end

-- 点击防御战报按钮
function UIBattleReport:OnClickDefenceReportBtn()
    if self.ReportType == BattleReportType.Defence then
        return;
    end
    self:ClearData();
    self.ReportType = BattleReportType.Defence;
    self:SetClickBtnState(self._AllReportBtn.gameObject,false);
    self:SetClickBtnState(self._AttackReportBtn.gameObject,false);
    self:SetClickBtnState(self._AttackCityReportBtn.gameObject,false);
    self:SetClickBtnState(self._DefenceReportBtn.gameObject,true);
    self:ClickBtnOver();
end

-- 点击攻城战报按钮
function UIBattleReport:OnClickAttackCityReportBtn()
    if self.ReportType == BattleReportType.AttackCity then
        return;
    end
    self:ClearData();
    self.ReportType = BattleReportType.AttackCity;
    self:SetClickBtnState(self._AllReportBtn.gameObject,false);
    self:SetClickBtnState(self._AttackReportBtn.gameObject,false);
    self:SetClickBtnState(self._AttackCityReportBtn.gameObject,true);
    self:SetClickBtnState(self._DefenceReportBtn.gameObject,false);
    self:ClickBtnOver();
end

function UIBattleReport:ClearData()
    if self._ReportInfoList ~= nil then
        self._ReportInfoList = nil;
    end
end

function UIBattleReport:ClickBtnOver()
    self:SetAllFalse();
    BattleReportService:Instance():ClearAllReport();
    self:SendToGetReport();
end

--设置当前点击的UIBattleReportItem
function UIBattleReport:SetClickItemDic(uiBase)
    self.CurClickItemBase = uiBase;
end

--打开当前点击的战报详情
function UIBattleReport:ReponseOpenReportDetail()
    if self.CurClickItemBase ~= nil then
        self.CurClickItemBase:JudgeOpenBattleReportDetail();
        --self:ShowReportList();
    end
end

-- 所有的都已读了
function UIBattleReport:JudgeIfAllRead()
    self._allReadBtn.gameObject:SetActive(false);
    local count = self._ReportInfoList:Count();
    for index = 1, count do
        local oneinfo = self._ReportInfoList:Get(index);
        if oneinfo ~= nil and oneinfo._isRead == false then
            self._allReadBtn.gameObject:SetActive(true);
            return;
        end
    end
end

-- 设置某个id的是否已经展开
--  openInfo : BattleReportInfo
function UIBattleReport:ShowOrHide(openInfo)
    --print("点击开关时 curRow: "..curRow.."  self.allPageCount: "..self.allPageCount);
    self:ShowReportList(openInfo,curRow);
    --self:RefreshShow();
end

return UIBattleReport
