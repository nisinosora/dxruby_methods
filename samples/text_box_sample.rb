require_relative '../dxruby_methods'

text = TextBox.new(x: 100, y: 200, width: 300, height: 100, bgcolor: C_GREEN, font: 30, controll: :both)
texts = [
  "あいうえお",
  "ABCDE",
  "12345",
  "あいうえおかきくけこ",
  "ABCDEFGHIJK",
  "1234567890",
  "test",
  "space space space space",
  "I am a cat. I don't have a name.",
  "吾輩は猫である。名前はまだない。",
  12456,
  4613451315,
  ["test", "test"]
]
text.set(texts)

Window.loop do
  text.show
end