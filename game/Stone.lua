Stone = {
  types = {'attack', 'heal', 'magic', 'defend', 'gap'},
}

function newStone(type)
  local self = {}
  setmetatable(self, Stone)
  Stone.__index = Stone
  self.color = {a = 1.0}
  self:setType(type)
  return self
end

function Stone:draw(x, y, size)
  love.graphics.setColor(self.color.r, self.color.g, self.color.b, self.color.a)
  love.graphics.rectangle('fill', x, y, size, size)
end

function Stone:getColor()
  return self.color.r, self.color.g, self.color.b, self.color.a
end

function Stone:setColor(r, g, b, ...) -- optional alpha value
  self.color.r = r or self.color.r
  self.color.g = g or self.color.g
  self.color.b = b or self.color.b
  self.color.a = select(1, ...) or self.color.a
end

function Stone:getType()
  return self.type
end

function Stone:setType(type)
  -- @TODO: stone sprites
  if type == 'attack' then
    self.color.r = 255
    self.color.g = 0
    self.color.b = 0
  elseif type == 'heal' then
    self.color.r = 0
    self.color.g = 255
    self.color.b = 0
  elseif type == 'magic' then
    self.color.r = 0
    self.color.g = 0
    self.color.b = 255
  elseif type == 'defend' then
    self.color.r = 255
    self.color.g = 255
    self.color.b = 0
  elseif type == 'gap' then
    self.color.r = 0
    self.color.g = 0
    self.color.b = 0
  elseif type == 'random' then
    return self:setType(Stone.types[math.random(#Stone.types - 1)])
  else
    error("invalid Stone type " .. tostring(type))
  end
  self.type = type
end
