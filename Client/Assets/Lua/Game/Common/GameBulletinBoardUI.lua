
local UIBase = require("Game/UI/UIBase")
local List = require("common/List")
local Queue = require("common/Queue")
local GameBulletinBoardUI = class("GameBulletinBoardUI",UIBase)
local UIService = require("Game/UI/UIService")
local UIType=require("Game/UI/UIType")

function GameBulletinBoardUI:ctor()
	GameBulletinBoardUI.super.ctor(self);
    GameBulletinBoardUI._instance = self;
    self.showText = nil;
    self.leftTransform = nil;
    self.rightTransform = nil;
    self.viewPortTransform = nil;
    
    self.isTimeDown = true;
    self.deletePerTime = 8;                   --间隔销毁时间
    self.translateTime = 8;                   --单条通知信息从右侧滑动到左侧的总时间（s）
    self.movePerTime = 5;                    --两条通知信息出现的间隔时间（s）
    self.queueList = Queue.new();              --需要显示的消息队列
    self.queueListObj = Queue.new();           --每个显示消息对应的item GameObject 

    self.uiIsOpen = false;            
end

--单例
function GameBulletinBoardUI:Instance()
    return GameBulletinBoardUI._instance;
end

--注册控件
function GameBulletinBoardUI:DoDataExchange()
    self.showText = self:RegisterController(UnityEngine.UI.Text,"Scroll View/Viewport/ShowText");
    self.leftTransform = self:RegisterController(UnityEngine.Transform,"Scroll View/Viewport/LeftPoint");
    self.rightTransform = self:RegisterController(UnityEngine.Transform,"Scroll View/Viewport/RightPoint");
    self.viewPortTransform =  self:RegisterController(UnityEngine.Transform,"Scroll View/Viewport");
end

function GameBulletinBoardUI:OnShow(content)
    self.isTimeDown = true;
    self.uiIsOpen = true;  
    self:AddListInformation(content);
    self:StartMoveOnce();
end

--开始移动 
function GameBulletinBoardUI:StartMoveOnce()
    if self.transform.gameObject.activeSelf == true then
        if self.queueList:Count() == 0 then
            --print("  queueList.count = 0 , 暂时没有要显示的跑马灯信息了");
        else
            self:NewOneItem();
        end
    
        --间隔时间检测有没有要显示的信息
        local _coroutine = StartCoroutine(function()
            WaitForSeconds(self.movePerTime, function()end)
            _coroutine = nil;
            self:StartMoveOnce();
        end);
    end
end

function GameBulletinBoardUI:NewOneItem()
    local dataItemConfig = DataUIConfig[UIType.GameBulletinItem];
    local uiBase = require(dataItemConfig.ClassName).new();
    GameResFactory.Instance():GetUIPrefab(dataItemConfig.ResourcePath, self.viewPortTransform, uiBase, function(go)
        if uiBase.gameObject then
            uiBase:Init();
            --取出List中第一条显示
            uiBase:InitText(self.rightTransform.localPosition,self.queueList:Pop());             
            --uiBase.gameObject.transform:DOLocalMoveX(self.leftTransform.localPosition.x, self.translateTime);
            CommonService:Instance():MoveX(uiBase.transform.gameObject,self.rightTransform.localPosition.x,self.leftTransform.localPosition.x,self.translateTime);
            self.queueListObj:Push(uiBase.gameObject);
            --时间到销毁
            local _coroutine = StartCoroutine(function()
            --WaitForSeconds(self.deletePerTime, function()end)
            WaitForSeconds(self.deletePerTime, function()end)
            _coroutine = nil;
            self:DestroyText(obj);
        end);          
        end
    end );
end

function GameBulletinBoardUI:DestroyText(obj)
    --销毁GameBulletinBoardItem GameObject对象
    self.queueListObj:Pop(); 
    UnityEngine.GameObject.Destroy(obj);

    if self.queueList:Count() == 0 and self.queueListObj:Count() == 0 then
        --print("信息List为空并且没有正在移动的其它信息,移动结束！！！！！！！！！！！！");
        UIService:Instance():HideUI(UIType.GameBulletinBoardUI);
        self.isTimeDown = false;
        self.uiIsOpen = false;
    end   
end

function GameBulletinBoardUI:ShowNext() 
    --print("移除后list的count: "..self.queueList:Count());
    if self.queueList:Count() > 0 then
        self:StartMoveOnce();
    end    
end

--向消息队列添加一条通知信息
function GameBulletinBoardUI:AddListInformation(content)
    if self.queueList ~= nil then
        self.queueList:Push(content);
    end
end

return GameBulletinBoardUI;
