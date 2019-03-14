require 'dxruby'

#更新テスト
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
  alias set bgm
  def initialize(file)
    @bgm = Sound.new(file)
    @bgm.loop_count = -1
    @play_check = true
  end

  def play
    if @play_check
      @play_check = false
      @bgm.play
    end
  end

  def stop(val = true)
    @play_check = val
    @bgm.stop
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
  attr_accessor :text, :size, :x, :y, :color, :bgcolor, :bgalpha, :font_alpha
  attr_reader :mouse
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
    @mouse = Sprite.new(0, 0, Image.new(1, 1, C_WHITE))
    @mouse.alpha = 0
  end

  def draw
    @font = Font.new(@size)
    @width = @font.getWidth(@text)
    @sprite = Sprite.new(@x, @y, Image.new(@width, @size, @bgcolor))
    @sprite.alpha = @bgalpha
    Sprite.draw([@sprite, @mouse])
    Window.draw_font_ex(@x, @y, @text, Font.new(@size), {color: @color, alpha: @font_alpha})
  end

  def check(val_bool = true)
    mouse
    @color = @buckup_color
    if Sprite.check(@sprite, @mouse) == val_bool
      @color = @hover unless @hover == nil
      yield if block_given?
    end
  end

  def draw_check(val_bool = true)
    mouse
    draw
    @color = @buckup_color
    if Sprite.check(@sprite, @mouse)  == val_bool
      @color = @hover unless @hover == nil
      yield if block_given?
    end
  end

  private
  def mouse
    @mouse.x = Input.mouse_pos_x
    @mouse.y = Input.mouse_pos_y
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