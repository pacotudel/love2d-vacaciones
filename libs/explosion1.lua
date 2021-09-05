-- Represents a single drawable object
local Class = require 'libs.hump.class'
local anim8 = require 'libs.anim8'

local Explosion1 = Class{}

function Explosion1:init(x, y)
	self.x = x
	self.y = y
	self.image = love.graphics.newImage('assets/flame.png')
	self.g = anim8.newGrid(32, 32, self.image:getWidth(), self.image:getHeight())
	--self.animation = anim8.newAnimation(self.g('1-3',8), 0.2,self.onLoop)
	self.animation = anim8.newAnimation(self.g('10-12',7), 0.1,function() self.stop = 1 end)
	--self.animation:pauseAtEnd()
	self.stop = 0
end


function Explosion1:getRect()
  return self.x, self.y
end

function Explosion1:draw()
  self.animation:draw(self.image, self.x, self.y)
  
  --love.graphics.print("Slow: " .. self.slow, self.x + 20, self.y)
  --love.graphics.print("Stop: " .. self.stop, self.x + 20, self.y + 10)
end

function Explosion1:update(dt)
	self.animation:update(dt)
end

return Explosion1