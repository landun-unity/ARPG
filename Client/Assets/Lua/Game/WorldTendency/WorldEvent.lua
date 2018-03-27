-- region *.lua
-- Date
local UIBase = require("Game/UI/UIBase");
local WorldEventUI = class("WorldEventUI", UIBase)
local DataEpicEvent = require("Game/Table/model/DataEpicEvent");

function WorldEventUI:ctor()

    WorldEventUI.super.ctor(self)

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
    self.intro = nil;
    self.Image1 = nil;
    self.Image2 = nil;
    self.Image3 = nil;
    self.Image4 = nil;
    self.Image5 = nil;
    self.Text1 = nil;
    self.Text2 = nil;
    self.Text3 = nil;
    self.Text4 = nil;
    self.Text5 = nil;
    self.btn1 = nil;
    self.btn2 = nil;
    self.btn3 = nil;
    self.btn4 = nil;
    self.btn5 = nil;
    self.eventInfo = nil;
    self.num = nil
    self.endTimeText = nil;
    self.nextImage = nil
    self.redPoint = nil;
end


function WorldEventUI:DoDataExchange()
    self.nextImage = self:RegisterController(UnityEngine.UI.Image, "IndicateSignImage")
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
    self.redPoint = self:RegisterController(UnityEngine.Transform, "redPoint")
    self.taskinfo = self:RegisterController(UnityEngine.Transform, "taskinfo")
    self.panel = self:RegisterController(UnityEngine.UI.Button, "Panel")

    self.getAward = self:RegisterController(UnityEngine.UI.Button, "getAward")
    self.intro = self:RegisterController(UnityEngine.UI.Text, "intro")
    self.Image1 = self:RegisterController(UnityEngine.UI.Image, "Image1")
    self.Image2 = self:RegisterController(UnityEngine.UI.Image, "Image2")
    self.Image3 = self:RegisterController(UnityEngine.UI.Image, "Image3")
    self.Image4 = self:RegisterController(UnityEngine.UI.Image, "Image4")
    self.Image5 = self:RegisterController(UnityEngine.UI.Image, "Image5")
    self.Text1 = self:RegisterController(UnityEngine.UI.Text, "Image1/Text")
    self.Text2 = self:RegisterController(UnityEngine.UI.Text, "Image2/Text")
    self.Text3 = self:RegisterController(UnityEngine.UI.Text, "Image3/Text")
    self.Text4 = self:RegisterController(UnityEngine.UI.Text, "Image4/Text")
    self.Text5 = self:RegisterController(UnityEngine.UI.Text, "Image5/Text")
    self.btn1 = self:RegisterController(UnityEngine.UI.Button, "Image1")
    self.btn2 = self:RegisterController(UnityEngine.UI.Button, "Image2")
    self.btn3 = self:RegisterController(UnityEngine.UI.Button, "Image3")
    self.btn4 = self:RegisterController(UnityEngine.UI.Button, "Image4")
    self.btn5 = self:RegisterController(UnityEngine.UI.Button, "Image5")
    self.num = self:RegisterController(UnityEngine.UI.Text, "Image/Text")
end

function WorldEventUI:DoEventAdd()

    self:AddListener(self.getAward, self.OnClickgetAward)
    self:AddListener(self.button, self.OnClickbutton)
    self:AddListener(self.btn1, self.OnClickbutton1)
    self:AddListener(self.btn2, self.OnClickbutton2)
    self:AddListener(self.btn3, self.OnClickbutton3)
    self:AddListener(self.btn4, self.OnClickbutton4)
    self:AddListener(self.btn5, self.OnClickbutton5)

end

function WorldEventUI:OnClickgetAward()
    local data = { self.eventInfo.Data.AwardParameter2[1],"DiamondAward" }
    UIService:Instance():ShowUI(UIType.UIGetJade, data)
    WorldTendencyService:Instance():SendGetAwardMessage(self.eventInfo.tableId)
end


function WorldEventUI:OnShow()


end

