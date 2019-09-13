require 'dxruby'
#----------test----------
#-------------------------
#HPゲージの処理
#-------------------------
class HpGage
  attr_accessor :x, :y, :height, :hp, :maxhp,:color, :bgcolor, :alpha, :bgalpha
  def initialize(x: 0, y: 0, height: 10, width: 100, hp: 100, maxhp: 100, color: C_WHITE, 
    bgcolor: nil, alpha: 255, bgalpha: 255, direction: nil)
    #----------------
    #x,y : 座標
    #height, width: 縦の長さと最大幅
    #----------------
    if hp > maxhp
      maxhp = hp
    end
    @x = x
    @y = y
    @height = height
    @width = width
    @hp = hp
    @maxhp = maxhp
    @color = color
    @alpha = alpha
    @bgalpha = bgalpha
    @direction = direction
    unless bgcolor == nil
      @bgcolor = Sprite.new(@x, @y, Image.new(@width, @height, bgcolor))
      @bgcolor.alpha = @bgalpha
    end
    set_gage
  end

  def draw(direction = nil)
    if direction == nil
      case @direction
      when "normal", "reverse", "both"
        direction = @direction
      else
        direction = "normal"
      end
    end

    @hp = @maxhp if @hp >= @maxhp
    @hp = 0 if @hp < 0
    Sprite.draw(@bgcolor) unless @bgcolor == nil
    set_gage
    if @gage_value >= 1
      image = Image.new(@gage_value, @height, @color)
      case direction
      when "normal"
        gage = Sprite.new(@x, @y, image)
      when "reverse"
        x = (@x - @gage_value) + @width
        gage = Sprite.new(x, @y, image)
      when "both"
        x = (@x - (@gage_value / 2)) + (@width / 2)
        gage = Sprite.new(x, @y, image)
      end
      gage.alpha = @alpha
      Sprite.draw(gage)
    end
  end

  private
  def set_gage
    @gage_value = (@width.to_f * @hp.to_f) / @maxhp.to_f
  end
end

#------------------------
#Spriteクラスでの判定をさらに簡単にしたもの
#------------------------
class Hit
  def self.check(ob1, ob2, val_bool = true)
    if ob1.class == Array && ob2.class == Array
      ob1.each do |ob1|
        ob2.each do |ob2|
          if Sprite.check(ob1, ob2) == val_bool
            yield(ob1, ob2) if block_given?
          end
        end
      end
    end

    if ob1.class == Array && ob2.class == Sprite
      ob1.each do |ob1|
        if Sprite.check(ob1, ob2) == val_bool
          yield(ob1, ob2) if block_given?
        end
      end
    end

    if ob2.class == Array && ob1.class == Sprite
      ob2.each do |ob2|
        if Sprite.check(ob1, ob1) == val_bool
          yield(ob2, ob1) if block_given?
        end
      end
    end

    if ob1.class == Sprite && ob2.class == Sprite
      if Sprite.check(ob1, ob2) == val_bool
        yield(ob1, ob2) if block_given?
      end
    end
  end

  def self.check_index(ob1, ob2, val_bool = true)
    if ob1.class == Array && ob2.class == Array
      ob1.each_with_index do |ob1, index|
        ob2.each_with_index do |ob2, index2|
          if Sprite.check(ob1, ob2) == val_bool
            yield(index, index2) if block_given?
          end
        end
      end
    end

    if ob1.class == Array && ob2.class == Sprite
      ob1.each_with_index do |ob1, index|
        if Sprite.check(ob1, ob2) == val_bool
          yield(index) if block_given?
        end
      end
    end

    if ob2.class == Array && ob1.class == Sprite
      ob2.each_with_index do |ob2, index|
        if Sprite.check(ob1, ob2) == val_bool
          yield(index) if block_given?
        end
      end
    end

    if ob1.class == Sprite && ob2.class == Sprite
      if Sprite.check(ob1, ob2) == val_bool
        yield if block_given?
      end
    end
  end

  def self.check_with_index(ob1, ob2, val_bool = true)
    if ob1.class == Array && ob2.class == Array
      ob1.each_with_index do |ob1, index|
        ob2.each_with_index do |ob2, index2|
          if Sprite.check(ob1, ob2) == val_bool
            yield(index, index2, ob1, ob2) if block_given?
          end
        end
      end
    end

    if ob1.class == Array && ob2.class == Sprite
      ob1.each_with_index do |ob1, index|
        if Sprite.check(ob1, ob2) == val_bool
          yield(index, ob1) if block_given?
        end
      end
    end

    if ob2.class == Array && ob1.class == Sprite
      ob2.each_with_index do |ob2, index|
        if Sprite.check(ob1, ob2) == val_bool
          yield(index, ob2) if block_given?
        end
      end
    end

    if ob1.class == Sprite && ob2.class == Sprite
      if Sprite.check(ob1, ob2) == val_bool
        yield if block_given?
      end
    end
  end
