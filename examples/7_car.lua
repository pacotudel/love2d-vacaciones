-- Example: Car
--[[
Description: Car controlled by arrow keys
Author: unknown
]]

W,H = love.graphics.getWidth(), love.graphics.getHeight()

function love.load()
	love.graphics.setColor(0,0,0)
	love.graphics.setBackgroundColor( 255, 255, 255 )
	car = love.graphics.newImage("assets/car.png")
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
end

function love.draw()
	love.graphics.draw(car, x, y, math.rad(angle), 1, 1, width/2, height/2 )
	love.graphics.print("Angle: " .. angle,10,20)
	love.graphics.print("Speed: " .. speed,10,40)
	love.graphics.print("X_Velocity: " .. velocity_x,10,60)
	love.graphics.print("Y_Velocity: " .. velocity_y,10,80)
	love.graphics.print("Acceleration: " .. acceleration,10,100)
end
