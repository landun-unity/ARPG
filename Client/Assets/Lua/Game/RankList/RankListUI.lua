--region *.lua
--Date
local UIBase = require("Game/UI/UIBase");
local RankListUI = class("RankListUI",UIBase)
local RankListType =  require("Game/RankList/RankListType");
local List = require("common/List");

local AddY = -84
local preRow = 0;
local curRow = 0;
local rectWidth = 1230
local itemHeight = 84;

function RankListUI:ctor()   
    RankListUI.super.ctor(self)

    self.exitBtn = nil;
    self.personalBtn = nil;
    self.personalBtnBg = nil;
    self.leagueBtn = nil;
    self.leagueBtnBg = nil;
    self.myselfInfoBtn = nil;
    self.myselfInfoText = nil;
    self.helpBtn = nil;

    self.itemParent = nil;
    self._scrollRect = nil;
    self._VerticalLayout = nil;

    self.oneUIPageShowCount = 6;
    self.itemMaxCount = 8;
    self.allItemList = List.new();
    self.bottomItem = nil;
    self.bottomItemIsShow = false;
    self.endItemInfo = nil;
    self.rankDataList = nil;

     self.firstPosy = 0;
    self.allPageCount = 1;
    self.ShowCount = 0;
    self.layoutHeight = self.itemMaxCount * itemHeight;

    self.curRankListType = RankListType.PersonalRankList;

end

function RankListUI:DoDataExchange()
    self.exitBtn = self:RegisterController(UnityEngine.UI.Button,"ExitBtn");
    self.personalBtn = self:RegisterController(UnityEngine.UI.Button,"AllBtns/PersonalBtn");
    self.personalBtnBg = self:RegisterController(UnityEngine.UI.Image,"AllBtns/PersonalBtn/Image");
    self.leagueBtn = self:RegisterController(UnityEngine.UI.Button,"AllBtns/LeagueBtn");
    self.leagueBtnBg = self:RegisterController(UnityEngine.UI.Image,"AllBtns/LeagueBtn/Image");
    self.myselfInfoBtn = self:RegisterController(UnityEngine.UI.Button,"AllBtns/MyselfInfoBtn");  
    self.myselfInfoText = self:RegisterController(UnityEngine.UI.Text,"AllBtns/MyselfInfoBtn/Text");
    self.helpBtn = self:RegisterController(UnityEngine.UI.Button,"ItemTitles/HelpBtn"); 
    self.itemParent = self:RegisterController(UnityEngine.Transform,"ScrolObj/ScrollView/Viewport/Layout");
    self._scrollRect = self:RegisterController(UnityEngine.UI.ScrollRect, "ScrolObj/ScrollView");
    self._VerticalLayout = self:RegisterController(UnityEngine.RectTransform, "ScrolObj/ScrollView/Viewport/Layout");
end

function RankListUI:DoEventAdd()
    self:AddListener(self.exitBtn, self.OnCilckExitBtn);
    self:AddListener(self.personalBtn, self.OnCilckPersonalBtn);
    self:AddListener(self.leagueBtn, self.OnCilckLeagueBtn);
    self:AddListener(self.myselfInfoBtn, self.OnCilckMyselfInfoBtn);
    self:AddListener(self.helpBtn, self.OnCilckHelpBtn);

    self:AddOnValueChanged(self._scrollRect, self.OnScrollRectChange);
end

function RankListUI:OnInit()
    local rankListBaseItem = require("Game/RankList/RankListItemUI");
    local itemPrefabPath = DataUIConfig[UIType.RankListItem].ResourcePath;
    for index = 1, self.itemMaxCount + 1 do
        local rankListItem = rankListBaseItem.new();
        GameResFactory.Instance():GetUIPrefab(itemPrefabPath, self.itemParent, rankListItem, function(go) 
            rankListItem:Init();
            self:SetItemPos(rankListItem.gameObject, index);
            if index < self.itemMaxCount + 1 then
                self.allItemList:Push(rankListItem);
            else
                self.bottomItem = rankListItem;
            end
            rankListItem.gameObject:SetActive(false);
        end );
    end
end

function RankListUI:OnHide()
	
end

function RankListUI:SetAllItemFalse()
    for i = 1, self.allItemList:Count() do
        self.allItemList:Get(i).gameObject:SetActive(false)
    end
    if self.bottomItem ~= nil then
        self.bottomItem.gameObject:SetActive(false);
    end
end

function RankListUI:OnShow()
    self.curRankListType = RankListType.PersonalRankList;
    self:SetBtnState(self.curRankListType);
    self:SendMessage(self.curRankListType);
end

--显示排行榜信息
function RankListUI:ShowRankListInfo()
    self.rankDataList = RankListService:Instance():GetRankListInfo(self.curRankListType);
    if self.rankDataList == nil or self.rankDataList:Count() == 0 then
        
        return;
    end
    self.ShowCount = self.rankDataList:Count();
    curRow = 0;
    self:ShowMyInformation();
    self:SetLayoutPosition();
    self:RefreshShow();
    
