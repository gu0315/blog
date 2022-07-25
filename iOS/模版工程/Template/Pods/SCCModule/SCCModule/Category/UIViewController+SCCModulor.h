//
//  UIViewController+SCCModulor.h
//  Pods
//
//  Created by 葛亮 on 16/6/2.
//
//

#import <UIKit/UIKit.h>

@interface UIViewController (SCCModulor)

/**
 *  采用present的方式打开一个模块，自动通过当前VC的navigationController获取导航的VC
 *
 *  @param moduleName           模块名
 *  @param animated             打开动画
 *  @param completion           打开完成回调
 *  @param params               模块参数
 *  @param callback             模块回调
 *
 *  @return 是否成功调用
 */
- (BOOL)scc_presentModule:(NSString *)moduleName animated:(BOOL)animated completion:(void (^)(void))completion params:(NSDictionary *)params callback:(void(^)(NSDictionary *moduleInfo))callback;

/**
 *  采用present的方式打开一组模块，自动通过当前VC的navigationController获取导航的VC
 *
 *  @param urlString           模块名
 *  @param animated             打开动画
 *  @param completion           打开完成回调
 *  @param params               模块参数
 *  @param callback             模块回调
 *
 *  @return 是否成功调用
 */
- (BOOL)scc_presentModuleUrl:(NSString *)urlString animated:(BOOL)animated completion:(void (^)(void))completion params:(NSDictionary *)params callback:(void(^)(NSDictionary *moduleInfo))callback;


/**
 *  根据open:和open:callback:的action自动采用push的方式打开页面， open_present:的action采用present的方式打开页面。
 *
 *  @param urlString 模块URL
 *  @param animated  打开动画
 *  @param params    模块参数
 *  @param callback  模块回调
 *
 *  @return 是否成功调用
 */
- (BOOL)scc_displayModuleUrl:(NSString *)urlString animated:(BOOL)animated params:(NSDictionary *)params callback:(void(^)(NSDictionary *moduleInfo))callback;

/**
 *  根据open:和open:callback:的action自动采用push的方式打开页面， open_present:的action采用present的方式打开页面。
 *
 *  @param urlString 模块URL
 *
 *  @return 是否成功调用
 */
- (BOOL)scc_displayModuleUrl:(NSString *)urlString;
@end
