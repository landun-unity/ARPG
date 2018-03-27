--Anchor:HXH
--Date: 16/10/21
--招募管理类

local GamePart = require("FrameWork/Game/GamePart");
local RecruitManage = class("RecruitManage",GamePart);
local List=require("common/List");
require("Game/UI/UIService")
local RecruitPackageInfo = require("Game/Recruit/RecruitPackageInfo");
local RecruitCardInfo = require("Game/Recruit/RecruitCardInfo");
local CurrencyEnum = require("Game/Player/CurrencyEnum");
local DataCardSet = require("Game/Table/model/DataCardSet");
local DataConstruction = require("Game/Table/model/DataConstruction");

function RecruitManage:ctor()
    RecruitManage.super.ctor(self);
    self.AllRecruitList=List.new(); -- 所有招募卡包的list
    self.NewRecruitList=List.new(); -- 所有新卡包的list
    self.CurrentPackageId = 0;      -- 当前卡包ID
    self.CurrentPackageTableId = 0;

    self.tempList = {};
    self.tempBeforeList = {};
    self.tempLockedList = {};
    self.tempUnlockList = {};
    self.tempFreeList = {};


    self.CardList = List.new();     --卡牌列表
    self.AllRecruitDic = {};        -- 卡包Id 卡包  字典
    self._tempTable = {} --排序用的 
    self.IsTransToExp = false;      -- 是否转换战法经验
    self.TransUnderStarNum = 1;     -- 
    self.TransWay = CurrencyEnum.Money;
    self.BatchRecruitInfo = nil;
    self.LastUpdateID = 0;          --最新的更新的卡包id
    self._LayoutWidth = 0;
    self.newRecruitCount = 0;
    self.IsRecruit = false；
    self._TransExpValue = 0;
    self._NeedEffectShowCardList = List.new();
    self._isBatchRecruit = 0;
    self._ShowCardList = {};
end

--收到卡包的消息
function RecruitManage:HandleRecruitKindPackage(modelList)
    self:InitRecruitList(modelList);
end

--更新卡包的消息
function RecruitManage:UpdateRecruitInfo(model)
    local info = RecruitPackageInfo.new()
    info:Init(model);
    self:SetLastUpdateID(model.recruitPackageId)
    if(self.AllRecruitDic[model.recruitPackageId] ~= nil) then
        self.AllRecruitList:Remove(self.AllRecruitDic[model.recruitPackageId])
        for i=1,self.NewRecruitList:Count() do
            local package = self.NewRecruitList:Get(i);
            if package._recruitPackageId == model.recruitPackageId then
                self.NewRecruitList:Remove(package);
            end
        end

            -- if info._isFree == true then
            --     self.NewRecruitList:Push(info);
            -- end
    end
    -- print(info._recruitPackageId )
    -- print(PlayerService:Instance():GetPlayerId())
    -- print(GameResFactory.Instance():GetInt("recruit"..info._recruitPackageId .. PlayerService:Instance():GetPlayerId()));
    if GameResFactory.Instance():GetInt("recruit"..info._recruitPackageId .. PlayerService:Instance():GetPlayerId()) == 0 then
                -- print("Camein");
                self.NewRecruitList:Push(info);
                GameResFactory.Instance():SetInt("recruit"..info._recruitPackageId .. PlayerService:Instance():GetPlayerId(), 1)            
    end
    -- self.NewRecruitList:Remove(info);
    -- self.NewRecruitList:Clear();
    self.AllRecruitList:Push(info)
    self.AllRecruitDic[model.recruitPackageId] = info;   
    
    -- self:AddInfo(model.recruitPackageId,info)
    self:SortPackage();
    local UIBase = UIService:Instance():GetUIClass(UIType.UIGameMainView)
    if UIBase ~= nil then
        UIBase:UpdateNewRecruitCount();
    end
end

function RecruitManage:SetPackageID(id)
    
    self.CurrentPackageId = id;
end

function RecruitManage:SetPackageTableId(tableId)
    -- body
    self.CurrentPackageTableId = tableId;
end

function RecruitManage:GetPackageTableId()
    -- body
    return self.AllRecruitDic[self.CurrentPackageId]._tableId;
end

--获得卡牌消息列表
function RecruitManage:SetRecruitCards(List)
    self.CardList:Clear();
    local count = List:Count();
    for index =1 ,count do
        local model = List:Get(index);
        local info = RecruitCardInfo.new()
        info:Init(model)
        self.CardList:Push(info)
    end
