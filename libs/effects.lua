local Class = require 'libs.hump.class'

local Effects = Class{}

function Effects:init()
  self.list = {}
  self.max = 50
end

function Effects:insert(efecto)
	if #self.list <= self.max then
		table.insert(self.list,efecto)
	end
end

function Effects:draw()
	for i,v in ipairs(self.list) do
		v:draw(self.image, self.x, self.y)
	end
end

function Effects:count()
	return #self.list
end

function Effects:update(dt)
    for i,v in ipairs(self.list) do
		if v.stop == 1 then
			table.remove(self.list,i)
		else
			v:update(dt)
		end
	end
end

return Effects