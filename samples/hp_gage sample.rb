require_relative '../dxruby_methods'

#--------------------
#  HPゲージサンプル
#--------------------

hp = {}
hp["normal"] = HpGage.new(x: 150, y: 100, color: C_GREEN, bgcolor: C_WHITE)
#=> 通常のHPゲージです。

hp["reverse"] = HpGage.new(x: 150, y: 140, color: C_GREEN, bgcolor: C_WHITE, direction: "reverse")
#=> 通常の逆方向に変動するゲージです。

hp["both"] = HpGage.new(x: 150, y: 180, color: C_GREEN, bgcolor: C_WHITE, direction: "both")
#=> 両端から変動するゲージです。

Window.loop do
  hp["normal"].draw
  Window.draw_font_ex(0, 100, "normal(通常)", Font.default)

  hp["reverse"].draw
  Window.draw_font_ex(0, 140, "reverse(逆)", Font.default)

  hp["both"].draw
  Window.draw_font_ex(0, 180, "both(両端)", Font.default)
  #=> ゲージを表示させます。

  if Input.key_down?(K_UP)
    #矢印の上キーを押している間HPを1上げる(0～最大値以下の範囲)
    hp["normal"].hp += 1
    hp["reverse"].hp += 1
    hp["both"].hp += 1
  end

  if Input.key_down?(K_DOWN)
    #矢印の下キーを押している間HPを1減らす(0～最大値以下の範囲)
    hp["normal"].hp -= 1
    hp["reverse"].hp -= 1
    hp["both"].hp -= 1
  end
  
  Window.draw_font_ex(150, 300, "上下(↑↓)キーでHPが変わります。", Font.default)
end