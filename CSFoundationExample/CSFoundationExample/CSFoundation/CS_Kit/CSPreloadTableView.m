//
//  CSPreloadTableView.m
//  CSFoundationExample
//
//  Created by dianju on 2019/6/11.
//  Copyright © 2019 Andersen. All rights reserved.
//

#import "CSPreloadTableView.h"
#import <objc/runtime.h>
#import <pthread.h>

@interface CSPreloadTableView()
@property (nonatomic,assign)pthread_rwlock_t cacheLock;//读写锁，多读单写
@end

@implementation CSPreloadTableView

- (id)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        pthread_rwlock_init(&_cacheLock, NULL);
        _cacheRange = 3;
    }
    return self;
}

- (id)init{
    if (self = [super init]) {
        [self setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        pthread_rwlock_init(&_cacheLock, NULL);
        _cacheRange = 3;
    }
    return self;
}


- (NSMutableDictionary*)cache{
    if(!_cache)
        _cache = [[NSMutableDictionary alloc] init];
    
    return _cache;
}
- (NSMutableDictionary*)reuseCellQueue
{
    if (!_reuseCellQueue)
        _reuseCellQueue = [[NSMutableDictionary alloc]init];
    
    return _reuseCellQueue;
}


- (void)replaceMethod{
    Class cls = object_getClass(self.dataSource);
    SEL sel = @selector(tableView:cellForRowAtIndexPathOrigin:);
    
    IMP originImp = class_getMethodImplementation(cls, @selector(tableView:cellForRowAtIndexPath:));
    
    IMP newImp = class_getMethodImplementation([self class], @selector(tableView:cellForRowAtIndexPathCached:));
    
    //"@@@"--返回值id类型，参数1:id类型，参数2:id类型
    //把originImp实现交给@selector(tableView:cellForRowAtIndexPathOrigin:)
    class_addMethod(cls, sel, originImp, "@@@");
    
    class_replaceMethod(cls, @selector(tableView:cellForRowAtIndexPath:), newImp, "@@@");
}
//拦截-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath回调
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPathCached:(NSIndexPath *)indexPath
{
    
    UITableViewCell* cachedCell = [(CSPreloadTableView*)tableView getCache:indexPath];
    
    if (!cachedCell)
    {
        if ([self respondsToSelector:@selector(tableView:cellForRowAtIndexPathOrigin:)]) {
            //把系统-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath返回的cell截取，放进自己的cache
            [(CSPreloadTableView*)tableView setupCache:indexPath];
            
            cachedCell = [(CSPreloadTableView*)tableView getCache:indexPath];
        }
    }
    
    [(CSPreloadTableView*)tableView cache:indexPath];
    
    return cachedCell;
}
- (id)dequeueReusableCellWithIdentifier:(NSString*)identifier{
    
    return [super dequeueReusableCellWithIdentifier:identifier];
}

- (id)dequeueReusableCellWithIdentifier:(NSString *)identifier forIndexPath:(NSIndexPath *)indexPath
{
    [super dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    return [self cellFromReuseQueue:identifier indexPath:indexPath];
}

- (void)addCellToResuseQueue:(UITableViewCell*)cell indexPath:(NSIndexPath*)indexPath{
    [self.reuseCellQueue setObject:cell forKey:StringFromIndexPath(indexPath)];
}


-(UITableViewCell*)cellFromReuseQueue:(NSString*)identifier indexPath:(NSIndexPath*)indexPath
{
    if(!identifier)
        return nil;
    
    UITableViewCell *cell = nil;
    
    if (indexPath)
    {
        UITableViewCell *tempCell = [self.reuseCellQueue objectForKey:StringFromIndexPath(indexPath)];
        
        if ([identifier isEqualToString:tempCell.reuseIdentifier]) {
            [self.reuseCellQueue removeObjectForKey:StringFromIndexPath(indexPath)];
            cell = tempCell;
        }
    }
    else{
        for (NSString *key in self.reuseCellQueue.allKeys) {
            UITableViewCell *tempCell = [self.reuseCellQueue objectForKey:key];
            if ([identifier isEqualToString:tempCell.reuseIdentifier]) {
                [self.reuseCellQueue removeObjectForKey:key];
                cell = tempCell;
            }
        }
    }
    return cell;
}
//判读是否在屏幕内显示区域
- (BOOL)isIndexPathVisible:(NSIndexPath*)indexPath
{
    for (NSIndexPath *visibleIndexPath in [self indexPathsForVisibleRows]) {
        if ([StringFromIndexPath(indexPath) isEqualToString:StringFromIndexPath(visibleIndexPath)])
        {
            return YES;
        }
    }
    
    return NO;
}
- (NSArray *)indexPathsForCachedRows
{
    NSMutableArray*indexPaths = [[NSMutableArray alloc]init];
    for (NSString*indexPathString in self.cache.allKeys) {
        [indexPaths addObject:IndexPathFromString(indexPathString)];
    }
    return indexPaths;
}
-(UITableViewCell*)cellForCachedrowAtIndexPath:(NSIndexPath*)indexPath
{
    return [self.cache objectForKey:StringFromIndexPath(indexPath)];
}

- (void)reloadData
{
    [self reCacheAll];
}
- (void)setDataSource:(id<UITableViewDataSource>)dataSource
{
    [super setDataSource:dataSource];
    [self replaceMethod];
}
- (void)reSetupCache:(NSIndexPath*)indexPath
{
    if ([self isCached:indexPath])
    {
        [self removeCache:indexPath];
        [self setupCache:indexPath];
    }
}
- (void)reCacheAll
{
    for (id key in self.cache.allKeys) {
        [self reSetupCache:IndexPathFromString(key)];
    }
}
#pragma cache methods
- (void)cache:(NSIndexPath*)currentIndexPath
{
    NSIndexPath* previousIndexPath;
    NSIndexPath* nextIndexPath;
    
    //判断cache里不在屏幕上的cell是否是当前要显示的cell临近的前两个或者后两个，如果不是则从caChe里移除放到复用池里
    [self uncache:currentIndexPath];
    
    for(int i = 1;i<self.cacheRange; i++)
    {
        if (currentIndexPath) {
            previousIndexPath = [self getPreviousIndexPath:previousIndexPath];

            if ([self isCached:previousIndexPath]) {
                [self setupCache:previousIndexPath];
            }
        }

        if (currentIndexPath) {
            nextIndexPath = [self getNextIndexPath:nextIndexPath];

            if (nextIndexPath) {
                if (![self isCached:nextIndexPath]) {
                    [self setupCache:nextIndexPath];
                }
            }
        }
    }
}

- (void)uncache:(NSIndexPath*)currentIndexPath{
    pthread_rwlock_wrlock(&_cacheLock);
    
    NSIndexPath *indexPath;
    
    for(id key in self.cache.allKeys)
    {
        indexPath = IndexPathFromString(key);
        //判断是否是当前indexPath
        if ([StringFromIndexPath(indexPath) isEqualToString:StringFromIndexPath(currentIndexPath)])
            continue;
        
        NSIndexPath *keyIndexPath = indexPath;
        int distance = 0;
        if (indexPath) {
            NSComparisonResult result = [indexPath compare:currentIndexPath];
            //如果key对应的cell在currentIndexPath对应的cell之后
            if (result == NSOrderedDescending) {
                //判断currentIndexpath是在当前屏幕可见的cell中
                while (![self isIndexPathVisible:indexPath])
                {
                    //获取上一个cell的indexPath
                    indexPath = [self getPreviousIndexPath:indexPath];
                    distance++;
                    
                    if (distance > self.cacheRange)
                        break;
                }
            }
            
            //如果key对应的cell在当前currentIndexPath对应的cell之前
            else
            {
                //当key对应的cell不在屏幕上的时候
                while (![self isIndexPathVisible:indexPath])
                {
                    indexPath = [self getNextIndexPath:indexPath];//获取key对应的cell之后的一个cell的indexPath
                    distance++;
                    if (distance>self.cacheRange)
                        break;
                }
            }
        }
        //如果cell的数量大于缓存限制，从缓存中移除，放入自定义复用池
        if (distance>self.cacheRange) {
            [self removeCache:keyIndexPath];
        }
    }
    
    pthread_rwlock_unlock(&_cacheLock);
}

- (void)setupCache:(NSIndexPath *)indexPath
{
    indexPath = [indexPath copy];
    
    if ([self numberOfRowsInSection:indexPath.section] <= indexPath.row)
        return;
    
    
    UITableViewCell* cachedCell;
    
    if ([self.dataSource respondsToSelector:@selector(tableView:cellForRowAtIndexPathOrigin:)])
    {
        cachedCell = [self.dataSource performSelector:@selector(tableView:cellForRowAtIndexPathOrigin:) withObject:self withObject:indexPath];
    }
    
    if (cachedCell)
    {
        pthread_rwlock_wrlock(&_cacheLock);
        [self.cache removeObjectForKey:StringFromIndexPath(indexPath)];
        [self.cache setObject:cachedCell forKey:StringFromIndexPath(indexPath)];
        pthread_rwlock_unlock(&_cacheLock);
    }
}

- (void)removeCache:(NSIndexPath*)indexPath
{
    pthread_rwlock_wrlock(&_cacheLock);
    
    id cell = [self.cache objectForKey:StringFromIndexPath(indexPath)];
    
    if (cell) {
        [self addCellToResuseQueue:cell indexPath:indexPath];
        [self.cache removeObjectForKey:StringFromIndexPath(indexPath)];
    }
    
    pthread_rwlock_unlock(&_cacheLock);
}

- (BOOL)isCached:(NSIndexPath*)indexPath
{

    if ([self getCache:indexPath])
        return YES;
    else
        return NO;
}

- (id)getCache:(NSIndexPath*)indexPath{
    UITableViewCell* cachedCell;
    pthread_rwlock_rdlock(&_cacheLock);
    cachedCell = [self.cache objectForKey:StringFromIndexPath(indexPath)];
    pthread_rwlock_unlock(&_cacheLock);
    return cachedCell;
}

- (NSIndexPath*)getPreviousIndexPath:(NSIndexPath*)indexPath{
    NSIndexPath *nextIndexPath = nil;
    NSUInteger row = indexPath.row;
    NSUInteger section = indexPath.section;
    
    //tableView分组的情况，当indexPath是一个分组的第一个cell，要找到前一个cell就必须得在前一组里寻找section-1；
    if (row == 0) {
        
        if (section == 0) {
            return nil;
        }else{
            section--;
        }
    }else{
        row--;
    }
    while (YES) {
        //如果这个Section的row大于0
        if ([self numberOfRowsInSection:section] > 0) {
            /*
             当前一个cell不在原本的section里时，获取这个section的最后一个cell的row
            */
            if (section != indexPath.section)
                row = [self numberOfRowsInSection:section] -1;
            //把indexPath的section - 1 的section和这个section的最后一个row组成一个IndexPath
            nextIndexPath = [NSIndexPath indexPathForRow:row inSection:section];
            break;
        }
        else
        {
            //如果当前sections已经是第一组时退出。
            if (section == 0)
                break;
            else
                section--;//如果这个section里没有row，就再到前一组section里面去找
        }
    }
    return nextIndexPath;
}

- (NSIndexPath*)getNextIndexPath:(NSIndexPath*)indexPath
{
    NSIndexPath *nextIndexPath = nil;
    NSUInteger row = indexPath.row + 1;
    NSUInteger section = indexPath.section;
    
    while (YES) {
        if ([self numberOfRowsInSection:section]>row) {
            nextIndexPath = [NSIndexPath indexPathForRow:row inSection:section];
            break;
        }
        else
        {
            section++;
            row = 0;
        }
    }
    
    return nextIndexPath;
}
@end