end

#-----------------
#Soundクラスをさらに扱いやすくしたもの
#-----------------
class BGM
  attr_accessor :bgm
  attr_reader :title, :path
  def initialize(file)
    @bgm = Sound.new(file)
    @bgm.loop_count = -1
    @play_check = true
    @title = File.basename(file, ".*")
    @path = File.dirname(file)
    @dispose = false
  end

  def play
    if @play_check
      unless @dispose
        @play_check = false
        @bgm.play
      end
    end
  end

  def stop(val = true)
    unless @dispose
      @play_check = val
      @bgm.stop
    end
  end

  def set_volume(val)
    @bgm.set_volume(val)
  end

  def sets
    yield @bgm
  end

  def dispose
    @bgm.dispose unless @bgm.disposed?
    @dispose = true
  end
end

#-----------------
#指定したフレーム数ごとに処理を行う。
#-----------------
class SetInterval
  def initialize(sec)
    @time = sec 
    @sec = 0
  end

  def loop(val = true)
    if val
      @sec += 1
      if @sec >= @time
        yield
        @sec = 0
      end
    end
  end
end

#-----------------
#マウスカーソルが文字に重なった時の処理
#-----------------
class TextSelect
  attr_accessor :text, :size, :x, :y, :color, :bgcolor, :bgalpha, :font_alpha, :hover
  @@mouse = Sprite.new(0, 0, Image.new(1, 1, C_WHITE))
  @@mouse.alpha = 0
  def initialize(x: 0, y: 0, text: "sample", size: 20, color: C_WHITE, 
                bgcolor: C_BLACK, bgalpha: 0, font_alpha: 255 ,hover: nil)
    @x = x
    @y = y
    @text = text
    @color = color
    @bgcolor = bgcolor
    @hover = hover
    @buckup_color = @color
    @bgalpha = bgalpha
    @font_alpha = font_alpha
    @size = size
    @font = Font.new(@size)
    @width = @font.getWidth(@text)
    @sprite = Sprite.new(@x, @y, Image.new(@width, @size, @bgcolor))
    @sprite.alpha = @bgalpha
  end

  def draw
    @font = Font.new(@size)
    @width = @font.getWidth(@text)
    @sprite = Sprite.new(@x, @y, Image.new(@width, @size, @bgcolor))
    @sprite.alpha = @bgalpha
    Sprite.draw([@sprite, @@mouse])
    Window.draw_font_ex(@x, @y, @text, Font.new(@size), {color: @color, alpha: @font_alpha})
  end

  def check(val_bool = true)
    mouse
    @color = @buckup_color
    if Sprite.check(@sprite, @@mouse) == val_bool
      @color = @hover unless @hover == nil
      yield if block_given?
    end
  end

  def draw_check(val_bool = true)
    mouse
    draw
    @color = @buckup_color
    if Sprite.check(@sprite, @@mouse)  == val_bool
      @color = @hover unless @hover == nil
      yield if block_given?
    end
  end

  private
  def mouse
    @@mouse.x = Input.mouse_pos_x
    @@mouse.y = Input.mouse_pos_y
  end
