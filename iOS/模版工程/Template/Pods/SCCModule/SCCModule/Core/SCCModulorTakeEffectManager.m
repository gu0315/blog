//
//  SCCModulorTakeEffectManager.m
//  Pods-SCCModule_Example
//
//  Created by 阎辉 on 2020/6/23.
//

#import "SCCModulorTakeEffectManager.h"

@implementation SCCModulorTakeEffectManager

+ (instancetype)manager {
    static SCCModulorTakeEffectManager *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[SCCModulorTakeEffectManager alloc] init];
    });
    return manager;
}

- (instancetype)init{
    if (self = [super init]) {
        
    }
    return self;
}

- (NSDictionary *)moduleTakeEffect{
    if (!_moduleTakeEffect) {
        _moduleTakeEffect = @{};
    }
    return _moduleTakeEffect;
}

@end
