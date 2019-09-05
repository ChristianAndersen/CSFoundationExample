//
//  MainTableView.m
//  CSFoundationExample
//
//  Created by dianju on 2019/6/13.
//  Copyright © 2019 Andersen. All rights reserved.
//

#import "MainTableView.h"
#import "MainCell.h"
#import "CSCommonFunctions.h"
@interface MainTableView()
@property (nonatomic) NSMutableDictionary* pageSizes;
@end

@implementation MainTableView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.dataSource = self;
        self.delegate = self;
        [self configBtn];
    }
    return self;
}
- (void)configBtn{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    btn.frame = CGRectMake(100, 100, 100, 60);
    btn.backgroundColor = [UIColor brownColor];
    [btn addTarget:self action:@selector(btnAction) forControlEvents:UIControlEventTouchUpInside];
    [btn setTitle:@"复用池Cell" forState:UIControlStateNormal];
    [self addSubview:btn];
}

- (void)btnAction
{
    NSMutableArray *cellArray = [[NSMutableArray alloc]init];
    for (int i = 0; i<self.data.count; i++)
    {
        NSString* identifier = [NSString stringWithFormat:@"0%d",i%3];

        MainCell *cell = [self dequeueReusableCellWithIdentifier:identifier];
        if (cell) {
            [cellArray addObject:cell];
        }
    }
    NSLog(@"%@",cellArray);
}
- (NSArray*)data
{
    if (!_data) {
        _data = [[NSMutableArray alloc]init];

        for(int i=0;i<30;i++)
        {
            [_data addObject:[NSString stringWithFormat:@"1_%d.png",i]];
        }
    }
    return _data;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.data.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGSize pageSize;
    
    NSString *sizeString = [self.pageSizes objectForKey:StringFromIndexPath(indexPath)];
    
    if (sizeString) {
        pageSize = SizeFromString(sizeString);
    }else{
        pageSize = [UIImage imageNamed:[self.data objectAtIndex:indexPath.row]].size;
        
        [self.pageSizes setObject:StringFromSize(pageSize) forKey:StringFromIndexPath(indexPath)];
    }
    
    CGFloat height = ((self.frame.size.width-20)/pageSize.width)*pageSize.height;
    
    return height;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString* identifier = [NSString stringWithFormat:@"%ld%ld",(long)indexPath.section,indexPath.row%3];

    MainCell *cell = [self dequeueReusableCellWithIdentifier:identifier];
    
    if (cell == nil) {
        cell =[[MainCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }

    cell.image = [UIImage imageNamed:[self.data objectAtIndex:indexPath.row]];;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
}
@end
