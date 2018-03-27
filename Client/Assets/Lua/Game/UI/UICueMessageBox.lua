--[[
	提示功能UI
	王伟
--]]

local UIBase = require("Game/UI/UIBase");
local UIType = require("Game/UI/UIType");
local UIService = require("Game/UI/UIService");
local UICueMessageType = require("Game/UI/UICueMessageType");
local CueMessageConfig = require("Game/Table/model/DataText");
local UICueMessageBox = class("UICueMessageBox", UIBase);

--[[
	构造函数
--]]
function UICueMessageBox:ctor()
    -- body
    UICueMessageBox.super.ctor(self);
    self._MessageBox = nil;
end

--[[
	注册控件
--]]
function UICueMessageBox:DoDataExchange()
    -- body
    self._MessageBox = self:RegisterController(UnityEngine.UI.Text, "Text");
end

--[[
	显示信息并在倒数计时后隐藏
--]]

function UICueMessageBox:OnShow(textID)
    if self.marchTimer ~= nil then
        self.marchTimer:Stop();
    end


    if type(textID) == "table" then
        -- body
        local MessageData = CueMessageConfig[textID[1]];
        local text = MessageData.TextContent;
        if textID[2] ~= nil then
            text = self:NewString(text, textID[2])
        end
        self._MessageBox.text = tostring(text);
        self.marchTimer = Timer.New(
        function()
            self.marchTimer:Stop();
            self.gameObject:SetActive(false);
        end , 3, 1, false);
        self.marchTimer:Start();

    else
        -- body
        local MessageData = CueMessageConfig[textID];
        local text = MessageData.TextContent;

        self._MessageBox.text = tostring(text);
        -- self.showTime = 3;
        self.marchTimer = Timer.New(
        function()            
            self.gameObject:SetActive(false);
            self.marchTimer:Stop();
        end , 3, 1, false);
        self.marchTimer:Start();
    end

end

function UICueMessageBox:Stop()
    self.gameObject:SetActive(false);
    self.marchTimer:Stop();
end

function UICueMessageBox:NewString(args, data)

    local newString = self:Split(args, "/");
    local stringBack = "";
    for i = 1, table.getn(newString) do

        if data[i] == nil then
            data[i] = ""
        end
        stringBack = stringBack .. newString[i] .. data[i]
    end

    return stringBack
end



function UICueMessageBox:Split(szFullString, szSeparator)
    local nFindStartIndex = 1
    local nSplitIndex = 1
    local nSplitArray = { }
    while true do
        local nFindLastIndex = string.find(szFullString, szSeparator, nFindStartIndex)
        if not nFindLastIndex then
            nSplitArray[nSplitIndex] = string.sub(szFullString, nFindStartIndex, string.len(szFullString))
            break
        end

        nSplitArray[nSplitIndex] = string.sub(szFullString, nFindStartIndex, nFindLastIndex - 1)
        nFindStartIndex = nFindLastIndex + string.len(szSeparator)
        nSplitIndex = nSplitIndex + 1
    end
    return nSplitArray
end  





return UICueMessageBox;