require_relative '../dxruby_methods'

Window.caption = "サンプル"
Window.bgcolor = [100, 150, 150]

#---------------
#  買い物
#  可能な限りすべてのクラスを利用しています。
#  簡易的に買い物をするシステムを作りました。
#---------------
bgm = BGM.new("./metas/Woodgrain_line Ryo_Lion.wav")
bgm.set do |b| 
  b.set_volume(200)
end
scene = Scene.new
scene_name = nil

money = 100000
items = [
  {name: "えんぴつ", price: 80},
  {name: "ノート", price: 100}
]

items.each_with_index do |val, i|
  val[:select] = TextSelect.new(x: 0, y: 30 * i, text: val[:name], hover: C_GREEN)
end

text = TextBox.new(bgcolor: C_GREEN, width: 500, height: 300)


Window.loop do
  bgm.play
end