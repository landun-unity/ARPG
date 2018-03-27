local UIBase = require("Game/UI/UIBase");
local UIService = require("Game/UI/UIService");
local UIType = require("Game/UI/UIType");

MessageBox = class("MessageBox", UIBase);

function MessageBox:ctor()

    MessageBox._instance = self;
    MessageBox.super.ctor(self);
    -- 黑色背景挡板
    self.mBackPanel = nil;
    -- tip提示信息对象
    self.mLbMsg = nil;
    self.mBottomTip = nil;
    self.mLbBottomMsg = nil;
    self.mBtnCanel = nil;
    self.mBtnOk = nil;
    -- 保存委托函数  取消与确定
    self.mEventCancel = nil;
    self.mEventOk = nil;
    self.BtnText = nil;
    self.HeadlineObjText = nil;
end

function MessageBox:Instance()
    return MessageBox._instance;
end

function MessageBox:DoDataExchange()

    self.mBackPanel = self:RegisterController(UnityEngine.Transform, "BackPanel");
    self.mBtnCanel = self:RegisterController(UnityEngine.UI.Button, "AffirmImage/BtnCancel");
    self.mBtnOk = self:RegisterController(UnityEngine.UI.Button, "AffirmImage/BtnOk");
    self.mLbMsg = self:RegisterController(UnityEngine.UI.Text, "AffirmImage/TipInfo/TipBg/LbMes");
    self.mBottomTip = self:RegisterController(UnityEngine.Transform, "AffirmImage/TipInfo/BottomTip");
    self.mLbBottomMsg = self:RegisterController(UnityEngine.UI.Text, "AffirmImage/TipInfo/BottomTip/LbBottomMsg");
    self.BtnText = self:RegisterController(UnityEngine.UI.Text,"AffirmImage/BtnOk/Text")
    self.HeadlineObjText = self:RegisterController(UnityEngine.UI.Text,"AffirmImage/HeadlineObj/BottomBlueImage/Text")
end

---- 注册控件事件
function MessageBox:DoEventAdd()

    self:AddListener(self.mBtnCanel, self.OnClickCanel)
    self:AddListener(self.mBtnOk, self.OnClickOk)

end

-- 注册事件
function MessageBox:RegisterCancel(callBack)
    self.mEventCancel = callBack;
end

function MessageBox:RegisterOk(callBack)
    self.mEventOk = callBack;
end

-- 设置提示信息,是否有挡板-默认false
-- 参数1： 主要提示信息，参数2：底部补充提示消息，参数3-是否有底部提示-默认false 参数4：是否开启盲板-默认false,
function MessageBox:OnShow(param)
    self.mLbMsg.text = param[1];
    self.mLbBottomMsg.text = param[2];
    self.mBottomTip.gameObject:SetActive(param[3]);
    self.mBackPanel.gameObject:SetActive(param[4]);
    self.BtnText.text = param[5]; -- 确认按钮name
    self.HeadlineObjText.text = param[6]  -- 最上面的text
    if param[3] == nil or param[3] == false then
        self.mLbMsg.gameObject.transform.localPosition = Vector3.zero;
    end
    if param[5] == nil then
        self.BtnText.text = "确认"
    end
    if param[6] == nil then
        self.HeadlineObjText.text = "说明"
    end
end

function MessageBox:OnClickOk()
    -- 执行对应的确定回调如果有
    UIService:Instance():HideUI(UIType.MessageBox);
    if self.mEventOk ~= nil then
        self.mEventOk();
    end

end

function MessageBox:OnClickCanel()
    -- 执行对应的取消回调如果有
    UIService:Instance():HideUI(UIType.MessageBox);
    if self.mEventCancel ~= nil then
        self.mEventCancel();
    end

end


return MessageBox;