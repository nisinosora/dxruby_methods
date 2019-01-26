require_relative 'dxruby_methods'
s1 = Sprite.new(0, 50, Image.new(50, 50, C_WHITE))
s2 = Array.new(2)
s2.each_with_index do |s, index|
  s2[index] = Sprite.new(50 * index, 0, Image.new(50, 50, C_BLUE))
end
mouse = Sprite.new(0, 0, Image.new(1, 1, C_WHITE))
mouse.alpha = 0 #不透明度を0%にする。
	
Window.loop do
  mouse.x = Input.mouse_pos_x
  mouse.y = Input.mouse_pos_y
  Sprite.draw([s1, s2, mouse])
  Hit.check(s1, mouse) do |obj1|
    Window.draw_font_ex(0, 150, "当たりました!", Font.default)
    Window.draw_font_ex(0, 180, "#{obj1}", Font.default)
  end
  
  Hit.check_index(s2, mouse) do |index|
    Window.draw_font_ex(30, 100, "#{index}に当たりました!", Font.default)
  end
end