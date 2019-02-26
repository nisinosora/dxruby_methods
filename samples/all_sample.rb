require_relative '../dxruby_methods'

Window.caption = "サンプル"
Window.bgcolor = [100, 150, 150]

#---------------
#  簡易的なバトルゲーム
#  簡易的とはいえ、コードは複雑になってしまいました。
#---------------
bgm = BGM.new("./metas/Goddess.wav")
win = Sound.new("./metas/栄光のファンファーレ.wav")
lose = Sound.new("./metas/nc148325.wav")
bgimage = BackGround.new(1, 1, "./metas/gahag.jpg")

commands = {} #技
commands[:attack] = TextSelect.new(x: 0, y: 400, text: "攻撃", color: C_WHITE, hover: C_GREEN, size: 30)
commands[:defense] = TextSelect.new(x: 100, y: 400, text: "防御", color: C_WHITE, hover: C_GREEN, size: 30)
commands[:recovery] = TextSelect.new(x: 200, y: 400, text: "回復", color: C_WHITE, hover: C_GREEN, size: 30)
commands[:status] = TextSelect.new(x: 300, y: 400, text: "ステータス確認", color: C_WHITE, hover: C_GREEN, size: 30, bgalpha: 200)
sheen = 0

hp = {}
hp[:my] = HpGage.new(x: 50, y: 50, hp: 100, maxhp: 100, color: C_GREEN, bgcolor: C_BLACK, bgalpha: 150, height: 20)
hp[:enemy] = HpGage.new(x: 500, y: 50, hp: 100, maxhp: 100, color: C_RED, bgcolor: C_BLACK, bgalpha: 150, height: 20)

my = {attack: 10, defense: 5}
enemy = {attack: 10, defense: 5}

images = []
images[0] = Image.load("./metas/main_6.jpg")
images[1] = Image.load("./metas/main_98.jpg")

select = {}
select[:restart] = TextSelect.new(x: 100, y: 500, text: "リスタート", color: C_WHITE, hover: C_GREEN, size: 30)
select[:finish] = TextSelect.new(x: 300, y: 500, text: "終了", color: C_WHITE, hover: C_GREEN, size: 30)
select[:back] = TextSelect.new(x: 0, y: 500, text: "戻る", color: C_WHITE, hover: C_GREEN, size: 30)

damage = 0
result = ""
finish = false

Window.loop do
  bgimage.draw
  unless finish
    Window.draw(50, 100, images[0])
    Window.draw(500, 100, images[1])
    hp[:my].draw("both")
    hp[:enemy].draw("both")
    commands.each_value{|c| c.draw}
  end

  case sheen
  when 0
    bgm.play
    commands[:attack].draw_check do
      if Input.mouse_push?(M_LBUTTON)
        damage = my[:attack]
        damage -= enemy[:defense]
        damage = 1 if damage < 1
        hp[:enemy].hp -= damage
        sheen = 1
      end
    end

    commands[:defense].draw_check do
      if Input.mouse_push?(M_LBUTTON)
        sheen = 1
        my[:defense] += 1
      end
    end

    commands[:recovery].draw_check do
      if Input.mouse_push?(M_LBUTTON)
        hp[:my].hp +=5
        sheen = 1
      end
    end

    commands[:status].draw_check do
      if Input.mouse_push?(M_LBUTTON)
        sheen = 5
        finish = true
      end
    end
  when 1
    sheen = 0
    case rand(0..10)
    when 0..5, 8..9
      damage = enemy[:attack]
      damage -= my[:defense]
      damage = 10 if damage < 1
      hp[:my].hp -= damage
    when 10
      enemy[:defense] += 1
    when 6,7
      hp[:enemy].hp += 5
    end
    sheen = 4
  when 3
    bgm.stop
    Window.draw_font_ex(300, 300, result, Font.default)
    select[:restart].draw_check do
      if Input.mouse_push?(M_LBUTTON)
        hp[:my].hp = hp[:my].maxhp
        hp[:enemy].hp = hp[:enemy].maxhp
        my[:defense] = 5
        enemy[:defense] = 5
        sheen = 0
        finish = false
      end
    end

    select[:finish].draw_check do
      if Input.mouse_push?(M_LBUTTON)
        Window.close
      end
    end
  when 4
    if hp[:my].hp < 1 || hp[:enemy].hp < 1
      sheen = 3
      finish = true
      if hp[:my].hp < 1
        result = "LOSE..."
        lose.play
      else
        result = "Win!"
        win.play
      end
    else
      sheen = 0
    end
  when 5
    Window.draw_font_ex(0, 0, "HP:#{hp[:my].hp} Enemy: #{hp[:enemy].hp}", Font.new(30))
    Window.draw_font_ex(0, 40, "防御: #{my[:defense]} Enemy:#{enemy[:defense]}", Font.new(30))
    select[:back].draw_check do
      if Input.mouse_push?(M_LBUTTON)
        sheen = 0
        finish = false
      end
    end
  end
end