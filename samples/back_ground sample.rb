require_relative '../dxruby_methods.rb'

bgimg = BackGround.new(0.8, 0.8, "./gahag.jpg")

Window.loop do
  bgimg.draw
end