-- region *.lua
-- Date
local UIBase = require("Game/UI/UIBase");
local EpicInfo = class("EpicInfo", UIBase)

function EpicInfo:ctor()

    EpicInfo.super.ctor(self)
    self.title = nil;
    self.detil = nil;
    self.doneText = nil;
    self.doneImage = nil;
    self.doneleague = nil;
    self.doneleagueName = nil;
    self.frontImage = nil;
    self.process = nil;
    self.processNum = nil;
    self.downTime = nil;
    self.openFunc = nil;
    self.award = nil;
    self.Fimage1 = nil;
    self.Fimage2 = nil;
    self.Fimage3 = nil;
    self.Fimage4 = nil;
    self.Fimage5 = nil;
    self.Fimage6 = nil;
    self.award = nil;
    self.Aimage1 = nil;
    self.Aimage2 = nil;
    self.Aimage3 = nil;
    self.Aimage4 = nil;
    self.Aimage5 = nil;
    self.Aimage6 = nil;
    self.FimageText1 = nil;
    self.FimageText2 = nil;
    self.FimageText3 = nil;
    self.FimageText4 = nil;
    self.FimageText5 = nil;
    self.Fimage6 = nil;
    self.Aimagetext1 = nil;
    self.Aimagetext2 = nil;
    self.Aimagetext3 = nil;
    self.Aimagetext4 = nil;
    self.Aimagetext5 = nil;
    self.taskState = nil;
    self.awardType = nil;
    self.button = nil;
    self.taskStateTime = nil;
    self.timer = 0;
    self.parent = nil;
end


function EpicInfo:DoDataExchange()

    self.parent = self:RegisterController(UnityEngine.Transform, "Viewport/Content");
    self.title = self:RegisterController(UnityEngine.UI.Text, "Text");
    self.detil = self:RegisterController(UnityEngine.UI.Text, "Viewport/Content/detil/detil");
    self.doneText = self:RegisterController(UnityEngine.UI.Text, "Viewport/Content/detil/doneText");
    self.doneImage = self:RegisterController(UnityEngine.UI.Text, "Viewport/Content/detil/doneImage");
    self.doneleague = self:RegisterController(UnityEngine.UI.Text, "Viewport/Content/detil/doneleague");
    self.doneleagueName = self:RegisterController(UnityEngine.UI.Text, "Viewport/Content/detil/doneleague/doneleaguename");
    self.process = self:RegisterController(UnityEngine.Transform, "Viewport/Content/detil/process");
    self.processNum = self:RegisterController(UnityEngine.UI.Text, "Viewport/Content/detil/process/processNum");
    self.frontImage = self:RegisterController(UnityEngine.UI.Image, "Viewport/Content/detil/process/frontImage");
    self.downTime = self:RegisterController(UnityEngine.UI.Text, "Viewport/Content/detil/donetime");
    self.openFunc = self:RegisterController(UnityEngine.Transform, "Viewport/Content/OpenFunc");
    self.award = self:RegisterController(UnityEngine.Transform, "Viewport/Content/Award");
    self.Fimage1 = self:RegisterController(UnityEngine.UI.Image, "Viewport/Content/OpenFunc/Image1");
    self.Fimage2 = self:RegisterController(UnityEngine.UI.Image, "Viewport/Content/OpenFunc/Image2");
    self.Fimage3 = self:RegisterController(UnityEngine.UI.Image, "Viewport/Content/OpenFunc/Image3");
    self.Fimage4 = self:RegisterController(UnityEngine.UI.Image, "Viewport/Content/OpenFunc/Image4");
    self.Fimage5 = self:RegisterController(UnityEngine.UI.Image, "Viewport/Content/OpenFunc/Image5");
    self.Fimage6 = self:RegisterController(UnityEngine.UI.Image, "Viewport/Content/OpenFunc/Image6");
    self.Aimage1 = self:RegisterController(UnityEngine.UI.Image, "Viewport/Content/Award/Image1");
    self.Aimage2 = self:RegisterController(UnityEngine.UI.Image, "Viewport/Content/Award/Image2");
    self.Aimage3 = self:RegisterController(UnityEngine.UI.Image, "Viewport/Content/Award/Image3");
    self.Aimage4 = self:RegisterController(UnityEngine.UI.Image, "Viewport/Content/Award/Image4");
    self.Aimage5 = self:RegisterController(UnityEngine.UI.Image, "Viewport/Content/Award/Image5");
    self.FimageText1 = self:RegisterController(UnityEngine.UI.Text, "Viewport/Content/OpenFunc/Image1/Text");
    self.FimageText2 = self:RegisterController(UnityEngine.UI.Text, "Viewport/Content/OpenFunc/Image2/Text");
    self.FimageText3 = self:RegisterController(UnityEngine.UI.Text, "Viewport/Content/OpenFunc/Image3/Text");
    self.FimageText4 = self:RegisterController(UnityEngine.UI.Text, "Viewport/Content/OpenFunc/Image4/Text");
    self.FimageText5 = self:RegisterController(UnityEngine.UI.Text, "Viewport/Content/OpenFunc/Image5/Text");
    self.FimageText6 = self:RegisterController(UnityEngine.UI.Text, "Viewport/Content/OpenFunc/Image6/Text");
    self.Aimagetext1 = self:RegisterController(UnityEngine.UI.Text, "Viewport/Content/Award/Image1/Text");
    self.Aimagetext2 = self:RegisterController(UnityEngine.UI.Text, "Viewport/Content/Award/Image2/Text");
    self.Aimagetext3 = self:RegisterController(UnityEngine.UI.Text, "Viewport/Content/Award/Image3/Text");
    self.Aimagetext4 = self:RegisterController(UnityEngine.UI.Text, "Viewport/Content/Award/Image4/Text");
    self.Aimagetext5 = self:RegisterController(UnityEngine.UI.Text, "Viewport/Content/Award/Image5/Text");
    self.taskState = self:RegisterController(UnityEngine.UI.Text, "Taskstate/Text");
    self.taskStateTime = self:RegisterController(UnityEngine.UI.Text, "Taskstate/timeText");
    self.button = self:RegisterController(UnityEngine.UI.Button, "Button");

