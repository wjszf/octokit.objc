//
//  OCTIssue.m
//  OctoKit
//
//  Created by Justin Spahr-Summers on 2012-10-02.
//  Copyright (c) 2012 GitHub. All rights reserved.
//

#import "OCTIssue.h"
#import "OCTPullRequest.h"
#import "OCTUser.h"

@interface OCTIssue ()

// The webpage URL for any attached pull request.
@property (nonatomic, copy, readonly) NSURL *pullRequestHTMLURL;

@end

@implementation OCTIssue

#pragma mark Properties

- (OCTPullRequest *)pullRequest {
	if (self.pullRequestHTMLURL == nil) return nil;

	// We don't have a "real" pull request model within the issue data, but we
	// have enough information to construct one.
	return [OCTPullRequest modelWithDictionary:@{
		@keypath(OCTPullRequest.new, objectID): self.objectID,
		@keypath(OCTPullRequest.new, HTMLURL): self.pullRequestHTMLURL,
		@keypath(OCTPullRequest.new, title): self.title,
		@keypath(OCTPullRequest.new, body): self.body,
		@keypath(OCTPullRequest.new, commentsURL): self.commentsURL,
		@keypath(OCTPullRequest.new, user): self.user,
	} error:NULL];
}

#pragma mark MTLJSONSerializing

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
	return [super.JSONKeyPathsByPropertyKey mtl_dictionaryByAddingEntriesFromDictionary:@{
		@"HTMLURL": @"html_url",
		@"objectID": @"number",
		@"pullRequestHTMLURL": @"pull_request.html_url",
		@"body": @"body",
		@"commentsURL": @"comments_url",
		@"user": @"user",
	}];
}

+ (NSValueTransformer *)HTMLURLJSONTransformer {
	return [NSValueTransformer valueTransformerForName:MTLURLValueTransformerName];
}

+ (NSValueTransformer *)pullRequestHTMLURLJSONTransformer {
	return [NSValueTransformer valueTransformerForName:MTLURLValueTransformerName];
}

+ (NSValueTransformer *)commentsURLJSONTransformer {
	return [NSValueTransformer valueTransformerForName:MTLURLValueTransformerName];
}

+ (NSValueTransformer *)userJSONTransformer {
	return [MTLValueTransformer mtl_JSONDictionaryTransformerWithModelClass:OCTUser.class];
}

@end
