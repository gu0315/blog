# SCCModule

[![CI Status](http://img.shields.io/travis/geliang/SCCModule.svg?style=flat)](https://travis-ci.org/geliang/SCCModule)
[![Version](https://img.shields.io/cocoapods/v/SCCModule.svg?style=flat)](http://cocoapods.org/pods/SCCModule)
[![License](https://img.shields.io/cocoapods/l/SCCModule.svg?style=flat)](http://cocoapods.org/pods/SCCModule)
[![Platform](https://img.shields.io/cocoapods/p/SCCModule.svg?style=flat)](http://cocoapods.org/pods/SCCModule)

## Example

  To run the example project, clone the repo, and run `pod install` from the Example directory first.

## 使用方法

模块的xcode snippets生成代码在XcodeSnippets目录下，拷贝放到`~/Library/Developer/Xcode/UserData/CodeSnippets`目录下即可。

## 注意事项

### Module的URL写法

`scheme://action/$module1/module2?key1=val1&key2=val2`

* scheme在appdelegate中的统一设置，不符合的scheme无法通过url调用module
* action为module调用的selector,需要注意：

* `open`和`open.present`兼容老版车牛使用，会被自动替换成`open_callback`和`open.present_callback`
* action中的`_`下划线会被替换成`:`，并且action的末尾自动补`:`
* action的`.`会被替换成`_`
* 综上一个action`open`最后会被转变为selector`open:callback:`

* module1和module2是`+ (NSString *)moduleName`方法返回的别名，用于调起对应的module target

* `$`符号表示在整个UINavigationController的堆栈中只会存在一个改module，只有使用`- (BOOL)scc_setModules:(NSString *)modulesURLString animated:(BOOL)animated withParams:(NSDictionary *)params callback:(void(^)(NSDictionary *moduleInfo))callback;`和`- (BOOL)scc_displayModuleUrl:(NSString *)urlString animated:(BOOL)animated params:(NSDictionary *)params callback:(void(^)(NSDictionary *moduleInfo))callback`方法的时候会做堆栈检查

* 参数的传递中，val需要做urlencode，特别特别是`= %3D` `? %3F` `& %26` `[ %5b` `] %5d` `# %23`
* 参数传递中，支持传递数组，字典，字典套数组等复杂格式
	
```
http://www.demo.com/?a=1&b=2&c=3&d[e]=4&d[f]=5&g[]=6&g[]=7&g[]=8&h[i][]=8&h[i][]=9&h[j][k]=10

{
    a = 1;
    b = 2;
    c = 3;
    d =     {
        e = 4;
        f = 5;
    };
    g =     (
        6,
        7,
        8
    );
    h =     {
        i =         (
            8,
            9
        );
        j =         {
            k = 10;
        };
    };
}

```

* 解析支持字典包涵字典，字典包涵数组；但是不允许数组里面包含数组和字典

### Modulor调用模块

* 远端的URL处理推荐使用以下方法：

*  `- (NSArray *)modulesURLString:(NSString *)urlString performWithParams:(NSDictionary *)params callback:(void(^)(NSDictionary *moduleInfo))callback`
*  `- (BOOL)scc_displayModuleUrl:(NSString *)urlString animated:(BOOL)animated params:(NSDictionary *)params callback:(void(^)(NSDictionary *moduleInfo))callback`
*  `- (BOOL)scc_displayModuleUrl:(NSString *)urlString`

* native调用模块推荐使用：

* `- (id)moduleName:(NSString *)moduleName performSelectorName:(NSString *)selectorName withParams:(NSDictionary *)params callback:(void(^)(NSDictionary *moduleInfo))callback`

* native调用模块的open方法推荐使用：

*`- (id)moduleName:(NSString *)moduleName openWithParams:(NSDictionary *)params callback:(void(^)(NSDictionary *moduleInfo))callback`

* 其他方法可以看`SCCModulor.h UINavigationController+SCCModulor.h UIViewController+SCCModulor.h`中的定义

### Modulor的Category

由于整个Module的调用都是用字符串作为模块名发起调用，在使用中可能并不是非常方便，可以在SCCModule Pod之上在集成一层业务Module的pod，然后对SCCModulor做Category

```
#import "SCCModulor.h"

@interface SCCModulor (SCCDetail)

- (void)detailVCWithCarID:(NSString *)carId callback:(void(^)(NSDictionary *))callback;
- 
@end

@implementation SCCModulor (SCCDetail)

- (void)detailVCWithCarID:(NSString *)carId callback:(void(^)(NSDictionary *))callback; {
UIViewController *vc = [self moduleName:@"detail" openWithParams:@{@"carId":carId} callback:callback];
return vc;
}
@end
```

## Requirements

## Installation

SCCModule is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "SCCModule"
```

## Author

geliang, geliang@souche.com

## License

SCCModule is available under the MIT license. See the LICENSE file for more info.
