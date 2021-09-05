local G = love.graphics

Player = Object:New {
	size = 16,
	img = G.newImage("assets/tankBeige.png"),
	barrel = G.newImage("assets/barrelBeige.png"),
	x = 250,
	y = 250,
	x_max = love.graphics.getWidth(),
	x_min = 20,
	y_max = love.graphics.getHeight(),
	y_min = 20,
	angle = 0,
	--speed = 15,
	velocity_x = 0,
	velocity_y = 0,
	--maxspeed = 60,
	--acceleration =0,
	--max_acceleration=5,
	width = 0,
   	height = 0,
	br_width = 0,
	br_height = 0,
	shootTimer = 0,
	shootTimerMax = 18,
	canShoot = true,
	anglespeed=(math.pi/2),
	maxspeed=22,
	thrust=10,
	friction = 0,
	debug = true
}

function Player:shot()
	self.canShoot = false
	--[[self.shootTimer = self.shootTimer - 1 * dt
    if self.shootTimer <= 0 then
        self.canShoot = true
		self.shootTimer = self.shotTimerMax
    end
	]]--
end

function Player:init()
	self.width     = self.img:getWidth()
   	self.height    = self.img:getHeight()
	self.br_width  = self.barrel:getWidth()
   	self.br_height = self.barrel:getHeight()
	self.friction  = 30*(self.thrust/self.maxspeed)
end
function Player:reset()
	self.x = 250
	self.y = 250
end

function Player:update(dt)
	local ax,ay=0,0
	ax = math.cos(self.angle)*self.thrust
	ay = math.sin(self.angle)*self.thrust
	ax = ax - self.velocity_x * self.friction
	ay = ay - self.velocity_y * self.friction

	self.velocity_x = self.velocity_x + ax*dt
	self.velocity_y = self.velocity_y + ay*dt
	-- Keyboard
	if love.keyboard.isDown("right") then
		self.angle = self.angle + self.anglespeed*dt
   	elseif love.keyboard.isDown("left") then
		self.angle = self.angle - self.anglespeed*dt
   	end
	if self.angle > (math.pi*2) or self.angle < -(math.pi*2) then self.angle = 0 end
	if love.keyboard.isDown("down") then
		self.x = self.x - self.velocity_x
		self.y = self.y - self.velocity_y
   	elseif love.keyboard.isDown("up") then
		self.x = self.x + self.velocity_x
		self.y = self.y + self.velocity_y
   	end
	
	--self.x = self.x + self.velocity_x
	--self.y = self.y + self.velocity_y
	
	
	if self.x < self.x_min then self.x = self.x_min end
	if self.x > self.x_max then self.x = self.x_max end
	if self.y < self.y_min then self.y = self.y_min end
	if self.y > self.y_max then self.y = self.y_max end
	-- Can Shot?
	--if self.canShot == false then
		self.shootTimer = self.shootTimer - 1
	--end
    if self.shootTimer <= 0 then
        self.canShoot = true
		self.shootTimer = self.shootTimerMax
    end
end
function Player:draw()
	local ng = self.angle + (math.pi / 2)
	-- Cuerpo
	love.graphics.draw(self.img, self.x, self.y, ng, 0.5, 0.5, self.width/2, self.height/2 )
	-- Torreta
	love.graphics.draw(self.barrel, self.x, self.y, ng, 0.5, 0.5, self.br_width/2, self.br_height )
	-- DEBUG
	love.graphics.rectangle("fill",self.x-2.5, self.y-2.5,5,5)
	if self.debug then
		local xx = self.x + math.cos(self.angle) * (15)
		local yy = self.y + math.sin(self.angle) * (15)
		love.graphics.line(self.x,self.y,xx,yy)
		love.graphics.print("X: " .. string.format("%.1f %%",self.x) .. " Y: " .. string.format("%.1f %%",self.y) ,self.x-25, self.y-25)
		love.graphics.print("VX: " .. string.format("%.1f %%",self.velocity_x) .. " VY: " .. string.format("%.1f %%",self.velocity_y), self.x-25, self.y-35)
		love.graphics.print("Grad: " .. string.format("%.1f %%",math.deg(self.angle)),self.x-25, self.y-45)
	end
end