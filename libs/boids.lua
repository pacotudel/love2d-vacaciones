local boids = {}
boids.__index = boids

function boids:new(x,y,angle)
	local t = {}
	t.x,t.y,t.angle = x,y,angle
	t.crowded = 0
	setmetatable(t,self)
	return t
end

function boids:update(i,dt,field)
	local dx,dy = math.cos(self.angle),math.sin(self.angle)
	self.x,self.y = self.x+dx*30*dt,self.y+dy*30*dt
	if self.x < 0 then self.x = W - self.x
	elseif self.x > W then self.x = self.x - W
	end
	if self.y < 0 then self.y = H - self.y
	elseif self.y > H then self.y = self.y - H
	end
	
	local neighbors = {}
	for j,boid in ipairs(field) do
		if dist(boid.x,boid.y,self.x,self.y) <= 50 and j~= i then table.insert(neighbors,boid) end
	end
	
	local num = #neighbors
	self.crowded = math.min(num,20)
	if num >= 1 then
		local totalx,totaly = 0,0
		local totalangle = 0
		local closest = {x=math.huge,y=math.huge}
		for _,boid in ipairs(neighbors) do
			totalx,totaly = boid.x+totalx,boid.y+totaly
			totalangle = boid.angle + totalangle
			if dist(closest.x,closest.y,self.x,self.y) > dist(boid.x,boid.y,self.x,self.y) then
				closest = {x=boid.x,y=boid.y}
			end
		end
		local avg_pos = {x=totalx/num,y=totaly/num}
		local avg_pos_angle = math.atan2(avg_pos.y-self.y,avg_pos.x-self.x)
		local avg_angle = totalangle/num
		local counter_angle = math.atan2(self.y-closest.y,self.x-closest.x)
		
		self:adjustAngle(avg_pos_angle,dt,2)
		self:adjustAngle(avg_angle,dt,2)
		self:adjustAngle(counter_angle,dt,num/5)
	end
	if cursor.press then
		local cursor_angle = math.atan2(cursor.y-self.y,cursor.x-self.x)
		self:adjustAngle(cursor_angle,dt,2)
	end
end

function boids:adjustAngle(target_angle,dt,power)
	local power = power or 1
	local target_angle = target_angle
	local angle_diff = target_angle - self.angle
	if math.abs(angle_diff) > math.pi then
		if angle_diff > 0 then
			angle_diff = -(2*math.pi-target_angle+self.angle)
		else
			angle_diff = 2*math.pi-self.angle+target_angle
		end
	end
	if angle_diff > 0 then
		self.angle = self.angle + power*dt
	else
		self.angle = self.angle - power*dt
	end
end

function boids:draw()
	love.graphics.setColor(255,255*(20-self.crowded)/20,255*(20-self.crowded)/20)
	local x1,y1 = self.x+math.cos(self.angle)*5,self.y+math.sin(self.angle)*5
	local x2,y2 = self.x+math.cos(self.angle+math.pi*0.8)*5,self.y+math.sin(self.angle+math.pi*0.8)*5
	local x3,y3 = self.x+math.cos(self.angle-math.pi*0.8)*5,self.y+math.sin(self.angle-math.pi*0.8)*5
	love.graphics.polygon("line",x1,y1,x2,y2,x3,y3)
end

return boids