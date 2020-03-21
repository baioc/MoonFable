function love.conf(t)
  t.version = '11.3'                    -- The LÖVE version this game was made for (string)
  t.window.title = "MoonFable"          -- The window title (string)
  t.window.icon = 'data/images/lua.png' -- Filepath to an image to use as the window's icon (string)
  t.window.width = 520                  -- The window width (number)
  t.window.height = 720                 -- The window height (number)
  t.window.resizable = false            -- Let the window be user-resizable (boolean)
  t.window.fullscreen = false           -- Enable fullscreen (boolean)
end
