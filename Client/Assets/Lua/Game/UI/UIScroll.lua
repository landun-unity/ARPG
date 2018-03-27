--[[
    Anchor:Dr
    Data:16/9/29
    行军配置界面
--]]

local UIBase = require("Game/UI/UIBase");

local UIScroll = class("UIScroll", UIBase);
require("Game/Hero/HeroService");
local List = require("common/List");
local UIType = require("Game/UI/UIType");
local DataUIConfig = require("Game/Table/model/DataUIConfig");
local HeroCard = require("Game/Hero/HeroCardPart/UIHeroCard");
require("Game/UI/UIMix");

-- 构造函数
function UIScroll:ctor()
    UIScroll.super.ctor(self)
    self.testImage = nil;
    -- 用来移动的物体
    self._curDragObj = nil;
    -- 移动物体的uibase脚本
    self._curDragBase = nil;
    -- 设置被拖动的物体
    self._curDragSingleDic = { };
    -- grid
    self._parentObj = nil;
    self._heroCardResouce = nil;
    self._curDragHeroCardObj = nil;
    -- 当前拖拽的物体
    self._BeDragObj = nil;
    -- 当前拖拽物体的数据
    self._BeDragData = nil;
    -- 被拖拽物体的脚本
    self._BeDragBase = nil;
    -- 被拖拽的母体
    -- 拥有英雄键值对,键数据，值绑定脚本
    self._allHaveHeroCardDic = { };
    -- 拥有英雄键值对，键:英雄id，值:脚本SetHeroCardMessage
    self._allHeroCardDic = { };

    -- 部队数 键:位置框(如大营框) 值:脚本
    -- 大营
    self._Bg1 = nil;
    -- 中军
    self._Bg2 = nil;
    -- 前锋
    self._Bg3 = nil;
    -- self._BgList = List.new();
    self._BgList = { };
    -- 三军对应框 键:拖拽框物体，值:uibase脚本
    self._allArmyCampDic = { };

    self._SortListObj = nil;


    self._heroCard0 = nil;
    self._heroCard1 = nil;
    self._heroCard2 = nil;

    --       self._heroCard3=nil;
    --       self._heroCard4=nil;
    self._localPointerPosition = nil;
    self._localScrollPosition = nil;
    self._armyObjList = nil;
    --------------------------------------滑动部分----------------------------------
    self._scrollRect = nil;
    self._ctorVect = nil;
    -- 初始位置
    self._testParentObjLeft = nil;
    -- 测试父物体左边
    self._testParentObjRight = nil;
    -- 测试父物体右边
    self._modelParentObjLeft = nil;
    -- 目标位置左
    self._modelParentObjRight = nil;
    -- 目标位置右
    self._ninePositionDic = { };
    -- 九个位置,索引从1开始
    self._distanceSmall = 50;
    -- 小的间距
    self._distanceBig = 200;
    -- 大的间距
    self._distanceMiddle = 190;
    -- 中间间距

    -- 滑动条
    self._scrollSlider = nil;

    -- 左滑还是右滑（0左,1：右）
    self._leftOrright = -1;
    -- 拥有武将
    self._haveHeroList = { };
    -- 左右两边各多少个物体
    self._fixedNum = 6;
    -- 最中间的编号
    self._middleNum = 7;

    -- 右边需要调整层级的物体编号
    self._parentNum = 8;
    -- 预制件最大个数
    self._sumNum = 13;

    -- 测试数字
    self.ttest = 0;

    -- 用于平滑处理的table
    self._lerpScrolleDic = { };

    -- 上一次移动的点
    self._lastPosition = nil;
    -- 上一次移动的点(卡牌的)
    self._cardLastPos = nil;

    local canvas = UGameObject.Find("Canvas");
    self._canvas = canvas:GetComponent(typeof(UnityEngine.Canvas));

    -- 开始索引
    self._startIndex = 2;

    -- 左边应该有的子物体数量
    self._lefetChildNum = 3;



    self._mMove = nil;
    -- 中间物体
    self._dMiddleObj = nil;
    -- 中间物体的索引
    self._mMiddleObjIndex = 0;
    -- 滑动状态0，拖动状态1
    self._scorllState = -1;
    -- 回调函数
    self._upCallBack = nil;
    self._downCallBack = nil;
    self._clickCallBack = nil;
    -- 部队父物体
    self.armyObj = nil;
    -- 状态
    self._btnState = nil;
    -- 当前点击物体的数据
    self._clickObjData = nil;
    -- 卡牌数据
    self._cardListDate = List.new();
    -- 用于隐藏的列表
    self._allHaveHeroCardIndexDic = { };
    -- 键:物体，值:物体对应列表索引
    self._cardIndexTable = { };
    -- 物体所对应的脚本
    self._objForBaseTable = { };
    -- 悬浮物体indexlist
    self._cardIndexList = List:new();

    -- 当前InitsCard
    self.HeroCardTable = { }

end

-- 得到当前被拖动的物体
function UIScroll:GetBeDragObj()
    return self._BeDragObj;
end

-- 得到当前被拖动的物体
function UIScroll:GetBeDragBase()
    return self._BeDragBase;
end

-- 得到被拖拽物体的数据
function UIScroll:GetBeDragObjData()
    return self._BeDragData;
end

function UIScroll:Get_localPointerPosition()
    return self._localPointerPosition;
end


-- 得到当前拖动的物体     
function UIScroll:Get_curDragObj()
    return self._curDragObj;
end


function UIScroll:LoadAllCard(cardDataList)
    self._cardListDate = cardDataList;
    self._haveHeroList = { };
    -- 初始化11个位置
    self:InitNinePosition();
    self._scrollSlider.value = 0;

    -- 吧传过来的物质设置好
    self:RefreshUIShow(cardDataList);

    self:AddOnDown(self._scrollRect, self.OnMouseDown);
    self:AddOnDrag(self._scrollRect, self.OnValueChangedStart);
    self:AddOnUp(self._scrollRect, self.OnMouseUp);

end

