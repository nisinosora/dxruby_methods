require 'dxruby'

#-------------------------
#HPゲージの処理
#-------------------------
class HpGage
  attr_accessor :x, :y, :height, :hp, :color
  attr_reader :maxhp
  def initialize(x: 0, y: 0, height: 10, width: 100, hp: 100, maxhp: 100, color: C_WHITE)
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
    set_gage
  end

  def draw
    @hp = @maxhp if @hp >= @maxhp
    set_gage
    if @gage_value > 0
      @gage = Sprite.new(@x, @y, Image.new(@gage_value, @height, @color))
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

  def stop
    @play_check = true
    @bgm.stop
  end
end