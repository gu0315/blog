//
//  SCCModuleMethod.h
//  Pods
//
//  Created by 葛亮 on 16/10/20.
//
//

#import <Foundation/Foundation.h>
#import "SCCModuleParam.h"
#import "SCCModuleParamEnumerator.h"

@class SCCModuleDescription;

NS_ASSUME_NONNULL_BEGIN

@interface SCCModuleMethod : NSObject

/**
 模块方法对应的selector
 */
@property (nonatomic, readonly, nullable) SEL methodSelector;

/**
 模块方法对应的别名
 */
@property (nonatomic, copy, readonly) NSString *methodName;

/**
 YES表示方法只能被native方式调用，NO表示可以使用URL方式调用，默认NO
 */
@property (nonatomic, readonly) BOOL isNativeMethod;

/**
 YES表示是类方法，NO表示是实例方法，默认NO
 */
@property (nonatomic, readonly) BOOL isClassMethod;

///**
// 模块方法中的所有参数，按照selecor的顺序排列
// */
//@property (nonatomic, strong, readonly) NSMutableArray<SCCModuleParam *> *methodParams;

/**
 对所属module的弱引用
 */
@property (nonatomic, weak) SCCModuleDescription *module;

/**
 方法的返回值
 */
@property (nonatomic, readonly) SCCParamType methodResultType;

#pragma mark - 设置method相关描述

/**
 方法的别名
 */
- (SCCModuleMethod *(^)(NSString *))name;

/**
 方法的别名

 @param name 别名

 @return 方法
 */
- (SCCModuleMethod *)name:(NSString *)name;

/**
 方法的selector
 */
- (SCCModuleMethod *(^)(SEL))selector;

/**
 方法的selector

 @param selector selector

 @return 方法
 */
- (SCCModuleMethod *)selector:(SEL)selector;

/**
 方法的是否支持URL调用，YES不支持，NO支持
 */
- (SCCModuleMethod *(^)(BOOL))justNative;

/**
 方法的是否支持URL调用，YES不支持，NO支持
 
 @param justNative YES不支持，NO支持

 @return 方法
 */
- (SCCModuleMethod *)justNative:(BOOL)justNative;

/**
 方法是否是类方法，YES类方法，NO实例方法
*/
- (SCCModuleMethod *(^)(BOOL))classMethod;
 

/**
 方法是否是类方法，YES类方法，NO实例方法

 @param classMethod YES类方法，NO实例方法

 @return 方法
*/
- (SCCModuleMethod *)classMethod:(BOOL)classMethod;


/**
 method增加所有参数描述，该方法根据selector获取参数个数，在使用之前首先调用selector和classMethod方法

 @param paramsDescriptionBlock 参数描述的block

 @return method实例
 */
- (SCCModuleMethod *)parameters:(void (^)(SCCModuleParamEnumerator *enumerator))paramsDescriptionBlock;


/**
 method增加所有参数描述，该方法根据selector获取参数个数，在使用之前首先调用selector和classMethod方法, 只不过使用的是链式调用，不太方便
*/
- (SCCModuleMethod *(^)(void (^)(SCCModuleParamEnumerator *enumerator)))parameters;
 
/**
 method增加返回参数描述
 
 @param type 参数表述的block
 
 @return method实例
 */
- (SCCModuleMethod *)resultType:(SCCParamType)type;

/**
 method增加返回参数描述,使用链式调用，不太方便
 */
- (SCCModuleMethod *(^)(SCCParamType))resultType;


/**
 返回字典描述
 
 @return 方法的字典描述
 */
- (NSDictionary *)jsonDescription;

#pragma mark - 执行方法

- (nullable id)invokeWithParams:(NSDictionary *)params callback:(void (^ __nullable)(NSDictionary * __nullable))callback;

@end

NS_ASSUME_NONNULL_END
