-- Example: Arco
--[[
Description: Esta un punto dentro de un arco?
Author: unknown
]]
local sentryX, sentryY, sentryR = 200, 200, 10
local targetX, targetY, targetR = 400, 300, 10
local arcR = 200
local arcAngle = 30
local arcFunnel = math.rad(12)

function love.mousemoved(x, y, dx, dy)
  if love.mouse.isDown(1) then
    arcAngle = (arcAngle + dx/60) % 6.283185307179586 -- 2*pi
  elseif love.mouse.isDown(2) then
    arcFunnel = (arcFunnel + dx/60)
    if arcFunnel < math.rad(1.5) then arcFunnel = math.rad(1.5) end
    if arcFunnel > 6.283185307179586 then arcFunnel = 6.283185307179586 end
    arcFunnel = arcFunnel % 6.283185307179586
  else
    sentryX, sentryY = x, y
  end
end

function love.keypressed(k) 
	if love.keyboard.isDown("right") then
		arcAngle = arcAngle + 0.1
   	elseif love.keyboard.isDown("left") then
		arcAngle = arcAngle - 0.1
	elseif love.keyboard.isDown("up") then
		arcR = arcR + 10
	elseif love.keyboard.isDown("down") then
		arcR = arcR - 10
	elseif love.keyboard.isDown("escape") then
		love.event.quit()
   	end
end

--local sin, cos, sqrt = math.sin, math.cos, math.sqrt

local function withinSector(tx, ty, tr, sx, sy, ar, a1, a2)
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

function love.draw()
  love.graphics.setColor(1, 1, 1)
  love.graphics.circle("fill", sentryX, sentryY, targetR)
  if withinSector(targetX, targetY, targetR, sentryX, sentryY, arcR, arcAngle-arcFunnel, arcAngle+arcFunnel) then
    love.graphics.setColor(1, 0.7, 0.7, 0.8)
  else
    love.graphics.setColor(0.7, 0.7, 0.7, 0.7)
  end
  --love.graphics.arc(drawmode, x,       y,       radius, angle1,             angle2,            segments )
  love.graphics.arc("fill",     sentryX, sentryY, arcR,   arcAngle-arcFunnel, arcAngle+arcFunnel)
  love.graphics.arc("line",     sentryX, sentryY, arcR,   arcAngle-arcFunnel, arcAngle+arcFunnel)
  love.graphics.setColor(1, 0, 0)
  love.graphics.circle("fill", targetX, targetY, targetR)

  love.graphics.setColor(1, 1, 1)
end
