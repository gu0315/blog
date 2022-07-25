//
//  UINavigationController+SCCModulor.m
//  Pods
//
//  Created by 葛亮 on 16/6/2.
//
//

#import "UINavigationController+SCCModulor.h"
#import "SCCModulor.h"
#import "SCCModuleURL.h"
#import "SCCModuleProtocol.h"

@implementation UINavigationController (SCCModulor)

- (BOOL)scc_pushModule:(NSString *)moduleName animated:(BOOL)animated withParams:(NSDictionary *)params callback:(void(^)(NSDictionary *moduleInfo))callback {
    BOOL suc = NO;
    UIViewController *moduleVC = [[SCCModulor modulor] moduleName:moduleName openWithParams:params callback:callback];
    if ([moduleVC isKindOfClass:[UIViewController class]]) {
        [self pushViewController:moduleVC animated:animated];
        suc = YES;
    }
    return suc;
}


- (BOOL)scc_setModules:(NSString *)modulesURLString animated:(BOOL)animated withParams:(NSDictionary *)params callback:(void(^)(NSDictionary *moduleInfo))callback {
    BOOL suc = NO;
    SCCModuleURL *url = [[SCCModuleURL alloc] initWithString:modulesURLString];
    NSArray<UIViewController *> *moduleVCs = [[SCCModulor modulor] modulesURLString:modulesURLString performWithParams:params callback:callback];
    if (moduleVCs.count) {
        NSMutableArray<UIViewController *> *stachVCs = [NSMutableArray arrayWithArray:self.viewControllers];
        [moduleVCs enumerateObjectsUsingBlock:^(UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj isKindOfClass:[UIViewController class]]) {
                __block BOOL hasBefore = NO;
                BOOL unique = [url moduleStackUnique:url.module_names[idx]];
                if (unique) {
                    [stachVCs enumerateObjectsUsingBlock:^(UIViewController * _Nonnull stachVC, NSUInteger idx, BOOL * _Nonnull stop) {
                        if ([NSStringFromClass(stachVC.class) isEqualToString:NSStringFromClass(obj.class)]) {
                            if ([stachVC respondsToSelector:@selector(moduleReload:)]) {
                                [stachVC performSelector:@selector(moduleReload:) withObject:params];
                            }
                            hasBefore = YES;
                            *stop = YES;
                        }
                    }];
                    
                }
                if (!hasBefore) {
                    [stachVCs addObject:obj];
                }
            }
        }];
        if (stachVCs.count) {
            [self setViewControllers:stachVCs animated:animated];
            suc = YES;
        }
    }    
    return suc;
}

@end
