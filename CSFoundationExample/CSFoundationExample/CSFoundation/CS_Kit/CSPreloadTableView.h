//
//  CSPreloadTableView.h
//  CSFoundationExample
//
//  Created by dianju on 2019/6/11.
//  Copyright © 2019 Andersen. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CSPreloadTableView : UITableView
@property (nonatomic,strong)NSMutableDictionary* cache;
@property (nonatomic,strong)NSMutableDictionary* reuseCellQueue;

@property (nonatomic,assign)int cacheRange;
@property (nonatomic,readonly) NSArray* indexPathsForCachedRows;
@end

NS_ASSUME_NONNULL_END
