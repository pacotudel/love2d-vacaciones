-- Example: 41 Hump timer tween 2
--[[
Description: 41_Hump_timer_tween_2
Author: Paco
]]

-- 'linear', 'quad', 'cubic', 'quart', 'quint', 'sine', 'expo', 'circ', 'back', 'bounce', and 'elastic'.
Timer = require "libs.hump.timer"
function love.load()
    circle = {rad = 10, pos = {x = 400, y = 300}}
    -- multiple tweens can work on the same subject
    -- and nested values can be tweened, too
    Timer.tween(5, circle, {rad = 50}, 'in-out-quad')
    Timer.tween(2, circle, {pos = {y = 550}}, 'out-bounce')
end

function love.update(dt)
    Timer.update(dt)
end

function love.draw()
    love.graphics.circle('fill', circle.pos.x, circle.pos.y, circle.rad)
end