end

function RankListUI:SetLayoutPosition(row)
    self:SetMaxPage();
    local addBottomCount = self.bottomItemIsShow == true and 1 or 0;
    if self.ShowCount < self.itemMaxCount then
        if self.ShowCount <= self.oneUIPageShowCount then
            self.layoutHeight = (self.oneUIPageShowCount + addBottomCount) * itemHeight;
        else
            self.layoutHeight = (self.ShowCount + addBottomCount)  * itemHeight;
        end
    else
        self.layoutHeight = (self.ShowCount + 1 + addBottomCount) * itemHeight;        
    end 
   
    --print("#####################self.ShowCount:"..self.ShowCount.."    self.layoutHeight:"..self.layoutHeight.."  curRow: "..curRow.."   msg.pageCount:"..self.pageCount)
    self._VerticalLayout.sizeDelta = Vector2.New(rectWidth, self.layoutHeight);
    if row ~= nil then
        self.itemParent.localPosition = Vector3.New(0, - self.layoutHeight/2 + (row + addBottomCount) * itemHeight, 0);
    else
        self.itemParent.localPosition = Vector3.New(0, - self.layoutHeight/2, 0);
    end
    
    self.firstPosy = self.layoutHeight / 2 + itemHeight / 2;
end

function RankListUI:SetMaxPage()
    local allPage =0;
    if self.ShowCount <= self.itemMaxCount then
        allPage = 1;
    else
        allPage = math.ceil(self.ShowCount / self.itemMaxCount)
    end
    self.allPageCount = allPage;
end

function RankListUI:OnScrollRectChange()
    self:OnDragScrollRect();
end

function RankListUI:OnDragScrollRect()
    self:SetCurRow();
    if curRow ~= preRow then
        preRow = curRow;
        self:RefreshShow();
    end
end

function RankListUI:RefreshShow()
    if self.rankDataList == nil then
        return;
    end
    for index = 1, self.itemMaxCount + 1 do
        --print("index:"..index.."   curRow:"..curRow);
        local uiBase = self.allItemList:Get(index);
        local dataIndex = curRow;
        if index < self.itemMaxCount + 1 then
            if self.rankDataList:Get(index + dataIndex) ~= nil then
                local itemInfo = self.rankDataList:Get(index + dataIndex);
                if uiBase ~= nil then
                    uiBase.gameObject:SetActive(true);
                    self:SetItemPos(uiBase.gameObject,index + dataIndex);
                    uiBase:SetInfo(self.curRankListType, itemInfo);
                end
            end
        else
            if self.bottomItem ~= nil then
                if self.bottomItemIsShow == false then
                    self.bottomItem.gameObject:SetActive(false);
                else
                    if dataIndex >= self.ShowCount - self.oneUIPageShowCount then
                        if self.bottomItemIsShow == true then
                            self.bottomItem.gameObject:SetActive(true);
                            self:SetItemPos(self.bottomItem.gameObject,self.ShowCount +1);
                            self.bottomItem:SetInfo(self.curRankListType,self.endItemInfo);
                        end
                    end
                end
            end
        end
    end
end

function RankListUI:SetCurRow()
    local scorllPos = math.floor(self.itemParent.localPosition.y + self.layoutHeight / 2);
    curRow = math.floor(scorllPos/-AddY);
end

function RankListUI:SetItemPos(obj, i)
    local y = self.firstPosy + i * AddY;
    obj.transform.localPosition = Vector3.New(0, y, 0)
end

function RankListUI:GoToTheRow(row)
    --print("go to row "..row);
    curRow = row - self.oneUIPageShowCount + 1;
    self:SetLayoutPosition(curRow);
    self:RefreshShow();
end

function RankListUI:ShowMyInformation()
    if  self.curRankListType == RankListType.PersonalRankList then
        local myRank,index = RankListService:Instance():GetMyRank(self.curRankListType,PlayerService:Instance():GetPlayerId());
        if myRank == 0 then
            self.myselfInfoText.text = "未上榜";
            self.bottomItemIsShow = true;
            self.endItemInfo = self:GetMyInfo(self.curRankListType);
        else
            self.myselfInfoText.text = "我的排名 "..myRank;
            self.bottomItemIsShow = false;
        end
    else
        local leagueID = PlayerService:Instance():GetLeagueId();
        if leagueID == 0 then
            self.myselfInfoText.text = "加入同盟";
            self.bottomItemIsShow = false;
        else
            local myRank = RankListService:Instance():GetMyRank(self.curRankListType,leagueID);
            if myRank == 0 then
                self.myselfInfoText.text = "同盟未上榜";
                self.bottomItemIsShow = true;
                self.endItemInfo = self:GetMyInfo(self.curRankListType);
            else
                self.myselfInfoText.text = "同盟排名 "..myRank;
                self.bottomItemIsShow = false;
            end
        end
    end
