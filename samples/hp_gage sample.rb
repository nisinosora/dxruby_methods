require_relative '../dxruby_methods'

#--------------------
#  HPゲージサンプル
#--------------------

hp = HpGage.new(hp: 200, maxhp: 200, color: [0, 200, 200], bgcolor: C_GREEN, bgalpha: 80, x: 50, y: 100)
#=> HPゲージを生成するときに、初期HPと最大HPを200に指定。
#=> ゲージの色とその背景色を指定。その背景色の不透明度を80%に指定。
#=> 座標を指定

Window.loop do
  hp.draw #=> HPゲージを表示
  if Input.key_down?(K_UP)
    #矢印の上キーを押している間HPを1上げる(0～最大値以下の範囲)
    hp.hp += 1
  end

  if Input.key_down?(K_DOWN)
    #矢印の下キーを押している間HPを1減らす(0～最大値以下の範囲)
    hp.hp -= 1
  end
end