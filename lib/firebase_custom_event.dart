import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:partypeopleindividual/constants.dart';

Future<void> logCustomEvent({required String eventName , required Map<String , dynamic> parameters }) async {


   log('$eventName Triggred.... - params -- $parameters');
   await analytics.logEvent(name: eventName ,parameters: parameters );

}

/*
Future<void> logFacebookCustomEvent({required String eventName , required Map<String , dynamic> parameters }) async {
   final  FacebookAppEvents facebookAppEvents =FacebookAppEvents();

   log('$eventName Triggred.... - params -- $parameters');
   await facebookAppEvents.logEvent(name: eventName ,parameters: parameters );

}
*/
const String logInEvent = 'log_in_event';
const String chatInitiateEvent = 'chat_event';
const String splash = 'splash';
const String partyPreview = 'PartyPreview';
const String bookNow = 'BookNow';
const String personLike = 'PeopleLike';
const String partyLike = 'PartyLike';
const String peopleProfileView = 'PeopleProfileView';