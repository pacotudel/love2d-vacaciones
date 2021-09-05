-- Example: anim8 example
-- Author: Paco
--[[Description:
Author: Paco
Animacion con anim8
]]
local anim8 = require 'libs.anim8'

local image, animation

function love.load()
  image = love.graphics.newImage('assets/flame.png')
  local g = anim8.newGrid(32, 32, image:getWidth(), image:getHeight())
  animation = anim8.newAnimation(g('10-12',1), 0.2)
end

function love.update(dt)
  animation:update(dt)
end

function love.draw()
  animation:draw(image, 100, 200)
end