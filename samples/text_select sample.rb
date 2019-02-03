require_relative '../dxruby_methods'

#--------------------
#  TextSelectサンプル
#--------------------
Window.bgcolor = [100, 150, 100]
text = TextSelect.new(text: "こんにちは", size: 30, hover: C_GREEN)

Window.loop do 
  text.draw
  text.check do
    Window.draw_font_ex(0, 50, "文字に重なりました。", Font.default)
  end
end