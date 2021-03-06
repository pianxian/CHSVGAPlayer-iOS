//
//  SVGAVideoEntity+CHSVGA.m
//  CHSVGAPlayer-iOS
//
//  Created by CHwang on 2020/1/9.
//

#import "SVGAVideoEntity+CHSVGA.h"
#import <CHCategories/NSObject+CHBase.h>

#import <YYKit/YYKit.h>

static YYCache *chVideoCache;

@interface SVGAVideoEntity () <NSCoding>
@end

@implementation SVGAVideoEntity (CHSVGA)

#pragma mark - Life cycle
+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        chVideoCache = [YYCache cacheWithName:@"CH_SVGA_CACHE"];
        [self chsvga_setupMemoryCacheCostLimit:10 * 1024];
    
        [self ch_swizzleClassMethod:@selector(readCache:) withNewMethod:@selector(_ch_svga_readCache:)];
        [self ch_swizzleInstanceMethod:@selector(saveCache:) withNewMethod:@selector(_ch_svga_saveCache:)];
    });
}

#pragma mark - Public methods

+ (void)chsvga_clearMemoryCache {
    [chVideoCache.memoryCache removeAllObjects];
}

+ (void)chsvga_setupMemoryCacheCostLimit:(NSUInteger)costLimit {
    [chVideoCache.memoryCache setCostLimit:costLimit];
}

#pragma mark - Swizzle methods
+ (SVGAVideoEntity *)_ch_svga_readCache:(NSString *)cacheKey {
    SVGAVideoEntity *cacheItem = (SVGAVideoEntity *)[chVideoCache objectForKey:cacheKey];
    return cacheItem.sprites.count ? cacheItem :nil;

}

- (void)_ch_svga_saveCache:(NSString *)cacheKey {
    [chVideoCache setObject:self forKey:cacheKey];
}

@end
