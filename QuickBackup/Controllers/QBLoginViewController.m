//
//  QBLoginViewController.m
//  QuickBackup
//
//  Created by Nagarro on 5/21/16.
//  Copyright © 2016 Nagarro. All rights reserved.
//

#import "QBLoginViewController.h"
#import "QBAdminHomeViewController.h"
#import "QBUserHomeViewController.h"
#import "QBAppUser.h"

#define CONNECTION_TAG_LOGIN 1001
#define CONNECTION_TAG_FETCH_CONTACT 1002

@interface QBLoginViewController ()<UITextFieldDelegate> {
    IBOutlet UITextField *_usernameTxt;
    IBOutlet UITextField *_passwordTxt;
    IBOutlet UIButton *_loginButton;
    NSString *_userName;
    NSString *_password;
    IBOutlet UIScrollView *_scrollView;
    NSMutableData *_responseData;
}

@end

@implementation QBLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _loginButton.enabled = NO;
    _scrollView.keyboardDismissMode = UIScrollViewKeyboardDismissModeInteractive;
    
}

- (void)updateLoginButtonState {
    _loginButton.enabled = _userName.length > 0 && _password.length > 0;
}

#pragma mark - IBAction
- (IBAction)loginButtonAction:(id)sender {
    if ([_usernameTxt isFirstResponder]) {
        [_usernameTxt resignFirstResponder];
    } else if ([_passwordTxt isFirstResponder]) {
        [_passwordTxt resignFirstResponder];
    }
    [self performLogin];
}

- (IBAction)signUpAction:(id)sender {
    [self performSegueWithIdentifier:@"qbSignUpSegue" sender:nil];
}

#pragma mark - UITextFieldDelegate methods
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == _usernameTxt) {
        [_passwordTxt becomeFirstResponder];
    } else {
        //Perform login
        [textField resignFirstResponder];
        [self performLogin];
    }
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSString *appendedString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    if (textField == _usernameTxt) {
        _userName = [appendedString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    } else {
        _password = appendedString;
    }
    
    [self updateLoginButtonState];
    
    return YES;
}

#pragma mark - Service integration methods
- (void)performLogin {
    self.showActivityIndicator = YES;

    NSDictionary *dict = @{@"userId" : _userName, @"password": _password};
    QBConnection *connection = [[QBConnection alloc] init];
    connection.connectionTag = CONNECTION_TAG_LOGIN;
    connection.delegate = self;
    connection.procedureName = @"login";
    connection.parameters = @{@"user" : dict};
    [connection connect];
    
}

- (void)connection:(NSInteger)connectionTag successfulWithResponse:(NSDictionary *)response {
    self.showActivityIndicator = NO;
    if (connectionTag == CONNECTION_TAG_LOGIN) {
        QBAppUser *user = [[QBAppUser alloc] initWithDictionary:response[@"response"][@"user"]];
        
        [[QBAppContext sharedInstance] userDidLogin:user];
        
        if (user.userType == Admin) {
            //Admin
            self.showActivityIndicator = YES;
            QBConnection *connection = [[QBConnection alloc] init];
            connection.connectionTag = CONNECTION_TAG_FETCH_CONTACT;
            connection.delegate = self;
            connection.procedureName = @"fetchRelatedContacts";
            connection.parameters = @{@"token" : [QBAppContext sharedInstance].currentUser.token};
            [connection connect];
            
        } else {
            [self performSegueWithIdentifier:@"qbUserHomeSegue" sender:nil];

        }
    } else if (connectionTag == CONNECTION_TAG_FETCH_CONTACT) {
        NSMutableArray *contacts = [NSMutableArray array];
        for (NSDictionary *dict in response[@"users"]) {
            
            QBAppUser *contact = [[QBAppUser alloc] initWithDictionary:dict];
            [contacts addObject:contact];
        }
        [self performSegueWithIdentifier:@"qbAdminHomeSegue" sender:contacts];

    }
    
    
}

- (void)connection:(NSInteger)connectionTag failedWithResponse:(NSString *)error {
    self.showActivityIndicator = NO;
    [self showOKAlertWithMessage:error];
    
}

#pragma mark - Navigation methods
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"qbAdminHomeSegue"]) {
        
        UINavigationController *navController = segue.destinationViewController;
        QBAdminHomeViewController *controller = (QBAdminHomeViewController*) navController.topViewController;
        controller.usersArray = sender;
        
    } else if ([segue.identifier isEqualToString:@"qbUserHomeSegue"]) {
        UINavigationController *navController = segue.destinationViewController;
        QBUserHomeViewController *controller = (QBUserHomeViewController*) navController.topViewController;

    }
}

@end
