
vector = {
    new = function(x,y)
        local x = x or 0
        local y = y or 0
        local v = {x=x,y=y}
        setmetatable(v, vector)
        return v
    end,

    dist = function(a,b)
        return (a-b):len()
    end,
    __add = function(a, b)
        return vector.new(a.x + b.x, a.y + b.y)
    end,
    __sub = function(a, b)
        return vector.new(a.x - b.x, a.y - b.y)
    end,
    __mul = function(a, b)
        if type(a) == "number" then
            return vector.new(a * b.x, a * b.y) end
        return vector.new(b * a.x, b * a.y)
    end,
    __div = function(a,b)
        return a * (1 / b)
    end,
    len2 = function(a)
        return a.x * a.x + a.y * a.y
    end,
    len = function(a)
        return math.sqrt(a:len2())
    end,
    normalized = function(a)
        local l = a:len()
        if l > 0 then return a / a:len() end
        return vector.new(0,0)
    end
}
vector.__index = vector