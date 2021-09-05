-- Example: Tank movement + bullets
-- Author: Paco
--[[Description:
Author: Paco
]]
require "libs.helper"
require "libs.bump.bump"
require "libs.player"
require "libs.bullets"
local Effects = require 'libs.effects'
local Explosion3 = require 'libs.explosion3'

debug = 1

local player = Player()
local effects


function love.load()
	player:init()
	effects = Effects()
end

function love.update(dt)
	effects:update(dt)
	
	player:update(dt)
	-- Bullets
	if love.keyboard.isDown("space") and player.canShoot then
		player:shot()
		bullets.insert(player.x,player.y,player.angle,player.br_height/3,4,400)
		local xx = player.x + math.cos(player.angle) * (player.br_height/3)
		local yy = player.y + math.sin(player.angle) * (player.br_height/3)
		local explosion3 = Explosion3(xx,yy)
		effects:insert(explosion3)
	end
	bullets.update(dt)
end

function love.draw()
	-- Walls
	drawWalls()
	-- Player
	player:draw()
	-- Bullets
	bullets.draw()
	-- debug
	if debug then
		love.graphics.print("Bullets: " .. bullets.count(),10,20)
		if player.canShoot then
			love.graphics.print("Canshot: OK ",20,30)
		else
			love.graphics.print("Canshot: NO ",20,30)
		end
		--shootTimer
		love.graphics.print("ShotTimer: " .. player.shootTimer,20,40)
		-- instrucciones
		love.graphics.print("Move: up,down,left,right Shot: Space",20,50)
	end
	-- Array de efectos
	effects:draw()
end

function drawWalls()
	love.graphics.push()
	--love.graphics.setColor(1,0,0,0)
	-- Wall size
	local size=15
	--UP
	love.graphics.rectangle("fill",0, 0,love.graphics.getWidth(),size)
	--DOWN
	love.graphics.rectangle("fill",0,love.graphics.getHeight()-size,love.graphics.getWidth(),size)
	--LEFT
	love.graphics.rectangle("fill",0, 0,love.graphics.getHeight(),size)
	love.graphics.pop()
end
