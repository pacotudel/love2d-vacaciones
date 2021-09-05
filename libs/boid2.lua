local Class = require 'libs.hump.class'
local vector = require "libs.hump.vector"

MIN_SPEED = 0.4
MIN_DISTANCE = 1.5
MAX_SPEED = 120

local Boid = Class{}

function Boid:init()
	self.pos = vector(0,0) 
    self.vel = vector(0,0)
	self.velmod = 0
    self.force = vector(0,0)
    self.mass = 5
	self.angle = 0
	self.angledeg = 0
	self.targetdist = 0
	self.type = 1
	-- 1 SEEK
	-- 2 ARRIVE
	-- 3 FLEE
end

function Boid:draw()
	-- draw boid
	love.graphics.setColor(1,0,0,1)
	love.graphics.circle('fill', self.pos.x, self.pos.y, 5, 3)
	-- draw velocity
	--love.graphics.setLine(1)
	--love.graphics.setColor(0,0.5,1,1)
	love.graphics.line(self.pos.x, self.pos.y,self.pos.x + self.vel.x,      self.pos.y + self.vel.y)
	love.graphics.print("Vel",                                              self.pos.x +10,self.pos.y-60)
	-- draw angulo
	local xx = self.pos.x + math.cos(self.angle) * (25)
	local yy = self.pos.y + math.sin(self.angle) * (25)
	love.graphics.line(self.pos.x,self.pos.y,xx,yy)
	-- draw force
	love.graphics.push()
	love.graphics.setLineWidth(5)
	love.graphics.setLineStyle("rough")
	love.graphics.setColor(1,0.48,0,1)
	love.graphics.line(self.pos.x, self.pos.y,	self.pos.x + self.force.x,  self.pos.y + self.force.y)
	love.graphics.pop()
	--love.graphics.print("Force",                                            self.pos.x +10,self.pos.y-50)
	-- Debug INFO
	love.graphics.print("Boid",                                             self.pos.x +10,self.pos.y)
	love.graphics.print("P X: " .. math.floor(self.pos.x) .. " Y: " .. math.floor(self.pos.y) ,     self.pos.x +10,self.pos.y-10)
	love.graphics.print("V X: " .. math.floor(self.vel.x) .. " Y: " .. math.floor(self.vel.y) ,     self.pos.x +10,self.pos.y-20)
	love.graphics.print("F X: " .. math.floor(self.force.x) .. " Y: " .. math.floor(self.force.y) , self.pos.x +10,self.pos.y-30)
	love.graphics.print("M: " .. math.floor(self.mass),                                             self.pos.x +10,self.pos.y-40)
	love.graphics.print("Ang: " .. math.floor(math.deg(self.angle)),                                self.pos.x +10,self.pos.y-50)
	love.graphics.print("Vel: " .. self.velmod,                                                     self.pos.x +10,self.pos.y-60)
	love.graphics.print("Target Dist: " .. self.targetdist,                                         self.pos.x +10,self.pos.y-70)
end

function Boid:limits()
	if self.type == 1 then --SEEK
	end
	local margin = 20
	if self.pos.x < margin then
		self.pos.x = margin end
	if self.pos.x >= W-margin then
		self.pos.x = W-margin end
	if self.pos.y < margin then
		self.pos.y = margin end
	if self.pos.y >= H-margin then
		self.pos.y = H-margin end

end

function Boid:seek(target,dt)
	local desired = vector(0,0)
	desired = target - self.pos
	self.targetdist = desired:len()
	if self.targetdist > MAX_SPEED then
		desired = desired:normalized() * MAX_SPEED
	end
	local steer = vector(0,0)
	steer = desired - self.vel
	--self.vel.x = steer.x
	--self.vel.y = steer.y
	-- Calcular angulo
	--self.angle = math.atan2(self.vel.y,self.vel.x)
	self.angle = math.atan2(steer.y,steer.x)
	self.angledeg = math.deg(self.angle)
	self.velmod = steer:len()
	-- Calcular posicion
	self:applyForce(steer,dt)
	-- Limits, no te salgas de la pantalla
	self:limits()
end



function Boid:applyForce(force,dt)
	self.pos = self.pos + force * dt
end

function Boid:flee(force,dt)
	self.pos = self.pos - force * dt
end

function Boid:stop()
	--self.pos.x = 0
	--self.pos.y = 0
	self.vel.x = 0
	self.vel.y = 0
	self.force.x = 0
	self.force.y = 0
end

return Boid