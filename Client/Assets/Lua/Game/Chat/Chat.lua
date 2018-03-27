Chat = class("Chat")

-- 构造函数
function Chat:ctor()
    self.type = 0;

    self.name = "";

	self.detailsText = "";

	self.time = 0;
    
   -- self._Property = {};
end

function Chat:Init(type, name, detailsText, time)
    self.type = type;

    self.name = name;

	self.detailsText = detailsText;

	self.time = time;
end

return Chat;