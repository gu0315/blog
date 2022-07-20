//
//  RootViewControllerProtocol.h
//  RootViewController
//
//  Created by 顾钱想 on 2022/7/19.
//

#import <Foundation/Foundation.h>
#import "IntegrationProtocol.h"
#import "IntegrationManager.h"

@protocol RootViewControllerProtocol<IntegrationProtocol>

//优先级
+ (long)integrationPriority;

+ (void)fb_injectable;

@end

