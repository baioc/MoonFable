require 'game/Board'
require 'game/Stone'
require 'game/Characters'
require 'game/Scene'

battle = newScene({ -- constants
  CURSOR_NORMAL = love.mouse.getSystemCursor('arrow'),
  CURSOR_MOVE = love.mouse.getSystemCursor('sizeall'),
  TREE = love.graphics.newImage('data/images/pine_tree.png'),
  SFX_SWAP = love.audio.newSource('data/sounds/swap.wav', 'static'),
})
local b = battle -- shorter, local alias

function battle.start(player, enemy) -- set initial state
  b.player = player
  b.enemy = enemy
  b.board = newBoard(8, 9, 36, 352, player, enemy)
  b.hovered = {stone = nil}
  b.grabbed = {stone = nil, i = nil, j = nil}
  return battle
end

function battle.draw()
  love.graphics.setColor(0.14, 0.09, 0.32)
  love.graphics.rectangle('fill', 0, 0, 650, 150)
  love.graphics.setColor(0.25, 0.51, 0.27)
  love.graphics.rectangle('fill', 0, 150, 650, 172)
  love.graphics.setColor(1, 1, 1)
  love.graphics.draw(b.TREE, 0, 8, 0, 0.5, 0.5)
  love.graphics.draw(b.TREE, 60, 12, 0, 0.5, 0.6)
  love.graphics.draw(b.TREE, 150, 18, 0, 0.5, 0.55)
  love.graphics.draw(b.TREE, 250, 8, 0, 0.5, 0.5)
  love.graphics.draw(b.TREE, 320, 20, 0, 0.5, 0.5)
  love.graphics.draw(b.TREE, 420, 16, 0, 0.4, 0.4)
  love.graphics.draw(b.TREE, 520, 16, 0, 0.4, 0.4)
  love.graphics.draw(b.TREE, 580, 18, 0, 0.5, 0.5)
  --
  love.graphics.setColor(0.98, 0.83, 0.11)
  love.graphics.rectangle('fill', 0, 322, 650, 578)
  love.graphics.setColor(0.93, 0.69, 0)
  love.graphics.rectangle('fill', 20, 342, 610, 538)
  b.board:draw()
  --
  b.player:draw(64, 84)
  b.enemy:draw(396, 32)
end

function battle.update(dt) -- returns winner of battle if it finished
  b.board:update(dt)
  b.player:update(dt)
  b.enemy:update(dt)
  if b.enemy:isDead() then
    return b.player
  elseif b.player:isDead() then
    return b.enemy
  else
    return nil
  end
end

function battle.mousemoved(x, y)
  -- get stone under the mouse (if any)
  local i, j = b.board:getPositionUnder(x, y)
  local stone = b.board:getStone(i, j)

  -- check if a stone swap is being performed
  if love.mouse.isDown(1) and b.grabbed.stone and stone and b.grabbed.stone ~= stone then
    -- stones must be side by side <-> Manhattan distance of 1
    if math.abs(b.grabbed.i - i) + math.abs(b.grabbed.j - j) == 1 then
      b.SFX_SWAP:stop()
      b.SFX_SWAP:play()
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
  if button == 1 and not b.board:isLocked() then
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
