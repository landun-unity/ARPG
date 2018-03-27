--region *.lua
--Date
local UIBase = require("Game/UI/UIBase");
local RankListHelpUI = class("RankListHelpUI",UIBase);
local List = require("common/List");
local DataPersonalPower = require("Game/Table/model/DataPersonalPower");
local DataAlliesPower = require("Game/Table/model/DataAlliesPower");

function RankListHelpUI:ctor()
    
    RankListHelpUI.super.ctor(self)

    self.bgBtn = nil;
    self.confirmBtn = nil;
    self.titleText = nil;
    self.contentParent = nil;
    self.contentParentTrans = nil;

    self.dataPersonalPower = {};
    self.dataAlliesPower = {};

    self.parentItems = {};
    self.height = 180;

end

function RankListHelpUI:DoDataExchange()
    self.bgBtn = self:RegisterController(UnityEngine.UI.Button,"CloseBg");
    self.confirmBtn = self:RegisterController(UnityEngine.UI.Button,"ConfirmBtn");
    self.titleText = self:RegisterController(UnityEngine.UI.Text,"TitleText");
    self.contentParent = self:RegisterController(UnityEngine.RectTransform,"Scroll View/Viewport/Content");
    self.contentParentTrans = self:RegisterController(UnityEngine.Transform,"Scroll View/Viewport/Content");
    for i =1 ,self.contentParent.childCount do
        if self.parentItems[i] == nil then
            self.parentItems[i] = self.contentParent:GetChild(i-1);
        end
    end
end

function RankListHelpUI:DoEventAdd()
    self:AddListener(self.bgBtn, self.OnCilckClose);
    self:AddListener(self.confirmBtn, self.OnCilckClose);
end

function RankListHelpUI:OnInit()
    self:LoadDataTable();
end

function RankListHelpUI:LoadDataTable()
    for k,v in pairs(DataPersonalPower) do
        if self.dataPersonalPower[v.Type] ~= nil then
            self.dataPersonalPower[v.Type]:Push(v);
        else
            self.dataPersonalPower[v.Type] = List.new();
            self.dataPersonalPower[v.Type]:Push(v);
        end
    end
    for k,v in pairs(DataAlliesPower) do
        if self.dataAlliesPower[v.Type] ~= nil then
            self.dataAlliesPower[v.Type]:Push(v);
        else
            self.dataAlliesPower[v.Type] = List.new();
            self.dataAlliesPower[v.Type]:Push(v);
        end
    end
end

function RankListHelpUI:OnShow(rankListType)
    local intiPos = self.contentParentTrans.localPosition;
    if  rankListType == RankListType.PersonalRankList then
        self.titleText.text = "如下项目可增加个人势力值";
        self.contentParent.sizeDelta = Vector2.New(30, self.height * #self.dataPersonalPower);
        self.contentParentTrans.localPosition = Vector3.New(intiPos.x,0,0);
        for j=1,#self.parentItems do
            if j<= #self.dataPersonalPower then
                self.parentItems[j].gameObject:SetActive(true);
                self:SetItemInfo(self.parentItems[j],self.dataPersonalPower[j]);
            else
                self.parentItems[j].gameObject:SetActive(false);
            end
        end
    else
        self.titleText.text = "同盟势力值与同盟等级、经验、占领的城池和郡城数相关";
        self.contentParent.sizeDelta = Vector2.New(30, self.height * #self.dataAlliesPower);
        self.contentParentTrans.localPosition = Vector3.New(intiPos.x,0,0);
        for j=1,#self.parentItems do
            if j<= #self.dataAlliesPower then
                self.parentItems[j].gameObject:SetActive(true);
                self:SetItemInfo(self.parentItems[j],self.dataAlliesPower[j]);
            else
                self.parentItems[j].gameObject:SetActive(false);
            end
        end
    end
end

function RankListHelpUI:SetItemInfo(transform,data)
    local dataCount = data:Count();
    local nameText = transform:Find("Image/NameText"):GetComponent(typeof(UnityEngine.UI.Text));
    local grid = transform:Find("Grid"):GetComponent(typeof(UnityEngine.Transform));
    nameText.text = data:Get(1).Name;

    for i =1 ,grid.childCount do
        local gridTran = grid:GetChild(i-1);
        if i<= dataCount then
            gridTran.gameObject:SetActive(true);
            local desText = gridTran:Find("NameText"):GetComponent(typeof(UnityEngine.UI.Text));
            local valueText = gridTran:Find("ValueText"):GetComponent(typeof(UnityEngine.UI.Text));
            desText.text = data:Get(i).Describe;
            valueText.text = "<color=#6eaf47>+"..data:Get(i).Power.."</color>";
        else
            gridTran.gameObject:SetActive(false);
        end
    end
end

function RankListHelpUI:OnCilckClose()
    UIService:Instance():HideUI(UIType.RankListHelpUI);
end

return RankListHelpUI
