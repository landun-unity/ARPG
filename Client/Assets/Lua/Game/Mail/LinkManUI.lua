--region *.lua
--Date
local UIBase = require("Game/UI/UIBase");
local LinkManUI = class("LinkManUI",UIBase)
local MailWriteUI =  require("Game/Mail/MailWriteUI");
local List = require("common/List");

function LinkManUI:ctor()
    
    LinkManUI.super.ctor(self)
    LinkManUI.instance = self;

    self.backBgBtn = nil;
    self.exitBtn = nil; 
    self.leagueBtn = nil;
    self.linkPeopleBtn = nil;

    self.notOpenImage = nil;        -- 同盟未开启遮挡图片
    self.leagueBtnSelect = nil;
    self.linkPeopleBtnSelect = nil;
    self.scrollGrid = nil;

    self.itemObjDic = {};           --key: index  value:预制GameObject
    self.itemBaseDic = {};          --key:预制GameObject  value:LinkManItem 脚本
    self.itemDataDic = {};          --key:预制GameObject  value:MemberModel 数据

    self.curClickItemObj = nil;
    self.lastClickItemObj = nil;

    self.selectIndex = 0;           --0 同盟  1 联系人
    self.leagueId = 0;              --同盟id
    self.leagueTitleId = 0;         --同盟官位id
    self.myPlayerId = nil;
end


-- 单例
function LinkManUI:Instance()
    return LinkManUI.instance;
end

function LinkManUI:DoDataExchange()
    self.backBgBtn = self:RegisterController(UnityEngine.UI.Button, "BackgroundButton");
    self.exitBtn = self:RegisterController(UnityEngine.UI.Button, "BackgroundImage/ExitButton");
    self.leagueBtn = self:RegisterController(UnityEngine.UI.Button, "BackgroundImage/TranslucenceImage/LeagueBtn");
    self.linkPeopleBtn = self:RegisterController(UnityEngine.UI.Button, "BackgroundImage/TranslucenceImage/LinkPeopleBtn");
    self.notOpenImage = self:RegisterController(UnityEngine.RectTransform, "BackgroundImage/TranslucenceImage/LeagueBtn/NotOpenImage");
    self.leagueBtnSelect = self:RegisterController(UnityEngine.RectTransform, "BackgroundImage/TranslucenceImage/LeagueBtn/SelectImage");
    self.linkPeopleBtnSelect = self:RegisterController(UnityEngine.RectTransform, "BackgroundImage/TranslucenceImage/LinkPeopleBtn/SelectImage");
    self.scrollGrid = self:RegisterController(UnityEngine.RectTransform, "BackgroundImage/Scroll View/Viewport/Content");

end

function LinkManUI:DoEventAdd()
    self:AddListener(self.backBgBtn, self.OnCilckExitBtn);
    self:AddListener(self.exitBtn, self.OnCilckExitBtn);
    self:AddListener(self.leagueBtn, self.OnCilckLeagueBtn);
    self:AddListener(self.linkPeopleBtn, self.OnCilckLinkPeopleBtn); 
end

function LinkManUI:OnShow()
    
    --发送消息获取同盟成员列表
    local myPlayerId = PlayerService:Instance():GetPlayerId();
    self.myPlayerId = myPlayerId; 
    LeagueService:Instance():SendLeagueMessage(myPlayerId);
    LeagueService:Instance():SendLeagueMemberMessage(myPlayerId);


    --默认显示联系人
    self.selectIndex = 1;
    self:SetFunctionBtnState();
    self:ShowPeople();
end

--显示联系人列表
function LinkManUI:ShowPeople()
    self.leagueId = PlayerService:Instance():GetLeagueId();
    self.leagueTitleId = PlayerService:Instance():GetPlayerTitle(); 
    --print("your leagueId: "..self.leagueId.."  your leagueTitleId:"..self.leagueTitleId);
    if self.leagueId == 0 then
        self.leagueBtn.interactable = false;
        self.notOpenImage.gameObject:SetActive(true);
    else
        self.leagueBtn.interactable = true;
        self.notOpenImage.gameObject:SetActive(false);
    end
    if self.selectIndex ==0 then 
        self.leagueBtnSelect.gameObject:SetActive(true);
        self.linkPeopleBtnSelect.gameObject:SetActive(false);
        self:ShowLeagueMemberList();
    elseif self.selectIndex ==1 then 
        self.leagueBtnSelect.gameObject:SetActive(false);
        self.linkPeopleBtnSelect.gameObject:SetActive(true);

        --print("暂时没有联系人！！！！！！！！！！！！！！！！")
        for k,v in pairs(self.itemObjDic) do 
            v:SetActive(false);
        end
    end
end

