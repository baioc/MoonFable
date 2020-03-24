Character = {}

function newCharacter(health)
  local self = {}
  setmetatable(self, Character)
  Character.__index = Character

  -- health points
  self.maxHp = health
  self.hp = health

  return self
end

function Character:draw(x, y)
  if not self.sprite then error("missing character sprite") end
  local w, _ = self.sprite:getDimensions()
  love.graphics.setColor(0.66, 0.66, 0.66)
  love.graphics.rectangle('fill', x, y, w, 20)
  love.graphics.setColor(0.8, 0, 0)
  love.graphics.rectangle('fill', x + 2, y + 2, (w - 4) * self:getHealthPercent(), 16)
  love.graphics.setColor(1, 1, 1)
  love.graphics.draw(self.sprite, x, y + 20)
end

function Character:getHealthPercent()
  return self.hp / self.maxHp
end

function Character:takeDamage(damage)
  self.hp = math.max(self.hp - damage, 0)
end


Player = newCharacter()
Player.sprite = love.graphics.newImage('data/images/elemental.png')

function newPlayer(health)
  local self = newCharacter(health)
  setmetatable(self, Player)
  Player.__index = Player

  self.sprite = Player.sprite

  return self
end

function Player:attack(target, skills)
  -- @TODO: improve player attack
  for type, modifier in pairs(skills) do
    print(type .. " -> " .. modifier)
    target:takeDamage(10 * modifier)
  end
end

function Player:update(dt)
  -- @TODO: player animations
end


Enemy = newCharacter()
Enemy.monsters = {
  ['slime'] = {
    sprite = love.graphics.newImage('data/images/slime.png')
  },
  ['owlbear'] = {
    sprite = love.graphics.newImage('data/images/owlbear.png')
  },
  ['gorillaphant'] = {
    sprite = love.graphics.newImage('data/images/gorillaphant.png')
  },
}

function newEnemy(type, health)
  local self = newCharacter(health)
  setmetatable(self, Enemy)
  Enemy.__index = Enemy

  self.sprite = Enemy.monsters[type].sprite

  return self
end

function Enemy:attack(target)
  -- @TODO: improve enemy attack
  print("enemy -> !!")
  target:takeDamage(10)
end

function Enemy:update(dt)
  -- @TODO: enemy animations
end
