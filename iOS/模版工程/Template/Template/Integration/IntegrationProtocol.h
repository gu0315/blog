//
//  IntegrationProtocol.h
//  Template
//
//  Created by 顾钱想 on 2022/7/18.
//

#import <Foundation/Foundation.h>
#import "IntegrationManager.h"

NS_ASSUME_NONNULL_BEGIN

char * BNavigationBarDefaultConfiguration InjectableDATA = "+[FBNavigationBarDefaultConfiguration(FBInjectable) fb_injectable]";

@protocol IntegrationProtocol <NSObject>
//优先级
+ (NSUInteger)integrationPriority;

@end

NS_ASSUME_NONNULL_END
