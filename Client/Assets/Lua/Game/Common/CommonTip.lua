--[[��Ϸ��ʾ����]]

local UIBase= require("Game/UI/UIBase");
local UIService=require("Game/UI/UIService");
local UIType=require("Game/UI/UIType");
require("Game/Recruit/RecruitService");

local CommonTip=class("CommonTip",UIBase);

function CommonTip:ctor()
    CommonTip.super.ctor(self)
end

--ע���ؼ�
function CommonTip:DoDataExchange()
    self.Title = self:RegisterController(UnityEngine.UI.Text,"Title")
    self.subheading1 = self:RegisterController(UnityEngine.UI.Text,"Bg/Panel/Layout/subheading1")
    self.Tips1 = self:RegisterController(UnityEngine.UI.Text,"Bg/Panel/Layout/Tips1")
    self.subheading2 = self:RegisterController(UnityEngine.UI.Text,"Bg/Panel/Layout/subheading2")
    self.Tips2 = self:RegisterController(UnityEngine.UI.Text,"Bg/Panel/Layout/Tips2")
    self.OkBtn = self:RegisterController(UnityEngine.UI.Button,"OkBtn")
    self.BackBtn = self:RegisterController(UnityEngine.UI.Button,"BackBtn")

    self.LayOutElement1 = self.subheading1:GetComponent(typeof(UnityEngine.UI.LayoutElement));
    self.LayOutElement2 = self.Tips1:GetComponent(typeof(UnityEngine.UI.LayoutElement));
    self.LayOutElement3 = self.subheading2:GetComponent(typeof(UnityEngine.UI.LayoutElement));
    self.LayOutElement4 = self.Tips2:GetComponent(typeof(UnityEngine.UI.LayoutElement));
end

--ע���ؼ������¼�
function CommonTip:DoEventAdd()
    self:AddListener(self.OkBtn,self.OnClickCloseBtn)
    self:AddListener(self.BackBtn,self.OnClickCloseBtn)
end

--����������ʯ��ť������ʯ���߼�
function CommonTip.OnClickCloseBtn()
 UIService:Instance():HideUI(UIType.UICommonTip)
end

--�򿪽�����ʼ����Ϣ
function CommonTip:OnShow(parem)
    if(parem[1] == nil) then
        print("title");
        return;
    end
    self.Title.text = parem[1];
    if(parem[2] == nil or parem[2] == "") then
        self.subheading1.gameObject:SetActive(false);
    else
        self.subheading1.gameObject:SetActive(true);
        self.subheading1.text = parem[2];
        print(self.subheading1);
        print(self.subheading1.transform);
        --print(self.subheading1.transform.Height);  --û������ֵ 
        --self.LayOutElement1.minHeight = self.subheading1.transfrom.height;
    end
     if(parem[3] == nil or parem[3] == "") then
        self.Tips1.gameObject:SetActive(false);
    else
        self.Tips1.gameObject:SetActive(true);
        self.Tips1.text = parem[3];
        --self.LayOutElement2.minHeight = self.Tips1.transform.height;
    end
     if(parem[4] == nil or parem[4] == "") then
        self.subheading2.gameObject:SetActive(false);
    else
        self.subheading2.gameObject:SetActive(true);
        self.subheading2.text = parem[4];
        --self.LayOutElement3.minHeight = self.subheading2.transform.height;
    end
     if(parem[5] == nil or parem[5] == "") then
        self.Tips2.gameObject:SetActive(false);
    else
        self.Tips2.gameObject:SetActive(true);
        self.Tips2.text = parem[5];
        --self.LayOutElement4.minHeight = self.Tips2.transform.height;
    end
end

return CommonTip;