function WorldEventUI:SetEventMessage(mtask)
    self.eventInfo = mtask;
    self.Title.text = mtask.Data.Name
    self.Target.text = mtask.Data.Target
    self.intro.text = mtask.Data.Explain;
    if mtask.Data.AwardParameter1[1] ~= nil then
        self.Image1.gameObject:SetActive(true)
        self.Image1.sprite = GameResFactory.Instance():GetResSprite(mtask.Data.RewardIcon[1]);
    else
        self.Image1.gameObject:SetActive(false)
    end
    if mtask.Data.OpenFunction[1] ~= nil then
        self.Image2.gameObject:SetActive(true)
        self.Image2.sprite = GameResFactory.Instance():GetResSprite(mtask.Data.OpenFunctionIcon[1]);
    else
        self.Image2.gameObject:SetActive(false)
    end
    if mtask.Data.OpenFunction[2] ~= nil then
        self.Image3.gameObject:SetActive(true)
        self.Image3.sprite = GameResFactory.Instance():GetResSprite(mtask.Data.OpenFunctionIcon[2]);
    else
        self.Image3.gameObject:SetActive(false)

    end
    if mtask.Data.OpenFunction[3] ~= nil then
        self.Image4.gameObject:SetActive(true)
        self.Image4.sprite = GameResFactory.Instance():GetResSprite(mtask.Data.OpenFunctionIcon[3]);
    else
        self.Image4.gameObject:SetActive(false)

    end
    if mtask.Data.OpenFunction[4] ~= nil then
        self.Image5.gameObject:SetActive(true)
        self.Image5.sprite = GameResFactory.Instance():GetResSprite(mtask.Data.OpenFunctionIcon[4])
        -- mtask.Data.OpenFunctionIcon[4]);--更新美术资源后需要暂替
    else
        self.Image5.gameObject:SetActive(false)
    end

    if mtask.isOpen == 1 then
        self.panel.gameObject:SetActive(false)
        self.taskinfo.gameObject:SetActive(true)
    else
        self.panel.gameObject:SetActive(true)
        self.taskinfo.gameObject:SetActive(false)
        self.getAward.gameObject:SetActive(false)
        return;
    end
    local time = mtask.endTime - PlayerService:Instance():GetLocalTime()


    if mtask.isOpen == 1 and mtask.doneTime == 0 then
        if mtask.Data.Duration ~= 0 then
            self.endTimeText.gameObject:SetActive(true)
            local cdTime = math.floor(time / 1000)
            if cdTime <= 0 then
                cdTime = 0;
            end
            self.endTimeText.text = CommonService:Instance():GetDateString(cdTime);
            CommonService:Instance():TimeDown(UIType.WorldTendencyUI, mtask.endTime, self.endTimeText, function() self:timeEnd() end);
        else
            self.endTimeText.gameObject:SetActive(false)
        end
    else
        self.endTimeText.gameObject:SetActive(false)
    end

    if mtask.paramValueTwo:Count() == 0 then

        self.doneManText.text = "达成同盟"
        self.doneMan.text = "暂无同盟达成"
    else
        self.doneManText.text = "达成同盟"
        self.doneMan.text = ""
        self.doneMan.text = mtask.paramValueTwo:Get(1).name
        if mtask.paramValueTwo:Get(2) ~= nil then
            self.doneMan.text = mtask.paramValueTwo:Get(1).name .. "\n" .. mtask.paramValueTwo:Get(2).name
        end
        if mtask.paramValueTwo:Get(3) ~= nil then
            self.doneMan.text = mtask.paramValueTwo:Get(1).name .. "\n" .. mtask.paramValueTwo:Get(2).name .. "\n" .. mtask.paramValueTwo:Get(3).name
        end
    end

    -- --print(mtask.Data.Type)
    if mtask.Data.Type == 9 or mtask.Data.Type == 6 or mtask.Data.Type == 7 or mtask.Data.Type == 5 or mtask.Data.Type == 11 or mtask.Data.Type == 12 or mtask.Data.Type == 13 then

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
        self.processNum.text = mtask.paramValueOne .. "/" .. mtask.Data.TypeParameter2
        self.processImage.fillAmount = mtask.paramValueOne / mtask.Data.TypeParameter2
        self.processPercent.text = math.floor(mtask.paramValueOne * 100 / mtask.Data.TypeParameter2) .. "%"
    end
    -- --print(mtask.isGetAward)
    if mtask.doneTime == 0 then
        self.getAward.gameObject:SetActive(false)
        self.isDone.text = "未达成"
        self.isDone.gameObject:SetActive(false)
        self.Text1.text = mtask.Data.AwardParameter2[1]
        self.Text2.text = "开启"
        self.Text3.text = "开启"
        self.Text4.text = "开启"
        self.Text5.text = "开启"
    else

        if mtask.doneTime < mtask.endTime then
            self.isDone.text = "达成"
        else
            self.isDone.text = "结束"
        end

        if mtask.isGetAward == 0 and mtask.couldGetAward == 1 then
            self.getAward.gameObject:SetActive(true)
            self.isDone.gameObject:SetActive(false)
            self.Text1.text = mtask.Data.AwardParameter2[1]
            self.Text2.text = "已开启"
            self.Text3.text = "已开启"
            self.Text4.text = "已开启"
            self.Text5.text = "已开启"
        else
            self.getAward.gameObject:SetActive(false)
            self.isDone.gameObject:SetActive(true)

            if mtask.isGetAward == 1 then
                self.Text1.text = "已领取"
            else
                self.Text1.text = mtask.Data.AwardParameter2[1]
            end
            self.Text2.text = "已开启"
            self.Text3.text = "已开启"
            self.Text4.text = "已开启"
            self.Text5.text = "已开启"
        end
    end
    -- print(mtask.Data.Name .. "mtask.isOpen:" .. mtask.isOpen .. " mtask.isDone:" .. mtask.isDone .. " mtask.doneTime:" .. mtask.doneTime .. " mtask.doneTime:" .. mtask.endTime);
    if mtask.isGetAward == 0 and mtask.couldGetAward == 1 and mtask.isOpen == 1 then
        self.redPoint.gameObject:SetActive(true)
    else
        self.redPoint.gameObject:SetActive(false)
    end
