require 'game/battle'
require 'game/Character'

-- @TODO: outer map
-- @TODO: scene change
-- @TODO: main menu

function love.load()
  math.randomseed(os.time())
  battle.load()
  battle.start(newPlayer(100), newEnemy(100))
end

function love.draw()
  battle.draw()
end

function love.update(dt)
  battle.update(dt)
end

function love.mousemoved(x, y, dx, dy, istouch)
  battle.mousemoved(x, y)
end

function love.mousepressed(x, y, button, istouch, presses)
  battle.mousepressed(x, y, button)
end

function love.mousereleased(x, y, button, istouch, presses)
  battle.mousereleased(x, y, button)
end
