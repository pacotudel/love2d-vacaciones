-- Example: Particulas
-- Author: Paco
--[[Description: Particulas
Author: Paco
]]
------------------------------------------------------
--	Simple fire effect with canvas and particle system
------------------------------------------------------

-- Returns canvas of given width and height containing a white circle
function initCanvas (width, height)
	local c = love.graphics.newCanvas(width, height)
	love.graphics.setCanvas(c) -- Switch to drawing on canvas 'c'
	love.graphics.setBlendMode("alpha")
	--love.graphics.setColor(255, 255, 255, 255)
	love.graphics.setColor(1, 1, 1,1)
	love.graphics.circle("fill", width / 2, height / 2, 5, 100)
	love.graphics.setCanvas() -- Switch back to drawing on main screen
	return c
end

-- Returns particle system with given image and maximum particles to mimic fire
function initPartSys (image, maxParticles)
	local ps = love.graphics.newParticleSystem(image, maxParticles)
	ps:setParticleLifetime(0.1, 0.5) -- (min, max)
	ps:setSizeVariation(1)
	ps:setLinearAcceleration(-200, -2000, 200, 100) -- (minX, minY, maxX, maxY)
	--ps:setColors(234, 217, 30, 128, 224, 21, 21, 0) -- (r1, g1, b1, a1, r2, g2, b2, a2 ...)
	ps:setColors(0.9, 0.85, 0.11, 0.5, 0.87, 0.08, 0.08, 0)
	--ps:setDirection( -math.pi/2 )
	ps:setDirection( 1 )
	ps:setSizeVariation(0.7)
	return ps
end
function initPartSys2 (image, maxParticles)
	local ps = love.graphics.newParticleSystem(image, 47)
	ps:setColors(1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 0.5, 1, 1, 1, 0)
	ps:setDirection(2.1815223693848)
	ps:setEmissionArea("none", 0, 0, 0, false)
	ps:setEmissionRate(20)
	ps:setEmitterLifetime(-1)
	ps:setInsertMode("top")
	ps:setLinearAcceleration(0, 0, 0, 0)
	ps:setLinearDamping(0, 0)
	ps:setOffset(90, 90)
	ps:setParticleLifetime(1.7999999523163, 2.2000000476837)
	ps:setRadialAcceleration(0, 0)
	ps:setRelativeRotation(false)
	ps:setRotation(0, -0.78539818525314)
	ps:setSizes(0.40000000596046)
	ps:setSizeVariation(0)
	ps:setSpeed(90, 100)
	ps:setSpin(0, 0)
	ps:setSpinVariation(0)
	ps:setSpread(0.31415927410126)
	ps:setTangentialAcceleration(0, 0)
	return ps
end

function love.load ()
	love.window.setTitle("Left-click to make fire!")
	--local image1 = LG.newImage("lightDot.png")
	--image1:setFilter("linear", "linear")
	local canvas = initCanvas(20, 40)
	psystem = initPartSys (canvas, 50)
	psystem2 = initPartSys2 (canvas, 50)
end

function love.mousemoved (x, y, dx, dy)
	-- To move the particles along with the emitter, do this offset in love.graphics.draw instead of setPosition
	psystem:setPosition(x, y)
	psystem2:setPosition(x+100, y)
end

function love.update (dt)
	-- Only emit particles when left mouse button is down
	if love.mouse.isDown(1) then
		psystem:setEmissionRate(3)
		psystem:setDirection( -math.pi/2 )
		
	else
		psystem:setEmissionRate(100)
		psystem:setDirection( 0 )
	end
	-- Particle system should usually be updated from within love.update
	psystem:update(dt)
	psystem2:update(dt)
end

function love.draw ()
	-- Try different blend modes out - https://love2d.org/wiki/BlendMode
	--love.graphics.setBlendMode("additive")
	
	-- Redraw particle system every frame
	love.graphics.draw(psystem)
	love.graphics.draw(psystem2)
end	