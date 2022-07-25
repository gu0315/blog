//
//  SCCModuleURL.h
//  Pods
//
//  Created by 葛亮 on 16/5/26.
//
//

#import <Foundation/Foundation.h>
#import "SCCModuleURLInitInterceptor.h"

NS_ASSUME_NONNULL_BEGIN


@interface SCCModuleURL : NSURL


/**
 设置 URL 初始化拦截器
 用于外部替换传入的 URL
 非常危险
 除了业务路由的临时方案外请勿使用!!!!

 @param interceptor 拦截器
 */
+ (void)setupURLInitInterceptor:(id<SCCModuleURLInitInterceptor>)interceptor;
    
/**
 *  URL中的参数
 */
@property (nonatomic, strong, readonly) NSDictionary *module_param;

/**
 *  URL中的模块名
 */
@property (nonatomic, strong, readonly) NSArray<NSString *> *module_names;


/**
 模块方法
 */
@property (nonatomic, copy, readonly) NSString *module_method;

/**
 *  根据module_names中的moduleName获取真实的name，由于moduleName可以增加$字符代表堆栈唯一，e.g $moduleName，代表该module作为VC是在整个堆栈中是唯一的，不会重复添加。
 *
 *  @param moduleName module_names中的name
 *
 *  @return 真正的name
 */
- (NSString *)moduleRealName:(NSString *)moduleName;

/**
 *  判断该moduleName对应的VC是否是堆栈唯一的
 *
 *  @param moduleName module_names中的name
 *
 *  @return YES 堆栈唯一， NO 不唯一
 */
- (BOOL)moduleStackUnique:(NSString *)moduleName;

@end

NS_ASSUME_NONNULL_END
