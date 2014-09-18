//
//  PostShareViewController.m
//  AwayDay2012
//
//  Created by xuehai zeng on 12-8-8.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "PostShareViewController.h"
#import "AppDelegate.h"
#import "AppHelper.h"
#import "ImageService.h"
#import "AppConstant.h"

#define text_length_limit   140
#define tag_req_post_user_share 1001

@implementation PostShareViewController {
    AppDelegate *appDelegate;
}
@synthesize session = _session;
@synthesize textView = _textView;
@synthesize textCountLabel = _textCountLabel;
@synthesize userImage = _userImage;
@synthesize sessionTextLabel = _sessionTextLabel;

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.textView becomeFirstResponder];
    if (self.userImage == nil) {
        self.photoView.alpha = 0.0f;
    }

    if (self.session == nil) {
        [self.sessionTextLabel setText:@""];
    } else {
        [self.sessionTextLabel setText:[NSString stringWithFormat:@"For %@", self.session.sessionTitle]];
    }


    appDelegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    [appDelegate hideMenuView];

    [self.textCountLabel setText:[NSString stringWithFormat:@"%d/%d", self.textView.text.length, text_length_limit]];
}

#pragma mark - UIAction method
- (IBAction)backButtonPressed:(id)sender {
    self.userImage = nil;
    [self.textView setText:@""];
    [self.navigationController popViewControllerAnimated:YES];

    [appDelegate showMenuView];
}


#pragma mark post weibo methods

#pragma mark - UIActionSheet delegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == actionSheet.numberOfButtons - 1) return;

    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    [picker setDelegate:self];

    if ([[actionSheet buttonTitleAtIndex:buttonIndex] rangeOfString:@"Take"].length > 0) {
        //take photo
        [picker setSourceType:UIImagePickerControllerSourceTypeCamera];
    }
    if ([[actionSheet buttonTitleAtIndex:buttonIndex] rangeOfString:@"Album"].length > 0) {
        //select from album
        [picker setSourceType:UIImagePickerControllerSourceTypeSavedPhotosAlbum];
    }
    [self presentModalViewController:picker animated:YES];
}

#pragma mark - UITextView delegate
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    if (self.textView.text.length < text_length_limit) {
        return YES;
    } else {
        return NO;
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if (range.location >= text_length_limit) {
        return NO;
    } else {
        return YES;
    }
}

- (void)textViewDidChange:(UITextView *)textView {
    if (text_length_limit == -1) return;
    if (self.textView.text.length == text_length_limit) {
        self.textView.text = [self.textView.text substringWithRange:NSMakeRange(0, text_length_limit)];
    }
    [self.textCountLabel setText:[NSString stringWithFormat:@"%d/%d", self.textView.text.length, text_length_limit]];
}

#pragma UIImagePickerViewController delegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    @autoreleasepool {
        self.userImage = [info objectForKey:UIImagePickerControllerOriginalImage];
        float xratio = self.userImage.size.width / 600.0f;
        float yratio = self.userImage.size.height / 600.0f;
        if (xratio > 1.0f || yratio > 1.0f) {
            self.userImage = [ImageService imageByScalingAndCroppingForSize:self.userImage toSize:CGSizeMake(self.userImage.size.width / xratio, self.userImage.size.height / yratio)];
        }
    }
    self.photoView.image = self.userImage;
    [self.photoView setAlpha:1.0f];

    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - util method
