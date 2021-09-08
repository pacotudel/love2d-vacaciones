-- Example: 40 Hump timer tween 1
--[[
Description: 40 Hump timer tween 1
Author: Paco
]]


Timer = require "libs.hump.timer"
-- 'linear', 'quad', 'cubic', 'quart', 'quint', 'sine', 'expo', 'circ', 'back', 'bounce', and 'elastic'.
--  Timer.tween(duration, subject, target, method, after, ...)
function love.load()
    circle = {angle = 0, pos = {x = 60, y = 60}, size = {w =40, h=10}}
    -- multiple tweens can work on the same subject
    -- and nested values can be tweened, too
	local turn1, move1

	move1 = function()
		Timer.tween(2, circle, {pos = {x = 550}}, 'linear', turn2)
	end
	turn2 = function()
		Timer.tween(2, circle, {angle = (math.pi/2)}, 'linear', move2)
	end
	move2 = function()
		Timer.tween(2, circle, {pos = {y = 300}}, 'linear', turn3)
	end
	turn3 = function()
		Timer.tween(2, circle, {angle = (math.pi)}, 'linear', move3)
	end
	move3 = function()
		Timer.tween(2, circle, {pos = {x = 60}}, 'linear', turn4)
	end
	turn4 = function()
		Timer.tween(2, circle, {angle = (math.pi+(math.pi/2))}, 'linear', move4)
	end
	move4 = function()
		Timer.tween(2, circle, {pos = {y = 60}}, 'linear', turn1)
	end
	turn1 = function()
		circle.angle = -(math.pi/2)
		Timer.tween(2, circle, {angle = (0)}, 'linear', move1)
	end
	move1()
end

function love.update(dt)
    Timer.update(dt)
end

function love.draw()
    --love.graphics.circle('fill', circle.pos.x, circle.pos.y, circle.rad)
	drawRotatedRectangle('fill',circle.pos.x, circle.pos.y, circle.size.w, circle.size.h, circle.angle)
end

function drawRotatedRectangle(mode, x, y, width, height, angle)
	-- We cannot rotate the rectangle directly, but we
	-- can move and rotate the coordinate system.
	love.graphics.push()
	love.graphics.translate(x, y)
	love.graphics.rotate(angle)
	love.graphics.rectangle(mode, 0, 0, width, height)
	love.graphics.rectangle(mode, -10, -10, 10, 10)
	love.graphics.rectangle(mode, height, -10, 10, 10)
	love.graphics.pop()
end