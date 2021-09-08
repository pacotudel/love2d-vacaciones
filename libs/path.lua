local vector = require "libs.hump.vector"
local Class = require 'libs.hump.class'

local Path = Class{}

function Path:init(x, y)
	self.indexant = 1
	self.index = 1
	self.list = { }
	self.max = 44
	--local pos = vector(0,0)
	--table.insert(self.list,pos)
	self.arrived=false
	self.dist=15
end

function Path:next()
	--BOIDS[#BOIDS+1] = boid.new(1 + 3 * math.random(), math.random() > .8, x, y)
	self.indexant = self.index
	self.index = self.index + 1
	if self.index > #self.list then
		self.index =1
	end
	--return self.list[self.index]
	return self:actual()
end

function Path:actual()
	if (self.index ~= 0) and (self.index <= #self.list) then
		return self.list[self.index]
	end
end

function Path:insert(pos)
	if #self.list <= self.max then
		table.insert(self.list,pos)
	end
end

function Path:count()
	return #self.list
end

function Path:dist()
	if (self.index ~= 0) and (self.index <= #self.list) and (self.indexant ~= 0) and (self.indexant <= #self.list) then
		return math.sqrt(((self.list[self.index].y - self.list[self.indexant].y) * (self.list[self.index].y - self.list[self.indexant].y)) + ((self.list[self.index].x - self.list[self.indexant].x) * (self.list[self.index].x - self.list[self.indexant].x)))
	end
end

function Path:dist2(x,y)
	if (self.index ~= 0) and (self.index <= #self.list) then
		return math.sqrt(((self.list[self.index].y - y) * (self.list[self.index].y - y)) + ((self.list[self.index].x - x) * (self.list[self.index].x - x)))
	end
end

function Path:hasarrived(x,y)
	if self:dist2(x,y) <= self.dist then
		return true
	else
		return false
	end
end

function Path:draw()
	for i, o in ipairs(self.list) do
		if i == self.index then
			love.graphics.rectangle("fill",o.x,o.y,15,15)
		else
			love.graphics.circle('fill', o.x, o.y, 10, 8)
		end
		--love.graphics.print(string.format("FPS: %d, boids: %d", timer.getFPS(), #BOIDS), 2, 10)
		love.graphics.print(string.format("N: %d", i), o.x+10, o.y+10)
	end
end

return Path