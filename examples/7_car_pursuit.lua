-- Example: Car Pursuit by Boid
--[[
Description: Car controlled by arrow keys and pursuit by boid
Author: Paco
]]

require "libs.helper"
--require "libs.vector"
vector = require "libs.hump.vector"
Boide  = require "libs.boid"

W,H = love.graphics.getWidth(), love.graphics.getHeight()


MAX_SPEED = 120
--SIMULATION_SPEED = 3

local boid2 = Boide()

function love.load()
	love.graphics.setColor(0,0,0)
	love.graphics.setBackgroundColor( 255, 255, 255 )
	--car = love.graphics.newImage("assets/car.png")
	car = love.graphics.newImage("assets/car_blue_small_1.png")
	x = 150 		--Posicao inicial
	y = 150
	angle = 90 		--Angulo inicial
	speed = 1 		--Velocidade
	maxspeed = 100 	--Velocidade Max
	angledif = 10	--Variacao de Angulo
	acceleration =0				--aceleracao
	max_acceleration=5
	width = car:getWidth()		--Dimensoes do carro
   	height = car:getHeight()
	--boid2.pos.x=50 + math.random(0, love.graphics.getWidth())
	boid2.pos.x=50 + math.random(0, 50)
	--boid2.pos.y=50 + math.random(0, love.graphics.getHeight())
	boid2.pos.y=50 + math.random(0, 50)
	
	boid2_img = love.graphics.newImage("assets/car_black_small_1.png")
end

function love.update(dt)
	local xx,yy = love.mouse.getX(), love.mouse.getY()
	--local pos = vector(xx,yy)
	local pos = vector(x,y)
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
	boid2:seek(pos,dt)
	-- Evadir
	--boid2:evade(pos,dt)
    boid2:update(dt)
end

function love.draw()
	-- draw boid
	love.graphics.draw(boid2_img, boid2.pos.x, boid2.pos.y, 0, 1, 1, width/2, height/2 )
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
