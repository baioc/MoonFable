Character = {}

function newCharacter(name, health)
  local self = {}
  setmetatable(self, Character)
  Character.__index = Character

  -- status control
  self.name = name
  self.maxHp = health
  self.hp = health

  -- animation control
  self.sprite = nil
  self.time = 0.0
  self.timestep = 0.0
  self.alpha = 1.0
  self.countdown = 0
  self.damage = 0

  return self
end

function Character:draw(x, y)
  if not self.sprite then error("missing character sprite") end
  local w, _ = self.sprite:getDimensions()

  -- draw life bar
  love.graphics.setColor(1, 1, 1)
  love.graphics.print(self.name, x, y)
  love.graphics.setColor(0.66, 0.66, 0.66)
  love.graphics.rectangle('fill', x, y+20, w, 20)
  love.graphics.setColor(0.8, 0, 0)
  love.graphics.rectangle('fill', x+2, y+22, (w-4)*self:getHealthPercent(), 16)

  -- draw sprite
  love.graphics.setColor(1, 1, 1, self.alpha)
  love.graphics.draw(self.sprite, x, y+40)

  -- draw damage
  if self.countdown > 0 then
    love.graphics.setColor(0.96, 0.68, 0)
    love.graphics.print(self.damage, x + w/3, y - 40 + 10*self.countdown, 0, 3, 3)
  end
end

function Character:isDead()
  return self.hp <= 0
end

function Character:getHealthPercent()
  return self.hp / self.maxHp
end

function Character:takeDamage(damage)
  -- @TODO: damage sfx
  self.damage = tostring(damage)
  if damage > 0 then
    -- apply life loss
    self.hp = math.max(self.hp - damage, 0)
    -- start hit animation
    self.time = 0.0
    self.timestep = 0.1
    self.countdown = 8
  end
end

function Character:update(dt)
  if self.countdown > 0 then
    self.time = self.time + dt
    if self.time >= self.timestep then
      self.time = self.time - self.timestep
      self.countdown = self.countdown - 1
      self.alpha = 1.0 - 0.35*((self.countdown % 4) % 2) -- hit blink animation
    end
  end
end


Player = newCharacter()
Player.sprite = love.graphics.newImage('data/images/elemental.png')

function newPlayer(name)
  local self = newCharacter(name, 100)
  setmetatable(self, Player)
  Player.__index = Player
  self.sprite = Player.sprite
  self.armour = 0
  self.heal = nil
  return self
end

function Player:attack(enemy, skills)
  -- @TODO: player skills sfx
  for type, modifier in pairs(skills) do
    if type == 'heal' then
      local heal = math.floor(10 * modifier)
      self.hp = math.min(self.hp + heal, self.maxHp)
      self.heal = tostring(heal)
    elseif type == 'defend' then
      self.armour = (modifier / 10) + 0.2
    else
      enemy:takeDamage(math.floor(10 * modifier))
    end
  end
end

function Player:takeDamage(damage)
  -- armour prefents some damage on next hit only
  if self.armour > 0 then
    damage = math.floor(damage * (1 - self.armour))
    self.armour = 0
  end
  Character.takeDamage(self, damage)
end

function Player:draw(x, y)
  -- after everything else
  Character.draw(self, x, y)
  local w, _ = self.sprite:getDimensions()
  -- draw healing
  if self.countdown > 0 and self.heal then
    love.graphics.setColor(0, 0.96, 0.13)
    love.graphics.print("+"..self.heal, x + w/1.5, y + 10 + 10*self.countdown, 0, 3, 3)
  elseif self.countdown <= 0 then
    self.heal = nil
  end
end


Enemy = newCharacter()
Enemy.types = {'slime', 'owlbear', 'gorillaphant'}
Enemy.monsters = {
  ['slime'] = {
    name = 'Slime',
    health = 100,
    sprite = love.graphics.newImage('data/images/slime.png')
  },
  ['owlbear'] = {
    name = 'Owlbear',
    health = 200,
    sprite = love.graphics.newImage('data/images/owlbear.png')
  },
  ['gorillaphant'] = {
    name = 'Gorillaphant',
    health = 400,
    sprite = love.graphics.newImage('data/images/gorillaphant.png')
  },
}

function newEnemy(type)
  if type == 'random' then type = Enemy.types[math.random(#Enemy.types)] end
  local self = newCharacter(Enemy.monsters[type].name, Enemy.monsters[type].health)
  setmetatable(self, Enemy)
  Enemy.__index = Enemy
  self.sprite = Enemy.monsters[type].sprite
  return self
end

function Enemy:attack(target)
  target:takeDamage(10)
end