end

function EpicInfo:DoEventAdd()
    self:AddListener(self.button, self.OnClickbutton)
end

function EpicInfo:OnShow(aa)
    self.parent.localPosition = Vector3.zero
    self.title.text = aa.Data.Name
    self.detil.text = aa.Data.Explain .. "\n" .. "【目标】：" .. aa.Data.Target
    self.doneText.text = aa.Data.Explain
    if aa.isDone == 1 then
        self.doneImage.gameObject:SetActive(true)
        if aa.doneTime < aa.endTime then
            self.doneImage.text = "达成"
        else
            if aa.tableId > 13 then
                self.doneImage.text = "达成"
            else
                self.doneImage.text = "结束"
            end
        end
        self.doneText.gameObject:SetActive(true)
    else
        self.doneText.gameObject:SetActive(false)
        self.doneImage.gameObject:SetActive(false)
    end
    self.doneleague.text = "达成同盟"
    self.doneleagueName.text = ""
    if aa.Data.Type == 7 then
        self.doneleague.text = "同盟排行"
        for i = 1, aa.paramValueTwo:Count() do
            if i % 2 == 1 then
                self.doneleagueName.text = self.doneleagueName.tex .. "第" .. i .. "名" .. aa.paramValueTwo:Get(i).name
            else
                self.doneleagueName.text = self.doneleagueName.tex .. "    " .. "第" .. i .. "名" .. aa.paramValueTwo:Get(i).name .. "\n"
            end
        end
    else
        for i = 1, aa.paramValueTwo:Count() do
            if i % 2 == 1 then
                self.doneleagueName.text = self.doneleagueName.text .. aa.paramValueTwo:Get(i).name
            else
                self.doneleagueName.text = self.doneleagueName.text .. "     " .. aa.paramValueTwo:Get(i).name .. "\n"
            end
        end
    end
    if aa.paramValueTwo:Count() == 0 then
        self.doneleagueName.text = "暂无同盟达成"
    end

    if aa.Data.TypeParameter3 == 0 then
        aa.Data.TypeParameter3 = aa.Data.TypeParameter2
        self.frontImage.fillAmount = aa.paramValueOne / aa.Data.TypeParameter3;
        self.processNum.text = math.floor(aa.paramValueOne / aa.Data.TypeParameter3 * 100) .. "%"
    else
        self.frontImage.fillAmount = aa.paramValueOne / aa.Data.TypeParameter3;
        self.processNum.text = math.floor(aa.paramValueOne / aa.Data.TypeParameter3 * 100) .. "%"
    end


    if aa.tableId > 13 then
        local num = aa.paramValueOne / aa.Data.TypeParameter3;
        local per =(num /(aa.Data.TypeParameter2 / 100) * 100) * 100;
        if per >= 100 then
            per = 100
        end
        self.frontImage.fillAmount = per / 100
        self.processNum.text = math.floor(self.frontImage.fillAmount * 100) .. "%"
    end

    if aa.Data.Type == 9 or aa.Data.Type == 6 or aa.Data.Type == 7 or aa.Data.Type == 5 or aa.Data.Type == 11 or aa.Data.Type == 12 or aa.Data.Type == 13 then
        self.process.gameObject:SetActive(false)
        self.doneleague.gameObject:SetActive(true)
    else
        self.process.gameObject:SetActive(true)
        self.doneleague.gameObject:SetActive(false)
    end

    self.downTime.text = "完成时间" .. os.date("%Y/%m/%d     %H:%M:%S  ", aa.doneTime / 1000)

    if aa.doneTime == 0 then
        self.downTime.gameObject:SetActive(false)
    else
        self.downTime.gameObject:SetActive(true)
    end


    if aa.Data.OpenFunction == nil then
        self.openFunc.gameObject:SetActive(false);
    else
        self.openFunc.gameObject:SetActive(true);
    end

    if aa.Data.OpenFunction[1] ~= nil then
        self.Fimage1.sprite = GameResFactory.Instance():GetResSprite(aa.Data.OpenFunctionIcon[1]);
        self.Fimage1.gameObject:SetActive(true)
        self.FimageText1.text = aa.Data.OpenFunctionExplain[1]
    else
        self.Fimage1.gameObject:SetActive(false)
    end
    if aa.Data.OpenFunction[2] ~= nil then
        self.Fimage2.sprite = GameResFactory.Instance():GetResSprite(aa.Data.OpenFunctionIcon[2]);
        self.FimageText2.text = aa.Data.OpenFunctionExplain[2]
        self.Fimage2.gameObject:SetActive(true)
    else
        self.Fimage2.gameObject:SetActive(false)
    end
    if aa.Data.OpenFunction[3] ~= nil then
        self.Fimage3.sprite = GameResFactory.Instance():GetResSprite(aa.Data.OpenFunctionIcon[3]);
        self.Fimage3.gameObject:SetActive(true)
        self.FimageText3.text = aa.Data.OpenFunctionExplain[3]
    else
        self.Fimage3.gameObject:SetActive(false)
    end

    if aa.Data.OpenFunction[4] ~= nil then
        self.Fimage4.sprite = GameResFactory.Instance():GetResSprite(aa.Data.OpenFunctionIcon[4]);
        self.Fimage4.gameObject:SetActive(true)
        self.FimageText4.text = aa.Data.OpenFunctionExplain[4]
    else
        self.Fimage4.gameObject:SetActive(false)
    end

    if aa.Data.OpenFunction[5] ~= nil then
        self.Fimage5.sprite = GameResFactory.Instance():GetResSprite(aa.Data.OpenFunctionIcon[5]);
        self.Fimage5.gameObject:SetActive(true)
        self.FimageText5.text = aa.Data.OpenFunctionExplain[5]
    else
        self.Fimage5.gameObject:SetActive(false)
    end
    if aa.Data.OpenFunction[6] ~= nil then
        self.Fimage6.sprite = GameResFactory.Instance():GetResSprite(aa.Data.OpenFunctionIcon[6])
        self.Fimage6.gameObject:SetActive(true)
        self.FimageText6.text = aa.Data.OpenFunctionExplain[6]
    else
        self.Fimage6.gameObject:SetActive(false)
    end
    -- 奖励类型
    if aa.Data.RewardLimit == 1 then
        self.awardType = "全服获得"
    else
        self.awardType = "同盟成员获得"
    end

    -- 奖励
    if aa.Data.Award == nil then
        self.award.gameObject:SetActive(false);
    else
        self.award.gameObject:SetActive(true);
    end

    if aa.Data.RewardIcon[1] ~= "" and aa.Data.RewardIcon[1] ~= nil then
        self.Aimage1.sprite = GameResFactory.Instance():GetResSprite(aa.Data.RewardIcon[1]);
        self.Aimage1.gameObject:SetActive(true)
        self.Aimagetext1.text = self.awardType .. aa.Data.AwardParameter2[1] .. "玉符"
    else
        self.Aimage1.gameObject:SetActive(false)
    end
    if aa.Data.RewardIcon[2] ~= "" and aa.Data.RewardIcon[2] ~= nil then
        self.Aimage2.sprite = GameResFactory.Instance():GetResSprite(aa.Data.RewardIcon[1]);
        self.Aimage2.gameObject:SetActive(true)
        self.Aimagetext2.text = self.awardType .. aa.Data.AwardParameter2[1] .. "玉符"
    else
        self.Aimage2.gameObject:SetActive(false)
    end
    if aa.Data.RewardIcon[3] ~= "" and aa.Data.RewardIcon[3] ~= nil then
        self.Aimage3.sprite = GameResFactory.Instance():GetResSprite(aa.Data.RewardIcon[1]);
        self.Aimage3.gameObject:SetActive(true)
        self.Aimagetext3.text = self.awardType .. aa.Data.AwardParameter2[1] .. "玉符"
    else
        self.Aimage3.gameObject:SetActive(false)
    end

    if aa.Data.RewardIcon[4] ~= "" and aa.Data.RewardIcon[4] ~= nil then
        self.Aimage4.sprite = GameResFactory.Instance():GetResSprite(aa.Data.RewardIcon[1]);
        self.Aimage4.gameObject:SetActive(true)
        self.Aimagetext4.text = self.awardType .. aa.Data.AwardParameter2[1] .. "玉符"
    else
        self.Aimage4.gameObject:SetActive(false)
    end

    if aa.Data.RewardIcon[5] ~= "" and aa.Data.RewardIcon[5] ~= nil then
        self.Aimage5.sprite = GameResFactory.Instance():GetResSprite(aa.Data.RewardIcon[1]);
        self.Aimage5.gameObject:SetActive(true)
        self.Aimagetext5.text = self.awardType .. aa.Data.AwardParameter2[1] .. "玉符"
    else
        self.Aimage5.gameObject:SetActive(false)
    end

    if aa.isDone == 1 then
        if aa.isGetAward == 1 then
            self.taskState.text = "已经领取奖励";
        else
            if aa.couldGetAward == 1 then
                self.taskState.text = "未领取奖励"
            else
                if aa.Data.RewardLimit == 1 or aa.tableId > 13 then
                    self.taskState.text = ""
                else
                    self.taskState.text = "未加入同盟或所在同盟未达成目标，不能领取奖励"
                end

            end
        end
        self.taskStateTime.gameObject:SetActive(false)
    else
        self.taskStateTime.gameObject:SetActive(true)
        self.taskState.text = aa.Data.Name .. "进行中"
        CommonService:Instance():TimeDown(UIType.EpicInfo, aa.endTime, self.taskStateTime, function() self.taskStateTime.gameObject:SetActive(false); end);
    end
    if aa.tableId > 13 then
        self.openFunc.gameObject:SetActive(false)
        self.award.gameObject:SetActive(false)
        self.taskStateTime.gameObject:SetActive(false)
    end
end

function EpicInfo:OnClickbutton()
    UIService:Instance():HideUI(UIType.EpicInfo)
end

return EpicInfo