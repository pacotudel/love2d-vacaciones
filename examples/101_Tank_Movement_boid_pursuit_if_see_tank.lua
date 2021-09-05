-- Example: Tank movement + bullets + Boid Tank pursuit only if see player tank 
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
vector = require "libs.hump.vector"
Boide  = require "libs.boid"

debug = true

local player = Player()
local effects

W,H = love.graphics.getWidth(), love.graphics.getHeight()
MAX_SPEED = 20
--SIMULATION_SPEED = 3

-- Arco de vision del Boid
local sentryX, sentryY, sentryR = 200, 200, 10
local targetX, targetY, targetR = 400, 300, 10
local arcR = 200
local arcAngle = 0
local arcFunnel = math.rad(10)

local boid2 = Boide()

local boid_target_pos = vector(100,100)

function love.load()
	player:init()
	effects = Effects()
	--boid2.pos.x=50 + math.random(0, love.graphics.getWidth())
	boid2.pos.x=50 + math.random(0, 50)
	--boid2.pos.y=50 + math.random(0, love.graphics.getHeight())
	boid2.pos.y=50 + math.random(0, 50)
end

function love.update(dt)
	-- Arco de vision del Boid
	sentryX = boid2.pos.x
	sentryY = boid2.pos.y
	targetX = player.x
	targetY = player.y
	
	-- Angulo en radianes
	-- Angulo con respecto al boid
	--arcAngle = boid2.angle
	-- Angulo con respecto a la posicion del player (Ojo, esto es para establecer hacia donde "mira" el boid
	arcAngle = math.pi + math.atan2((boid2.pos.y - targetY), (boid2.pos.x - targetX))
	
	if withinSector(targetX, targetY, targetR, sentryX, sentryY, arcR, arcAngle-arcFunnel, arcAngle+arcFunnel) then
		boid_target_pos.x = player.x
		boid_target_pos.y = player.y
		bullets.insert(boid2.pos.x,boid2.pos.y,arcAngle,player.br_height/3,4,400)
	else
		--pos.x = boid2.pos.x
		--pos.y = boid2.pos.y
	end
	-- Perseguir
	boid2:seek(boid_target_pos,dt)
	-- Evadir
	--boid2:evade(pos,dt)
    boid2:update(dt)
	-- Efectos
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
	-- draw boid
	love.graphics.push()
	boid2:draw()
	love.graphics.pop()
	love.graphics.setColor(1, 0.1, 0.1)
	-- Draw Arco de vision del Boid
	--love.graphics.arc("fill",     sentryX, sentryY, arcR,   arcAngle-arcFunnel, arcAngle+arcFunnel)
	love.graphics.arc("line",     sentryX, sentryY, arcR,   arcAngle-arcFunnel, arcAngle+arcFunnel)
	love.graphics.setColor(1, 1, 1)
	-- Draw boid target
	love.graphics.circle("fill",boid_target_pos.x,boid_target_pos.y,5,5)
	-- Walls
	drawWalls()
	-- Player
	player:draw()
	-- Bullets
	bullets.draw()
	-- debug
	if debug then
		love.graphics.setColor(1, 1, 1)
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
	-- FPS
	local statistics = ("fps: %d, \nmem: %dKB\n"):format(love.timer.getFPS(), collectgarbage("count"))
	love.graphics.printf(statistics, 20, 30, 400, 'right')
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



function withinSector(tx, ty, tr, sx, sy, ar, a1, a2)
  -- First filter is the easiest and fastest - a square of radius vr+tr
  if   tx <= sx-(ar+tr)
    or tx >= sx+(ar+tr)
    or ty <= sy-(ar+tr)
    or ty >= sy+(ar+tr)
  then
    return false
  end
  -- Second filter is by distance - a circle of radius vr+tr
  local stx = tx-sx
  local sty = ty-sy
  local dist = math.sqrt(stx*stx + sty*sty)
  if dist >= ar + tr then
    return false
  end
  -- Now for the gist of it.
  local vertex1x, vertex1y, vertex2x, vertex2y
  local normal1x, normal1y, normal2x, normal2y
  local vsx, vsy
  local dot1, dot2
  vertex1x, vertex1y = math.cos(a1), math.sin(a1)
  normal1x, normal1y = -vertex1y, vertex1x
  -- To account for the target radius, we displace the sentry by the normal
  -- times the radius of the target, giving a "virtual sentry" position
  vsx, vsy = sx - normal1x * tr, sy - normal1y * tr
  -- Calculate the dot product of the vector VV->Target and the normal
  dot1 = (tx - vsx) * normal1x + (ty - vsy) * normal1y
  -- Repeat with the other line; the normal is the opposite
  vertex2x, vertex2y = math.cos(a2), math.sin(a2)
  normal2x, normal2y = vertex2y, -vertex2x
  vsx, vsy = sx - normal2x * tr, sy - normal2y * tr
  dot2 = (tx - vsx) * normal2x + (ty - vsy) * normal2y
  -- We can now reject many cases
  -- This would benefit from having the funnel angle instead of calculating it
  local span = a2 - a1
  if span < 0 then span = span + 6.283185307179586 end
  if span >= 3.141592653589793 then
    -- the area covers >= 180 degrees; we can discard if both dot products
    -- are negative
    if dot1 < 0 and dot2 < 0 then return false end
  else
    -- the area covers < 180 degrees; we can discard if either dot product is
    -- negative
    if dot1 < 0 or dot2 < 0 then return false end

    -- In this case, the corner at the sentry's position needs to be checked.
    -- If the target and both segments' endpoints are at opposite sides of
    -- the normal, the previously calculated result is invalid and needs to be
    -- evaluated based on distance to the corner (the sentry's position).
    dot1 = vertex1x * (tx - sx) + vertex1y * (ty - sy)
    dot2 = vertex2x * (tx - sx) + vertex2y * (ty - sy)
    if dot1 < 0 and dot2 < 0 then
      -- The result depends entirely on the distance to the sentry
      return dist < tr
    end
  end
  -- Now for the corners at the ends of the segments. First, if the distance
  -- is less than the arc's radius, the result is already accurate and we have
  -- a collision.
  if dist < ar then
    return true
  end
  
  -- Now, check which side of the segments the centre of the target is with
  -- respect to the normal. If either is on the arc's side, the result is
  -- already correct; return true.
  dot1 = (tx - sx) * normal1x + (ty - sy) * normal1y
  dot2 = (tx - sx) * normal2x + (ty - sy) * normal2y
  if dot1 >= 0 and dot2 >= 0 or span >= 3.141592653589793 and (dot1 >= 0 or dot2 >= 0) then return true end
  -- The collision is now solely determined by the distance to either corner
  dist = math.sqrt((vertex1x * ar + sx - tx)^2 + (vertex1y * ar + sy - ty)^2)
  if dist < tr then return true end
  dist = math.sqrt((vertex2x * ar + sx - tx)^2 + (vertex2y * ar + sy - ty)^2)
  return dist < tr  
end