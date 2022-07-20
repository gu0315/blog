//
//  IntegrationProtocol.h
//  Template
//
//  Created by 顾钱想 on 2022/7/18.
//

#import <Foundation/Foundation.h>

@protocol IntegrationProtocol <NSObject>
//优先级
+ (long)integrationPriority;

+ (void)fb_injectable;

@end

