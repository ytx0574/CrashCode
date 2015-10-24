framework的制作最好使用现有的xcode5打包, 从而实现低版本兼容高版本.

本工程请使用xcode5.1.1打开, 直接在里面修改代码即可.

Tips: 打包framework用低版本Xcode打包, 打包的时候, 任何第三方引入framework在Link Binary With Libraries全部删掉, 但是在工程属里面保留

framework中的DEBUG宏区分: 模拟器只在模拟器下面有效. 真机只在真机中有效.  如模拟器版的framework, 那么debug只区分模拟器.  模拟器和真机互不干扰, 也就是说,模拟器版的只能以模拟器运行时有效, 真机只能真机上面运行有效

#ifdef DEBUG   = Debug-iphoneos = Debug-iphonesimulator = 1

#ifundef DEBUG = Release-iphoneos = Release-iphonesimulator

如下:
                            [debug framework]           [release framework]
debug                               1                            0
release                             1                            0
