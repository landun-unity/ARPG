-- region *.lua
-- Date
-- 工具类:提供UGUI控件的常用函数

UIMix = class("UIMix");

function UIMix:ctor()
    -- body
    -- print("UIMix:ctor");
    -- UIMix._instance = self;
    self._scorllData = DataUIConfig[UIType.UIScorll];
    self.scrollTable = { };
    self._curBase = nil;
    self._LoadCallBack = nil;
end

function UIMix:SetLoadCallBack(callBack)
    self._LoadCallBack = callBack;
end


function UIMix:LoadDownPartCallBack(obj)
    if self._LoadCallBack == nil then
        return;
    end

    self._LoadCallBack(obj);
end


-- function  UIMix:ScrollOnUpCallBack(obj)
--    if self._LoadCallBack == nil then
--        return;
--    end

--    self._LoadCallBack(obj);
-- end

-- 得到加载预制
function UIMix:GetDownPart()
    return self._curBase;
end

-- 得到当前被拖动的物体
function UIMix:GetBeDragObj()
    return self._curBase:GetBeDragObj();
end

-- 得到被拖拽物体的数据
function UIMix:GetBeDragObjData()
    return self._curBase:GetBeDragObjData();
end

-- 得到被拖拽物体的脚本
function UIMix:GetBeDragBase()
    return self._curBase:GetBeDragBase();
end

function UIMix:SetCardChooseState(heroTable)
    if self._curBase then
        self._curBase:SetCardChooseState(heroTable)
    end
end

function UIMix:Get_localPointerPosition()
    return self._curBase:Get_localPointerPosition();
end

-- 得到当前拖动的物体     
function UIMix:Get_curDragObj()
    if self._curBase then
        return self._curBase:Get_curDragObj();
    end
end

function UIMix:SetPostionObj(obj)
    if self._curBase then
        self._curBase:SetPostionObj(obj);
    end
end

-- 调用滑动板
-- ObjList:物体列表
-- parentObj:父物体
-- isFromSkill 是否是来自于skill
function UIMix:MakeScrollDrag(ObjList, parentObj, isFromSkill, position)
    -- 如果没有此 预制
    -- self._LoadCallBack=callBack;
    -- print("+++++++++++++++++++++++++++++parentObj.name:  "..parentObj.name)
    -- print("+++++++++++++++++++++++++++++self._scorllData.ResourcePath:  "..self._scorllData.ResourcePath)

    local path = CommonService:Instance():StringSplit(self._scorllData.ResourcePath, "/");

    if parentObj:FindChild(path[#path]) == nil then
        local uiBase = require(self._scorllData.ClassName).new();
        -- print(uiBase);
        -- 加载预制
        GameResFactory.Instance():GetUIPrefab(self._scorllData.ResourcePath, parentObj.transform, uiBase, function(go)

            if uiBase == nil then
                -- print("uiBase is nil");
            end

            uiBase:Init();
            uiBase:LoadAllCard(ObjList);
            if (isFromSkill) then
                uiBase:SetFalseForSkill(position);
            end
            self._curBase = uiBase;
            -- print(parentObj.name);
            if self.scrollTable[parentObj.transform] == nil then
                self.scrollTable[parentObj.transform] = uiBase;
                -- print(uiBase);
            end
            self:LoadDownPartCallBack(uiBase.gameObject);
        end );
        -- 如果已有此预制
    else
        -- print("已有此预制!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!")
        if self.scrollTable[parentObj.transform] then
            local mmBase = self.scrollTable[parentObj.transform];
            mmBase:Init();
            mmBase:LoadAllCard(ObjList);

        end

    end
end

-- 初始化11个位置
function UIMix:InitNinePostion(ObjList)
    local size = ObjList:Count();
    -- print("HeroCardCount:" .. size);
    local mObjIndex = -1;

    for index = 1, size do

        local heroCard = listData:Get(index);
        -- print(heroCard);
        -- continue
        while true do
            if heroCard == nil then
                -- print("HeroCard is nil,Index:" .. index)
                break
            end

            local mdata = DataUIConfig[UIType.UIHeroCard];
            -- body
            -- local parentObj , childnum = self:GetParentModel(mObjIndex, size);

            -- 如果没有就加载，如果有了就设置
            if self._testParentObjLeft.transform.childCount < index then
                -- print(self._perfabPath,self._parentObj);
                local mHeroCard = HeroCard.new();

                GameResFactory.Instance():GetUIPrefab(mdata.ResourcePath, self._testParentObjLeft.transform, mHeroCard, function(go)
                    -- 如果在前7个位置
                    -- if mObjIndex <= self._parentNum then

                    self:SetSingleHeroCardData(mHeroCard, heroCard);

                    mObjIndex = self:RefreshCarPart(index, mObjIndex, mHeroCard);
                    -- end
                    -- mObjIndex = mObjIndex + 1;
                end );

            else
                -- 如果有了就设置一遍
                -- 设置数据
                if self._allHeroCardDic[heroCard.iD] then
                    local nHeroCard = self._allHeroCardDic[heroCard.iD];

                    nHeroCard:SetHeroCardMessage(heroCard);

                end

                mObjIndex = self:RefreshCarPart(index, mObjIndex, nHeroCard);

                -- 设置位置大小

            end

            break
        end


        mObjIndex = mObjIndex + 1;
    end

end

-- 得到滑动脚本
function UIMix:GetUIMixBase(parentObj)
    -- print(parentObj.name);
    -- print("UIMix:GetUIMixBase");
    -- print(self.scrollTable[parentObj.transform]);
    if self.scrollTable[parentObj.transform] then
        -- print("UIMix:GetUIMixBase");
        local mmBase = self.scrollTable[parentObj.transform];
        return mmBase;
    end
end

function UIMix:Get_testParentObjLeft()
    if self._curBase then
        return self._curBase._testParentObjLeft;
    end
    return nil;
end


-- function UIMix:ScrollOnUpCB(parentObj,method)

--         if self.scrollTable[parentObj.transform] then
--            local mmBase = self.scrollTable[parentObj.transform];
--            mmBase:SetUpCallBack(method)
--            end
-- end

-- 点击事件
function UIMix:ScrollOnClickCB(method)
    if self._curBase then
        self._curBase:SetClickCallBack(method)
    end
end


function UIMix:ScrollOnUpCB(method)

    -- print("UIMix:ScrollOnUpCB");
    if self._curBase then
        self._curBase:SetUpCallBack(method)
    end
end

function UIMix:ScrollOnDownCB(method)
    -- print("UIMix:ScrollOnDownCB");
    if self._curBase then
        self._curBase:SetDownCallBack(method)
    end
end


function UIMix:SetCurDragObj(obj)
    if self._curBase then
        self._curBase:SetCurDragObj(obj)
    end
end

function UIMix:SetBeDragData(data)
    if self._curBase then
        self._curBase:SetBeDragData(data)
    end
end

function UIMix:SetChooseBtn(visable)
    self._curBase:SetSortListObj(visable);
end

-- 排序不重置位置
function UIMix:SortingCardList(cardDataList)
    self._curBase:SortingCardList(cardDataList);
end


return UIMix;

-- endregion
