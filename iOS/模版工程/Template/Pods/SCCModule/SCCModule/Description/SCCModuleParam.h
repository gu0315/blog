//
//  SCCModuleParam.h
//  Pods
//
//  Created by 葛亮 on 16/10/20.
//
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, SCCParamType) {
    SCCParamTypeString,//字符串类型,参数会被转为NSString
    SCCParamTypeNumber,//数字类型，参数会被转为NSNumber
    SCCParamTypeMap,//字典类型，参数对应的name如果无法找到或者参数不是字典类型，模块接收到的所有参数组成的字典会被传入该参数，map支持strict模式
    SCCParamTypeArray,//数组类型，
    SCCParamTypeBlock,//block类型，模块接收的block会被传入该类型对应的参数
    SCCParamTypeObject,//其他对象类型，比如UIImage
    SCCParamTypeUnknown,//参数初始化类型
    SCCParamTypeEmpty,//函数返回空值类型，默认的函数返回值类型
};

NS_ASSUME_NONNULL_BEGIN

@interface SCCModuleParam : NSObject

/**
 参数别名
 */
@property (nonatomic, copy, readonly) NSString *paramName;

/**
 参数类型
 */
@property (nonatomic, readonly) SCCParamType paramType;

/**
 是否严格匹配，默认no，开启严格匹配的参数，会在参数列表里寻找对应名称和对应类型的数据，不再有兼容处理，目前只有map支持该模式
 */
@property (nonatomic, readonly) BOOL isStrict;

/**
 设置参数是否name type 严格匹配
 */
- (SCCModuleParam *(^)(BOOL))strict;

/**
 设置参数是否name type 严格匹配

 @param isStrict 是否严格匹配
 @return 参数
 */
- (SCCModuleParam *)strict:(BOOL)isStrict;

/**
 设置最近一个参数的别名
 */
- (SCCModuleParam *(^)(NSString *))name;

/**
 设置最近一个参数的别名

 @param name 别名

 @return 参数
 */
- (SCCModuleParam *)name:(NSString *)name;

/**
 设置最近一个参数的类型
 */
- (SCCModuleParam *(^)(SCCParamType))type;

/**
 设置最近一个参数的类型

 @param type 类型

 @return 参数
 */
- (SCCModuleParam *)type:(SCCParamType)type;

/**
 返回参数的描述

 @return 参数描述
 */
+ (NSString *)typeDescription:(SCCParamType)type;

/**
 返回字典描述

 @return 参数的字典描述
 */
- (NSDictionary *)jsonDescription;
@end

NS_ASSUME_NONNULL_END
