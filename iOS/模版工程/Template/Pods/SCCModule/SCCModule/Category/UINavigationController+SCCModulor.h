//
//  UINavigationController+SCCModulor.h
//  Pods
//
//  Created by 葛亮 on 16/6/2.
//
//

#import <UIKit/UIKit.h>

@interface UINavigationController (SCCModulor)

/**
 *  采用push的的方式打开模块
 *
 *  @param moduleName 模块名
 *  @param animated   打开动画
 *  @param params     模块需要的参数
 *  @param callback   模块的回调
 *
 *  @return 是否成功调用
 */
- (BOOL)scc_pushModule:(NSString *)moduleName animated:(BOOL)animated withParams:(NSDictionary *)params callback:(void(^)(NSDictionary *moduleInfo))callback;

/**
 *  采用set的方式打开一个或者多个模块
 *
 *  @param modulesURLString 模块的URLString
 *  @param animated         打开动画
 *  @param params           模块需要的参数
 *  @param callback         模块的回调
 *
 *  @return 是否成功调用
 */
- (BOOL)scc_setModules:(NSString *)modulesURLString animated:(BOOL)animated withParams:(NSDictionary *)params callback:(void(^)(NSDictionary *moduleInfo))callback;
@end