end

#-----------------
#背景設定
#-----------------
class BackGround
  attr_accessor :set
  def initialize(scale_x, scale_y, file)
    @scale_x = scale_x
    @scale_y = scale_y
    @image = file
    @bgimg = Image.load(@image)
    @set = Sprite.new(0, 0, @bgimg)
    @set.scale_x = @scale_x
    @set.scale_y = @scale_y

    Window.width = @bgimg.width * @set.scale_x
    Window.height = @bgimg.height * @set.scale_y

    @set.x= (Window.width / 2) - (@bgimg.width / 2)
    @set.y = (Window.height / 2) - (@bgimg.height / 2)
  end

  def draw
    Sprite.draw(@set)
  end
end

#-----------------
#ブール値を設定するためのもの
#-----------------
class Boolean
  attr_reader :bool
  alias val bool
  def initialize(val = nil)
    if val == true || val == false
      @bool = val
    else
      @bool = true
    end
  end

  def chenge(val = nil)
    if val == nil
      if @bool
        @bool = false
      else
        @bool = true
      end
    else
      if val == true || val == false
        @bool = val
      else
        chenge
      end
    end
  end

  def set(val = nil)
    chenge(val)
  end
end

#-----------------
#テキストボックス
#-----------------
key = :key
mouse = :mouse
both = :both
class TextBox
  @@text = ""
  @@text_save = ""
  @@output = ""
  @@index = 0
  @@key_type = true #テキスト切り替えのキーの有効と無効の切り替え
  @@key_type_save = 0
  def initialize(x: 0,y: 0, width: 500, height: 100, bgcolor: C_WHITE, font: 25, interval: 5, controll: :both)
    @x = x
    @y = y
    @width = width
    @height = height
    @bgcolor = bgcolor
    @font = Font.new(font)
    @font_val = font
    @interval_num = interval
    @interval = SetInterval.new(interval)
    @back = Sprite.new(@x, @y, Image.new(@width, @height, @bgcolor))
    @text_ary = []
    @text_ary_index = 0
    @ary_set_check = false
    @controll = controll
    if @controll == nil
      @@key_type = false
      @@key_type_save = 1
    end

    @vanished = false
    #メニュー
    @menu_key = K_ESCAPE
    @menu_type = false

    #セーブ
    @index_save = 0
  end

  def set(ary)
    unless @vanished
      @text_ary = ary
      if @text_ary.class != Array
        raise "配列を入れてください。please in array"
      end

      @text_ary.delete_if{ |val| val.class != String}

      @text_ary_size = @text_ary.size - 1
      if @text_ary_size < 1
        @text_ary = [""]
        @text_ary_size = 1
      end
      set_text(ary[@text_ary_index])
      @ary_set_check = true
    end
  end

  def save
    unless @vanished
      @index_save = @text_ary_index
      return @index_save
    end
  end

  def load
    unless @vanished
      @text_ary_index = @index_save
      return @text_ary_index
    end
  end

  def finish(&proc)
    unless @vanished
      @proc = proc
    end
  end

  def menu_set(key:K_ESCAPE, &menu_sheen)
    unless @vanished
      @menu_key = key
      @menu_sheen = menu_sheen
    end
  end

  def menu_show
    unless @vanished
      if Input.key_push?(@menu_key)
        if @menu_type == true
          @menu_type = false
          @@key_type = true if @@key_type_save = 0
        else
          @menu_type = true
          @@key_type = false
        end
      end

      if @menu_sheen != nil && @menu_type
        @@key_type = false
        @menu_sheen.call unless @menu_sheen == nil
      end
    end
  end

  def menu_close
    unless @vanished
      @@key_type = true if @@key_type_save == 0
      @menu_type = false
    end
  end

  def show(color: C_WHITE)
    unless @vanished
      Sprite.draw(@back)
      Window.draw_font(@x, @y, "#{@@output}", @font, color: color)
      if @ary_set_check
        set_text(@text_ary[@text_ary_index])
        if @@key_type == true
          case @controll
          when :key
            if Input.key_push?(K_RETURN)
              output_if
            end
          when :mouse
            if Input.mouse_push?(M_LBUTTON)
              output_if
            end
          when :both
            if Input.key_push?(K_RETURN) || Input.mouse_push?(M_LBUTTON)
              output_if
            end
          end
        end

        if @text_ary_index > @text_ary_size
          @text_ary_index = 0
          @proc.call unless @proc == nil
        end
        
        yield(@text_ary[@text_ary_index], @text_ary_index) if block_given?
      end
    end
  end

  def next
    @text_ary_index += 1
  end

  def pred
    @text_ary_index -= 1
  end

  def change(val)
    @text_ary_index = val
    if @text_ary_index > @text_ary_size
      @text_ary_index = @text_ary_size
    end
  end

  def despose
    @back.vasnish
  end

  private
  def set_text(text = "")
    unless @vanished
      @@text = text
      @size = @@text.size - 1
      @t_width = @font.getWidth(@@text)
      if (@@text_save != @@text) || (@@text_save == "")
        @@text_save = @@text
        @@index = 0
        check
      end
      count
    end
  end

  def check
    unless @vanished
      moji = ""
      if (@width < @t_width) && @@text.include?("\n") == false
        @@text.each_char.with_index do |char, index|
          moji += char
          if @width < @font.getWidth(moji)
            @@text[index] = "\n#{@@text[index]}"
            moji = char
          end
        end
      end
    end
  end

  def count
    unless @vanished
      if @interval_num == -1
        @@output = @@text
      else
        @@output = @@text[0..@@index]
        @interval.loop do
          @@index += 1 if @@index < @size
        end
      end
    end
  end

  def output_if
    if @@index < @size
      @@index = @size
    else
      @text_ary_index += 1
    end
  end