end

function RecruitManage:SetBatchRecruitInfo(info)
    self.BatchRecruitInfo = info;
end

function RecruitManage:GetBatchRecruitInfo()
    return self.BatchRecruitInfo;
end

-- function RecruitManage:InitRecruitList(PackageList)
--     local new = true;
--     if self.AllRecruitList:Count() ~=0 then
--         -- PackageList:Count() - #self.AllRecruitList;
--         for i=1,PackageList:Count() do
--             for j=1,self.AllRecruitList:Count() do
--                 if PackageList:Get(i).recruitPackageId == self.AllRecruitList:Get(j)._recruitPackageId then
--                     new = false;
--                     break;
--                 end
--             end
--             if new == true then
--                 self.NewRecruitList:Push(PackageList:Get(i));
--             end
--         end
--     end

--     self.AllRecruitList:Clear();
--     local Count = PackageList:Count()
--     for index = 1,Count do
--         local model = PackageList:Get(index)
--         local info = RecruitPackageInfo.new()
--         info:Init(model);
--         self.AllRecruitList:Push(info)
--         self.AllRecruitDic[model.recruitPackageId] = info;
--     end
--     self:SortPackage();

-- end

function RecruitManage:InitRecruitList(PackageList)
    -- local new = true;
    -- if self.AllRecruitList:Count() ~=0 then
    --     -- PackageList:Count() - #self.AllRecruitList;
    --     for i=1,PackageList:Count() do
    --         for j=1,self.AllRecruitList:Count() do
    --             if PackageList:Get(i).recruitPackageId == self.AllRecruitList:Get(j)._recruitPackageId then
    --                 new = false;
    --                 break;
    --             end
    --         end
    --         if new == true then
    --             self.NewRecruitList:Push(PackageList:Get(i));
    --         end
    --     end
    -- end

    self.AllRecruitList:Clear();
    self.AllRecruitDic = {};
    local Count = PackageList:Count()
    for index = 1,Count do
        local model = PackageList:Get(index)
        local info = RecruitPackageInfo.new()
        info:Init(model);
        self.AllRecruitList:Push(info)
        self.AllRecruitDic[model.recruitPackageId] = info;

        -- print(info._recruitPackageId )
        -- print(PlayerService:Instance():GetPlayerId())
        -- print(GameResFactory.Instance():GetInt("recruit"..info._recruitPackageId .. PlayerService:Instance():GetPlayerId()));

            if GameResFactory.Instance():GetInt("recruit"..info._recruitPackageId .. PlayerService:Instance():GetPlayerId()) == 0 then
                GameResFactory.Instance():SetInt("recruit"..info._recruitPackageId .. PlayerService:Instance():GetPlayerId(), 1)
            end

        if info._isFree == true then
            self.NewRecruitList:Push(info);
        end
        -- elseif info._curRecruitTimes < 1 and DataCardSet[info._tableId].PriceForOnce == 0 then
        --     self.NewRecruitList:Push(info);
        -- elseif info._isNew == 1 then
        --     self.NewRecruitList:Push(info);
    end
    
    self:SortPackage();
end


function RecruitManage:SortPackage()
    -- body
    -- print("Camein   SortPackage")
    self.tempFreeList = {};
    self.tempBeforeList = {};
    self.tempUnlockList = {};
    self.tempLockedList = {};
    local FamousPackage = nil;
    local GeneralPackage = nil;
    local RookiePackage = nil;
    local count = self.AllRecruitList:Count();
    local AfterSortList = List.new();   
    for index = 1,count do
        info = self.AllRecruitList:Get(index);
        if (info._tableId == 24) then
            RookiePackage = info;
        elseif(info._tableId == 1) then
            FamousPackage = info;
        elseif(info._tableId == 9) then
            GeneralPackage = info;
        else
            if(info._overTime~=0) then
                if info._isFree == 1 then 
                    table.insert(self.tempFreeList,info);
                else
                    table.insert(self.tempBeforeList,info);
                end
            else
                if self:JudgeIfUnlock(info._tableId) == true then
                    table.insert(self.tempUnlockList,info);
                else
                    table.insert(self.tempLockedList,info);
                end
            end
        end
    end
    AfterSortList:Push(RookiePackage);
    for i = 1 , #self.tempFreeList do 
        AfterSortList:Push(self.tempFreeList[i]);
    end
    for i = 1 , #self.tempBeforeList do 
        AfterSortList:Push(self.tempBeforeList[i]);
    end
    AfterSortList:Push(FamousPackage);
    AfterSortList:Push(GeneralPackage);
    for i = 1 , #self.tempUnlockList do 
        AfterSortList:Push(self.tempUnlockList[i]);
    end
    for i = 1 , #self.tempLockedList do 
        AfterSortList:Push(self.tempLockedList[i]);
    end
    self.AllRecruitList = AfterSortList;
