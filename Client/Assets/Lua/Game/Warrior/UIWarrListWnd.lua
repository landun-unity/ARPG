
-- 城池入口队列窗体

local UIBase = require("Game/UI/UIBase");
local UIWarrListWnd = class("UIWarrListWnd", UIBase);
local UIType = require("Game/UI/UIType");
local UIService = require("Game/UI/UIService");
local ArmyManage=require("Game/Army/ArmyManage");


function UIWarrListWnd:ctor()

    UIWarrListWnd.super.ctor(self);
    -- 背景
    self.mBackground = nil;
    -- 创建部队的列表容器
    self.mScorllContent = nil;
    -- 保持已经创建的卡牌
    self.mCardList = { };
    -- 保存当前队伍卡牌信息
    self.mArmyList = { };


end

function UIWarrListWnd:OnShow()

    self:CreateWarriorCard();
end

function UIWarrListWnd:DoDataExchange()
    self.mBackground = self:RegisterController(UnityEngine.Transform, "Background");
    self.mScorllContent = self:RegisterController(UnityEngine.Transform, "ArmyScorll/ViewPoint/Content");
    self.mBackground.gameObject:SetActive(false);
end

-- 注册控件事件
function UIWarrListWnd:DoEventAdd()
    -- self:AddListener(self._mOnceBtn, self.OnClickOnceBtn)

end

-- count创建个数
function UIWarrListWnd:CreateWarriorCard()

    -- 取第一个部队
    local mCurArmyInfo = ArmyManage:GetMyArmyInMainCity(1);

    local count = 3;
    -- self:ClearPerObj();

    for index = 1, count do
        -- 如果没创建就创建
        if self.mCardList[index] == nil then
            local UIWarrCardInfo = require("Game/Warrior/UIWarrCardInfo").new();
            GameResFactory.Instance():GetUIPrefab("UIPrefab_UIWarrCard", self.mScorllContent, UIWarrCardInfo, function(go)
                UIWarrCardInfo:Init()
                self.mCardList[index] = UIWarrCardInfo;
                -- 设置数据
                UIWarrCardInfo:SetWarrCardDataInfo(mCurArmyInfo);
            end );
        else
            -- 有就刷新数据
            if self.mCardList[index] then
                local tempUIWarrCardInfo = self.mCardList[index];
                -- 保证是显示的
                tempUIWarrCardInfo:SetVisible(true);
                tempUIWarrCardInfo:SetWarrCardDataInfo(mCurArmyInfo);
            end
        end

    end
    -- 如果新创建个数少于已有的 就隐藏
    if #self.mCardList > count then
        for index = count, #self.mCardList do
            self.mCardList[index]:SetVisible(false);
        end

    end
end

-- 删除之前创建的
-- function UIWarrListWnd:ClearPerObj()
--    GameResFactory.Instance():DestroyOldChid(self.mScorllContent.gameObject);
-- end 

return UIWarrListWnd;
