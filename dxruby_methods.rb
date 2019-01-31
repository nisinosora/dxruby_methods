require 'dxruby'

#-------------------------
#HPゲージの処理
#-------------------------
class HpGage
  attr_accessor :x, :y, :height, :hp, :maxhp,:color, :bgcolor, :alpha, :bgalpha
  def initialize(x: 0, y: 0, height: 10, width: 100, hp: 100, maxhp: 100, color: C_WHITE, bgcolor: nil, alpha: 255, bgalpha: 255)
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
    unless bgcolor == nil
      @bgcolor = Sprite.new(@x, @y, Image.new(@width, @height, bgcolor))
      @bgcolor.alpha = @bgalpha
    end
    set_gage
  end

  def draw
    @hp = @maxhp if @hp >= @maxhp
    @hp = 0 if @hp < 0
    Sprite.draw(@bgcolor) unless @bgcolor == nil
    set_gage
    if @gage_value >= 1
      @gage = Sprite.new(@x, @y, Image.new(@gage_value, @height, @color))
      @gage.alpha = @alpha
      Sprite.draw(@gage)
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
  def self.check(ob1, ob2)
    if ob1.class == Array && ob2.class == Array
      ob1.each do |ob1|
        ob2.each do |ob2|
          if Sprite.check(ob1, ob2)
            yield(ob1, ob2) if block_given?
          end
        end
      end
    end

    if ob1.class == Array && ob2.class == Sprite
      ob1.each do |ob1|
        if Sprite.check(ob1, ob2)
          yield(ob1, ob2) if block_given?
        end
      end
    end

    if ob2.class == Array && ob1.class == Sprite
      ob2.each do |ob2|
        if Sprite.check(ob1, ob1)
          yield(ob2, ob1) if block_given?
        end
      end
    end

    if ob1.class == Sprite && ob2.class == Sprite
      if Sprite.check(ob1, ob2)
        yield(ob1, ob2) if block_given?
      end
    end
  end

  def self.check_index(ob1, ob2)
    if ob1.class == Array && ob2.class == Array
      ob1.each_with_index do |ob1, index|
        ob2.each_with_index do |ob2, index2|
          if Sprite.check(ob1, ob2)
            yield(index, index2) if block_given?
          end
        end
      end
    end

    if ob1.class == Array && ob2.class == Sprite
      ob1.each_with_index do |ob1, index|
        if Sprite.check(ob1, ob2)
          yield(index) if block_given?
        end
      end
    end

    if ob2.class == Array && ob1.class == Sprite
      ob2.each_with_index do |ob2, index|
        if Sprite.check(ob1, ob2)
          yield(index) if block_given?
        end
      end
    end

    if ob1.class == Sprite && ob2.class == Sprite
      if Sprite.check(ob1, ob2)
        yield if block_given?
      end
    end
  end

  def self.check_with_index(ob1, ob2)
    if ob1.class == Array && ob2.class == Array
      ob1.each_with_index do |ob1, index|
        ob2.each_with_index do |ob2, index2|
          if Sprite.check(ob1, ob2)
            yield(index, index2, ob1, ob2) if block_given?
          end
        end
      end
    end

    if ob1.class == Array && ob2.class == Sprite
      ob1.each_with_index do |ob1, index|
        if Sprite.check(ob1, ob2)
          yield(index, ob1) if block_given?
        end
      end
    end

    if ob2.class == Array && ob1.class == Sprite
      ob2.each_with_index do |ob2, index|
        if Sprite.check(ob1, ob2)
          yield(index, ob2) if block_given?
        end
      end
    end

    if ob1.class == Sprite && ob2.class == Sprite
      if Sprite.check(ob1, ob2)
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

class TextSelect
  attr_accessor :text, :size, :x, :y, :color, :bgcolor, :alpha
  attr_reader :mouse
  def initialize(x: 0, y: 0, text: "", size: 20, color: C_WHITE, bgcolor: C_BLACK, alpha: 0)
    @x = x
    @y = y
    @text = text
    @color = color
    @bgcolor = bgcolor
    @alpha = alpha
    @size = size
    @font = Font.new(@size)
    @width = @font.getWidth(@text)
    @sprite = Sprite.new(@x, @y, Image.new(@width, @size, @bgcolor))
    @sprite.alpha = @alpha
    @mouse = Sprite.new(0, 0, Image.new(1, 1, C_WHITE))
    @mouse.alpha = 0
  end

  def draw
    @width = @font.getWidth(@text)
    @sprite = Sprite.new(@x, @y, Image.new(@width, @size, @bgcolor))
    @sprite.alpha = @alpha
    Sprite.draw([@sprite, @mouse])
    Window.draw_font_ex(@x, @y, @text, Font.new(@size), color: @color)
  end

  def check
    @mouse.x = Input.mouse_pos_x
    @mouse.y = Input.mouse_pos_y
    if Sprite.check(@sprite, @mouse)
      yield if block_given?
    end
  end
end