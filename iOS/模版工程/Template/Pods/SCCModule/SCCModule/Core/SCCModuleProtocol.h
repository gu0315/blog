//
//  SCCModuleProtocol.h
//  Pods
//
//  Created by 葛亮 on 16/5/26.
//
//

#import <Foundation/Foundation.h>
#import "SCCModuleDescription.h"

@protocol SCCModuleProtocol <NSObject>

/**
 描述模块的作用

 @param description 模块描述
 */
+ (void)moduleDescription:(SCCModuleDescription *)description;

@optional

/**
 *  模块名称  英文驼峰式
 *
 *  @return 模块名称
 */
+ (NSString *)moduleName;

/**
 *  描述模块的作用
 *
 *  @return 模块描述
 */
+ (NSString *)moduleDescription;

/**
 *  模块保护方法 只能在native调用
 *
 *  @return 保护方法列表
 */
- (NSArray<NSString *> *)moduleProtectedSelectors;

/**
 *  模块提供的调用方法，如果返回为nil，则可以调用任何方法
 *
 *  @return 模块提供的方法
 */
- (NSArray<NSString *> *)moduleSelectors;

/**
 *  实现该方法，创建模块，并传递参数和回调block，兼容之前的cheniu://open/module?key=value
 *
 *  @param params   模块参数
 *  @param callback 模块回调
 *
 *  @return 模块对象
 */
- (id)open:(NSDictionary *)params callback:(void(^)(NSDictionary *))callback;

/**
 *  实现该方法，创建模块，并传递参数，该方法用来兼容之前的cheniu://open.present/module?key=value
 *
 *  @param params   模块参数
 *  @param callback 模块回调
 *
 *  @return 模块对象
 */
- (id)open_present:(NSDictionary *)params callback:(void(^)(NSDictionary *))callback;


/**
 *  实现该方法，当模块作为Controller被标记为$符号整个堆栈唯一时，会调用该方法通知堆栈中已经存在的controller刷新数据
 *
 *  @param params   模块参数
 *
 */
- (void)moduleReload:(NSDictionary *)params;
@end