end
-- function RecruitManage:SortPackage()
--     --self.AllRecruitList 排序
--     self.tempLastList:Clear()
--     if self.tempFristList ~= nil then
--         self.tempFristList:Clear()
--     end
--     local count = self.AllRecruitList:Count();
--     local FamousPackage = nil;
--     local GeneralPackage = nil;
--     local RookiePackage = nil;
--     local info = nil;
--     for index = 1,count do
--         info = self.AllRecruitList:Get(index);
--         if (info._tableId == 24) then
--             RookiePackage = info;
--         elseif(info._tableId == 1) then
--             FamousPackage = info;
--         elseif(info._tableId == 9) then
--             GeneralPackage = info;
--         else
--             if(info._overTime~=0) then
--                 self.tempFristList:Push(info)
--             else 
--                 self.tempLastList:Push(info)
--             end
--         end
--     end
--     self:SortList(self.tempFristList,false)
--     self:SortList(self.tempLastList,true)
--     self.AllRecruitList:Clear();
--     if(RookiePackage~=nil) then self.AllRecruitList:Push(RookiePackage) end
--     if self.tempFristList ~= nil then
--         for index = 1,self.tempFristList:Count() do
--             self.AllRecruitList:Push(self.tempFristList:Get(index));
--         end
--     end
--     if(FamousPackage~=nil) then self.AllRecruitList:Push(FamousPackage) end
--     if(GeneralPackage~=nil) then self.AllRecruitList:Push(GeneralPackage) end
--     for index = 1,self.tempLastList:Count() do
--         self.AllRecruitList:Push(self.tempLastList:Get(index));
--     end
    
-- end

-- -- 排序 ContainUnlock 是否包含解锁内容
-- function RecruitManage:SortList(Listinfo,ContainUnlock)
--     if Listinfo == nil then
--         return;
--     end
--     local count = Listinfo:Count();
--     if(count == 0) then
--         return
--     end
--      local firstList = {}
--     local lastList = {}
--     for index =1,count do
--         local info =Listinfo:Get(index); 
--             if(self:JudgeIfUnlock(info._tableId) == true ) then
--                 table.insert(firstList,info);
--             else
--                 table.insert(lastList,info);
--             end
            
--     end
--     Listinfo:Clear();
--     for i =1 ,#firstList  do
-- 	    Listinfo:Push(firstList[i]);
--     end
--     for i = 1 ,#lastList do 
--         Listinfo:Push(lastList[i]);
--     end
--     self._tempTable = {}
--     return Listinfo;
-- end

--判断某种类型是否解锁
function RecruitManage:JudgeIfUnlock(tableId)
    if tableId == 0 then
        return;
    end
    local Line = DataCardSet[tableId]; 
    if(Line~=nil) then
        if(Line.ConstructionID == 0 and Line.ConstructionLv == 0) then --如果没有填写 默认解锁
            return true;
             
        --收到消息的顺序不对 会报空 这里先注释
        elseif(Line.ConstructionID~=0 and Line.ConstructionLv~=0 and PlayerService:Instance():GetmainCityId()~=0) then
            local Construction = DataConstruction[Line.ConstructionID];
            -- print(PlayerService:Instance():GetmainCityId())
            -- print(FacilityService:Instance():GetFacilitylevelByIndex(PlayerService:Instance():GetmainCityId(),Construction.Type))
            -- print(Line.ConstructionLv);
            if(FacilityService:Instance():GetFacilitylevelByIndex(PlayerService:Instance():GetmainCityId(),Construction.Type) >= Line.ConstructionLv) then
                return  true;
            end
        end
    end
    return false;
end

