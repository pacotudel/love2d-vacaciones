local G = love.graphics

bullets = { }

Bullet = Object:New {
	size = 4,
	x = 0,
	y = 0,
	angle = 0,
	speed = 0
}

function Bullet:init()
	
end
function Bullet:reset()
	self.x = 0
	self.y = 0
end

function Bullet:update(dt)

end
function Bullet:draw()

end

-- Bullets
function bullets.insert(x,y,angle,dist,size,speed)
	--[[table.insert(bullets, 
		{	
		x = x + math.cos(math.rad(angle-90)) * (dist), 
		y = y + math.sin(math.rad(angle-90)) * (dist),	
		dir = math.rad(angle)-(math.pi/2),
		speed = speed,
		size = size,
		})
		]]--
		table.insert(bullets, 
		{	
		x = x + math.cos(angle) * (dist), 
		y = y + math.sin(angle) * (dist),	
		dir = angle,
		speed = speed,
		size = size,
		})
end
function bullets.update(dt)
    for i, o in ipairs(bullets) do
        o.x = o.x + math.cos(o.dir) * o.speed * dt
        o.y = o.y + math.sin(o.dir) * o.speed * dt
    end
	-- clean up out-of-screen bullets:
	for i = #bullets, 1, -1 do
        local o = bullets[i]
        if (o.x < -10) or (o.x > love.graphics.getWidth() + 10)
        or (o.y < -10) or (o.y > love.graphics.getHeight() + 10) then
            table.remove(bullets, i)
        end
    end
end

function bullets.draw()
	for i, o in ipairs(bullets) do
		love.graphics.circle('fill', o.x, o.y, o.size, 8)
	end
end

function bullets.count()
	return #bullets
end