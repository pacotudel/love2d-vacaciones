-- Example: Car Pursuit by Boid 2
--[[
Description: Car controlled by arrow keys and pursuit by boid
Author: Paco
]]

require "libs.helper"
vector = require "libs.hump.vector"
Boide  = require "libs.boid2"

W,H = love.graphics.getWidth(), love.graphics.getHeight()


MAX_SPEED = 120

car = love.graphics.newImage("assets/car_blue_small_1.png")
x = 150 		
y = 150
angle = 90 		
speed = 1 		
maxspeed = 100 	
angledif = 5	
acceleration =0				
max_acceleration=5
width = car:getWidth()		
height = car:getHeight()

pos = vector(x,y)

local boid2 = Boide()

function love.load()
	love.graphics.setColor(0,0,0)
	love.graphics.setBackgroundColor( 255, 255, 255 )
		
	boid2.pos.x=150 + math.random(0, 50)
	boid2.pos.y=150 + math.random(0, 50)
	boid2_img = love.graphics.newImage("assets/car_black_small_1.png")
end

function love.update(dt)
	if love.keyboard.isDown("right") then
		angle = angle + angledif
   	elseif love.keyboard.isDown("left") then
		angle = angle - angledif
   	end

	if angle > 360 or angle < -360 then angle = 0 end

	scale_x = math.cos(math.rad(angle+90))
	scale_y	= math.sin(math.rad(angle+90))

	velocity_x = speed * scale_x * acceleration --Define velocidade no eixo X
	velocity_y = speed * scale_y * acceleration

   	if love.keyboard.isDown("down") then
    	y = y + velocity_y
    	x = x + velocity_x
		acceleration = acceleration-0.3
   	elseif love.keyboard.isDown("up") then
    	y = y - velocity_y
      	x = x - velocity_x
		acceleration = acceleration+0.4
   	end
	acceleration=acceleration-0.3
	if acceleration < 0 then acceleration = 0 end
	if acceleration > max_acceleration then acceleration = max_acceleration end
	if x > W then x=W end
	if x < 0 then x=0 end
	if y > H then y=H end
	if y < 0 then y=0 end
	-- Perseguir
	pos.x = x
	pos.y = y
	boid2:seek(pos,dt)
end

function love.draw()
	-- draw boid
	love.graphics.draw(boid2_img, boid2.pos.x, boid2.pos.y, boid2.angle+(math.pi/2), 1, 1, width/2, height/2 )
	boid2:draw()
	-- Draw Car
	love.graphics.draw(car, x, y, math.rad(angle), 1, 1, width/2, height/2 )
	-- Draw debug info
	love.graphics.print("Angle: " .. angle,10,20)
	love.graphics.print("Speed: " .. speed,10,40)
	love.graphics.print("X_Velocity: " .. velocity_x,10,60)
	love.graphics.print("Y_Velocity: " .. velocity_y,10,80)
	love.graphics.print("Acceleration: " .. acceleration,10,100)
end
