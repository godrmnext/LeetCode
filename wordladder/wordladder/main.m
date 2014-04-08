//
//  main.m
//  wordladder
//
//  Created by Jung Kim on 4/8/14.
//  Copyright (c) 2014 nhnnext. All rights reserved.
//

#import <Foundation/Foundation.h>

void NXInternalFinder(NSMutableArray* resultArray, NSMutableArray* lastResult, NSString *start, NSString*end, NSSet* dictionary)
{
    char* newString;
    newString = calloc(start.length+1, 1);
    NSMutableString *currentString = [start copy];
    NSMutableSet *lastWords = [[NSMutableSet alloc] initWithCapacity:dictionary.count];
    [lastResult addObject:start];
    for (NSString* lastWord in lastResult) {
        [lastWords addObject:lastWord];
    }
    for (int nIndex=0; nIndex<start.length; nIndex++)
    {
        @autoreleasepool {
            for (int nChar = 'a'; nChar<='z'; nChar++)
            {
                [currentString getCString:newString maxLength:sizeof(newString) encoding:NSUTF8StringEncoding];
                newString[nIndex] = nChar;
                NSString *newWord = [NSString stringWithCString:newString encoding:NSUTF8StringEncoding];
                if ([newWord isEqualToString:currentString]) continue;
                else if ([end isEqualToString:newWord])
                {
                    [lastResult addObject:newWord];
                    if (![resultArray containsObject:lastResult])
                        [resultArray addObject:lastResult];
                    free(newString);
                    return;
                }
                else if ([dictionary containsObject:newWord] && ![lastWords containsObject:newWord])
                {
                    NXInternalFinder(resultArray, [lastResult mutableCopy], [newWord copy], end, dictionary);
                }
            }
        }
    }
    
    free(newString);
}

NSArray* NXFindLadders(NSString *start, NSString *end, NSSet *dictionary)
{
    NSMutableArray *resultArray = [[NSMutableArray alloc] initWithCapacity:dictionary.count];
    NSMutableArray *workArray = [[NSMutableArray alloc] initWithCapacity:dictionary.count];
    NXInternalFinder(resultArray, workArray, start, end, dictionary);
    return resultArray;
}

int main(int argc, const char * argv[])
{

    @autoreleasepool {
        
        NSSet *dictionary = [[NSSet alloc] initWithArray:@[@"hot",@"dot",@"dog",@"lot",@"log"]];
        NSString *startWord = @"hit";
        NSString *endWord = @"cog";
        
        NSArray* resultArray = NXFindLadders(startWord, endWord, dictionary);
        NSLog(@"%@", resultArray);
    }
    return 0;
}

