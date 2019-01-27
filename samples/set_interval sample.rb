require_relative '../dxruby_methods'

#--------------------
#  setInterval サンプル
#--------------------

set = SetInterval.new(20)
#20フレームに１回処理を行う。

Window.loop do
  set.loop do
    Window.draw_font_ex(0, 0, "表示", Font.default)
  end
end