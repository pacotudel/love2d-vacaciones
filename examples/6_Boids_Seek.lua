-- Example: Boids Seek
--[[
Description: Boids Seek
Author: Paco
]]

require "libs.helper"
require "libs.vector"
vector = require "libs.hump.vector"
Boide  = require "libs.boid"


random = love.math.random

W,H = love.graphics.getWidth(), love.graphics.getHeight()


BOIDS = {}
BOIDCOUNT = 50

MAX_SPEED = 120
SIMULATION_SPEED = 3


---------------------------------------------------

function love.load()
    math.randomseed( os.time() )
    love.graphics.setBackgroundColor(255,255,255)
    for i = 1,BOIDCOUNT do
		local boid2 = Boide()
		table.insert(BOIDS,boid2)
    end
	for _,b in pairs(BOIDS) do
		--b.pos.x=50 + math.random(0, love.graphics.getWidth())
		b.pos.x=50 + math.random(0, 50)
		--b.pos.y=50 + math.random(0, love.graphics.getHeight())
		b.pos.y=50 + math.random(0, 50)
	end
end

function love.update(dt)
	local xx,yy = love.mouse.getX(), love.mouse.getY()
	local pos = vector(xx,yy)
    for _,b in pairs(BOIDS) do
		-- Perseguir
		b:seek(pos,dt)
		-- Evadir
		--b:evade(pos,dt)
        b:update(dt * SIMULATION_SPEED)
    end
end

function love.draw()
	-- draw attractors
	love.graphics.setColor(0,1,0,0.5)
	
	-- draw boids
	for _,b in pairs(BOIDS) do
		b:draw()
	end
	local timer = love.timer
	love.graphics.setColor(0,0,0,1)
	love.graphics.print(string.format("FPS: %d, boids: %d", timer.getFPS(), #BOIDS), 2, 10)
	love.graphics.print(string.format("Mouse: %dx%d", love.mouse.getX(), love.mouse.getY()), 2, 20)
end




function dist(x1,y1,x2,y2)
	return math.sqrt((x1-x2)^2+(y1-y2)^2)
end