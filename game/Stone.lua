Stone = { -- constants
  types = {'attack', 'heal', 'magic', 'defend'}, -- ++ 'gap', 'blink'
  sprites = {
    ['attack'] = love.graphics.newImage('data/images/attack_stone.png'),
    ['heal'] = love.graphics.newImage('data/images/heal_stone.png'),
    ['magic'] = love.graphics.newImage('data/images/magic_stone.png'),
    ['defend'] = love.graphics.newImage('data/images/defend_stone.png'),
  },
}

function newStone(type)
  local self = {}
  setmetatable(self, Stone)
  Stone.__index = Stone
  self:setType(type)
  return self
end

function Stone:setType(type)
  if type == 'random' then
    type = Stone.types[math.random(#Stone.types)]
  end
  local sprite = Stone.sprites[type]
  if sprite then
    self.sprite = sprite
    self.glow = 0.0
  elseif type == 'blink' then
    self.glow = 0.75
  elseif type == 'gap' then
    self.sprite = nil
  else
    error("invalid Stone type " .. tostring(type))
  end
  self.type = type
end

function Stone:getType()
  return self.type
end

function Stone:draw(x, y)
  if self.sprite then
    love.graphics.setColor(1, 1, 1)
    love.graphics.draw(self.sprite, x, y)
    if self.glow > 0 then
      love.graphics.setColor(1, 1, 1, self.glow)
      love.graphics.rectangle('fill', x, y, 64, 64)
    end
  end
end

function Stone:setSelected(selected)
  if self.type ~= 'blink' and selected then
    self.glow = 0.5
  elseif self.type ~= 'blink' then
    self.glow = 0.0
  end
end
