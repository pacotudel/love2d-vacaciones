-- Represents a single drawable object
local Class = require 'libs.hump.class'
local anim8 = require 'libs.anim8'

local Chispa = Class{}

function Chispa:init(x, y)
	self.x = x
	self.y = y
	self.image = love.graphics.newImage('assets/flame.png')
	self.g = anim8.newGrid(32, 32, self.image:getWidth(), self.image:getHeight())
	--self.animation = anim8.newAnimation(self.g('1-3',8), 0.2,self.onLoop)
	self.animation = anim8.newAnimation(self.g('10-12',6), 0.1,function() self.stop = 1 end)
	--self.animation:pauseAtEnd()
	self.stop = 0
end
--[[
function Chispa:onLoop()
	self.stop = 1
end
]]--

function Chispa:getRect()
  return self.x, self.y
end

function Chispa:draw()
  self.animation:draw(self.image, self.x, self.y)
  
  --love.graphics.print("Slow: " .. self.slow, self.x + 20, self.y)
  --love.graphics.print("Stop: " .. self.stop, self.x + 20, self.y + 10)
end

function Chispa:update(dt)
	--[[if self.slow <= self.slowMax then
		self.slow = self.slow + 1
	else
		--self.animation:update(dt)
		self.slow = 0
	end
	]]--
	self.animation:update(dt)
end

return Chispa