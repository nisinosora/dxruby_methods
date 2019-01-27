require_relative '../dxruby_methods'

#--------------------
#  BGMサンプル
#--------------------

#読み込む音楽ファイルを引数に入力
bgm = BGM.new("Woodgrain_line Ryo_Lion.wav")

#自動で音楽が流れるためご注意ください。
Window.loop do
  #playで再生します。
  bgm.play
  Window.draw_font_ex(0, 0, "音楽が流れています", Font.default)
end