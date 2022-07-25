//
//  SCCModuleParamEnumerator.h
//  Pods
//
//  Created by 葛亮 on 16/12/5.
//
//

#import <Foundation/Foundation.h>
#import "SCCModuleParam.h"

@interface SCCModuleParamEnumerator : NSObject

@property (nonatomic, strong, readonly) NSMutableArray *params;

- (SCCModuleParam *)next;

- (SCCModuleParamEnumerator *)enumerate;

- (BOOL)end;
@end
