require 'game/Puzzle'


local board = nil
local selectedStone = nil
local savedColor = {}


function love.load()
  math.randomseed(os.time())
  board = newBoard()
end

function love.update(dt)
end

function love.mousemoved(x, y, dx, dy, istouch)
  if selectedStone then
    selectedStone:setColor(savedColor.r, savedColor.g, savedColor.b)
    selectedStone = nil
  end
  local i, j = board:getPositionUnder(x, y)
  selectedStone = board:getStoneAt(i, j)
  if selectedStone then
    savedColor.r, savedColor.g, savedColor.b = selectedStone:getColor()
    selectedStone:setColor(255, 255, 255)
  end
end

function love.draw()
  board:draw()
end