- (void)removeInfoView {
    [AppHelper removeInfoView:self.view];
}
/*
- (void)postUserShare2Server {
    NSMutableDictionary *param = [[NSMutableDictionary alloc] initWithCapacity:0];
    if (self.session != nil) {
        [param setObject:self.session.id forKey:kSessionIDKey];
    }
    if (self.userImage != nil) {
        [param setObject:[AppHelper base64EncodeImage:self.userImage] forKey:kShareImageKey];
    }

    NSTimeInterval interval = [[NSDate date] timeIntervalSince1970];
    NSString *timestamp = [NSString stringWithFormat:@"%ld", (long) interval];

    [param setObject:[AppHelper macaddress] forKey:kDeviceIDKey];
    [param setObject:self.textView.text forKey:kShareTextKey];
    [param setObject:[appDelegate.userState objectForKey:kUserNameKey] forKey:kUserNameKey];
    [param setObject:timestamp forKey:kTimastampKey];
    SBJsonWriter *jsonWriter = [[SBJsonWriter alloc] init];
    NSString *paramString = [jsonWriter stringWithObject:param];

    //I'm here
    ASIFormDataRequest *req = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:kServiceUserShare]];
    [req setRequestMethod:@"POST"];
    [req addRequestHeader:@"Content-Type" value:@"application/json"];
    [req appendPostData:[paramString dataUsingEncoding:NSUTF8StringEncoding]];
    [req setTag:tag_req_post_user_share];
    [req setDelegate:self];
    [req startAsynchronous];
}*/
/*

- (void)postUserPath2Server:(UserPath *)userPath {
    NSMutableDictionary *param = [[NSMutableDictionary alloc] initWithCapacity:0];
    if (self.userImage != nil) {
        //we don't need to submit path's image for now
//        [param setObject:[AppHelper base64DecodeImage:self.userImage] forKey:kShareImageKey];
    }
    [param setObject:[AppHelper macaddress] forKey:kDeviceIDKey];
    [param setObject:userPath.pathContent forKey:kPathTextKey];
    [param setObject:[appDelegate.userState objectForKey:kUserNameKey] forKey:kUserNameKey];
    [param setObject:userPath.pathID forKey:kTimastampKey];
    SBJsonWriter *jsonWriter = [[SBJsonWriter alloc] init];
    NSString *paramString = [jsonWriter stringWithObject:param];

    //I'm here
    ASIFormDataRequest *req = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:kServiceUserPath]];
    [req setRequestMethod:@"POST"];
    [req addRequestHeader:@"Content-Type" value:@"application/json"];
    [req appendPostData:[paramString dataUsingEncoding:NSUTF8StringEncoding]];
    [req addPostValue:paramString forKey:nil];
    [req setTag:tag_req_post_user_share];
    [req setDelegate:self];
    [req startAsynchronous];
}
*/

- (void)requestFinished {
    self.userImage = nil;
    [self.textView setText:@""];
    [AppHelper removeInfoView:self.view];
    [AppHelper showInfoView:self.view withText:@"Share successfully" withLoading:NO];
    [NSTimer scheduledTimerWithTimeInterval:1.5f target:self selector:@selector(removeInfoView) userInfo:nil repeats:NO];

    [appDelegate showMenuView];
    [NSTimer scheduledTimerWithTimeInterval:1.5f target:self.navigationController selector:@selector(popViewControllerAnimated:) userInfo:nil repeats:NO];
}

- (void)requestFailed {
    [AppHelper removeInfoView:self.view];
    [AppHelper showInfoView:self.view withText:@"Share Failed" withLoading:NO];
    [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(removeInfoView) userInfo:nil repeats:NO];
}

- (void)viewDidUnload {
    [super viewDidUnload];
}


//- (IBAction)shareToWeibo:(id)sender {
//    [self presentViewController:[self buildSLComposeVC] animated:YES completion:nil];
//}

//- (SLComposeViewController *)buildSLComposeVC {
//    SLComposeViewController *slComposerSheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeSinaWeibo];
//
//    [slComposerSheet setInitialText:[self buildWeiboText:self.textView.text]];
//    [slComposerSheet addImage:self.userImage];
//    [slComposerSheet addURL:[NSURL URLWithString:@"http://www.weibo.com/"]];
//    
//    [slComposerSheet setCompletionHandler:^(SLComposeViewControllerResult result) {
//        switch (result) {
//            case SLComposeViewControllerResultCancelled:
//                [self requestFailed];
//                break;
//            case SLComposeViewControllerResultDone:
//                [self requestFinished];
//                break;
//            default:
//                [self requestFailed];
//                break;
//        }
//    }];
//    
//    return slComposerSheet;
//}

@end
