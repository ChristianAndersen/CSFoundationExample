//
//  MainTableView.h
//  CSFoundationExample
//
//  Created by dianju on 2019/6/13.
//  Copyright © 2019 Andersen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CSPreloadTableView.h"
NS_ASSUME_NONNULL_BEGIN

@interface MainTableView : CSPreloadTableView<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)NSMutableArray *data;
@end

NS_ASSUME_NONNULL_END
