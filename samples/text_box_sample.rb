require_relative '../dxruby_methods'

text = TextBox.new(x: 100, y: 200, width: 300, height: 100, bgcolor: C_GREEN, font: 30, controll: :both)
texts = [
  "あいうえお",
  "ABCDE",
  "12345",
  "あいうえおかきくけこ",
  "ABCDEFGHIJK",
  "1234567890",
  "test",
  "space space space space",
  "I am a cat. I don't have a name.",
  "吾輩は猫である。名前はまだない。",
  12456,
  4613451315,
  ["test", "test"]
]
text.set(texts)

#メニュー用
back = Sprite.new(0, 0, Image.new(Window.width, Window.height, C_BLUE))
back.alpha = 150
close = TextSelect.new(x: 100, y: 100, text: "閉じる", size: 20, hover: C_GREEN)

text.menu_set(key: K_ESCAPE) do
  Sprite.draw(back)
  close.draw_check do 
    if Input.mouse_push?(M_LBUTTON)
      text.menu_close
    end
  end
end

#最後の表示になったら、終了という文字を出力し、繰り返す
# text.finish do
#   puts "終了"
# end

Window.loop do
  text.show
  text.menu_show
end