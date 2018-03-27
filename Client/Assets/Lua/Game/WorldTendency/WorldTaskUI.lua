-- region *.lua
-- Date
local UIBase = require("Game/UI/UIBase");
local WorldTaskUI = class("WorldTaskUI", UIBase)

function WorldTaskUI:ctor()

    WorldTaskUI.super.ctor(self)

    self.Title = nil;
    self.Target = nil;
    self.doneManText = nil;
    self.doneMan = nil;
    self.processNum = nil;
    self.processImage = nil;
    self.processPercent = nil;
    self.isDone = nil;
    self.button = nil;
    self.processSlider = nil;

    self.taskInfo = nil;
    self.endTimeText = nil;
end


function WorldTaskUI:DoDataExchange()

    self.endTimeText = self:RegisterController(UnityEngine.UI.Text, "endTime")
    self.Title = self:RegisterController(UnityEngine.UI.Text, "title")
    self.Target = self:RegisterController(UnityEngine.UI.Text, "target")
    self.doneManText = self:RegisterController(UnityEngine.UI.Text, "taskinfo/Viewport/Content/Text")
    self.doneMan = self:RegisterController(UnityEngine.UI.Text, "taskinfo/Viewport/Content/doneLeague")
    self.processNum = self:RegisterController(UnityEngine.UI.Text, "taskinfo/Viewport/Content/process")
    self.processSlider = self:RegisterController(UnityEngine.UI.Image, "taskinfo/Viewport/Content/slider")
    self.processImage = self:RegisterController(UnityEngine.UI.Image, "taskinfo/Viewport/Content/slider/Image")
    self.processPercent = self:RegisterController(UnityEngine.UI.Text, "taskinfo/Viewport/Content/slider/Text")
    self.isDone = self:RegisterController(UnityEngine.UI.Text, "taskinfo/Viewport/Content/done")
    self.button = self:RegisterController(UnityEngine.UI.Button, "Button")

end

function WorldTaskUI:DoEventAdd()


    self:AddListener(self.button, self.OnClickbutton)

end


function WorldTaskUI:OnShow()



end

function WorldTaskUI:SetTaskMessage(mtask)

    self.taskInfo = mtask
    self.Title.text = mtask.Data.Name
    self.Target.text = mtask.Data.Target

    if mtask.paramValueTwo:Count() == 0 then

        self.doneManText.text = "达成同盟"
        self.doneMan.text = "暂无同盟达成"
    else
        self.doneManText.text = "达成同盟"
        self.doneMan.text = ""
        -- --print(mtask.paramValueTwo:Get(1).name)
        self.doneMan.text = mtask.paramValueTwo:Get(1).name
        if mtask.paramValueTwo:Get(2) ~= nil then
            self.doneMan.text = mtask.paramValueTwo:Get(1).name .. "\n" .. mtask.paramValueTwo:Get(2).name
        end
        if mtask.paramValueTwo:Get(3) ~= nil then
            self.doneMan.text = mtask.paramValueTwo:Get(1).name .. "\n" .. mtask.paramValueTwo:Get(2).name .. "\n" .. mtask.paramValueTwo:Get(3).name
        end
    end
    -- --print(mtask.tableId)
    -- --print(mtask.Data.Type)
    if mtask.Data.Type == 0 or mtask.Data.Type == 9 or mtask.Data.Type == 6 or mtask.Data.Type == 7 or mtask.Data.Type == 5 or mtask.Data.Type == 11 or mtask.Data.Type == 12 or mtask.Data.Type == 13 then

        self.processNum.gameObject:SetActive(false)
        self.processSlider.gameObject:SetActive(false)
        self.processPercent.gameObject:SetActive(false)
        self.doneMan.gameObject:SetActive(true)
        self.doneManText.gameObject:SetActive(true)

    else
        self.doneMan.gameObject:SetActive(false)
        self.doneManText.gameObject:SetActive(false)
        self.processNum.gameObject:SetActive(true)
        self.processSlider.gameObject:SetActive(true)
        self.processPercent.gameObject:SetActive(true)
        if mtask.Data.TypeParameter3 == 0 then
            self.processNum.text = mtask.paramValueOne .. "/" .. mtask.Data.TypeParameter2
            self.processImage.fillAmount = mtask.paramValueOne / mtask.Data.TypeParameter2
            self.processPercent.text = math.floor((mtask.paramValueOne /(mtask.Data.TypeParameter2)) * 100) .. "%"
        else
            self.processNum.text = mtask.paramValueOne / mtask.Data.TypeParameter3 * 100 .. "%"
             if mtask.paramValueOne / mtask.Data.TypeParameter3 * 100 >= mtask.Data.TypeParameter2 / 100 then
                self.processNum.text = mtask.Data.TypeParameter2 / 100 .. "%"
            end
            self.processImage.fillAmount =((mtask.paramValueOne / mtask.Data.TypeParameter3 * 100)/ mtask.Data.TypeParameter2*100)
            self.processPercent.text = math.floor(((mtask.paramValueOne / mtask.Data.TypeParameter3 * 100)/ mtask.Data.TypeParameter2*100) * 100) .. "%"
           if math.floor(((mtask.paramValueOne / mtask.Data.TypeParameter3 * 100)/ mtask.Data.TypeParameter2*100) * 100)>=100 then
              self.processPercent.text = 100 .. "%"
           end
        end
    end


    local time = mtask.endTime - PlayerService:Instance():GetLocalTime()

    if time > 0 and mtask.isDone == 0 then
        self.endTimeText.gameObject:SetActive(false)
        CommonService:Instance():TimeDown(UIType.WorldTendencyUI,mtask.endTime,self.endTimeText,function() self:timeEnd() end);
    else
        self.endTimeText.gameObject:SetActive(false)
    end

    if mtask.isDone == 1 then
        self.isDone.gameObject:SetActive(true)
        self.isDone.text = "达成"
    else
        self.isDone.gameObject:SetActive(false)
    end

end

function WorldTaskUI:OnClickbutton()

    -- 显示任务信息
    UIService:Instance():ShowUI(UIType.EpicInfo, self.taskInfo)

end

function WorldTaskUI:timeEnd()

    self.endTimeText.gameObject:SetActive(false)
    if self.timer ~= nil then
        self.timer:Stop();
        self.timer = nil;
        WorldTendencyService:Instance():SendWorldTendencyMessage()
    end
end

return WorldTaskUI