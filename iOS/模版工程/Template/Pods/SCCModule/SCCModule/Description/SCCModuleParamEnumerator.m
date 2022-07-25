//
//  SCCModuleParamEnumerator.m
//  Pods
//
//  Created by 葛亮 on 16/12/5.
//
//

#import "SCCModuleParamEnumerator.h"

@interface SCCModuleParamEnumerator ()

@property (nonatomic, strong) NSMutableArray *params;
@property (nonatomic) NSInteger index;

@end

@implementation SCCModuleParamEnumerator

- (instancetype)init {
    if (self = [super init]) {
        self.params = [NSMutableArray array];
    }
    return self;
}

- (SCCModuleParam *)next {
    NSAssert(self.index < self.params.count, @"没有参数可以描述");
    SCCModuleParam *param;
    if (self.index < self.params.count) {
        param = self.params[self.index];
        self.index++;
    }
    return param;
}

- (SCCModuleParamEnumerator *)enumerate {
    self.index = 0;
    return self;
}

- (BOOL)end {
    return self.index == self.params.count;
}
@end
