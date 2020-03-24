Character = {}

function newCharacter(health)
  local self = {}
  setmetatable(self, Character)
  Character.__index = Character

  -- health points
  self.maxHp = health
  self.hp = health

  -- constants used for drawing
  -- @TODO: character sprites
  self.width = 200
  self.height = 200
  self.barSize = 20
  self.gap = 2

  return self
end

function Character:draw(x, y)
  love.graphics.setColor(15, 15, 15)
  love.graphics.rectangle('line', x, y, self.width, self.barSize)
  love.graphics.setColor(255, 0, 0)
  love.graphics.rectangle('fill',
                          x + self.gap,
                          y + self.gap,
                          (self.width - 2*self.gap) * self:getHealthPercent(),
                          self.barSize - 2*self.gap)
  love.graphics.setColor(255, 0, 255)
  love.graphics.rectangle('fill',
                          x,
                          y + self.barSize,
                          self.width,
                          self.height - self.barSize)
end

function Character:getHealthPercent()
  return self.hp / self.maxHp
end

function Character:takeDamage(damage)
  self.hp = math.max(self.hp - damage, 0)
end


Player = newCharacter()

function newPlayer(health)
  local self = newCharacter(health)
  setmetatable(self, Player)
  Player.__index = Player
  self.width = 150
  self.height = 200
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

function newEnemy(health)
  local self = newCharacter(health)
  setmetatable(self, Enemy)
  Enemy.__index = Enemy
  self.width = 200
  self.height = 250
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
