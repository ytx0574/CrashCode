framework的制作最好使用现有的xcode5打包, 从而实现低版本兼容高版本.

本工程请使用xcode5.1.1打开, 直接在里面修改代码即可.

Tips: 打包framework用低版本Xcode打包, 打包的时候, 任何第三方引入framework在Link Binary With Libraries全部删掉, 但是在工程属里面保留
