Scene = {}

function newScene(t)
  self = t or {}
  setmetatable(self, Scene)
  Scene.__index = Scene
  return self
end

function Scene.start(...)
end

function Scene.draw()
end

function Scene.update(dt)
  return true
end

function Scene.mousemoved(x, y)
end

function Scene.mousepressed(x, y, button)
end

function Scene.mousereleased(x, y, button)
end

function Scene.keypressed(key)
end

function Scene.textinput(text)
end
