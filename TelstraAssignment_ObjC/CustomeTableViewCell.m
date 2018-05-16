//
//  CustomeTableViewCell.m
//  TelstraAssignment_ObjC
//
//  Created by Yash on 16/05/18.
//  Copyright © 2018 infosys. All rights reserved.
//

#import "CustomeTableViewCell.h"

@implementation CustomeTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

//MARK:- Init
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createSubviews];
        [self addFontStyles];
        [self addSubviews];
        [self addConstraints];
    }
    return self;
}

//MARK:- Design Methods
-(void)createSubviews {
    self.imageview = [[UIImageView alloc] init];
    self.titleLabel = [[UILabel alloc] init];
    self.descLabel = [[UILabel alloc] init];
}

-(void)addFontStyles {
    self.imageview.translatesAutoresizingMaskIntoConstraints = false;
    self.titleLabel.translatesAutoresizingMaskIntoConstraints = false;
    self.descLabel.translatesAutoresizingMaskIntoConstraints = false;
    
    self.descLabel.numberOfLines = 0;
    self.descLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.titleLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline];
    self.descLabel.font = [UIFont fontWithName:@"Helvetica Neue" size:15];
    self.descLabel.tintColor = [UIColor lightGrayColor];
}

-(void)addSubviews {
    [self.contentView addSubview:self.imageview];
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.descLabel];
}

-(void)addConstraints {
    NSMutableDictionary *viewDict = [[NSMutableDictionary alloc] init];
    [viewDict setObject:self.imageview forKey:@"image"];
    [viewDict setObject:self.titleLabel forKey:@"title"];
    [viewDict setObject:self.descLabel forKey:@"desc"];
  
    [self.contentView addConstraints:(
                                      [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-11-[image(150)]-(>=11)-|"
                                                                              options:0
                                                                              metrics:nil
                                                                                views:viewDict])];
    [self.contentView addConstraints:(
                                      [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-11-[title(20)]-[desc]-(>=10)-|"
                                                                              options:NSLayoutFormatAlignAllLeading
                                                                              metrics:nil
                                                                                views:viewDict])];
    [self.contentView addConstraints:(
                                      [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-16-[image(120)]-[title]-16-|"
                                                                              options:NSLayoutFormatAlignAllTop
                                                                              metrics:nil
                                                                                views:viewDict])];
    [self.contentView addConstraints:(
                                      [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-16-[image(120)]-[desc]-16-|"
                                                                              options:0
                                                                              metrics:nil
                                                                                views:viewDict])];
}

@end
