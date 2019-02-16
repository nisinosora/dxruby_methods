require_relative '../dxruby_methods'

bool = Boolean.new(true)

text = TextSelect.new(x: 200, y: 200, text: "切り替え", hover: C_GREEN)

Window.loop do
  text.draw_check(true) do
    if Input.mouse_push?(M_LBUTTON)
      bool.chenge("aaa")
    end
  end

  Window.draw_font_ex(0, 0, "#{bool.val}", Font.default)
end