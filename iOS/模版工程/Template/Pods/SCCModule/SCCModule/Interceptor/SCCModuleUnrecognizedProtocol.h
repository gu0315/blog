//
//  SCCModuleUnrecognizedProtocol.h
//  Pods-SCCModule_Example
//
//  Created by dasheng on 2019/1/10.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol SCCModuleUnrecognizedProtocol <NSObject>
- (void)sccInterceptOriginURL:(NSString *)URL params:(NSDictionary *)params callback:(void(^)(NSDictionary *moduleInfo))callback;
@end

NS_ASSUME_NONNULL_END