function UIScroll:SetUpCallBack(upCallBack)
    self._upCallBack = upCallBack;
end


function UIScroll:ScrollOnUpCallBack(go, eventData)
    if self._upCallBack == nil then
        return;
    end

    self._upCallBack(go, eventData);
end


function UIScroll:SetClickCallBack(clickCallBack)
    self._clickCallBack = clickCallBack;
end


function UIScroll:ScrollOnClickCallBack(go, eventData)
    if self._clickCallBack == nil then
        return;
    end
    -- print(go);
    self._clickCallBack(go, eventData);
end


function UIScroll:SetDownCallBack(downCallBack)
    self._downCallBack = downCallBack;
end


function UIScroll:ScrollOnDownCallBack(go, eventData)
    if self._downCallBack == nil then
        return;
    end

    self._downCallBack(go, eventData);
end



-- 初始化11个显示位置
function UIScroll:InitNinePosition()


    if self._modelParentObjLeft == nil or self._modelParentObjRight == nil then
    end

    for index = 1, self._modelParentObjLeft.transform.childCount do
        if self._ninePositionDic[index] == nil then
            self._ninePositionDic[index] = { ninePostion = self._modelParentObjLeft.transform:GetChild(index - 1).localPosition.x, nineScale = self._modelParentObjLeft.transform:GetChild(index - 1).localScale.x };
        end
    end

    for index = self._modelParentObjLeft.transform.childCount + 1, self._modelParentObjLeft.transform.childCount + self._modelParentObjRight.transform.childCount do
        if self._ninePositionDic[index] == nil then
            self._ninePositionDic[index] = { ninePostion = self._modelParentObjRight.transform:GetChild(self._modelParentObjLeft.transform.childCount + self._modelParentObjRight.transform.childCount - index).localPosition.x, nineScale = self._modelParentObjRight.transform:GetChild(self._modelParentObjLeft.transform.childCount + self._modelParentObjRight.transform.childCount - index).localScale.x };
        end
    end

    self._dMiddleObj = nil;

end

-- 设置物体位置和大小
function UIScroll:SetObjPoSc(obj, ninePart)
    obj.transform.localPosition = UnityEngine.Vector3(ninePart.ninePostion, obj.transform.localPosition.y, obj.transform.localPosition.z);

    local sScale = ninePart.nineScale;
    obj.gameObject.transform.localScale = UnityEngine.Vector3(sScale, sScale, sScale);
    -- print(sScale);
end

-- 设置物体位置大小并加入到列表
function UIScroll:SetObjPart(obj, ninePart)
    obj.transform.localPosition = UnityEngine.Vector3(ninePart.ninePostion, obj.transform.localPosition.y, obj.transform.localPosition.z);

    local sScale = ninePart.nineScale;
    obj.gameObject.transform.localScale = UnityEngine.Vector3(sScale, sScale, sScale);

end

-- 屏幕坐标转化为UGUI坐标
function UIScroll:_ScreenPointToUGUIPosition(position)
    -- 转化为本地坐标
    local isInRect, convertPosition = UnityEngine.RectTransformUtility.ScreenPointToLocalPointInRectangle(self._scrollRect.gameObject.transform, position, self._canvas.worldCamera);
    return Vector3.New(convertPosition.x, convertPosition.y, 0);
end

-- 鼠标按下的事件
function UIScroll:OnMouseDown(go, eventData)

    self._btnState = 0;
    self._lastPosition = self:_ScreenPointToUGUIPosition(eventData.position);
    -- self:ResetNinePostion();
    self:FindDragObj(go, eventData);
    if self._BeDragObj == nil then
        -- print("self._BeDragObj is nil");
        return;
    end
    self._localPointerPosition = nil;
    self:ScrollOnDownCallBack();

end


-- 松开归位
function UIScroll:OnMouseUp(go, eventData)
    if self._BeDragBase then
        self._BeDragBase:SetCardAlpha(true)
    end
    self._scorllState = -1;
    -- 如果没有拖拽就认为在点击
    if self._btnState == 0 then
        if self._BeDragData ~= nil and self._BeDragObj ~= nil and self._BeDragObj.gameObject.activeInHierarchy == true then
            if GuideServcice:Instance():GetIsFinishGuide() == true then
                self:ScrollOnClickCallBack(go, eventData);
                -- HeroService:Instance():ShowHeroInfoUI(self._BeDragData.id);
            end
        end

        return;

    end

    self:ResetNinePostion();
    self._curDragObj = nil;
    -- 清空拖拽的物体
    self:ScrollOnUpCallBack(go, eventData);

end

