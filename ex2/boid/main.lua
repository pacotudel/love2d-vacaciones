-- Example: Boids Evade
-- Author: Paco
--[[Description: Boids Evade
Author: Paco
]]

package.path = package.path .. ";../../libs/?.lua"
package.path = package.path .. ";../../libs/?/?.lua"
package.path = package.path .. ";../../libs/?/init.lua"

require "helper"
require "libs.vector"
vector = require "libs.hump.vector"
Boide   = require "libs.boid"


random = love.math.random

W,H = love.graphics.getWidth(), love.graphics.getHeight()


BOIDS = {}
BOIDCOUNT = 50
--ATTRACTORS = {}
--REPULSORS = {}
WIDTH = 800
HEIGHT = 600
MAX_SPEED = 120
SIMULATION_SPEED = 3


---------------------------------------------------

function love.load()
    math.randomseed( os.time() )
    love.graphics.setBackgroundColor(255,255,255)
    for i = 1,BOIDCOUNT do
		local boid2 = Boide()
		--[[
		boid.pos.x=i+math.random(0, love.graphics.getWidth())
		boid.pos.y=i+10+math.random(0, love.graphics.getHeight())
		boid.mass = 50
        BOIDS[#BOIDS + 1] = boid
		]]--
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
    --get_boids_force()
	local xx,yy = love.mouse.getX(), love.mouse.getY()
	local pos = vector(xx,yy)
    for _,b in pairs(BOIDS) do
		-- Perseguir
		--b:seek(pos,dt)
		
		-- Evadir
		--b:evade(pos,dt)
        --b:update(dt * SIMULATION_SPEED)
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

function love.mousereleased(x,y, btn)
    if btn == 'l' then
        --BOIDS[#BOIDS+1] = boid.new(1 + 3 * math.random(), math.random() > .8, x, y)
		local boid = Boid()
		boid.pos.x=x
		boid.pos.y=y
        BOIDS[#BOIDS + 1] = boid
    end
end
function love.mousepressed(x, y, button, istouch)
	-- Checks which button was pressed.
	if btn == 'l' then
        --BOIDS[#BOIDS+1] = boid.new(1 + 3 * math.random(), math.random() > .8, x, y)
		local boid = Boid()
		boid.pos.x=x
		boid.pos.y=y
        BOIDS[#BOIDS + 1] = boid
    end
end


function dist(x1,y1,x2,y2)
	return math.sqrt((x1-x2)^2+(y1-y2)^2)
end