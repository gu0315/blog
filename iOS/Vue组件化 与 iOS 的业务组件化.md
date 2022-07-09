## **Vue组件化 与 iOS 的业务组件化**（模块化）

## Vue

### 一. 组件化的需求

Vue.js的两个核心数据驱动和组件化

为了提高代码复用性，减少重复性的开发，我们就把相关的代码按照 template、style、script 拆分，封装成一个个的组件。组件可以扩展 HTML 元素，封装可重用的 HTML 代码，我们可以将组件看作自定义的 HTML元素。

### 二. 如何划分组件

通常一个应用会以一棵嵌套的组件树的形式来组织：

![Component Tree](https://vuejs.bootcss.com/images/components.png)

### 三. 组件分类

组件的种类可分为以下4种：

1. 普通组件
2. 动态组件
3. 异步组件
4. 递归组件

普通组件

```
import tem from './components/tem' 
...
{
	components: {tem}  // 注册
}
```

动态组件

```
var vm = new Vue({
  el: '#example',
  data: {
    currentView: 'home'
  },
  components: {
    home: { /* ... */ },
    posts: { /* ... */ },
    archive: { /* ... */ }
  }
})
<component v-bind:is="currentView">
  <!-- 组件在 vm.currentview 变化时改变！ -->
</component>
```

异步组件

```
const AsyncComponent = () => ({
    // 需要加载的组件 (应该是一个 `Promise` 对象)
    component: import('../components/MyComponent'),
    // 异步组件加载时使用的组件
    loading: LoadingComponent,
    // 加载失败时使用的组件
    error: ErrorComponent,
    // 展示加载时组件的延时时间。默认值是 200 (毫秒)
    delay: 200,
    // 如果提供了超时时间且组件加载也超时了，
    // 则使用加载失败时使用的组件。默认值是：`Infinity`
    timeout: 3000
})
```

递归组件

```
name: 'recursion-component',
template: '<div><recursion-component></recursion-component></div>'
```

## iOS 

注：对于iOS或者android相比组件（Component），个人感觉称之为模块（Module）更为合适。组件强调物理拆分，以便复用；模块强调逻辑拆分，以便解耦。而且如果用过 Android Studio, 会发现它创建的子系统都叫 Module. 但介于业界习惯称之为组件化，所以我们继续使用这个术语。 [链接](https://blog.csdn.net/lizhongfu2013/article/details/108219890)

### 一. 组件化的需求

在 iOS Native app 前期开发的时候，如果参与的开发人员也不多，那么代码大多数都是写在一个工程里面的，这个时候业务发展也不是太快，所以很多时候也能保证开发效率。但是一旦项目工程庞大以后，开发人员也会逐渐多起来，业务发展突飞猛进，这个时候单一的工程开发模式就会暴露出弊端了。

- 项目内代码文件耦合比较严重
- 容易出现冲突
- 业务方的开发效率不够高

为了解决这些问题，就出现了组件化的概念。所以 iOS 的组件化是为了解决上述这些问题的，这里与Vue组件化解决的痛点不同。

iOS 组件化以后能带来如下的好处：

- 加快编译速度（不用编译主客那一大坨代码了，各个组件都是静态库）但静态库会加大包体积的大小
- 方便 QA 有针对性地测试
- 提高业务开发效率

组件化的封装性只是其中的一小部分，更加关心的是如何拆分组件，如何解除耦合。前端的组件化可能会更加注重组件的封装性，高可复用性。

### 二. 如何封装组件

iOS 的组件化手段非常单一，就是利用 Cocoapods 封装成 pod 库，主工程分别引用这些 pod 即可。最终想要达到的理想目标就是主工程就是一个壳工程，其他所有代码都在组件 Pods 里面，主工程的工作就是初始化，加载这些组件的，没有其他任何代码了。

拿弹个车为例

![image-20220706220546507](https://tva1.sinaimg.cn/large/e6c9d24ely1h3xk5ndabpj20xf0u00xn.jpg)

CocoaPods，iOS包管理工具，类似于前端的npm,  yarn。其原理：根据Podfile描述，找到对应代码库的podspec文件，然后根据podspec中的描述，找到代码库，并且找到之后，拷贝需要的文件到自己的工程中。具体如果用 Cocoapods 打包一个静态库 .a 或者 framework[链接](http://www.cnblogs.com/brycezhang/p/4117180.html)

### 三. 如何划分组件

iOS 划分组件虽然没有一个很明确的标准，因为每个项目都不同，划分组件的粗粒度也不同，但是依旧有一个划分的原则。

App之间可以重用的 Util、Category、网络层和本地存储 storage 等等这些东西抽成了 Pod 库。还有些一些和业务相关的，也是在各个App之间重用的。

原则就是：要在App之间共享的代码就应该抽成 Pod 库，把它们作为一个个组件。不在 App 间共享的业务线，也应该抽成 Pod，解除它与工程其他的文件耦合性。

常见的划分方法都是从底层开始动手，网络库，数据库存储，加密解密，工具类，地图，基础SDK，APM，风控，埋点……从下往上，到了上层就是各个业务方的组件了，最常见的就类似于购物车，我的钱包，登录，注册等。

### 四. 组件间的消息传递

划分好了组件，那么我们就要解决两个问题：1.各个页面和组件之间的跳转问题。2.各个组件之间相互调用。

iOS组件化有以下三种方案

- URLRouter注册
- Protocol-Class注册
- Taret-Action

我们公司的方案是`Target_Action`，但表现上`Target_Action`可以通过URL来表现，也就是说URL通过解析能解析成`Target_Action`的形式。

#### 1.url-block

url-block 这个方式我最早是在蘑菇街的组件化方案中看到的，简单来说它就是配置“一段 url 对应一个 block 方法”，当我们使用 openUrl：方法的时候，其实就是在调用这个 block 方法。
![img](https://images.xiaozhuanlan.com/photo/2018/365e1fe4414d2354f06edbc1421ea997.png)
比如下面代码：

```
[MGJRouter registerURLPattern:@"mgj://detail?id=:id" toHandler:^(NSDictionary *routerParameters) {
    NSNumber *id = routerParameters[@"id"];
    // create view controller with id
    // push view controller
}];
```

这是蘑菇街调用详情页的方法，`MGJRouter`作为中间件，任何组件间的调用都有它来统一处理。不过这种 url 的传递方式使得参数类型受到了限制，无法传递非常规的参数类型，比如 `UIImage`。于是就有了下面这种 protocol-class。

#### 2.protocol-class

protocol-class 也是在蘑菇街组件中提出的，对于需要非常规参数的时候，他们就使用这种方案。protocol-class 通过在内部维护了一个 protocol 和 class 的映射表，根据对于的 protocol 来获取对应的 class，使用方不需要在意 class 是哪个类，只要知道它实现了 protocol 就可以。

![img](https://images.xiaozhuanlan.com/photo/2018/186f4c7e57b6bb0bac515f4fc939fcf5.png)
代码如下：

```
[ModuleManager registerClass:ClassA forProtocol:ProtocolA];
[ModuleManager classForProtocol:ProtocolA];
```

[ModuleManager classForProtocol:ProtocolA] 的返回结果就是之前在 ModuleManager 内部注册好的 dict 里 protocol 对应的 class。

#### 3.target-action

这种组件化方式是利用一个中间件来调用，中间件利用 runtime 来调用其他组件，这种方式可以做到真正意义上的解耦。然后再通过实现中间件 category 的方式来提供服务，使得使用者只需要依赖中间件，而组件不需要依赖中间件。

![img](https://images.xiaozhuanlan.com/photo/2018/e9323eddf295a20d410f66fb1c066255.png)

核心代码总结

```
[self performTarget:@"A" action:@"viewController" params:params shouldCacheTarget:NO];
```

```
//这里的类和方法子都是运行时动态生成的
- (id)performTarget:(NSString *)targetName action:(NSString *)actionName params:(NSDictionary *)params shouldCacheTarget:(BOOL)shouldCacheTarget
{
    if (targetName == nil || actionName == nil) {
        return nil;
    }
    NSString *swiftModuleName = params[kCTMediatorParamsKeySwiftTargetModuleName];
    // generate target
    NSString *targetClassString = nil;
    if (swiftModuleName.length > 0) {
        targetClassString = [NSString stringWithFormat:@"%@.Target_%@", swiftModuleName, targetName];
    } else {
        targetClassString = [NSString stringWithFormat:@"Target_%@", targetName];
    }
    NSObject *target = [self safeFetchCachedTarget:targetClassString];
    if (target == nil) {
        Class targetClass = NSClassFromString(targetClassString);
        target = [[targetClass alloc] init];
    }
    // generate action
    NSString *actionString = [NSString stringWithFormat:@"Action_%@:", actionName];
    SEL action = NSSelectorFromString(actionString);
    .......
}
```

### 两者平台上开发方式存在差异

主要体现在单页应用和类多页应用的差异。现在前端比较火的一种应用就是单页Web应用（single page web application，SPA），顾名思义，就是只有一张Web页面的应用，是加载单个HTML 页面并在用户与应用程序交互时动态更新该页面的Web应用程序。

浏览器从服务器加载初始页面，以及整个应用所需的脚本（框架、库、应用代码）和样式表。当用户定位到其他页面时，不会触发页面刷新。通过 HTML5 History API 更新页面的 URL 。浏览器通过 AJAX 请求检索新页面（通常以 JSON 格式）所需的新数据。然后， SPA 通过 JavaScript 动态更新已经在初始页面加载中已经下载好的新页面。这种模式类似于原生手机应用的工作原理。

但是 iOS 开发更像类 MPA (Multi-Page Application)。

![image-20220707233256382](https://tva1.sinaimg.cn/large/e6c9d24ely1h3ys9sr8c1j21nc0rcwig.jpg)

往往一个原生的 App ，页面差不多应该是上图这样。

### 两者解决的需求也存在差异

iOS 的组件化一部分也是解决了代码复用性的问题，但是更多的是解决耦合性大，开发效率合作性低的问题。而 Vue 的组件化更多的是为了解决代码复用性的问题。

### 两者的组件化的方向也有不同。

iOS 平台由于有 UIKit 这类苹果已经封装好的 Framework，所以基础控件已经封装完成，不需要我们自己手动封装了，所以 iOS 的组件着眼于一个大的功能，比如网络库，购物车，我的钱包，整个业务块。前端的页面布局是在 DOM 上进行的，只有最基础的 CSS 的标签，所以控件都需要自己写，Vue 的组件化封装的可复用的单文件组件其实更加类似于 iOS 这边的 ViewModel。

友情链接：
[Vue.js 官方文档](https://cn.vuejs.org/)

[ Vue 与 iOS 的组件化](https://github.com/halfrost/Halfrost-Field/blob/master/contents/Vue/%E5%A4%A7%E8%AF%9D%E5%A4%A7%E5%89%8D%E7%AB%AF%E6%97%B6%E4%BB%A3(%E4%B8%80)%20%E2%80%94%E2%80%94%20Vue%20%E4%B8%8E%20iOS%20%E7%9A%84%E7%BB%84%E4%BB%B6%E5%8C%96.md)

[组件化 OR 模块化](https://www.zybuluo.com/qidiandasheng/note/445105)

[iOS 组件化 —— 路由设计思路分析](https://www.jianshu.com/p/76da56b3bd55)

[iOS应用架构谈 组件化方案](https://casatwy.com/iOS-Modulization.html)

[App 组件化与业务拆分那些事](https://juejin.cn/post/6844903458680619021)
