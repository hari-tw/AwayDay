//
// Created by Hari B on 11/09/14.
//

#import <Foundation/Foundation.h>


@interface QuestionTableViewCell : UITableViewCell
@property (nonatomic, strong) NSString *question;

+ (CGFloat)heightForCellWithQuestion:(NSString *)question;
@end