end

function RankListUI:GetMyInfo(rankListType)    
    if  self.curRankListType == RankListType.PersonalRankList then
        local playerinfo = require("MessageCommon/Msg/L2C/RankList/PlayerModel").new();
        playerinfo.playerid = PlayerService:Instance():GetPlayerId();
        playerinfo.rankPostion = "未上榜";
        playerinfo.name = PlayerService:Instance():GetName();
        playerinfo.province = PlayerService:Instance():GetSpawnState();
        playerinfo.subcityNum = PlayerService:Instance():GetAllSubCityCount();
        playerinfo.fortNum = PlayerService:Instance():GetFortCount();
        playerinfo.landNum = PlayerService:Instance():GetTiledInfoListCount();
        playerinfo.influence = PlayerService:Instance():GetPlayerInfluence();
        return playerinfo;
    else
        local leagueinfo = require("MessageCommon/Msg/L2C/RankList/LeagueModel").new();
        leagueinfo.leagueId = PlayerService:Instance():GetLeagueId();
        leagueinfo.rankPostion = "未上榜";
        leagueinfo.name = PlayerService:Instance():GetLeagueName();
        leagueinfo.countryName = "";
        --leagueinfo.leagueLevel = PlayerService:Instance():GetLeagueLevel();
        --leagueinfo.province = PlayerService:Instance():GetSpawnState();
        --leagueinfo.memberNum = PlayerService:Instance():GetAllSubCityCount();
        --leagueinfo.wildCityNum = PlayerService:Instance():GetFortCount();
        --leagueinfo.influence = PlayerService:Instance():GetPlayerInfluence();
        return leagueinfo;
    end
end

function RankListUI:OnCilckMyselfInfoBtn()
     if  self.curRankListType == RankListType.PersonalRankList then
        local myRank,index = RankListService:Instance():GetMyRank(self.curRankListType,PlayerService:Instance():GetPlayerId());
        if myRank ~= 0 then
            if myRank >= self.itemMaxCount then
                self:GoToTheRow(index);
            end
        else
            if self.ShowCount > self.itemMaxCount then
                self:GoToTheRow(self.ShowCount);
            end
        end
     else
        local leagueID = PlayerService:Instance():GetLeagueId();
        if leagueID == 0 then
            UIService:Instance():HideUI(UIType.RankListUI);    
            LeagueService:Instance():SendLeagueMessage(PlayerService:Instance():GetPlayerId());
        else
            local myRank,index = RankListService:Instance():GetMyRank(self.curRankListType,leagueID);
            if myRank ~= 0 and myRank >= self.itemMaxCount then
                self:GoToTheRow(index);
            end
        end
     end
end

function RankListUI:OnCilckHelpBtn()
     UIService:Instance():ShowUI(UIType.RankListHelpUI,self.curRankListType);
end

function RankListUI:SendMessage(rankListType)
    local msg = nil;
    if rankListType == RankListType.PersonalRankList then
        msg = require("MessageCommon/Msg/C2L/RankList/OpenPlayerRanklistRequest").new();    
        msg:SetMessageId(C2L_Ranklist.OpenPlayerRanklistRequest);
    else
        msg = require("MessageCommon/Msg/C2L/RankList/OpenLeagueRanklistRequest").new();    
        msg:SetMessageId(C2L_Ranklist.OpenLeagueRanklistRequest);
    end
    NetService:Instance():SendMessage(msg)
end

function RankListUI:SetBtnState(rankListType)
    if  self.curRankListType == RankListType.PersonalRankList then
        self.personalBtnBg.gameObject:SetActive(true);
        self.leagueBtnBg.gameObject:SetActive(false);
    else
        self.personalBtnBg.gameObject:SetActive(false);
        self.leagueBtnBg.gameObject:SetActive(true);
    end
end

--点击个人排行榜
function RankListUI:OnCilckPersonalBtn()
    if  self.curRankListType == RankListType.PersonalRankList then
        return;
    end
    self:SetAllItemFalse();
    self.curRankListType = RankListType.PersonalRankList;
    self:SetBtnState(self.curRankListType);
    self:SendMessage(self.curRankListType);
end

--点击同盟排行榜
function RankListUI:OnCilckLeagueBtn()
    if  self.curRankListType == RankListType.LeagueRankList then
        return;
    end
    self:SetAllItemFalse();
    self.curRankListType = RankListType.LeagueRankList;
    self:SetBtnState(self.curRankListType);
    self:SendMessage(self.curRankListType);
end

function RankListUI:OnCilckExitBtn()
    UIService:Instance():HideUI(UIType.RankListUI);
    UIService:Instance():ShowUI(UIType.UIGameMainView);
end

return RankListUI