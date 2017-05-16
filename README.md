# IntoYunSDKDemo-ios

为了方便第三方开发者快速集IntoYun SDK，我们提供了以下联系方式，协助开发者进行集成：
邮箱：support@intorobot.com
微博：IntoRobot
另外，关于SDK的Bug反馈、用户体验、以及好的建议，请大家尽量提交到 Github 上，我们会尽快解决。
目前，我们正在逐步完善IntoYun SDK，争取为第三方开发者提供一个规范、简单易用、可靠、可扩展、可定制的 SDK，敬请期待。

## 快速集成 IntoYunSDK支持使用Cocoapods集成，请在Podfile中添加以下语句：

* 导入IntoYunSDK, 将下面代码添加到Podflie文件中

`pod 'IntoYunSDK', '~> 1.0.1'`

* 设置build setting

在项目target中设置 Build Settings--> Linking -->Other Linker Flags 在后面增加[-ObjC]。(必须添加，否则程序会崩溃)

* 添加相关依赖库, 将下面代码添加到Podflie文件中

`
pod 'AFNetworking', '~> 3.0'    #source     https://github.com/AFNetworking/AFNetworking/
pod 'MQTTClient'                #source     https://github.com/ckrey/MQTT-Client-Framework
pod 'CocoaAsyncSocket'          #source     https://github.com/robbiehanson/CocoaAsyncSocket
pod 'MJExtension'               #source     https://github.com/CoderMJLee/MJExtension/tree/master/MJExtension
`


