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
  self:checkMatch(self.stones[i][j]:getType(), self:absolutePosition(i, j))
  self:checkMatch(self.stones[y][x]:getType(), self:absolutePosition(y, x))
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

function Board:absolutePosition(i, j)
  return (i - 1)*self.columns + j
end

function Board:matrixIndexes(position)
  local j = (position - 1) % self.columns + 1
  local i = math.floor((position - 1) / self.columns) + 1
  return i, j
end

function Board:checkMatch(type, origin)
  -- gaps shouldn't match
  if type == 'gap' then return end

  local visited = {}
  visited[origin] = true
  local queue = {origin}

  local function visit (i, j)
    if j < 1 or j > self.columns or i < 1 or i > self.rows then
      return -- skip invalid positions
    end

    local position = self:absolutePosition(i, j)
    if visited[position] then
      return -- skip already-visited positions
    end

    -- mark as visited and add it to the queue if it has the right type
    visited[position] = true
    if self.stones[i][j]:getType() == type then
      table.insert(queue, position)
    end
  end

  local matching = {}
  local n = 0
  repeat
    local position = table.remove(queue, 1)
    local i, j = self:matrixIndexes(position)
    matching[position] = self.stones[i][j]
    n = n + 1
    -- try doing this in python
                    visit(i - 1, j)
    visit(i, j - 1)                 visit(i, j + 1)
                    visit(i + 1, j)
  until #queue < 1

  -- collapse stones if match 3 or more
  if n >= 3 then
    -- @FIXME: missing an actual animation
    -- @TODO: what do we get by matching
    for _, stone in pairs(matching) do
      -- stone:setType('gap')
      stone:setColor(nil, nil, nil, 0.25)
    end
  end
end


Stone = {
  types = {'attack', 'defend', 'magic', 'potion'},
}

function newStone(type)
  local self = {}
  setmetatable(self, Stone)
  Stone.__index = Stone

  self.color = {a = 1.0}
  self:setType(type)

  return self
end

function Stone:getType()
  return self.type
end

function Stone:setType(type)
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
    return self:setType(Stone.types[math.random(#Stone.types)])
  elseif type == 'gap' then
    self.color.r = 0
    self.color.g = 0
    self.color.b = 0
  else
    error("invalid Stone type " .. tostring(type))
  end
  self.type = type
end

function Stone:getColor()
  return self.color.r, self.color.g, self.color.b, self.color.a
end

function Stone:setColor(r, g, b, ...) -- optional: alpha value
  self.color.r = r or self.color.r
  self.color.g = g or self.color.g
  self.color.b = b or self.color.b
  local arg = {...}
  self.color.a = arg[1] or self.color.a
end

function Stone:draw(x, y, size)
  love.graphics.setColor(self.color.r, self.color.g, self.color.b, self.color.a)
  love.graphics.rectangle('fill', x, y, size, size)
end
