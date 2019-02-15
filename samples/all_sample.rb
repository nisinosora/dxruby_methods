require_relative '../dxruby_methods'

Window.caption = "サンプル"
Window.bgcolor = [100, 150, 150]
#--------------------
#  全てを合わせたサンプル
#  ブロックがランダムに出てきます。それにマウスを重ねると消えるというゲームです。
#  HPゲージも見てみてください。
#--------------------
bg_image = BackGround.new(0.7, 0.7, "./gahag.jpg")
ary = []
ary2 = []
mouse = Sprite.new(0, 0, Image.new(1, 1, C_WHITE))
mouse.alpha = 0 #不透明度を0%に指定

bgm = BGM.new("./Woodgrain_line Ryo_Lion.wav")

set_interval = SetInterval.new(30)

blocks = HpGage.new(hp: 0, x: 0, y: 0, height: 20, color: C_GREEN, bgcolor: [0, 200, 250])

text = TextSelect.new(text: "TEST", size: 30, x: 0, y: 100, bgcolor: C_BLUE, bgalpha: 255)

Window.loop do
  bg_image.draw #背景画像表示
  mouse.x = Input.mouse_pos_x
  mouse.y = Input.mouse_pos_y

  bgm.play
  set_interval.loop do
    if blocks.hp < 100
      ary << Sprite.new(rand(0..600), rand(0..300), Image.new(50, 50, C_WHITE))
      blocks.hp += 1
    end
  end
  Sprite.draw([ary, mouse])
  Hit.check_index(mouse, ary) do |index|
    ary.delete_at(index)
    blocks.hp -= 1
  end

  blocks.draw
  text.draw
  text.check do
    Window.draw_font_ex(0, 130, "文字と重なりました！", Font.default)
  end
end