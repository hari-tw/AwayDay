

#import "User.h"
#import "AFHTTPRequestOperation.h"

NSString * const kUserProfileImageDidLoadNotification = @"com.alamofire.user.profile-image.loaded";

@interface User ()
@property (readwrite, nonatomic, assign) NSUInteger userID;
@property (readwrite, nonatomic, copy) NSString *username;
@property (readwrite, nonatomic, copy) NSString *avatarImageURLString;
@property (readwrite, nonatomic, strong) AFHTTPRequestOperation *avatarImageRequestOperation;

@end

@implementation User

- (instancetype)initWithAttributes:(NSDictionary *)attributes {
    self = [super init];
    if (!self) {
        return nil;
    }
    self.userID = [[attributes valueForKeyPath:@"id"] integerValue];
    self.username = [attributes valueForKeyPath:@"name"];
    self.avatarImageURLString = [attributes valueForKeyPath:@"profile_image_url"];
    
    return self;
}

- (NSURL *)avatarImageURL {
    return [NSURL URLWithString:self.avatarImageURLString];
}



@end
