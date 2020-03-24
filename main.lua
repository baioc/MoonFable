require 'game/battle'
require 'game/intro'

local Game = {
  player = nil,
  scene = nil,
}

-- game over scene
Game.over = newScene({
  draw = function ()
    love.graphics.printf(
      "YOU DIED\nClick to restart",
      0, 370, 650/4, 'center', 0, 4, 4)
  end,
  mousepressed = function(x, y, button)
    if button == 1 then
      Game.player = newPlayer(Game.player.name)
      Game.scene = battle.start(Game.player, newEnemy('slime'))
    end
  end,
})

-- @TODO: outer map

function love.load()
  math.randomseed(os.time())
  love.keyboard.setKeyRepeat(true)
  love.graphics.setFont(love.graphics.newFont('data/fonts/NemoyBold.ttf'))
  Game.scene = intro.start()
end

function love.draw()
  Game.scene.draw()
end

function love.update(dt)
  -- update current scene and check for any returns
  local ret = Game.scene.update(dt)
  if not ret then return end
  -- when update returns, change scene accordingly
  if Game.scene == intro then
      Game.player = ret
      Game.scene = battle.start(Game.player, newEnemy('slime'))
  elseif Game.scene == battle then
    if ret == Game.player then
      Game.scene = battle.start(Game.player, newEnemy('random'))
    else
      Game.scene = Game.over
    end
  end
end

function love.mousemoved(x, y, dx, dy, istouch)
  Game.scene.mousemoved(x, y)
end

function love.mousepressed(x, y, button, istouch, presses)
  Game.scene.mousepressed(x, y, button)
end

function love.mousereleased(x, y, button, istouch, presses)
  Game.scene.mousereleased(x, y, button)
end

function love.keypressed(key, scancode, isrepeat)
  Game.scene.keypressed(key)
end

function love.textinput(text)
  Game.scene.textinput(text)
end
