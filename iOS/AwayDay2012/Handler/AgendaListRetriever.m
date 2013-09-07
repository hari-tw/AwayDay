#import "AgendaListRetriever.h"
#import "AppConstant.h"
#import "AFJSONRequestOperation.h"

@implementation AgendaListRetriever

-(id)init {
    self = [super init];
    if (self) {
        NSURL *url = [NSURL URLWithString:(NSString *)kServiceLoadSessionList];
        NSLog(@"url = %@", kServiceLoadSessionList);
        NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
        AFJSONRequestOperation *requestOperation = [AFJSONRequestOperation JSONRequestOperationWithRequest:urlRequest
                                                                                                   success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
                                                                                                       NSLog(@"success response:%@", JSON);
                                                                                                   }
                                                                                                   failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
                                                                                                       NSLog(@"fail response:%@", JSON);
                                                                                                   }
        ];

        [requestOperation start];
//        [request setDelegate:self];
//        [request setTimeOutSeconds:10.0f];
//        [request setTag:tag_req_load_session_list];
//        [request startAsynchronous];

    }
    return self;
}
@end
