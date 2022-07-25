//
//  SCCModulorTakeEffectManager.h
//  Pods-SCCModule_Example
//
//  Created by 阎辉 on 2020/6/23.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SCCModulorTakeEffectManager : NSObject

+ (instancetype)manager NS_SWIFT_NAME(sharedInstance());

/**
*  若有重复的协议，设置生效的协议，{modeleName: className}
*/
@property (nonatomic, copy) NSDictionary *moduleTakeEffect;

@end

NS_ASSUME_NONNULL_END
