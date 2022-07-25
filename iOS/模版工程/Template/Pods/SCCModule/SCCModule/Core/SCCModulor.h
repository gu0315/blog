//
//  SCCModulor.h
//  Pods
//  处理module的核心类
//  Created by 葛亮 on 16/5/26.
//
//

#import <Foundation/Foundation.h>
#import "SCCModuleUnrecognizedProtocol.h"

typedef void(^ExceptionHandler)(NSException * _Nullable exception);

@class SCCModuleDescription;

NS_ASSUME_NONNULL_BEGIN

@interface SCCModulor : NSObject

/**
 *  获取modulor对象
 *
 *  @return modulor
 */
+ (instancetype)modulor NS_SWIFT_NAME(sharedInstance());

/**
 *  设置module scheme 和该scheme不符的URL请不会被执行。
 */
@property (nonatomic, copy) NSArray <NSString *> *moduleSchemes;

/**
 *  设置exception handler
 */
@property (nonatomic, strong) ExceptionHandler exceptionHandler;

/**
 无法识别的协议的拦截，暂时只支持URL调用的方式，如果设置了拦截就不会走配置的404页面，由拦截处来走
 */
@property (nonatomic, strong) id<SCCModuleUnrecognizedProtocol> unrecognizedInterceptor;

/**
 *  根据URL获取module的数组，主要用于服务端调用客户端的模块，不符合moduleScheme的URL无法被使用，moduleProtectedSeletors中的方法无法被调用， selector中的:用_代替，末尾的下划线可以不写，e.g. scheme://open_callback/moduleName?key1=value1
 *
 *  @param urlString 调用相关模块的URL
 *  @param params    模块需要的参数
 *  @param callback  模块的回调
 *
 *  @return 模块对象数组
 */
- (NSArray *)modulesURLString:(NSString *)urlString performWithParams:(nullable NSDictionary *)params callback:(void (^ __nullable)(NSDictionary * _Nullable moduleInfo))callback;

/**
 *  native推荐使用该方法调用模块
 *
 *  @param moduleName   模块名
 *  @param selectorName 模块方法
 *  @param params       模块需要的参数
 *  @param callback     模块的参数
 *
 *  @return 模块对象
 */
- (nullable id)moduleName:(NSString *)moduleName performSelectorName:(NSString *)selectorName withParams:(nullable NSDictionary *)params callback:(void(^ __nullable)( NSDictionary * _Nullable moduleInfo))callback;

/**
 *  native推荐使用该方法调用模块的open:callback:和open:方法，优先调用前者
 *
 *  @param moduleName 模块名
 *  @param params     模块参数
 *  @param callback   模块回调
 *
 *  @return 模块对象
 */
- (nullable id)moduleName:(NSString *)moduleName openWithParams:(nullable NSDictionary *)params callback:(void(^ __nullable)(NSDictionary * _Nullable moduleInfo))callback;

/**
 *  判断urlstring中的module是否存在。多个module只要有一个不存在就为NO
 *
 *  @param urlString 模块URL
 *
 *  @return YES 存在，NO不存在
 */
- (BOOL)isValidModuleUrlString:(NSString *)urlString;

/**
 *  判断moduleName中的module是否存在。
 *
 *  @param moduleName 模块名称
 *
 *  @return YES 存在，NO不存在
 */
- (BOOL)isValidModuleName:(NSString *)moduleName;

/**
 *  打印当前所有模块的名称，类名，描述，方法，保护方法的数组
 */
- (void)modulesLog;

/**
 所有的模块字典描述

 @return 描述字典
 */
- (NSDictionary *)modulesJsonDescription;

/**
 打印对应模块名的模块

 @param name 模块名
 */
- (void)moduleLogWithName:(NSString *)name;

/**
 根据模块URL获取模块描述的数组

 @param urlString 模块URL
 @return 模块描述的数组
 */
- (NSArray <SCCModuleDescription *> *)moduleDescriptionsWithURLString:(NSString *)urlString;

/**
 根据模块名称获取整个模块描述

 @param name 模块名称
 @return 模块描述
 */
- (nullable SCCModuleDescription *)moduleDescriptionWithName:(NSString *)name;


/**
 RN 使用，动态注册模块描述, 优先级较高，可以覆盖原来的模块描述
 
 @param modules 模块描述数组

 */
- (void)registerModules:(NSArray <SCCModuleDescription *> *)modules;

@end

NS_ASSUME_NONNULL_END
