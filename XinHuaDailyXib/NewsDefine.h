//
//  NewsDefine.
//  XinHuaNewsIOS
//
//  Created by 耀龙 马 on 12-4-18.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//
#define iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)
#define iOS7 [[[UIDevice currentDevice] systemVersion] floatValue]>=7.0
#ifdef LNZW
#define sxttype @"lnzw"
#endif
#ifdef HNZW
#define sxttype @"hnzw"
#endif
#define sxtversion [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]
#define InHouseDistribution 1
#define  KGetNewsUpdate @"http://mis.xinhuanet.com//sxtv2/Mobile/Interface/sjb_ColList.asp?mNum=%@&imei=%@"
#define KGetOlderNews @"http://mis.xinhuanet.com/sxtv2/Mobile/Interface/sjb_ColHistory_New.asp?pid=%@&imei=%@"
//#define KVersionInfo @"http://mis.xinhuanet.com/SXTV2/Mobile/interface/sjb_login.ashx?sn=%@"
#define KVersionInfo @"http://mis.xinhuanet.com/SXTV2/Mobile/interface/sjb_config.ashx?sn=%@"
#define KXinhuaUrl @"http://mis.xinhuanet.com//sxtv2/Mobile"
#ifdef LNZW
#define KupdateURL @"https://raw.githubusercontent.com/zhangjianxhs/sxt/master/lnzw_inhouse.plist"
#endif
#ifdef HNZW
#define KupdateURL @"https://raw.githubusercontent.com/zhangjianxhs/sxt/master/hnzw_inhouse.plist"
#endif
#define KRegUrl @"http://mis.xinhuanet.com/SXTV2/Mobile/Interface/sjb_bindphone.ashx?imei=%@"
#ifdef LNZW
#define KBindleSNUrl @"http://mis.xinhuanet.com/SXTV2/Mobile/interface/sjb_bindsn.ashx?imei=%@&sn=%@&osversion=iphone_%@_%@_%@&appid=XHSJB"
#endif
#ifdef HNZW
#define KBindleSNUrl @"http://mis.xinhuanet.com/SXTV2/Mobile/interface/sjb_bindsn.ashx?imei=%@&sn=%@&osversion=iphone_%@_%@_%@&appid=HNYQT"
#endif
#define KBindlePhoneUrl @"http://mis.xinhuanet.com/sxtv2/Mobile/Interface/sjb_bindphone.ashx?imei=%@&model=%@&osversion=iphone_%@_%@_%@"
#define KSubscribeCommitURL @"http://mis.xinhuanet.com/SXTV2/Mobile/interface/sjb_setuserperiodical.ashx?imei=%@&pids=%@&osversion=iphone_%@_%@_%@"

#ifdef LNZW
#define KUploadTokenUrl @"http://mis.xinhuanet.com/sxtv2/mobile/Interface/nsjb_Token_ios.asp?imei=%@&token=%@&appname=XHSJB"
#endif

#ifdef HNZW
#define KUploadTokenUrl @"http://mis.xinhuanet.com/sxtv2/mobile/Interface/nsjb_Token_ios.asp?imei=%@&token=%@&appname=HNYQT"
#endif
#define KReportZipDownloadUrl @"http://mis.xinhuanet.com/sxtv2/Mobile/Interface/sjb_zipgeted.ashx?imei=%@&pid=%@&gid=%@&osversion=iphone_%@_%@_%@"
#ifdef LNZW
#define KClearBadgeURL @"http://mis.xinhuanet.com/sxtv2/mobile/Interface/nsjb_ClearBadge_ios.asp?imei=%@&appname=XHSJB"
#endif
#ifdef HNZW
#define KClearBadgeURL @"http://mis.xinhuanet.com/sxtv2/mobile/Interface/nsjb_ClearBadge_ios.asp?imei=%@&appname=HNYQT"
#endif
#define KResponseURL @"http://mis.xinhuanet.com/sxtv2/Mobile/Interface/sjb_feedback.ashx"
#define KArticleFeedURL @"http://mis.xinhuanet.com/sxtv2/Mobile/interface/sjb_literfeedback.ashx"
#define KDeleteAndUpdateNews @"http://mis.xinhuanet.com/sxtv2/mobile/interface/sjb_statedperiodicalitem.ashx?imei=%@&n=60"
#define KTagTitle  @"title"
#define KTagPageUrl @"pageurl"
#define KTagZipUrl @"zipurl"
#define KTagDate @"date"

#define KSn @"F_SN"
#define KDescription @"F_Description"
#define KName @"F_Name"
#define KSex @"F_Sex"
#define KCom @"F_Com"
#define KPhone @"F_Phone"
#define KEmail @"F_Email"
#define KEnabled @"F_Enabled"
#define KEndDate @"F_EndDate"
#define KGpID @"F_GpID"
#define KUpdateTime @"F_UpdateTime"


#define KUserDefaultAuthCode  @"AuthCode"
#define KUserToken @"userToken"

#define KRegNewUserUrl @"http://mis.xinhuanet.com/SXTV2/Mobile/interface/sjb_completeUserInfo.ashx?imei=%@&phone=%@&name=%@&com=%@&osversion=%@&type=apply"
#define KLabelUrl @"http://mis.xinhuanet.com/SXTV2/Mobile/interface/sjb_periodicallist.ashx?imei=%@"
#define KXdailyUrl @"http://mis.xinhuanet.com/SXTV2/Mobile/interface/sjb_newperiodicals.ashx?imei=%@&n=%@&pid=%@"

#define KReceivedPush  @"ReceivedPushNotification"
#define KEnterForeground  @"EnterForeground"
#define KUpdateWithMemory @"updateWithMemory"
#define KKUpdateXdailyWithMemory @"KUpdateXdailyWithMemory"
#define KShowToast @"showToast"
#define KUpdateInbox @"updateInbox"
#define KUpdatePicture @"update_picture"
#define KUpdateFavorList @"updatefavorlist"
#define KSettingChange @"fontchange"
#define KAllTaskFinished @"alltaskfinished"
#define KBindlePhoneOK @"bindle phone Ok"
#define KShowAdvPage @"show adv page"
#define KBindlePhoneFailed @"bindle phone Failed"
#define KBindleSnOK @"bindleSnOk"
#define KExpressNewsOK @"express news ok"
#define KExpressNewsError @"express news error"
#define KPictureOK @"picture ok"
#define KPictureError @"picture error"
#define KXdailyUrlOnlyOne @"http://mis.xinhuanet.com/SXTV2/Mobile/interface/sjb_periodicalitem.ashx?gid=%@&imei=%@"
#define KMoreXdailys @"http://mis.xinhuanet.com/SXTV2/Mobile/interface/sjb_getperiodicalitems.ashx?gid=%@&pid=%@&n=%@&imei=%@"
#define KWelcomePictureURL @"http://mis.xinhuanet.com/SXTV2/Mobile/interface/sjb_groupimage.ashx?sn=%@"
#define KGap  10
#define KUserActionURL @"http://mis.xinhuanet.com/sxtv2/mobile/interface/sjb_literread.ashx"
#define KUserInfo @"http://mis.xinhuanet.com/SXTV2/Mobile/interface/sjb_sn_info.ashx?sn=%@"
#define KUserInfoReady @"userinfo ready"
#define KUserInfoFailed @"userinfo failed"
#define KUserRegOK @"user register ok"
#define KUserRegError @"user register error"
#define KRegWrong @"dddd"
#define KDisplayMode @"displayMode"
