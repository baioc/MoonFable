Board = {}

function newBoard(rows, columns)
  local self = {}
  setmetatable(self, Board)
  Board.__index = Board

  if not (tonumber(rows) and rows > 0) then
    error("invalid row number")
  end
  if not (tonumber(columns) and columns > 0) then
    error("invalid column number")
  end

  self.rows = rows
  self.columns = columns

  self.stones = {}
  for i=1,rows do
    local row = {}
    for j=1,columns do
      table.insert(row, newStone('random'))
    end
    table.insert(self.stones, row)
  end

  return self
end

function Board:getSize()
  return self.rows, self.columns
end

function Board:getRows()
  return self.rows
end

function Board:getColumns()
  return self.columns
end

function Board:at(row, column)
  return self.stones[row][column]
end

function Board:draw()
  local x, y = 35, 286
  local size = 50
  for i=1,self.rows do
    for j=1,self.columns do
      self.stones[i][j]:draw(x + (j - 1) * size, y + (i - 1) * size, size)
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

function Stone:draw(x, y, size)
  love.graphics.setColor(self.color.r, self.color.g, self.color.b)
  love.graphics.rectangle('fill', x, y, size, size)
end
