-- Example: Chispa Anim 8
-- Author: Paco
--[[Description:
Author: Paco
Pintar chispa en pantalla con anim8
]]

local Chispa = require 'libs.chispa'
local chispa


function love.load()
  chispa = Chispa(500, 500)
end

function love.update(dt)
	chispa:update(dt)
end

function love.draw()
  chispa:draw()
  local statistics = ("fps: %d, \nmem: %dKB\n"):format(love.timer.getFPS(), collectgarbage("count"))
  love.graphics.printf(statistics, 10, 10, 200, 'right')
end