end

function WorldEventUI:OnClickbutton()
    UIService:Instance():ShowUI(UIType.EpicInfo, self.eventInfo)
end


function WorldEventUI:SetEventNum(args)
    self.num.text = args
end

function WorldEventUI:SetLastImageFalse()
    self.nextImage.gameObject:SetActive(false)
end

function WorldEventUI:OnClickbutton1()

    local data = { self.eventInfo.Data.RewardIcon[1], "奖励玉" .. self.eventInfo.Data.AwardParameter2[1] };
    UIService:Instance():ShowUI(UIType.UIClickPic, data)
end

function WorldEventUI:OnClickbutton2()
    local data = { self.eventInfo.Data.OpenFunctionIcon[1], self.eventInfo.Data.OpenFunctionExplain[1] };
    UIService:Instance():ShowUI(UIType.UIClickPic, data)
end
function WorldEventUI:OnClickbutton3()
    local data = { self.eventInfo.Data.OpenFunctionIcon[2], self.eventInfo.Data.OpenFunctionExplain[2] };
    UIService:Instance():ShowUI(UIType.UIClickPic, data)
end
function WorldEventUI:OnClickbutton4()
    local data = { self.eventInfo.Data.OpenFunctionIcon[3], self.eventInfo.Data.OpenFunctionExplain[3] };
    UIService:Instance():ShowUI(UIType.UIClickPic, data)
end
function WorldEventUI:OnClickbutton5()
    local data = { self.eventInfo.Data.OpenFunctionIcon[4], self.eventInfo.Data.OpenFunctionExplain[4] };
    -- self.eventInfo.Data.OpenFunctionExplain[4] };---更新美术资源之后这个地方需要替换
    UIService:Instance():ShowUI(UIType.UIClickPic, data)
end


function WorldEventUI:timeEnd()
    self.endTimeText.gameObject:SetActive(false);
end

return WorldEventUI