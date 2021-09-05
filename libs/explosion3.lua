-- Represents a single drawable object
local Class = require 'libs.hump.class'
local anim8 = require 'libs.anim8'

local Explosion1 = Class{}

function Explosion1:init(x, y)
	self.x = x
	self.y = y
	self.image = love.graphics.newImage('assets/flame.png')
	self.w = self.image:getWidth()
	self.h = self.image:getHeight()
	self.w2 = 32 / 2
	self.h2 = 32 / 2
	self.x2 = self.x - self.w2
	self.y2 = self.y - self.h2
	self.g = anim8.newGrid(32, 32, self.w, self.h)
	--self.animation = anim8.newAnimation(self.g('1-3',8), 0.2,self.onLoop)
	self.animation = anim8.newAnimation(self.g('10-12',8,9,7,9,6,9,5), 0.1,function() self.stop = 1 end)
	--self.animation:pauseAtEnd()
	self.stop = 0
end


function Explosion1:getRect()
  return self.x, self.y
end

function Explosion1:draw()
  self.animation:draw(self.image, self.x2, self.y2)
  
  --love.graphics.print("Slow: " .. self.slow, self.x + 20, self.y)
  --love.graphics.print("Stop: " .. self.stop, self.x + 20, self.y + 10)
end

function Explosion1:update(dt)
	self.animation:update(dt)
end

return Explosion1