function LinkManUI:ShowLeagueMemberList()
     --获取同盟联系人
    local leagueMemberList = LeagueService:Instance():GetLeagueMemberList();

    --print("同盟中数量:"..leagueMemberList:Count())
    if self.leagueId ~= 0 then
        if self.itemObjDic[1]  == nil then
            self:LoadOneItem(1);
        end
        if self.leagueTitleId < 5 then 
            self.itemObjDic[1]:SetActive(true);
        else
            self.itemObjDic[1]:SetActive(false);                             
        end
        for i = 1 ,leagueMemberList:Count() do 
            if self.itemObjDic[i+1]  == nil then
                if self.myPlayerId ~=  leagueMemberList:Get(i).playerid then
                    self:LoadOneItem(i+1,leagueMemberList:Get(i));
                end                   
            else
                if self.myPlayerId ~=  leagueMemberList:Get(i).playerid then
                    self.itemObjDic[i+1]:SetActive(true);
                    self.itemDataDic[self.itemObjDic[i+1]] = leagueMemberList:Get(i);
                    self.itemBaseDic[self.itemObjDic[i+1]]:SetName(leagueMemberList:Get(i).name);
                end
            end
        end
        --若预制物体多出则隐藏
        local objPrefabCount = self:GetItemPrefabCounts();
        local dataCount = leagueMemberList:Count();
        --print("objPrefabCount"..objPrefabCount.."  dataCount"..dataCount);
        if objPrefabCount > dataCount then 
            for index = 1, objPrefabCount-dataCount do
                if self.mailItemObjDic~= nil then 
                    if self.mailItemObjDic[dataCount+index] ~= nil then 
                        self.mailItemObjDic[dataCount+index].gameObject:SetActive(false);
                    end
                end
            end
        end
    end
end

function LinkManUI:GetItemPrefabCounts()
    local count =0;
    for k,v in pairs(self.itemObjDic) do 
       count = count+1;
    end
    return count;
end

function  LinkManUI:LoadOneItem(index,memberModel)
    local dataUIConfig = DataUIConfig[UIType.LinkManItem];
    local uiBase = require(dataUIConfig.ClassName).new();
    GameResFactory.Instance():GetUIPrefab(dataUIConfig.ResourcePath, self.scrollGrid, uiBase, function(go)
        if uiBase.gameObject then
            uiBase:Init();
            uiBase.gameObject:SetActive(true);
            if index == 1 then 
                uiBase.gameObject.name = uiBase.gameObject.name.."_AllPeopleItem"
            end   
            self.itemObjDic[index] = uiBase.gameObject;
            self.itemBaseDic[uiBase.gameObject] = uiBase;
            self.itemDataDic[uiBase.gameObject] = memberModel;
            if memberModel == nil then
                uiBase:SetName("同盟全部成员"); 
            else
                uiBase:SetName(memberModel.name);   
            end        

            self:AddOnClick(uiBase.gameObject,self.CliclPeopleItem);
        end              
    end );    
end

--点击item
function LinkManUI:CliclPeopleItem(itemObj)
    self.lastClickItemObj = self.curClickItemObj;                   
    self.curClickItemObj = itemObj;
    self:ShowSelectState();
    if self.itemDataDic[itemObj] == nil then       
        --发送给同盟所有玩家，属于群发邮件             
        local leagueMemberList = LeagueService:Instance():GetLeagueMemberList();
        local peopleCount = leagueMemberList:Count();
        if peopleCount<=1 then 
            print("当前同盟中人数少于或等于1人，无法群发邮件");
            return;
        end
        local idLists = List.new();
        for i=1, leagueMemberList:Count() do
            idLists:Push(leagueMemberList:Get(i).playerid);
        end     
        MailWriteUI:Instance():SetGroupReceiveInfo(idLists);
    else        
        --确定发送给某个玩家
        MailWriteUI:Instance():SetPersonalReceiveInfo(self.itemDataDic[itemObj].name);
    end
    UIService:Instance():HideUI(UIType.LinkManUI); 
end

--item点击时 高亮切换
function  LinkManUI:ShowSelectState()    
    if self.lastClickItemObj ~= nil then 
        self.itemBaseDic[self.lastClickItemObj]:SetSelectState(false);
    end
    if self.curClickItemObj ~= nil then 
        self.itemBaseDic[self.curClickItemObj]:SetSelectState(true);
    end
end

--同盟、联系人按钮切换
function  LinkManUI:SetFunctionBtnState()    
    if self.selectIndex == 1 then 
        self.leagueBtnSelect.gameObject:SetActive(false);
        self.linkPeopleBtnSelect.gameObject:SetActive(true);
    elseif  self.selectIndex == 0 then 
        self.leagueBtnSelect.gameObject:SetActive(true);
        self.linkPeopleBtnSelect.gameObject:SetActive(false);
    end
end

function  LinkManUI:OnCilckExitBtn(args)    
    UIService:Instance():HideUI(UIType.LinkManUI);
end

function  LinkManUI:OnCilckLeagueBtn(args)
    if self.selectIndex == 0 then 
        return;
    end
    self.selectIndex = 0;
    self:SetFunctionBtnState();
    self:ShowPeople(self.selectIndex);
end

function  LinkManUI:OnCilckLinkPeopleBtn(args)
    --print("暂时没有联系人")
    if self.selectIndex == 1 then 
        return;
    end
    self.selectIndex = 1;
     self:SetFunctionBtnState();
    self:ShowPeople(self.selectIndex);
end

return LinkManUI