-- function RecruitManage:UpdateRecruitList(model)
--     local info = RecruitPackageInfo.new()
--     info.Init(model);
--     self:AddInfo(model.recruitPackageId,info)
-- end

function RecruitManage:AddInfo(id,info)
    if(self.AllRecruitDic[id]) then
        self.AllRecruitList:Remove(self.AllRecruitDic[id])
    else
        self.AllRecruitList:Push(info)
        self.NewRecruitList:Push(info)
    end
    self.AllRecruitDic[id] = info;
end

function RecruitManage:GetLayoutObjWidth()
    return self._LayoutWidth;
end

function RecruitManage:SetLayoutObjWidth(value)
    -- body
    self._LayoutWidth = value;
end


function RecruitManage:GetPackageByID(id)
    return self.AllRecruitDic[id];
end

function RecruitManage:GetAllRecruitKindCount()
    return self.AllRecruitList:Count();
end

function RecruitManage:GetRecruitPackageByIndex(index)
    return self.AllRecruitList:Get(index);
end

function RecruitManage:GetNewRecruitListByIndex(index)
    return self.NewRecruitList:Get(index);
end

function RecruitManage:GetNewRecruitListCount()
    return self.NewRecruitList:Count();
end

function RecruitManage:ClearNewRecruitList()
    self.NewRecruitList:Clear();
end

function RecruitManage:RemoveInfoFromNewRecruitList(value)
    -- body
    self.NewRecruitList:Remove(value);
end

function RecruitManage:PushElementToNewRecruitList(value)
    -- body
    self.NewRecruitList:Push(value);
end

function RecruitManage:GetPackageID()
    return self.CurrentPackageId;
end

function RecruitManage:GetCardListCount()
    return self.CardList:Count();
end

function RecruitManage:GetCardInfoByIndex(index)
    return self.CardList:Get(index);
end

function RecruitManage:SetIsTransToExp(temp)
    self.IsTransToExp = temp;
end

function RecruitManage:GetIsTransToExp()
    return self.IsTransToExp;
end

function RecruitManage:SetTransUnderStarNum(temp)
    self.TransUnderStarNum = temp;
end

function RecruitManage:GetTransUnderStarNum()
    return self.TransUnderStarNum;
end

function RecruitManage:SetTransWay(temp)
    self.TransWay = temp;
end

function RecruitManage:GetTransWay()
    return self.TransWay;
end

function RecruitManage:SetLastUpdateID(id)
    self.LastUpdateID = id;
end

function RecruitManage:GetLastUpdateID()
    return self.LastUpdateID
end


function RecruitManage:GetCurRecruitPackageTimes()
    -- body
    return self.AllRecruitDic[self.CurrentPackageId]._curRecruitTimes;
end

function RecruitManage:GetIsRecruit()
    -- body
    return self.IsRecruit;
end

function RecruitManage:SetIsRecruit(value)
    -- body
    self.IsRecruit = value;
end

function RecruitManage:SetTransExpValue(value)
    -- body
    self._TransExpValue = value;
end

function RecruitManage:GetTransExpValue()
    return self._TransExpValue;
end


function RecruitManage:GetNeedEffectShowCardListCount()
    -- body
    return self._NeedEffectShowCardList:Count();
end

function RecruitManage:GetNeedEffectShowCardByIndex(index)
    -- body
    return self._NeedEffectShowCardList:Get(index)
end

function RecruitManage:RemoveNeedEffectShowCard(value)
    -- body
    return self._NeedEffectShowCardList:Remove(value)
end

function RecruitManage:AddNeedEffectShowCard(value)
    self._NeedEffectShowCardList:Push(value)
end

function RecruitManage:SetIsBatchRecruit(value)
    -- body
    self._isBatchRecruit = value;
end

function RecruitManage:GetIsBatchRecruit()
    -- body
    return self._isBatchRecruit;
end

function RecruitManage:GetShowCardListCount( ... )
    -- body
    return #self._ShowCardList;
end

function RecruitManage:GetShowCardByIndex(index)
    -- body
    return self._ShowCardList[index];
end

function RecruitManage:RemoveShowCard(value)
    -- body
    table.remove(self._ShowCardList,value);
end

function RecruitManage:AddShowCard(value)
    -- body
    table.insert(self._ShowCardList,value)
end

function RecruitManage:ClearShowCardList()
    -- body
    self._ShowCardList = {};
end

return RecruitManage