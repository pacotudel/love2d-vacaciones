-- Example: Special Effects Array ... BIG tileset
-- Author: Paco
--[[Description:
Author: Paco
Pintar array de efectos
]]
local Effects = require 'libs.effects'
local Chispa = require 'libs.chispa'
local Explosion1 = require 'libs.explosion1'
local Explosion2 = require 'libs.explosion2'
local Explosion3 = require 'libs.explosion3'

local effects

function love.load()
  effects = Effects()
end

function love.update(dt)
	effects:update(dt)
	local chispa2 = Chispa(math.random(0, love.graphics.getWidth()),math.random(0, love.graphics.getHeight()))
	effects:insert(chispa2)
	local explosion = Explosion1(math.random(0, love.graphics.getWidth()),math.random(0, love.graphics.getHeight()))
	effects:insert(explosion)
	local explosion2 = Explosion2(math.random(0, love.graphics.getWidth()),math.random(0, love.graphics.getHeight()))
	effects:insert(explosion2)
	local explosion3 = Explosion3(math.random(0, love.graphics.getWidth()),math.random(0, love.graphics.getHeight()))
	effects:insert(explosion3)
end

function love.draw()

  effects:draw()
  local statistics = ("fps: %d, \nmem: %dKB\n , items: %d"):format(love.timer.getFPS(), collectgarbage("count"),#effects.list)
  love.graphics.printf(statistics, 10, 10, 200, 'right')
end

function love.mousepressed(x, y, button, istouch)
	-- Checks which button was pressed.
	local buttonname = ""
	if button == 1 then
		local explosion3 = Explosion3(math.random(0, love.graphics.getWidth()),math.random(0, love.graphics.getHeight()))
		effects:insert(explosion3)
	end
end