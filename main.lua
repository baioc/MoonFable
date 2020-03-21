require 'game/Puzzle'


local board = nil


function love.load()
  math.randomseed(os.time())

  board = newBoard(8, 9)
end

function love.update(dt)
end

function love.draw()
  board:draw()
end
