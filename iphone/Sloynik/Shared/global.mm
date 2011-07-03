//
//  global.mm
//  sloynik
//
//  Created by Yury Melnichek on 20.01.11.
//  Copyright 2011 -. All rights reserved.
//

#include "global.hpp"
#include "../../words/sloynik_engine.hpp"
#include "../../base/assert.hpp"
#include "../../base/logging.hpp"
#import <UIKit/UIKit.h>

sl::StrFn::Str const * StrCreateApple(char const * utf8Str, uint32_t size)
{
  return reinterpret_cast<sl::StrFn::Str const *>(
      CFStringCreateWithBytes(kCFAllocatorDefault,
                              reinterpret_cast<UInt8 const *>(utf8Str),
                              size,
                              kCFStringEncodingUTF8,
                              false));
}

void StrDestroyApple(sl::StrFn::Str const * s)
{
  if (s)
    CFRelease(reinterpret_cast<CFStringRef>(s));
}

int StrPrimaryCompareApple(void *, sl::StrFn::Str const * a, sl::StrFn::Str const * b)
{
  CFStringRef sa = reinterpret_cast<CFStringRef>(a);
  CFStringRef sb = reinterpret_cast<CFStringRef>(b);
  return CFStringCompareWithOptionsAndLocale(sa, sb, CFRangeMake(0, CFStringGetLength(sa)),
                                             kCFCompareCaseInsensitive |
                                             kCFCompareNonliteral |
                                             kCFCompareWidthInsensitive |
                                             kCFCompareLocalized, NULL);
}

int StrSecondaryCompareApple(void *, sl::StrFn::Str const * a, sl::StrFn::Str const * b)
{
  CFStringRef sa = reinterpret_cast<CFStringRef>(a);
  CFStringRef sb = reinterpret_cast<CFStringRef>(b);
  return CFStringCompareWithOptionsAndLocale(sa, sb, CFRangeMake(0, CFStringGetLength(sa)),
                                             kCFCompareWidthInsensitive |
                                             kCFCompareLocalized, NULL);
}

sl::SloynikEngine * g_pEngine = NULL;

sl::SloynikEngine * GetSloynikEngine()
{
  return g_pEngine;
}

void SetSloynikEngine(sl::SloynikEngine * pEngine)
{
  g_pEngine = pEngine;
}

sl::SloynikEngine * CreateSloynikEngine()
{
  ASSERT(!g_pEngine, ());
  LOG(LINFO, ("Creating sloynik engine."));
  sl::StrFn strFn;
  strFn.Create = StrCreateApple;
  strFn.Destroy = StrDestroyApple;
  strFn.PrimaryCompare = StrPrimaryCompareApple;
  strFn.SecondaryCompare = StrSecondaryCompareApple;
  strFn.m_pData = NULL;
  NSString * nsVersion = [NSString stringWithFormat:@"%@ %@ %@",
                          [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"],
                          [[UIDevice currentDevice] systemVersion],
                          [[NSLocale systemLocale] localeIdentifier]];
  LOG(LINFO, ("Version:", [nsVersion UTF8String]));
  strFn.m_PrimaryCompareId   = [[NSString stringWithFormat:@"%@ 1", nsVersion] hash];
  strFn.m_SecondaryCompareId = [[NSString stringWithFormat:@"%@ 2", nsVersion] hash];
  sl::SloynikEngine * pEngine = new sl::SloynikEngine("dictionary.slf", "index", strFn);
  LOG(LINFO, ("Sloynik engine created."));
  return pEngine;
}
