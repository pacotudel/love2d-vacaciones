-- Example: Boids
-- Author: Paco
--[[Description: Boids
Author: Paco
]]

require "libs.helper"
require "libs.vector"
vector = require "libs.hump.vector"
Boide  = require "libs.boid"


random = love.math.random

W,H = love.graphics.getWidth(), love.graphics.getHeight()


BOIDS = {}
BOIDCOUNT = 1
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
		table.insert(BOIDS,boid2)
    end
	for _,b in pairs(BOIDS) do
		--b.pos.x=50 + math.random(0, love.graphics.getWidth())
		b.pos.x=150 + math.random(0, 50)
		--b.pos.y=50 + math.random(0, love.graphics.getHeight())
		b.pos.y=150 + math.random(0, 50)
	end
end

function love.update(dt)
    --get_boids_force()
	local force = 10
	local xx,yy = love.mouse.getX(), love.mouse.getY()
	local pos = vector(xx,yy)
    for _,b in pairs(BOIDS) do
		--b:seek(pos,dt)
		--b.force.y = 0
		--b.force.x = 0
        b:update(dt * SIMULATION_SPEED)
		if love.keyboard.isDown("down") then
			--b:applyForce(vector(0,force),dt)
			b.force.x = 0
			b.force.y = force
		elseif love.keyboard.isDown("up") then
			--b:applyForce(vector(0,-force),dt)
			b.force.x = 0
			b.force.y = -force
		elseif love.keyboard.isDown("right") then
			--b:applyForce(vector(force,0),dt)
			b.force.x = force
			b.force.y = 0
		elseif love.keyboard.isDown("left") then
			--b:applyForce(vector(-force,0),dt)
			b.force.x = -force
			b.force.y = 0
		elseif love.keyboard.isDown("r") then
			--b:applyForce(vector(0,0),dt)
			b.force.x = 0
			b.force.y = 0
		end
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
