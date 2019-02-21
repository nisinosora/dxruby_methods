require_relative '../dxruby_methods'

#--------------------
#  HPゲージサンプル
#--------------------

hp = HpGage.new(hp: 200, maxhp: 200, color: [0, 200, 200], bgcolor: C_GREEN, bgalpha: 80, x: 50, y: 100)
hp_revers = HpGage.new(hp: 200, maxhp: 200, x: 0, bgcolor: C_WHITE, color: C_GREEN)
hp_revers2 = HpGage.new(hp: 200, maxhp: 200, y: 50, bgcolor: C_WHITE, color: C_GREEN, direction: "reverse")
#=> HPゲージを生成するときに、初期HPと最大HPを200に指定。
#=> ゲージの色とその背景色を指定。その背景色の不透明度を80%に指定。
#=> 座標を指定

Window.loop do
  hp.draw #=> HPゲージを表示
  hp_revers.draw("reverse")
  hp_revers2.draw()
  if Input.key_down?(K_UP)
    #矢印の上キーを押している間HPを1上げる(0～最大値以下の範囲)
    hp.hp += 1
    hp_revers.hp += 1
    hp_revers2.hp += 1
  end

  if Input.key_down?(K_DOWN)
    #矢印の下キーを押している間HPを1減らす(0～最大値以下の範囲)
    hp.hp -= 1
    hp_revers.hp -= 1
    hp_revers2.hp -= 1
  end
end