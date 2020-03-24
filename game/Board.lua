require 'game/Stone'
require 'game/Characters'

Board = {
  SFX_MATCH = love.audio.newSource('data/sounds/match.wav', 'static'),
  SFX_FALL = love.audio.newSource('data/sounds/fall.wav', 'static'),
}

function newBoard(rows, columns, x, y, player, enemy)
  local self = {}
  setmetatable(self, Board)
  Board.__index = Board

  -- board dimensions
  self.rows = rows
  self.columns = columns

  -- construct 2D board
  self.stones = {}
  for i = 1, self.rows do
    local row = {}
    for j = 1, self.columns do
      table.insert(row, newStone('random'))
    end
    table.insert(self.stones, row)
  end

  -- constants used for drawing
  self.x = x
  self.y = y

  -- animation control
  self.locked = false
  self.time = 0.0
  self.animation = nil
  self.timestep = 0.0

  -- reference to combatants
  self.player = player
  self.enemy = enemy

  return self
end

function Board:draw()
  for i = 1, self.rows do
    for j = 1, self.columns do
      self.stones[i][j]:draw(self.x + (j - 1) * 64, self.y + (i - 1) * 64)
    end
  end
end

function Board:getStone(i, j) -- -> returns stone or nil if invalid indexes
  if i > 0 and i <= self.rows and j > 0 and j <= self.columns then
    return self.stones[i][j]
  else
    return nil
  end
end

-- computes a pair of indexes mapping to the stone under given mouse position
function Board:getPositionUnder(x, y)
  local i = math.floor((y - self.y) / 64) + 1
  local j = math.floor((x - self.x) / 64) + 1
  return i, j
end

-- swaps stones and checks for any matches
function Board:swapStones(i, j, y, x)
  self.stones[i][j], self.stones[y][x] = self.stones[y][x], self.stones[i][j]

  if not self.locked then
    local matching = {} -- set of positions to be collapsed

    local type1 = self.stones[i][j]:getType()
    local n1 = self:checkMatch(type1, self:absolutePosition(i, j), matching)
    local type2 = self.stones[y][x]:getType()
    local n2 = self:checkMatch(type2, self:absolutePosition(y, x), matching)

    -- make the player act on match-driven command
    local skills = {}
    skills[type1] = n1 and n1 / 3
    skills[type2] = n2 and n2 / 3
    self.player:attack(self.enemy, skills)
    if not self.enemy:isDead() then self.enemy:attack(self.player) end

    if not n1 and not n2 then
      return
    end

    -- stone "explosion" effect
    Board.SFX_MATCH:stop()
    Board.SFX_MATCH:play()
    for _, stone in pairs(matching) do
      stone:setType('blink')
    end

    -- then begin animation (locks the board)
    self:animate(0.2, coroutine.create(function ()
      -- finish blinking effect
      for _, stone in pairs(matching) do
        stone:setType('gap')
      end
      -- animate stones falling, one timestep per frame
      local moved = true
      repeat
        coroutine.yield() -- each yield corresponds to 1 animation frame
        moved = false
        for i = self.rows,1 , -1 do -- bottom-up
          for j = 1, self.columns do
            if self.stones[i][j]:getType() == 'gap' then
              if i == 1 then
                Board.SFX_FALL:stop()
                Board.SFX_FALL:play()
                self.stones[i][j]:setType('random')
              elseif self.stones[i-1][j]:getType() ~= 'gap' then
                self:swapStones(i, j, i-1, j)
              end
              moved = true
            end
          end
        end
      until not moved
    end))
  end
end

function Board:checkMatch(type, origin, matching)
  -- breadth-first search algorithm
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

  local match = {}
  local n = 0
  repeat
    local position = table.remove(queue, 1)
    local i, j = self:matrixIndexes(position)
    match[position] = self.stones[i][j]
    n = n + 1
                    visit(i - 1, j)
    visit(i, j - 1)                 visit(i, j + 1)
                    visit(i + 1, j) -- try doing this in python
  until #queue < 1

  -- must match 3 or more; if it's the case, concatenate into out parameter
  if n >= 3 then
    for k, v in pairs(match) do
      matching[k] = v
    end
    return n
  else
    return nil
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

function Board:update(dt)
  -- when locked, wait for a full timestep
  if self.locked then
    self.time = self.time + dt
    if self.time >= self.timestep then
      self.time = self.time - self.timestep
      -- then resume the animation coroutine, unlocking when it finishes
      if not coroutine.resume(self.animation) then
        self.locked = false
      end
    end
  end
end

function Board:animate(dt, co)
  self.locked = true
  self.animation = co
  self.timestep = dt
end

function Board:isLocked()
  return self.locked
end
