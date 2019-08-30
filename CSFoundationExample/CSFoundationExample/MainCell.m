//
//  MainCell.m
//  CSFoundationExample
//
//  Created by dianju on 2019/6/13.
//  Copyright © 2019 Andersen. All rights reserved.
//

#import "MainCell.h"
@interface MainCell()
@property (nonatomic,strong)UIImageView *mainView;
@end

@implementation MainCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor lightGrayColor];
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    _mainView = [[UIImageView alloc]initWithFrame:CGRectInset(self.contentView.frame, 10, 10)];
    _mainView.image = _image;
    NSLog(@"cell: %p  %p",_mainView.image,_image);
    [self.contentView addSubview:_mainView];
}


- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
