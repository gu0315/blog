//
//  SCCModuleURLInitInterceptor.h
//  SCCModule
//
//  Created by Shao Tianchi on 2018/4/23.
//

#import <Foundation/Foundation.h>

@protocol SCCModuleURLInitInterceptor <NSObject>
- (NSString *)interceptOriginURL:(NSString *)URL;
@end
