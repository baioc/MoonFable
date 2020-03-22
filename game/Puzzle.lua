Board = {}

function newBoard(rows, columns, x, y, stoneSize)
  local self = {}
  setmetatable(self, Board)
  Board.__index = Board

  self.rows = rows
  self.columns = columns
  self.x = x
  self.y = y
  self.stoneSize = stoneSize

  -- construct 2D board
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

function Board:getStone(i, j) -- -> returns stone or nil if invalid indexes
  if i > 0 and i <= self.rows and j > 0 and j <= self.columns then
    return self.stones[i][j]
  else
    return nil
  end
end

function Board:swapStones(i, j, y, x)
  self.stones[i][j], self.stones[y][x] = self.stones[y][x], self.stones[i][j]
  -- @TODO: collapse board if match 3 or more
end

-- computes a pair of indexes mapping to the stone under given mouse position
function Board:getPositionUnder(x, y)
  local i = math.floor((y - self.y) / self.stoneSize) + 1
  local j = math.floor((x - self.x) / self.stoneSize) + 1
  return i, j
end

function Board:draw()
  for i=1,self.rows do
    for j=1,self.columns do
      self.stones[i][j]:draw(self.x + (j - 1) * self.stoneSize,
                             self.y + (i - 1) * self.stoneSize,
                             self.stoneSize)
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
  self.color.a = 1.0
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
  return self.color.r, self.color.g, self.color.b, self.color.a
end

function Stone:setColor(r, g, b, ...) -- optional: alpha value
  self.color.r = r
  self.color.g = g
  self.color.b = b
  local arg = {...}
  self.color.a = arg[1] or self.color.a
end

function Stone:draw(x, y, size)
  love.graphics.setColor(self.color.r, self.color.g, self.color.b, self.color.a)
  love.graphics.rectangle('fill', x, y, size, size)
end
