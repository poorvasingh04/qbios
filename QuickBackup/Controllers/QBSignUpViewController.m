//
//  QBSignUpViewController.m
//  QuickBackup
//
//  Created by Nagarro on 6/1/16.
//  Copyright © 2016 Nagarro. All rights reserved.
//

#import "QBSignUpViewController.h"
#import "QBSignUpTableViewCell.h"

typedef enum {
    EmailId = 0,
    PassWord,
    FirstName,
    LastName,
    PhoneNumber
    
} UserDetails;

@interface QBSignUpViewController ()<UITableViewDataSource, UITableViewDelegate, QBSignUpTableViewCellDelegate> {
    NSArray *_userDetailsArray;
    QBAppUser *_user;
    IBOutlet UIBarButtonItem *_cancelButton;
    IBOutlet UIBarButtonItem *_saveButton;

}

@end

@implementation QBSignUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _userDetailsArray = @[@"Email Id", @"Password", @"First Name", @"Last Name", @"Phone Number"];
    _user = [[QBAppUser alloc] init];
    _user.userType = QBUser;
    _saveButton.enabled = NO;
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([QBSignUpTableViewCell class]) bundle:nil] forCellReuseIdentifier:[QBSignUpTableViewCell reuseIdentifier]];
    self.title = @"Sign Up";
}


#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _userDetailsArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    QBSignUpTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[QBSignUpTableViewCell reuseIdentifier]];
    cell.label.text = _userDetailsArray[indexPath.row];
    cell.textfield.tag = indexPath.row;
    cell.textfield.secureTextEntry = (indexPath.row == 1) ? YES : NO;
    cell.delegate = self;
    return cell;
}

#pragma mark - UITableViewDelegate methods
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 40.0;
}

- (void)cellDidEdited:(QBSignUpTableViewCell*)cell string:(NSString*)string {
    NSInteger tag = cell.textfield.tag;
    NSString *text = [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    switch (tag) {
        case PassWord:
            _user.password = text;

            break;
        case FirstName:
            _user.firstName = text;
            break;
        case LastName:
            _user.lastName = text;
            break;
        case EmailId:
            _user.emailId = text;
            break;
        case PhoneNumber:
            _user.phoneNumber = text;
            break;
        default:
            break;
    }
    
    [self updateSaveButtonState];
}

- (void)updateSaveButtonState {
    _saveButton.enabled =  _user.firstName.length > 0 && _user.lastName.length > 0 && _user.emailId.length > 0 && _user.phoneNumber.length > 0 && _user.password.length > 0;
}

#pragma mark - IBAction
- (IBAction)saveButtonAction:(id)sender {
    [self.tableView endEditing:YES];
    self.showActivityIndicator = YES;

    QBConnection *connection = [[QBConnection alloc] init];
    connection.delegate = self;
    connection.procedureName = @"signUp";
    connection.parameters = _user.dictionary;
    [connection connect];

}

- (void)connection:(NSInteger)connectionTag successfulWithResponse:(NSDictionary *)response {
    self.showActivityIndicator = NO;
    [self showOKAlertWithMessage:@"User created successfully. Please log-in."];
}

- (void)connection:(NSInteger)connectionTag failedWithResponse:(NSString *)error {
    self.showActivityIndicator = NO;
    [self showOKAlertWithMessage:error];

}

- (IBAction)cancelButtonAction:(id)sender {
    [self.tableView endEditing:YES];

    [self.presentingViewController dismissViewControllerAnimated:YES completion:NULL];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
