-- Example: Path waypoints
--[[
Description: Path Waypoints
Author: Paco
]]

require "libs.helper"
vector = require "libs.hump.vector"
local Path = require 'libs.path'

W,H = love.graphics.getWidth(), love.graphics.getHeight()




local path = Path()

function love.load()
	love.graphics.setColor(0,0,0)
	love.graphics.setBackgroundColor( 255, 255, 255 )
	for i = 1,5 do
		local pos = vector(0,0)
		pos.x=150 + i*4 + math.random(10, W-10)
		pos.y=150 + i*4 + math.random(10, H-10)
		path:insert(pos)
    end
	local pos = vector(x,y)
end

function love.update(dt)
	if love.keyboard.isDown("right") then
		path:next()
   	elseif love.keyboard.isDown("left") then
		path:next()
   	end
end

function love.draw()
	path:draw()
	love.graphics.print(string.format("ACTUAL: %d, TOTAL: %d", path.index, path:count()), 100, 10)
end
