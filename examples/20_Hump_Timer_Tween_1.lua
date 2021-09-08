-- Example: 40 Hump timer tween 1
--[[
Description: 40 Hump timer tween 1
Author: Paco
]]


Timer = require "libs.hump.timer"
-- 'linear', 'quad', 'cubic', 'quart', 'quint', 'sine', 'expo', 'circ', 'back', 'bounce', and 'elastic'.
function love.load()
    color = {0, 0, 0}
    Timer.tween(10, color, {1, 1, 1}, 'in-out-quad')
end

function love.update(dt)
    Timer.update(dt)
end

function love.draw()
    love.graphics.setBackgroundColor(color)
end