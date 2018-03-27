--
-- 逻辑服务器 --> 客户端
-- 邮件信息
-- @author czx
--
local AnnexInfo = class("AnnexInfo");

function AnnexInfo:ctor()
    --
    -- 附件类型
    --
    self.annexType = 0;
    
    --
    -- 附件内容
    --
    self.annexContent = "";
end

return AnnexInfo;
