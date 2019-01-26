ReadMe

利用方法
ダウンロードしてそのまま使いたいフォルダに配置してください。
その後、「require_relative 'dxruby_methods'」をRubyファイルの先頭に記入します。
これで、利用可能になります。

※gem dxrubyが入っていないと利用できません。
管理者権限でコマンドプロンプトを開き、「gem install dxruby」と入力してください。

管理者権限で開く方法：コマンドプロンプトのアイコン上で右クリックをすると、
「管理者として実行」という項目が出てきます。それで開いてください。
「変更を加えてもいいですか？」と確認が出たら、「はい」を選んでください。

クラス・メソッド説明
HpGageクラス
・HPゲージを作成します。引数の値は、シンボルで指定します。
	:x #=> 表示するx座標を指定します。標準では「0」が指定されています。
	:y #=> 表示するy座標を指定します。標準では「0」が指定されています。
	:height #=> HPゲージの高さを指定します。標準では「10」が指定されています。
	:width #=> 最大横幅を指定します。標準では「100」が指定されています。
	:hp #=> 初期HPを指定します。標準では「100」が指定されています。
	:maxhp #=> HPの最大値を指定します。標準では「100」が指定されています。
	:color #=> ゲージの色を指定します。標準では「C_WHITE(白)」が指定されています。
	
・変更可能な変数
x, y, height, hp, maxhp, color

・使用例
	gage = HpGage.new(x: 10, y: 10, hp: 200, maxhp: 200, color: C_GREEN)
	Window.loop do
	  gage.draw
	  if Input.key_down?(K_SPACE)
	    #SPACEキーを押すとx座標が移動する
	    gage.x += 1
	  end
	end

Hitクラス
・Spriteクラスでの当たり判定をさらに使いやすくしたクラスです。
Hit.check(), Hit.check_index
・引数
	Spriteクラスか、Spriteクラスを含む配列(2つ)
	※SpriteクラスはDxrubyで独自に作成されているクラスです。
	違うクラスの変数を入れても何も起きません。
・ブロック
	do endで囲んで、当たった時の処理を記入します。

使用例：
	s1 = Sprite.new(0, 50, Image.new(50, 50, C_WHITE))
	s2 = Array.new(2) #配列を2つ生成
	s2.each_with_index do |s, index|
	  #配列にSpriteを追加
	  s2[index] = Sprite.new(50 * index, 0, Image.new(50, 50, C_BLUE))
	end
	mouse = Sprite.new(0, 0, Image.new(1, 1, C_WHITE))
	mouse.alpha = 0 #不透明度を0%にする。
		
	Window.loop do
	  mouse.x = Input.mouse_pos_x
	  mouse.y = Input.mouse_pos_y
	  Sprite.draw([s1, s2, mouse])
	  Hit.check(s1, mouse) do |obj1|
	    Window.draw_font_ex(0, 150, "当たりました!", Font.default)
	    Window.draw_font_ex(0, 180, "#{obj1}", Font.default)
	  end
	  
	  Hit.check_index(s2, mouse) do |index|
	    Window.draw_font_ex(30, 100, "#{index}に当たりました!", Font.default)
	  end
	end
	
BGMクラス
	SoundクラスでBGMを再生するとき、先頭の音が繰り返されてしまうため
	１回の再生で通常の再生になるクラスを作りました。
	
  BGM.new(), play, stop
・引数
  音楽ファイル名(*.wavか*.mid)
  
使用例:

bgm = BGM.new(ファイル名)

Window.loop do
  bgm.play
end