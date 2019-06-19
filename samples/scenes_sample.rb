require_relative '../dxruby_methods'

scene = Scene.new

scene.scene_set(:first) do
  Window.draw_font_ex(100, 100, "hello world", Font.default)
end

scene.scene_set(:del) do
  Window.draw_font_ex(100, 150, "Delete Test", Font.default)
end

scene.scene_unset(:del)

Window.loop do
  scene.scene_call(:first, :del)
end

