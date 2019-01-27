require_relative '../dxruby_methods'

#--------------------
#  Hitサンプル(当たり判定)
#--------------------

s = Sprite.new(0, 0, Image.new(50, 50, C_WHITE))
sary = Array.new(3)
sary2 = Array.new(3)

sary.each_with_index do |v, i|
  sary[i] = Sprite.new(50 * i, 50, Image.new(40, 40, [0, 100, 250]))
end

sary2.each_with_index do |v, i|
  sary2[i] = Sprite.new(50 * i, 100, Image.new(40, 40, C_GREEN))
end

mouse = Sprite.new(0, 0, Image.new(1, 1, C_WHITE))
mouse.alpha = 0

#ここまで初期設定

Window.loop do
  mouse.x = Input.mouse_pos_x
  mouse.y = Input.mouse_pos_y
  Sprite.draw([s, sary, sary2, mouse])

  Hit.check(mouse, s) do |object|
    Window.draw_font_ex(0, 200, "#{object}に当たった!", Font.default)
  end

  Hit.check_index(mouse, sary) do |index|
    Window.draw_font_ex(0, 200, "1の#{index}に当たった!", Font.default)
  end

  Hit.check_index(mouse, sary2) do |index|
    Window.draw_font_ex(0, 200, "2の#{index}に当たった!", Font.default)
  end

  Hit.check_with_index(sary, sary2) do |index1, index2, object1, object2|
    #当たることがないため説明をします。
    #index1 index2 は、それぞれ入力順に要素番号が渡されます。
    #index1 は、 sary。 index2は、sary2です。
    #object1 object2も同様に渡されます。
  end
end