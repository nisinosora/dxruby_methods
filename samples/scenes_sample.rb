require_relative '../dxruby_methods'

Window.bgcolor = C_BLUE
scene = Scene.new(fade: true)

#シーン「:first」をセットする
scene.set(:first) do
  Window.draw_font_ex(100, 100, "hello world", Font.default)
end

#シーン「:second」をセットする
scene.set(:second) do
  Window.draw_font_ex(100, 100, "Scene2", Font.default)
end

#シーン「:del」をセットする
scene.set(:del) do
  Window.draw_font_ex(100, 150, "Delete Test", Font.default)
end

#シーン「:del」を無効化する
#無効化したシーン名は、再利用できます。
scene.unset(:del)

scene_name = :first

Window.loop do
  scene.call(scene_name)
  if Input.key_push?(K_RETURN)
    #Enterキーを押したら
    if scene_name == :first
      #シーン名が:firstだったら:secondに切り替える
      scene_name = :second
    else
      #そうでないなら、:fistに切り替える
      scene_name = :first
    end
  end
end