-- 松开归位
function UIScroll:ResetNinePostion()
    self:MiddleHeroCardIndex();

    if self._mMiddleObjIndex then
        -- print(self._mMiddleObjIndex);
        local mMiddleObj = self._haveHeroList[self._mMiddleObjIndex];
        if mMiddleObj then

            if self._mMove ~= 0 then


                local dotT = self:AskDotT(mMiddleObj);
                -- 如果向右
                if self._mMove > 0 then
                    if dotT >= 0.5 then
                        self._mMiddleObjIndex = self._mMiddleObjIndex - 1;
                    end

                    -- 如果向左
                elseif self._mMove < 0 then
                    if dotT >= 0.5 then
                        self._mMiddleObjIndex = self._mMiddleObjIndex + 1;
                    end
                end
            end
            local newMiddleObj = self._haveHeroList[self._mMiddleObjIndex];

            if newMiddleObj then
                newMiddleObj.transform.localPosition = UnityEngine.Vector3.New(self._ninePositionDic[self._middleNum].ninePostion, newMiddleObj.transform.localPosition.y, newMiddleObj.transform.localPosition.z);
            end
            local modelIndex = self._middleNum - self._fixedNum;
            for index = self._mMiddleObjIndex - self._fixedNum, self._mMiddleObjIndex + self._fixedNum do
                local obj = self._haveHeroList[index];

                if obj and self._ninePositionDic[modelIndex] then
                    -- and obj ~= mMiddleObj then
                    -- print(index);
                    -- print("modelIndex;"..modelIndex);
                    obj.transform.localPosition = UnityEngine.Vector3.New(self._ninePositionDic[modelIndex].ninePostion, obj.transform.localPosition.y, obj.transform.localPosition.z);
                    local pScale = self._ninePositionDic[modelIndex].nineScale;
                    obj.transform.localScale = UnityEngine.Vector3.New(pScale, pScale, pScale);

                    if obj.transform.localPosition.x <= self._ninePositionDic[self._parentNum].ninePostion + 1 then
                        if obj.transform.parent ~= self._testParentObjLeft.transform then
                            obj.transform:SetParent(self._testParentObjLeft.transform);
                        end
                        -- 松开同步一下数据
                        -- print("index:"..index);
                        self._cardIndexTable[obj] = index;
                        local mData = self._cardListDate:Get(index);
                        -- 新数据
                        local mHeroCard = self._objForBaseTable[obj];
                        -- self._allHaveHeroCardDic[mData]=mHeroCard;
                        -- print("remove:"..nIndex.."add:"..newIndex);
                        self._haveHeroList[index] = obj;
                        self:SetSingleHeroCardData(mHeroCard, mData);



                    end

                    -- 右


                    if obj.transform.localPosition.x > self._ninePositionDic[self._parentNum].ninePostion then
                        if obj.transform.parent ~= self._testParentObjRight.transform then
                            obj.transform:SetParent(self._testParentObjRight.transform);
                        end
                    end


                    -- self:SetObjWithParent(obj);
                end

                modelIndex = modelIndex + 1;
            end
        end
    end

end



-- 滑动执行
-- @parem go:物体，Vector2:鼠标位置
function UIScroll:OnValueChangedStart(go, eventData)
    self._btnState = 1;

    if self._ctorVect == nil then
        self._ctorVect = eventData.position;
    else
    end
    local position = self:_ScreenPointToUGUIPosition(eventData.position);
    local move = nil;
    if self._lastPosition ~= nil then

        local targetPlane = position - self._lastPosition;
        local xPalen = UnityEngine.Vector3.New(1, 0, 0);
        local angle = UnityEngine.Vector3.Angle(targetPlane, xPalen);
        move = position.x - self._lastPosition.x;
        self._mMove = move;

        if angle <= 20 or angle >= 160 then
            if self._scorllState == -1 then
                self._scorllState = 0;
            end
        else

            if self._scorllState == -1 then
                self._scorllState = 1;
            end
        end
        if self._scorllState == 0 then
            if GuideServcice:Instance():GetIsFinishGuide() == false then
                return;
            end
            self:RefreshScrollPart(go, eventData);

        elseif self._scorllState == 1 then
            if self._curDragObj then
                self:OnDragStartBtn(self._curDragObj.gameObject, eventData);
            end
        end
    end
    self._lastPosition = position;
end

-- 设置当前拖拽的物体
function UIScroll:SetCurDragObj(obj)
    self._curDragObj = obj;
end

-- 设置点击物体的数据
function UIScroll:SetBeDragData(data)
    self._clickObjData = data;
end

