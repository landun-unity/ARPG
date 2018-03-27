local UIBase = require("Game/UI/UIBase");
local UIPublicClick = class("UIPublicClick", UIBase);
local UIType = require("Game/UI/UIType");
require("Game/Table/InitTable");

-- 构造方法
function UIPublicClick:ctor()
    UIPublicClick.super.ctor(self);
    self.tiled = nil;
    self.LeagueMarkBtn = nil
    self.LeagueMarkText = nil
    self.LeagueMarkDetail = nil
    self.markName = nil
    self.markDetail = nil
    self.IsLeagueMarked = false;
    -- 坐标
    self.coordx = nil;
    self.coordy = nil;
    self.MarkCount = 0;

    -- -- 呼吸框
    -- self._tiledImage = nil;

    -- self.marchTimer = nil;
    -- self._valueMax = 1;
    -- self._valueMin = 0.25;
    -- self._change = 0.06;
    -- self._curvalue = 1;
end

-- 初始化
function UIPublicClick:DoDataExchange()
    self.LeagueMarkBtn = self:RegisterController(UnityEngine.UI.Button, "LeagueMark");
    self.LeagueMarkText = self:RegisterController(UnityEngine.UI.Text, "LeagueMark/Text");
    self.LeagueMarkDetail = self:RegisterController(UnityEngine.Transform, "LeagueMarkDetail");
    self.markName = self:RegisterController(UnityEngine.UI.Text, "LeagueMarkDetail/markName")
    self.markDetail = self:RegisterController(UnityEngine.UI.Text, "LeagueMarkDetail/detail");
    -- self._tiledImage = self:RegisterController(UnityEngine.UI.Image, "tile/tileimage")
end

-- 注册控件点击事件
function UIPublicClick:DoEventAdd()

    self:AddListener(self.LeagueMarkBtn, self.OnClickLeagueMarkBtn);

end

-- 加载资源
function UIPublicClick:ShowTiled(tiled)
    -- self.gameObject.transform.localScale = Vector3.New(1.52, 1.52, 1.52);
    -- 同盟标记界面UI显示
    CommonService:Instance():SetTweenAlphaGameObject(self.transform.gameObject, true, tiled._index, false, 0, 0, 0, function() end, true, 1.42, 1.52, 0.25)
    self.tiled = tiled
    if self.tiled._leagueMark == nil then
        self.LeagueMarkText.text = "同盟标记"
        self.IsLeagueMarked = false;
        self.LeagueMarkDetail.gameObject:SetActive(false)
    else
        self.LeagueMarkText.text = "取消同盟标记"
        self.IsLeagueMarked = true
        self.LeagueMarkDetail.gameObject:SetActive(true)
        self.markName.text = self.tiled._leagueMark:GetName()
        self.markDetail.text = self.tiled._leagueMark:GetDescription()
    end

    if self.tiled._leagueMark ~= nil then
        if PlayerService:Instance():GetPlayerId() ~= self.tiled._leagueMark.publisherid then
            self.LeagueMarkBtn.gameObject:SetActive(false);
        end
    end

    local postionx = self.tiled:GetX();
    local postiony = self.tiled:GetY();

    self.coordx = postionx;
    self.coordy = postiony;

    local resource = tiled:GetResource();
    if resource == nil then
        self.LeagueMarkBtn.gameObject:SetActive(false);
    else
        if self:IsRiver(tiled) == true then
            self.LeagueMarkBtn.gameObject:SetActive(false);
        else
            if PlayerService:Instance():GetLeagueId() ~= 0 and PlayerService:Instance():GetPlayerTitle() <= LeagueTitleType.Command and resource.Type ~= 0 and PlayerService:Instance():GetPlayerTitle() ~= 0 and resource.Type ~= 1 then
                self.LeagueMarkBtn.gameObject:SetActive(true);
            else
                self.LeagueMarkBtn.gameObject:SetActive(false);
            end
        end
    end
    -- self:_ShowTiledImage();
end

-- 是否是河流
function UIPublicClick:IsRiver(tiled)
    local riverImage = tiled:GetImageId(LayerType.Land);
    if riverImage == nil or type(riverImage) ~= "number" then
        return false
    end
    if riverImage < 6 or riverImage > 25 then
        return false
    end
    return true;
end

function UIPublicClick:HideTiled()
end

-- 同盟标记
function UIPublicClick:OnClickLeagueMarkBtn()
    if self.IsLeagueMarked then
        LeagueService:Instance():RemoveLeagueMark(self.tiled:GetLeagueMarkId())
    else
        if PlayerService:Instance():GetPlayerTitle() > LeagueTitleType.Command then
            UIService:Instance():ShowUI(UIType.UICueMessageBox, UICueMessageType.NoPowerToDo);
            return;
        end
        local data = { self.coordx, self.coordy };
        UIService:Instance():ShowUI(UIType.UILeagueMark, data)
    end
end


---同盟标记的详情位置
function UIPublicClick:SetDetialPos(args)
    self.LeagueMarkDetail.localPosition = args
end

return UIPublicClick;
