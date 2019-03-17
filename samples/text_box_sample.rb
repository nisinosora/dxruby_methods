require_relative '../dxruby_methods'

text = TextBox.new(x: 100, y: 200, width: 300, height: 100, bgcolor: C_GREEN, font: 30)
texts = %w(あいうえお あいうえおかきくけこ あいうえおかきくけこさしすせそ あいうえおかきくけこさしすせそたちつてと あいうえおかきくけこさしすせそたちつてとなにぬねの)

ind = 0
text_size = texts.size - 1

Window.loop do
  text.set(texts[ind])
  if Input.key_push?(K_RETURN)
    ind += 1
    ind = 0 if ind > text_size
  end
  text.show(color: C_WHITE)
end