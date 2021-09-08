-- Example: Path waypoints and boid
--[[
Description: Path Waypoints
Author: Paco
]]

require "libs.helper"
vector = require "libs.hump.vector"
local Path = require 'libs.path'
Boide  = require "libs.boid2"

W,H = love.graphics.getWidth(), love.graphics.getHeight()


pos2 = vector(x,y)

local boid2 = Boide()

local path = Path()


boid2_img = love.graphics.newImage("assets/car_black_small_1.png")
width = boid2_img:getWidth()		
height = boid2_img:getHeight()

function love.load()
	love.graphics.setColor(0,0,0)
	love.graphics.setBackgroundColor( 255, 255, 255 )

	path:insert(vector(30,30))
	path:insert(vector(30,H-30))
	path:insert(vector(W-30,H-30))
	path:insert(vector(W-30,30))
	--path:insert(vector(200,170))
	local pos = vector(x,y)
	boid2.pos.x=150 + math.random(0, 50)
	boid2.pos.y=150 + math.random(0, 50)
	
end

function love.update(dt)
	--if love.keyboard.isDown("right") then
	--	path:next()
   	--elseif love.keyboard.isDown("left") then
--		path:next()
   --	end
	--local pos3 = path:actual()
	if path:hasarrived(boid2.pos.x,boid2.pos.y) then
		boid2:seek(path:next(),dt)
	else
		boid2:seek(path:actual(),dt)
	end
end

function love.draw()
	path:draw()
	-- draw boid
	love.graphics.draw(boid2_img, boid2.pos.x, boid2.pos.y, boid2.angle+(math.pi/2), 1, 1, width/2, height/2 )
	boid2:draw()
	love.graphics.print(string.format("ACTUAL: %d, TOTAL: %d", path.index, path:count()), 100, 10)
end