end

#-----------------
#シーン
#-----------------
class Scene
  @@now_scene = []
  @@black_back = Sprite.new(0, 0, Image.new(Window.width * 10, Window.height * 10, C_BLACK))
  @@black_back.alpha = 0
  @@scene_back = ""
  @@scene_back_change = true
  @@loop_save = ""
  @@counter = 0
  def initialize(fade: false)
    @fade_on = false
    @fade_on_save = fade
    @scenes = {}
    @scene_save = ""
    @fade_play = false
    @fade_change = true
  end

  def set(*val)
    val.each do |v|
      unless v == nil || v == false
        @scenes[v] = proc
      end
    end
  end

  def call(*val)
    @val = val
    @@loop_save = val
    if @@scene_back != val
      unless @scene_save == ""
        @val = @scene_save
      end
      if @@counter > 0
        @fade_on = @fade_on_save
      end
      @@counter = 1
      @fade_play = true
      if @@scene_back_change
        @@scene_back = val 
        @@scene_back_change = false
      end
    end

    if @fade_play && @fade_on
      @scene_save = @val
      fade
      @@scene_back_change = false
    end

    @val.each do |v|
      unless @scenes[v] == nil
        @scenes[v].call
      else
        #シーン名が存在しないときの処理
        #When nothing scene_name's code 
      end
    end
    Sprite.draw(@@black_back)
  end

  def fade
    if @fade_change
      @@black_back.alpha += 5
      if @@black_back.alpha >= 255
        @fade_change = false
      end
    else
      @@black_back.alpha -= 5
      if @@black_back.alpha <= 0
        @@black_back.alpha = 0
        @fade_change = true
        @fade_play = false
        @@scene_back = @@loop_save
        @scene_save = @@loop_save
        @@scene_back_change = true
      end
    end
  end

  def unset(*val)
    val.each do |v|
      unless v == nil
        @scenes.delete(v)
      end
    end
  end
end