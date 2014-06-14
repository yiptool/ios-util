/* vim: set ai noet ts=4 sw=4 tw=115: */
//
// Copyright (c) 2014 Nikolay Zapolnov (zapolnov@gmail.com).
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.
//
#import "NSNotificationCenter+ExtraMethods.h"

@implementation NSNotificationCenter (ExtraMethods)

+(void)postNotificationName:(NSString *)name
{
	[[NSNotificationCenter defaultCenter] postNotificationName:name object:nil];
}

+(void)postNotificationName:(NSString *)name object:(id)object
{
	[[NSNotificationCenter defaultCenter] postNotificationName:name object:object];
}

+(void)addObserver:(id)observer selector:(SEL)selector name:(NSString *)name
{
	[[NSNotificationCenter defaultCenter] addObserver:observer selector:selector name:name object:nil];
}

+(void)addObserver:(id)observer selector:(SEL)selector name:(NSString *)name object:(id)object
{
	[[NSNotificationCenter defaultCenter] addObserver:observer selector:selector name:name object:object];
}

+(void)removeObserver:(id)observer
{
	[[NSNotificationCenter defaultCenter] removeObserver:observer];
}

@end
