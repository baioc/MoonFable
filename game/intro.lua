local utf8 = require("utf8")
require 'game/Scene'
require 'game/Characters'

intro = newScene()
local i = intro -- alias
i.exposition = ". . .\n" ..
               "\nYour body feels six times heavier. Even though its dark, hot air moves around you. " ..
               "For some reason, the silent darkness of your home has been replaced by this noisy and bright strange world. " ..
               "You wonder if this is what death feels like...\n" ..
               "\nNo, you remember . . . a dark stone, oddly flat, with perfectly squared edges. Somehow, it felt wrong. " ..
               "Maybe it did something to you. Maybe it shaped your lonely planet into this hellish nightmare you find yourself in.\n" ..
               "\nLooking around, you find some of your special moon stones. That's it, all hope's not lost yet. " ..
               "You gather up the fragments of your home, knowing they will help you find your way back.\n" ..
               "\nYour head starts spinning.\n" ..
               "\n. . .\n" ..
               "\nWhat was your name, again?\n\n"

function intro.start()
  love.keyboard.setKeyRepeat(true)
  i.name = ""
  i.done = false
  i.char = 0
  i.time = 0.0
  -- @FIXME: sync timestep to typing sfx
  i.timestep = 0 -- 0.08
  return intro
end

function intro.draw()
  love.graphics.printf(string.sub(i.exposition, 1, i.char), 50, 100, 550/1.5, 'left', 0, 1.5, 1.5)
  if i.char >= #i.exposition then
    love.graphics.printf("> " .. i.name .. " <", 0, 650, 650/1.5, 'center', 0, 1.5, 1.5)
  end
end

function intro.update(dt)
  if i.char < #i.exposition then
    i.time = i.time + dt
    if i.time >= i.timestep then
      i.time = 0.0
      i.char = i.char + 1
      keypress()
    end
  end
  return i.done and newPlayer(i.name)
end

function keypress()
  -- @TODO: typing sfx
  io.write('.'); io.flush()
end

function intro.keypressed(key)
  if i.char >= #i.exposition then
    keypress()
    if key == 'backspace' then
      -- get the byte offset to the last UTF-8 character in the string
      local byteoffset = utf8.offset(i.name, -1)
      if byteoffset then
        -- string.sub operates on bytes rather than UTF-8 characters
        i.name = string.sub(i.name, 1, byteoffset - 1)
      end
    elseif key == 'return' then
      i.done = true
    end
  end
end

function intro.textinput(text)
  if i.char >= #i.exposition and not i.done then
    i.name = i.name .. text
  end
end
