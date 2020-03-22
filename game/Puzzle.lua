Board = {
  X = 36, Y = 353,
  STONE_SIZE = 64,
}

function newBoard()
  local self = {}
  setmetatable(self, Board)
  Board.__index = Board

  self.rows = 8
  self.columns = 9

  self.stones = {}
  for i=1,self.rows do
    local row = {}
    for j=1,self.columns do
      table.insert(row, newStone('random'))
    end
    table.insert(self.stones, row)
  end

  return self
end

function Board:getStoneAt(i, j)
  if i > 0 and i <= self.rows and j > 0 and j <= self.columns then
    return self.stones[i][j]
  end
end

function Board:getPositionUnder(x, y)
  local i = math.floor((y - Board.Y) / Board.STONE_SIZE) + 1
  local j = math.floor((x - Board.X) / Board.STONE_SIZE) + 1
  return i, j
end

function Board:draw()
  for i=1,self.rows do
    for j=1,self.columns do
      self.stones[i][j]:draw(Board.X + (j - 1) * Board.STONE_SIZE,
                             Board.Y + (i - 1) * Board.STONE_SIZE,
                             Board.STONE_SIZE)
    end
  end
end


Stone = {
  types = {'attack', 'defend', 'magic', 'potion', 'random'},
}

function newStone(type)
  local self = {}
  setmetatable(self, Stone)
  Stone.__index = Stone

  self.color = {}
  if type == 'attack' then
    self.color.r = 255
    self.color.g = 0
    self.color.b = 0
  elseif type == 'defend' then
    self.color.r = 0
    self.color.g = 255
    self.color.b = 0
  elseif type == 'magic' then
    self.color.r = 0
    self.color.g = 0
    self.color.b = 255
  elseif type == 'potion' then
    self.color.r = 255
    self.color.g = 255
    self.color.b = 0
  elseif type == 'random' then
    return newStone(Stone.types[math.random(#Stone.types - 1)])
  else
    error("invalid Stone type")
  end
  self.type = type

  return self
end

function Stone:getType()
  return self.type
end

function Stone:getColor()
  return self.color.r, self.color.g, self.color.b
end

function Stone:setColor(r, g, b)
  self.color.r = r
  self.color.g = g
  self.color.b = b
end

function Stone:draw(x, y, size)
  love.graphics.setColor(self.color.r, self.color.g, self.color.b)
  love.graphics.rectangle('fill', x, y, size, size)
end
