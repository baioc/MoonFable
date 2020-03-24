require 'game/Board'
require 'game/Stone'
require 'game/Character'

battle = { -- constants
  CURSOR_NORMAL = love.mouse.getSystemCursor('arrow'),
  CURSOR_MOVE = love.mouse.getSystemCursor('sizeall'),
}
local b = battle -- shorter, local alias

function battle.start(player, enemy) -- set initial state
  -- @TODO: starting animation: graphics and sounds
  b.player = player
  b.enemy = enemy
  b.board = newBoard(8, 9, 36, 352, player, enemy)
  b.hovered = {stone = nil}
  b.grabbed = {stone = nil, i = nil, j = nil}
end

function battle.draw()
  b.board:draw()
  b.player:draw(52, 84)
  b.enemy:draw(396, 32)
end

function battle.update(dt)
  b.board:update(dt)
  b.player:update(dt)
  b.enemy:update(dt)
end

function battle.mousemoved(x, y)
  -- get stone under the mouse (if any)
  local i, j = b.board:getPositionUnder(x, y)
  local stone = b.board:getStone(i, j)

  -- check if a stone swap is being performed
  if love.mouse.isDown(1) and b.grabbed.stone and stone and b.grabbed.stone ~= stone then
    -- stones must be side by side <-> Manhattan distance of 1
    if math.abs(b.grabbed.i - i) + math.abs(b.grabbed.j - j) == 1 then
      b.board:swapStones(i, j, b.grabbed.i, b.grabbed.j)
      stone = b.board:getStone(i, j)
    end
    b.grabbed.stone = nil
    love.mouse.setCursor(b.CURSOR_NORMAL)
  end

  -- "unhover" the previously hovered stone
  if b.hovered.stone then
    b.hovered.stone:setSelected(false)
    b.hovered.stone = nil
  end

  -- if there's a stone there, apply hover effect
  if stone then
    b.hovered.stone = stone
    b.hovered.stone:setSelected(true)
  -- otherwise out of b.board, so release b.grabbed stone (if any)
  elseif b.grabbed.stone then
    b.grabbed.stone = nil
    love.mouse.setCursor(b.CURSOR_NORMAL)
  end
end

function battle.mousepressed(x, y, button)
  -- if LB and board not locked, grab the stone under the mouse (if any)
  if button == 1 then
    local i, j = b.board:getPositionUnder(x, y)
    b.grabbed.stone = b.board:getStone(i, j)
    if b.grabbed.stone then
      b.grabbed.i, b.grabbed.j = i, j
      love.mouse.setCursor(b.CURSOR_MOVE)
    end
  end
end

function battle.mousereleased(x, y, button)
  -- as left button is released, release b.grabbed stone (if any)
  if button == 1 then
    b.grabbed.stone = nil
    love.mouse.setCursor(b.CURSOR_NORMAL)
  end
end
