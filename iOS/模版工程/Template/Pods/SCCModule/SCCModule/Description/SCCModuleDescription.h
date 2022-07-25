//
//  SCCModuleDescription.h
//  Pods
//
//  Created by 葛亮 on 16/10/20.
//
//

#import <Foundation/Foundation.h>
#import "SCCModuleMethod.h"

NS_ASSUME_NONNULL_BEGIN

@interface SCCModuleDescription : NSObject

/**
 runtime获取实现SCCModuleProtocol协议的类做绑定
 */
@property (nonatomic, readonly, nullable) Class moduleClass;

/**
 为了兼容老版本，在runtime时期绑定老版本的SCCModuleProtocol的+(NSString *)moduleName方法
 */
@property (nonatomic, copy, readonly) NSString *moduleName;

/**
 该模块下面的所有method，key为method的别名，value为SCCModuleMethod的对象
 */
@property (nonatomic, strong, readonly) NSMutableDictionary<NSString *, SCCModuleMethod *> *moduleMethods;

#pragma mark - 模块描述方法


/**
 设置模块所属的类
 */
- (SCCModuleDescription *(^)(Class))cls;

/**
 设置模块所属的类

 @param cls 所属类

 @return 模块
 */
- (SCCModuleDescription *)cls:(Class)cls;


/**
 设置模块别名
 */
- (SCCModuleDescription *(^)(NSString *))name;

/**
 设置模块别名
 
 @param name 模块别名
 
 @return 模块
 */
- (SCCModuleDescription *)name:(NSString *)name;

/**
 调用该方法为你的模块增加一个动作,函数式调用方法

 @param methodDescriptionBlock method描述的block

 @return 模块的描述对象
 */
- (SCCModuleDescription *)method:(void (^)(SCCModuleMethod * method))methodDescriptionBlock;

/**
 调用该方法为你的模块增加一个动作,链式调用方法，没有代码补全很难用
 */
- (SCCModuleDescription *(^)(void (^)(SCCModuleMethod * method)))method;


/**
 调用该方法为你的模块增加一个open动作,函数式调用方法
 
 @param methodDescriptionBlock method描述的block
 
 @return 模块的描述对象
 */
- (SCCModuleDescription *)openMethod:(void (^)(SCCModuleMethod * method))methodDescriptionBlock;

/**
 调用该方法为你的模块增加一个open动作,链式调用方法，没有代码补全很难用
 */
- (SCCModuleDescription *(^)(void (^)(SCCModuleMethod * method)))openMethod;


/**
 返回字典描述
 
 @return 模块的字典描述
 */
- (NSDictionary *)jsonDescription;

@end

NS_ASSUME_NONNULL_END
