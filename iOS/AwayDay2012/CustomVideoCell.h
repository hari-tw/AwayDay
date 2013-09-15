//
//  CustomVideoCell.h
//  YouTubePlayer
//
//  Created by safadmoh on 15/09/13.
//  Copyright (c) 2013 safadmoh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomVideoCell : UICollectionViewCell

@property(nonatomic,strong) IBOutlet UIActivityIndicatorView *indicatorView;
@property(nonatomic,weak) IBOutlet UIButton *playButton;
@property (weak, nonatomic) IBOutlet UIImageView *videoImageView;

@end