-- 刷新滑动主方法
function UIScroll:RefreshScrollPart(go, eventData)

    if self._mMove == 0 then
        return;
    end

    local middeIndex = self:MiddleHeroCardIndex();
    local drMiddleObj = self._haveHeroList[middeIndex];
    if drMiddleObj == nil or drMiddleObj.gameObject.activeInHierarchy == false then
        -- print("drMiddleObj is nil");
        return;
    end

    self._dMiddleObj = drMiddleObj;
    self._scrollSlider.value =(self._mMiddleObjIndex - self._startIndex) /(self._cardListDate:Count() -1 - self._startIndex);
    if (self._mMiddleObjIndex <= self._startIndex and self._mMove > 0) or(self._mMiddleObjIndex >= self._cardListDate:Count() -1 and self._mMove < 0) then
        --            --print("self._mMiddleObjIndex"..self._mMiddleObjIndex);
        --         --print(middeIndex);
        --           --print("self._haveHeroList"..#self._haveHeroList);
        return;

    else

        drMiddleObj.transform.localPosition = Vector3.New(drMiddleObj.transform.localPosition.x + self._mMove, drMiddleObj.transform.localPosition.y, drMiddleObj.transform.localPosition.z);
        -- self:SetObjInParent(drMiddleObj);
        -- 求出dotT
        local dotT = self:AskDotT(drMiddleObj);
        -- print("==============="..dotT);

        local downIndex, upIndex, mmYieid = self:ForEachLeftAndRight(middeIndex);

        for mmIndex = downIndex, upIndex, mmYieid do

            local obj = self._haveHeroList[mmIndex];
            -- print("out:"..mmIndex);
            if obj then
                -- print(mmIndex);
                -- print("middleIndex:"..middeIndex)
                self:ScrollSibiObje(obj, middeIndex, dotT, mmIndex);

            end

        end

        self:SetLeftMiddleIndex(middeIndex);
        self:SetRightMiddleIndex(middeIndex);

    end

end

-- 找到需要被拖动的物体
function UIScroll:FindDragObj(go, eventData)

    local middeIndex = self:MiddleHeroCardIndex();
    local position = nil;
    local isBoolPositon, position = UnityEngine.RectTransformUtility.ScreenPointToLocalPointInRectangle(self._testParentObjLeft:GetComponent(typeof(UnityEngine.RectTransform)), eventData.position, eventData.pressEventCamera);


    local chooseObj = nil;
    local clickTable = { };
    local beginIndex = 9999999;
    for mmIndex = middeIndex - self._fixedNum, middeIndex + self._fixedNum do
        local obj = self._haveHeroList[mmIndex];
        if obj then

            local fWidth = obj.gameObject:GetComponent(typeof(UnityEngine.RectTransform)).rect.width / 2;
            local fHeight = obj.gameObject:GetComponent(typeof(UnityEngine.RectTransform)).rect.height / 2;
            local vecTemp = obj.transform.localPosition;
            -- 如果在框内，找到这几个物体
            if ((vecTemp.x - position.x <= fWidth) and(vecTemp.x - position.x >=(0 - fWidth)) and(vecTemp.y - position.y <= fHeight) and(vecTemp.y - position.y >=(0 - fHeight))) then
                clickTable[mmIndex] = obj;
                if beginIndex > mmIndex then
                    beginIndex = mmIndex;
                end
                --            local mdis = math.abs(vecTemp.x - position.x);

                --            if mdis <= distance and obj.activeInHierarchy == true then
                --            --print(mmIndex);
                --            --print("In");
                --                distance = mdis;
                --                chooseObj = obj;
                --            end
            end
        end

    end

    if beginIndex == 9999999 then
        self._BeDragObj = nil;
        self._BeDragData = nil;
        self._BeDragBase = nil;
        return;
    end

    for index = beginIndex, table.maxn(clickTable) do

        if index < middeIndex then
            if clickTable[index] then
                chooseObj = clickTable[index];
            end
        else
            if clickTable[index] then
                chooseObj = clickTable[index];
            end
            break;
        end
    end

    self._BeDragObj = chooseObj;
    local newIndex = self._cardIndexTable[chooseObj];
    local mData = self._cardListDate:Get(newIndex);
    -- 新数据
    self._BeDragData = mData;
    self._BeDragBase = self._objForBaseTable[chooseObj];
    if mData then
        -- print("tableid:"..mData.tableID)
        -- print("level:"..mData.level)
    end
end

-- 用于滑动时设置层级
function UIScroll:ForEachLeftAndRight(middeIndex)
    -- 如果是左
    if self._mMove < 0 then

        return middeIndex - self._fixedNum, middeIndex + self._fixedNum, 1;

        -- 右
    elseif self._mMove > 0 then

        return middeIndex + self._fixedNum, middeIndex - self._fixedNum, -1;
    end
end

-- 设置子父物体
function UIScroll:SetObjWithParent(obj)

    -- 左
    if self._mMove < 0 then

        if obj.transform.localPosition.x < self._ninePositionDic[self._parentNum].ninePostion then
            obj.transform:SetParent(self._testParentObjLeft.transform);
            -- obj.transform.parent=self._testParentObjLeft.transform;
            obj.transform:SetAsLastSibling();
        end

        -- 右


        if obj.transform.localPosition.x > self._ninePositionDic[self._parentNum].ninePostion then
            obj.transform:SetParent(self._testParentObjRight.transform);
            -- obj.transform.parent=self._testParentObjRight.transform;
            obj.transform:SetAsFirstSibling();
        end

    elseif self._mMove > 0 then
        if obj.transform.localPosition.x < self._ninePositionDic[self._parentNum].ninePostion then
            obj.transform:SetParent(self._testParentObjLeft.transform);
            -- obj.transform.parent=self._testParentObjLeft.transform;
            obj.transform:SetAsFirstSibling();
        end

        -- 右
        if obj.transform.localPosition.x > self._ninePositionDic[self._parentNum].ninePostion then
            obj.transform:SetParent(self._testParentObjRight.transform);
            -- obj.transform.parent=self._testParentObjRight.transform;
            obj.transform:SetAsLastSibling();
        end

    end
end 

-- 设置左滑index
function UIScroll:SetLeftMiddleIndex(middeIndex)

    local drMiddleObj = self._haveHeroList[middeIndex];
    if drMiddleObj == nil then
        return;
    end

    if self._mMove < 0 then
        for ddIndex = 1, #self._ninePositionDic do
            local nineObjX = self._ninePositionDic[ddIndex].ninePostion;
            if self._ninePositionDic[ddIndex - 1] ~= nil and self._ninePositionDic[ddIndex] ~= nil then
                local downObjX = self._ninePositionDic[ddIndex - 1].ninePostion;

                if drMiddleObj.transform.localPosition.x <= nineObjX and drMiddleObj.transform.localPosition.x >= downObjX then
                    -- print("ddIndex.."..ddIndex);

                    local t1, t2 = math.modf(#self._ninePositionDic / 2);
                    -- print(t1);
                    self._mMiddleObjIndex = self._middleNum - t1 +((self._middleNum - ddIndex) + middeIndex - 1);
                    -- print(self._mMiddleObjIndex);

                    break
                end
            end
        end
    end
end

-- 设置右滑index
function UIScroll:SetRightMiddleIndex(middeIndex)

    local drMiddleObj = self._haveHeroList[middeIndex];
    if drMiddleObj == nil then
        return;
    end

    if self._mMove > 0 then
        for ddIndex = 1, #self._ninePositionDic do
            local nineObjX = self._ninePositionDic[ddIndex].ninePostion;
            if self._ninePositionDic[ddIndex + 1] ~= nil and self._ninePositionDic[ddIndex] ~= nil then
                local downObjX = self._ninePositionDic[ddIndex + 1].ninePostion;

                if drMiddleObj.transform.localPosition.x >= nineObjX and drMiddleObj.transform.localPosition.x < downObjX then
                    -- print("ddIndex.."..ddIndex);

                    local t1, t2 = math.modf(#self._ninePositionDic / 2);
                    -- print(t1);
                    self._mMiddleObjIndex = self._middleNum - t1 +((self._middleNum - ddIndex) + middeIndex - 1);
                    -- print(self._mMiddleObjIndex);

                    break
                end
            end
        end
    end
end

-- @parem obj:物体，middleIndex:中间物体索引，dotT:t，mmIndex:自己的索引
function UIScroll:ScrollSibiObje(obj, middleIndex, dotT, mmIndex)

    if self._mMove == 0 then
        return;
    end


    if self._mMove > 0 then
        local nowindex = mmIndex +(self._middleNum - middleIndex);
        local nextIndex = mmIndex +(self._middleNum - middleIndex) + 1;
        -- print(nowindex,nextIndex);
        -- 如果不是最后一个
        if nowindex ~= #self._ninePositionDic then

            if self._ninePositionDic[nextIndex] == nil or self._ninePositionDic[nowindex] == nil then
                -- print("_ninePositionDic is nil "..nextIndex..nowindex);
                return;
            end

            -- print("right==============");
            local privot = self._ninePositionDic[nowindex].ninePostion + dotT *(self._ninePositionDic[nextIndex].ninePostion - self._ninePositionDic[nowindex].ninePostion)

            local pScale = self._ninePositionDic[nowindex].nineScale + dotT *(self._ninePositionDic[nextIndex].nineScale - self._ninePositionDic[nowindex].nineScale);
            if privot ~= nil and pScale ~= nil then
                -- if obj ~= self._haveHeroList[middleIndex] and privot ~= nil and pScale ~= nil then
                -- print(obj.transform:GetSiblingIndex());
                obj.transform.localPosition = Vector3.New(privot, obj.transform.localPosition.y, obj.transform.localPosition.z);

                obj.transform.localScale = Vector3.New(pScale, pScale, pScale);
            end
            -- 如果是最后一个
        else
            -- print("nowindex:"..nowindex);
            -- print("x:"..obj.transform.localPosition.x);
            -- print("==1:"..self._ninePositionDic[#self._ninePositionDic].ninePostion - 1);
            if obj.transform.localPosition.x >= self._ninePositionDic[#self._ninePositionDic].ninePostion - 1 then
                -- print("in right");
                -- 并且后面的数据部位空
                local nIndex = self._cardIndexTable[obj];
                local newIndex = nIndex - #self._ninePositionDic;

                if newIndex <= self._cardListDate:Count() and newIndex > 0 then
                    -- print("in right");
                    -- obj.transform.localPosition = Vector3.New(self._ninePositionDic[1].ninePostion, obj.transform.localPosition.y, obj.transform.localPosition.z);
                    self._cardIndexTable[obj] = newIndex;
                    -- local mData = self._cardListDate:Get(newIndex);
                    -- 新数据
                    -- local mHeroCard = self._objForBaseTable[obj];
                    -- self._allHaveHeroCardDic[mData]=mHeroCard;
                    -- print("right,remove:"..nIndex.."add:"..newIndex);
                    self._haveHeroList[newIndex] = obj;
                    -- self:SetSingleHeroCardData(mHeroCard, mData);
                    -- if  self._cardIndexList:Get(nIndex) then
                    --                         self._cardIndexList:Remove(nIndex);
                    --                         self._cardIndexList:Push(newIndex);
                    --                          --print("remove:"..nIndex.."add:"..newIndex);
                    -- end


                end
            end
        end

        -- 如果左移
    elseif self._mMove < 0 then

        local nowindex = mmIndex +(self._middleNum - middleIndex);
        local nextIndex = 0;
        -- 如果没在最边上
        if nowindex ~= 1 then
            nextIndex = mmIndex +(self._middleNum - middleIndex) -1;

            if self._ninePositionDic[nextIndex] == nil or self._ninePositionDic[nowindex] == nil then
                -- print("nowindex:"..nowindex..",nextIndex:"..nextIndex);
                return;
            end


            local privot = self._ninePositionDic[nowindex].ninePostion - dotT *(self._ninePositionDic[nowindex].ninePostion - self._ninePositionDic[nextIndex].ninePostion);

            -- 如果开始和结束缩放一样
            local pScale = self._ninePositionDic[nowindex].nineScale - dotT *(self._ninePositionDic[nowindex].nineScale - self._ninePositionDic[nextIndex].nineScale);
            if privot ~= nil and pScale ~= nil then
                -- if obj ~= self._haveHeroList[middleIndex] and privot ~= nil and pScale ~= nil then
                -- print(obj.transform:GetSiblingIndex());
                obj.transform.localPosition = Vector3.New(privot, obj.transform.localPosition.y, obj.transform.localPosition.z);

                obj.transform.localScale = Vector3.New(pScale, pScale, pScale);

            end


        else

            -- print("in first");
            -- print("x:"..obj.transform.localPosition.x);
            -- print("ninePostion:"..self._ninePositionDic[1].ninePostion);
            if obj.transform.localPosition.x <= self._ninePositionDic[1].ninePostion + 1 then

                -- 并且后面的数据部位空

                local nIndex = self._cardIndexTable[obj];

                local newIndex = nIndex + #self._ninePositionDic;

                if newIndex <= self._cardListDate:Count() then
                    -- print("ninePostion:"..self._ninePositionDic[#self._ninePositionDic].ninePostion);
                    obj.transform.localPosition = Vector3.New(self._ninePositionDic[#self._ninePositionDic].ninePostion, obj.transform.localPosition.y, obj.transform.localPosition.z);
                    self._cardIndexTable[obj] = newIndex;
                    -- local mData = self._cardListDate:Get(newIndex);
                    -- 新数据
                    -- local mHeroCard = self._objForBaseTable[obj];
                    -- self._allHaveHeroCardDic[mData]=mHeroCard;
                    -- print("left,remove:"..nIndex.."add:"..newIndex);
                    self._haveHeroList[newIndex] = obj;
                    -- self._cardIndexTable[obj]=newIndex;
                    -- self:SetSingleHeroCardData(mHeroCard, mData);
                    -- if  self._cardIndexList:Get(nIndex) then
                    --                         self._cardIndexList:Remove(nIndex);
                    --                         self._cardIndexList:Push(newIndex);

                    --  end

                end

            end
            -- nextIndex = nowindex + 7;
        end

    end
    local mHeroCard = self._objForBaseTable[obj];
    local mData = self._cardListDate:Get(mmIndex);
    self:SetSingleHeroCardData(mHeroCard, mData);
    self:SetObjWithParent(obj);

end

-- 求出△t
function UIScroll:AskDotT(drMiddleObj)
    local dotT = nil;
    -- 如果向右
    if self._mMove > 0 then
        dotT =(drMiddleObj.transform.localPosition.x - self._ninePositionDic[self._middleNum].ninePostion) /(self._ninePositionDic[self._middleNum + 1].ninePostion - self._ninePositionDic[self._middleNum].ninePostion);

        -- 如果向左
    elseif self._mMove < 0 then

        dotT =(self._ninePositionDic[self._middleNum].ninePostion - drMiddleObj.transform.localPosition.x) /(self._ninePositionDic[self._middleNum].ninePostion - self._ninePositionDic[self._middleNum - 1].ninePostion);

    end

    if dotT >= 1 then
        dotT = 1;
    end

    if dotT <= 0 then
        dotT = 0;
    end

    return dotT;
end


-- 插值
-- @parem obj :变化物体,lastTable:原本编号，NowTable:现在编号
function UIScroll:LerpScorll(obj, lastTable, nowTable)

    local sPotion = self._lerpScrolleDic[obj]._ninePositionDic;
    local sScale = self._lerpScrolleDic[obj]._nineScaleDic;

    if sPotion == nil then
        -- print("sPotion ==nil");
        sPotion = lastTable.ninePostion;
        -- 原来的x轴
        self._lerpScrolleDic[obj]._ninePositionDic = sPotion;
    end

    -- print("UIScroll:LerpScorll,lastTable:  "..lastTable.ninePostion..",nowTable:  "..nowTable.ninePostion);
    if sScale == nil then
        sScale = lastTable.nineScale;
        self._lerpScrolleDic[obj]._nineScaleDic = sScale;
    end

    -- print(sPotion,sScale);
    sPotion = sPotion - UnityEngine.Time.deltaTime * 500;
    sScale = sScale - UnityEngine.Time.deltaTime * 0.8;

    if sPotion <= nowTable.ninePostion then
        sPotion = nowTable.ninePostion;
    end

    if sScale <= nowTable.nineScale then
        sScale = nowTable.nineScale;
    end
    self._lerpScrolleDic[obj]._ninePositionDic = sPotion;
    self._lerpScrolleDic[obj]._nineScaleDic = sScale;
    -- print(sPotion,sScale);
    obj.transform.position = UnityEngine.Vector3(sPotion, obj.transform.position.y, obj.transform.position.z);
    obj.transform.localScale = UnityEngine.Vector3(sScale, sScale, sScale);
end

-- 找到最中间的武将卡索引
function UIScroll:MiddleHeroCardIndex()
    -- 初始化物体
    if self._dMiddleObj == nil then
        local t1, t2 = math.modf(#self._ninePositionDic / 2);
        self._mMiddleObjIndex = self._middleNum - t1 + 1;
    end
    if self._mMiddleObjIndex > #self._haveHeroList - 1 then
        self._mMiddleObjIndex = #self._haveHeroList - 1
    end
    if self._mMiddleObjIndex < 2 then
        self._mMiddleObjIndex = 2;
    end
    return self._mMiddleObjIndex;
end

-- 刷新加载UI
function UIScroll:RefreshUIShow(cardDataList)
    self:SetSortListObj(false);
    self._cardIndexList:Clear();
    -- self._allHaveHeroCardDic={};
    -- 默认隐藏了
    local size = math.min(cardDataList:Count(), self._sumNum);
    -- print("cardSize:" .. size);
    local mObjIndex = -1;

    for index = 1, size do

        local cardData = cardDataList:Get(index);
        -- print(cardData);
        -- continue
        while true do
            if cardData == nil then
                -- print("cardData is nil,Index:" .. index)
                break
            end
            local mdata = DataUIConfig[UIType.UIHeroCard];

            -- 如果没有卡牌物体就加载，如果有了就重新刷数据（此时卡牌数量可能会有所变化）
            if index - table.getn(self._allHaveHeroCardIndexDic) > 0 then
                -- print(table.getn(self._allHaveHeroCardIndexDic));
                local mHeroCard = HeroCard.new();
                GameResFactory.Instance():GetUIPrefab(mdata.ResourcePath, self.transform, mHeroCard, function(go)
                    self:SetSingleHeroCardData(mHeroCard, cardData);
                    self._allHaveHeroCardIndexDic[index] = mHeroCard;
                    -- self._allHeroCardDic[heroCard.iD] = mHeroCard;
                    -- 加入键值对
                    -- self._allHaveHeroCardDic[cardData] = mHeroCard;
                    -- 物体所对应的脚本
                    self._objForBaseTable[mHeroCard.gameObject] = mHeroCard;
                    local mHeroCard = self._allHaveHeroCardIndexDic[index];
                    self._haveHeroList[index] = mHeroCard.gameObject;
                    -- 加入键值对
                    self._cardIndexTable[mHeroCard.gameObject] = index;

                    -- local mHeroCard =self._allHaveHeroCardIndexDic[index];-- self._allHaveHeroCardDic[cardData];
                    mHeroCard.transform:SetParent(self._testParentObjLeft);
                    mHeroCard.transform.localPosition = Vector3.zero;
                    mObjIndex = self:RefreshCarPart(index, mObjIndex, mHeroCard);
                    -- print("mindex:"..mObjIndex);
                    if self._cardIndexList:Get(index) == nil then
                        self._cardIndexList:Push(index);
                    end
                    mObjIndex = mObjIndex + 1;
                end );

            else
                -- 刷新数据（每次都会刷新最新数据）
                local mHeroCard = self._allHaveHeroCardIndexDic[index];
                self:SetSingleHeroCardData(mHeroCard, cardData);
                -- self._allHaveHeroCardIndexDic[index] = mHeroCard;
                -- self._allHeroCardDic[heroCard.iD] = mHeroCard;
                -- 加入键值对
                -- self._allHaveHeroCardDic[cardData] = mHeroCard;
                -- 物体所对应的脚本
                self._objForBaseTable[mHeroCard.gameObject] = mHeroCard;
                local mHeroCard = self._allHaveHeroCardIndexDic[index];
                self._haveHeroList[index] = mHeroCard.gameObject;
                -- 加入键值对
                self._cardIndexTable[mHeroCard.gameObject] = index;

                -- local mHeroCard =self._allHaveHeroCardIndexDic[index];-- self._allHaveHeroCardDic[cardData];
                mHeroCard.transform:SetParent(self._testParentObjLeft);
                mHeroCard.transform.localPosition = Vector3.zero;
                mObjIndex = self:RefreshCarPart(index, mObjIndex, mHeroCard);
                if self._cardIndexList:Get(index) == nil then
                    self._cardIndexList:Push(index);
                end
                mObjIndex = mObjIndex + 1;
            end

            break
        end


    end
    -- 多余的隐藏
    for index = size + 1, #self._allHaveHeroCardIndexDic do
        self._allHaveHeroCardIndexDic[index].gameObject:SetActive(false);
    end
end


-- 设置当前是否选中的状态
function UIScroll:SetCardChooseState(heroTable)
    self.HeroCardTable = heroTable
    for k, v in pairs(self._allHaveHeroCardIndexDic) do
        v:HeroCardState(v.heroCard)
    end

    for k1, v1 in pairs(heroTable) do
        for k, v in pairs(self._allHaveHeroCardIndexDic) do
            if v1._heroId == v._heroId and v1.gameObject.activeSelf then
                v:SetChooseState();
            else
                v:HeroCardState(v.heroCard)
            end
            isOpenAwake = UIService:Instance():GetOpenedUI(UIType.UIHeroAwake);
            isOpenAdvnace = UIService:Instance():GetOpenedUI(UIType.UIHeroAdvance);
            isOpenSplite = UIService:Instance():GetOpenedUI(UIType.UIHeroSpliteHero);
            isOpenResearch = UIService:Instance():GetOpenedUI(UIType.UITactisResearch);
            isOpenransExp = UIService:Instance():GetOpenedUI(UIType.UITactisTransExp);
            if isOpenAwake or isOpenSplite or isOpenAdvnace or isOpenResearch or isOpenransExp then
                if self:CheckInTable(v.heroCard) then
                    v:HeroCardState(v.heroCard)
                else
                    v:SetChooseState()
                end
                -- 初始化卡牌的状态
            else
                v:HeroCardState(v.heroCard)
            end
        end
    end

end


-- 刷新位置和大小
function UIScroll:RefreshCarPart(index, mObjIndex, mHeroCard)
    -- 初始化位置
    if index == 1 then
        local distanece = 99999999;

        local targetX = { };
        -- 找到最近的位置
        mObjIndex = self._middleNum - 1;
        targetX = self._ninePositionDic[mObjIndex];

        self:SetObjPoSc(mHeroCard.gameObject, targetX);

    else
        -- 如果大于1

        -- 把剩下几个位置给他
        if mObjIndex < #self._ninePositionDic then
            -- print(mObjIndex);
            -- print(mHeroCard.gameObject.transform:GetSiblingIndex());
            self:SetObjPoSc(mHeroCard.gameObject, self._ninePositionDic[mObjIndex]);

            -- 大于的都放入第11个位置
        else

            self:SetObjPoSc(mHeroCard.gameObject, self._ninePositionDic[#self._ninePositionDic]);
        end
    end


    self:SetObjInParent(mObjIndex, mHeroCard.gameObject);

    return mObjIndex;
end


-- 设置父物体和层级
function UIScroll:SetObjInParent(mObjIndex, obj)

    if mObjIndex <= self._parentNum then
        obj.transform:SetParent(self._testParentObjLeft.transform);
        obj.transform:SetAsLastSibling();
    else

        obj.transform:SetParent(self._testParentObjRight.transform);
        obj.transform:SetAsFirstSibling();

    end
end

-- 获取父物体
function UIScroll:GetParentModel(mObjIndex, size)

    if mObjIndex <= self._parentNum then

        return self._testParentObjLeft.transform, self._lefetChildNum;
    else

        return self._testParentObjRight.transform, size - self._lefetChildNum;

    end
end 

-- 设置单个武将卡的信息
function UIScroll:SetSingleHeroCardData(mHeroCard, heroCard)
    mHeroCard:Init();
    mHeroCard:SetClickModel(true)
    mHeroCard:SetHeroCardMessage(heroCard, true);
    if (mHeroCard.gameObject.activeSelf == false) then
        mHeroCard.gameObject:SetActive(true);
    end
    local isOpen = UIService:Instance():GetOpenedUI(UIType.UIHeroSpliteHero);
    if (isOpen == false) then
        isOpen = UIService:Instance():GetOpenedUI(UIType.UITactisTransExp);
    end
    if (isOpen == false) then
        isOpen = UIService:Instance():GetOpenedUI(UIType.UITactisResearch);
    end
    mHeroCard:SetHeroInArmy(heroCard);
    local baseClass = UIService:Instance():GetUIClass(UIType.ArmyFunctionUI);
    local isArmyFunctionOpen = UIService:Instance():GetOpenedUI(UIType.ArmyFunctionUI);
    if baseClass ~= nil and isArmyFunctionOpen == true then
        local building = baseClass.curBuilding;
        if building ~= nil then
            mHeroCard:SetHeroBelongsCityName(heroCard, building._id);
        end
    end
    if isOpen then
        mHeroCard:HeroCardState(heroCard)
        -- 初始化卡牌的状态
    else
        mHeroCard:HeroCardState(heroCard)
    end
    isOpenAwake = UIService:Instance():GetOpenedUI(UIType.UIHeroAwake);
    isOpenAdvnace = UIService:Instance():GetOpenedUI(UIType.UIHeroAdvance);
    isOpenSplite = UIService:Instance():GetOpenedUI(UIType.UIHeroSpliteHero);
    isOpenResearch = UIService:Instance():GetOpenedUI(UIType.UITactisResearch);
    isOpenransExp = UIService:Instance():GetOpenedUI(UIType.UITactisTransExp);
    if isOpenAwake or isOpenSplite or isOpenAdvnace or isOpenResearch or isOpenransExp then
        if self:CheckInTable(heroCard) then
            mHeroCard:HeroCardState(heroCard)
        else
            mHeroCard:SetChooseState()
        end
        -- 初始化卡牌的状态
    else
        mHeroCard:HeroCardStateNil()
    end
    -- 部队中武将设置
    if UIService:Instance():GetOpenedUI(UIType.ArmyFunctionUI) then
        mHeroCard:SetStatePicFalse()
    end
end

-- 设置InitsCard
function UIScroll:CheckInTable(info)
    for k, v in pairs(self.HeroCardTable) do
        if info == v.heroCard and v.gameObject.activeSelf then
            return false
        end
    end
    return true
end

function UIScroll:OnClickHeroBtn(obj, eventData)
    -- print("ONClick");
end

-- 不重置排序
function UIScroll:SortingCardList(cardDataList)
    if cardDataList == nil then
        print("self._cardIndexList==nil or cardDataList==nil");
        return;
    end
    self._cardListDate = cardDataList;
    if self._cardListDate:Count() == 1 then
        self._mMiddleObjIndex = 1;
    else
        self:MiddleHeroCardIndex();
    end

    if self._mMiddleObjIndex then
        local mMiddleObj = self._haveHeroList[self._mMiddleObjIndex];
        if mMiddleObj then
            for index = self._mMiddleObjIndex - self._fixedNum, self._mMiddleObjIndex + self._fixedNum do
                local obj = self._haveHeroList[index];
                local mData = cardDataList:Get(index);
                if obj and mData then
                    local mHeroCard = self._objForBaseTable[obj];
                    self:SetSingleHeroCardData(mHeroCard, mData);
                    self._cardIndexTable[obj] = index;
                end
            end
        end
    end
end


-- 注册控件
function UIScroll:DoDataExchange()

    self._testParentObjLeft = self:RegisterController(UnityEngine.RectTransform, "Scroll View/Viewport/Content/Left");
    self._testParentObjRight = self:RegisterController(UnityEngine.RectTransform, "Scroll View/Viewport/Content/Right");

    self._modelParentObjRight = self:RegisterController(UnityEngine.RectTransform, "ScrollModel/Content/Right");
    self._modelParentObjLeft = self:RegisterController(UnityEngine.RectTransform, "ScrollModel/Content/Left");

    self._scrollRect = self:RegisterController(UnityEngine.RectTransform, "Scroll View/Viewport/ScrollObj");

    self._scrollSlider = self:RegisterController(UnityEngine.UI.Scrollbar, "Scroll View/Scrollbar Horizontal");
    self._SortListObj = self:RegisterController(UnityEngine.Transform, "SortListObj");
    self._SortArmyBtn = self:RegisterController(UnityEngine.Transform, "SortArmyBtn");
    self._CloseArmyConfigBtn = self:RegisterController(UnityEngine.Transform, "CloseArmyConfigBtn");
    self._Backgrounds = self:RegisterController(UnityEngine.Transform, "Backgrounds");
    self._Scrollbar = self:RegisterController(UnityEngine.Transform, "Scroll View/Scrollbar Horizontal");
    -- print(self._scrollRect);
end

-- 注册控件点击事件
function UIScroll:DoEventAdd()

    -- self:InitArmyCamp();

end

-- @parem  true全色，false浅色
function UIScroll:SetPrefabColor(obj, mBool)
    if obj == nil then
        -- print("obj is nil");
        return;

    end

end

-- 拖拽
-- @parem obj:物体，eventData:事件回调
function UIScroll:OnDragStartBtn(obj, eventData)
    -- print("UIScroll.OnDragStartBtn=================");


    -- print(obj.name);
    if self._BeDragObj == nil then
        -- print("self._BeDragObj is nil");
        return;
    end

    if self._BeDragBase then
        self._BeDragBase:SetCardAlpha(false)
    end

    if obj == nil then
        -- print("obj is nil");
    end

    if self._curDragObj == nil then
        -- print("self._curDragObj is nil");
        return;
    end

    -- local mImage=  self._curDragObj:GetComponent(typeof(UnityEngine.UI.Image));
    -- mImage.Color.alpha=0.5;

    local localPositonVec3 = UnityEngine.Vector3.zero;
    if self._curDragObj.transform == nil then
        -- print("self._curDragObj.transform ==nil");
        return;
    end

    localPositonVec3.z = self._curDragObj.transform.localPosition.z;

    local _localPosition = nil;
    local isBoolPositon, _localPosition = UnityEngine.RectTransformUtility.ScreenPointToLocalPointInRectangle(self.armyObj.gameObject:GetComponent(typeof(UnityEngine.RectTransform)), eventData.position, eventData.pressEventCamera);

    self._localPointerPosition = _localPosition;
    if isBoolPositon then
        localPositonVec3.x = _localPosition.x;
        localPositonVec3.y = _localPosition.y;
        self._curDragObj.gameObject:SetActive(true);
        self._curDragObj.gameObject.transform.localPosition = localPositonVec3;
    end


end

function UIScroll:SetPostionObj(obj)
    self.armyObj = obj;
end

-- 隐藏时都作为左边物体的子集
function UIScroll:OnHide(param)

    local size = self._testParentObjRight.transform.childCount;

    if size ~= 0 then
        for index = size, 1, -1 do
            local tras = self._testParentObjRight.transform:GetChild(index - 1);
            if tras then
                tras:SetParent(self._testParentObjLeft);
                tras:SetAsLastSibling();
            end
        end

    end

end

function UIScroll:SetSortListObj(visable)
    if (self._SortListObj) then
        self._SortListObj.gameObject:SetActive(visable);
    end

end

function UIScroll:SetFalseForSkill(position)
    local visable = false;
    if (self._SortArmyBtn) then
        self._SortArmyBtn.gameObject:SetActive(visable);
    end
    if (self._CloseArmyConfigBtn) then
        self._CloseArmyConfigBtn.gameObject:SetActive(visable);
    end
    if (self._Backgrounds) then
        self._Backgrounds.gameObject:SetActive(visable);
    end
    -- if (position) then
    --     self._Scrollbar.localPosition = position;
    --     print(self._Scrollbar.localPosition.x);
    -- end
end

return UIScroll;