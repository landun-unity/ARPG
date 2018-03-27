-- region *.lua
-- Date 16/10/13
-- 邀请加入同盟界面

local UIBase = require("Game/UI/UIBase")
local UIService = require("Game/UI/UIService")
local UIType = require("Game/UI/UIType")
local List = require("common/List")
local UIConfigTable = require("Game/Table/model/DataUIConfig");

local InviteLeagueUI = require("Game/League/InviteLeagueUI")
local LeagueInviteUI = class("LeagueInviteUI", UIBase); 

function LeagueInviteUI:ctor()

    LeagueInviteUI.super.ctor(self);
    self.LeagueBackBtn = nil;
    self._parentObj = nil;
    self._beInventedList = List:new();
    self._prefabPath = UIConfigTable[UIType.InviteLeagueUI].ResourcePath;
    self._beInventedLeagues = { };
    self._MembMap = { };
end


-- 注册控件
function LeagueInviteUI:DoDataExchange()

    self.LeagueBackBtn = self:RegisterController(UnityEngine.UI.Button, "Back")
    self._parentObj = self:RegisterController(UnityEngine.Transform, "Scroll View/Viewport/Content")

end

-- 注册点击事件
function LeagueInviteUI:DoEventAdd()

    self:AddListener(self.LeagueBackBtn, self.OnClickLeagueBackBtn)

end

function LeagueInviteUI:OnShow(msg)


    local oldSize = self._parentObj.transform.childCount;

    self._beInventedList = msg.list;

    local size = self._beInventedList:Count();

    for i = 1, size do

        local mInviteLeagueUI = InviteLeagueUI.new();
        local memberData = self._beInventedList:Get(i)

        if i > oldSize then
            GameResFactory.Instance():GetUIPrefab( self._prefabPath, self._parentObj, mInviteLeagueUI, function(go)
                mInviteLeagueUI:Init();
                mInviteLeagueUI:SetInviteLeagueMessage(memberData)
                mInviteLeagueUI.gameObject:SetActive(true);
                if self._MembMap[i] == nil then
                    self._MembMap[i] = mInviteLeagueUI;
                end
            end
            )
        else
            local mdata = self._MembMap[i];
            if mdata ~= nil then
                mdata:Init();
                mdata:SetInviteLeagueMessage(memberData)
                mdata.gameObject:SetActive(true);
            end

        end
    end


    for i = 1, oldSize do


        if size < i then
            local child = self._parentObj.transform:GetChild(i - 1);
            child.gameObject:SetActive(false);
        end



    end




end


-- 点击按钮逻辑
function LeagueInviteUI:OnClickLeagueBackBtn()

    UIService:Instance():HideUI(UIType.LeagueInviteUI)
    UIService.Instance():ShowUI(UIType.LeagueDisExistUI)

end



return LeagueInviteUI
-- endregion
