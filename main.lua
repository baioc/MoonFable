require 'game/Puzzle'


local CURSOR_ARROW = love.mouse.getSystemCursor('arrow')
local CURSOR_HAND = love.mouse.getSystemCursor('hand')

local board = nil
local hovered = {stone = nil}
local grabbed = {stone = nil, i = nil, j = nil}


function love.load()
  math.randomseed(os.time())
  board = newBoard(8, 9, 36, 352, 64)
end

function love.mousemoved(x, y, dx, dy, istouch)
  local i, j = board:getPositionUnder(x, y)
  local stone = board:getStone(i, j)

  -- check if a stone swap was performed
  if love.mouse.isDown(1) and grabbed.stone and stone and grabbed.stone ~= stone then
    -- stones must have a Manhattan distance of 1
    if math.abs(grabbed.i - i) + math.abs(grabbed.j - j) == 1 then
      board:swapStones(i, j, grabbed.i, grabbed.j)
      stone = grabbed.stone
    end
    grabbed.stone = nil
    love.mouse.setCursor(CURSOR_ARROW)
  end

  -- "unhover" the previously hovered stone
  if hovered.stone then
    r, g, b = hovered.stone:getColor()
    hovered.stone:setColor(r, g, b, 1.0)
    hovered.stone = nil
  end

  -- if there's a stone there, apply hover effect
  if stone then
    r, g, b = stone:getColor()
    stone:setColor(r, g, b, 0.75)
    hovered.stone = stone
  -- otherwise out of board, so release grabbed stone (if any)
  elseif grabbed.stone then
    grabbed.stone = nil
    love.mouse.setCursor(CURSOR_ARROW)
  end
end

function love.mousepressed(x, y, button, istouch, presses)
  -- if left button is pressed, grab the stone under the mouse
  if button == 1 then
    local i, j = board:getPositionUnder(x, y)
    grabbed.stone = board:getStone(i, j)
    if grabbed.stone then
      grabbed.i, grabbed.j = i, j
      love.mouse.setCursor(CURSOR_HAND)
    end
  end
end

function love.mousereleased(x, y, button, istouch, presses)
  -- as left button is released, release grabbed stone (if any)
  if button == 1 then
    grabbed.stone = nil
    love.mouse.setCursor(CURSOR_ARROW)
  end
end

function love.draw()
  board:draw()
end
