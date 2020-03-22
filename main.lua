require 'game/Puzzle'


-- constants
local CURSOR_NORMAL = nil
local CURSOR_MOVE = nil

-- global state
local board = nil
local hovered = nil
local grabbed = nil


function love.load()
  math.randomseed(os.time())

  CURSOR_NORMAL = love.mouse.getSystemCursor('arrow')
  CURSOR_MOVE = love.mouse.getSystemCursor('sizeall')

  board = newBoard(8, 9, 36, 352, 64)
  hovered = {stone = nil}
  grabbed = {stone = nil, i = nil, j = nil}
end

function love.update(dt)
  board:update(dt)
end

function love.draw()
  board:draw()
end

function love.mousemoved(x, y, dx, dy, istouch)
  -- get stone under the mouse (if any)
  local i, j = board:getPositionUnder(x, y)
  local stone = board:getStone(i, j)

  -- check if a stone swap was performed
  if love.mouse.isDown(1) and grabbed.stone and stone and grabbed.stone ~= stone then
    -- stones must have a Manhattan distance of 1
    if math.abs(grabbed.i - i) + math.abs(grabbed.j - j) == 1 then
      board:swapStones(i, j, grabbed.i, grabbed.j) -- may lock the board
      stone = board:getStone(i, j)
    end
    grabbed.stone = nil
    love.mouse.setCursor(CURSOR_NORMAL)
  end

  -- "unhover" the previously hovered stone
  if hovered.stone then
    hovered.stone:setColor(nil, nil, nil, 1.0)
    hovered.stone = nil
  end

  -- if there's a stone there, apply hover effect
  if stone and not board:isLocked() then
    stone:setColor(nil, nil, nil, 0.75)
    hovered.stone = stone
  -- otherwise out of board, so release grabbed stone (if any)
  elseif grabbed.stone then
    grabbed.stone = nil
    love.mouse.setCursor(CURSOR_NORMAL)
  end
end

function love.mousepressed(x, y, button, istouch, presses)
  -- if left button is pressed, grab the stone under the mouse (if any)
  if button == 1 and not board:isLocked() then
    local i, j = board:getPositionUnder(x, y)
    grabbed.stone = board:getStone(i, j)
    if grabbed.stone then
      grabbed.i, grabbed.j = i, j
      love.mouse.setCursor(CURSOR_MOVE)
    end
  end
end

function love.mousereleased(x, y, button, istouch, presses)
  -- as left button is released, release grabbed stone (if any)
  if button == 1 then
    grabbed.stone = nil
    love.mouse.setCursor(CURSOR_NORMAL)
  end
end
