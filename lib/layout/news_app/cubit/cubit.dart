import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app/layout/news_app/cubit/states.dart';
import 'package:news_app/layout/news_app/news_layout.dart';
import 'package:news_app/modules/business/business_screen.dart';
import 'package:news_app/modules/health/health_screen.dart';
import 'package:news_app/modules/science/science_screen.dart';
import 'package:news_app/modules/search/search_screen.dart';
import 'package:news_app/modules/settings/settings_screen.dart';
import 'package:news_app/modules/sports/sports_screen.dart';
import 'package:news_app/shared/network/shared/dio_helper.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class NewsCubit extends Cubit<NewsStates>
{
  NewsCubit(): super(NewsInitialState());
  static NewsCubit get(context)=>BlocProvider.of(context);

  RefreshController busiRefreshController = RefreshController(initialRefresh: false);
  RefreshController sporRefreshController = RefreshController(initialRefresh: false);
  RefreshController scieRefreshController = RefreshController(initialRefresh: false);
  RefreshController healRefreshController = RefreshController(initialRefresh: false);

  int currentIndex = 0 ;

  List<BottomNavigationBarItem> bottomItems = [
    BottomNavigationBarItem(
      icon: Icon(Icons.business),
      label: 'Business'
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.sports),
      label: 'Sports'
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.science),
      label: 'Science'
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.medical_services_rounded),
      label: 'Health'
    ),
  ];

  List<Widget>screens = [
    BusinessScreen(),
    SportsScreen(),
    ScienceScreen(),
    HealthScreen(),
  ];

  List<dynamic> business = [];
  List<dynamic> sports = [];
  List<dynamic> science = [];
  List<dynamic> health = [];
  List<dynamic> search = [];

  void ChangeBottomNavBar(int index)  {
      currentIndex = index;
    if(index == 1)
      getSports();
    if(index == 2)
      getScience();
    if(index == 3)
      getHealth();
    emit(NewsBottomNavBarState());
  }

  void getBusiness(){

    emit(NewsGetBusinessLoadingState());

    DioHelper.getData(url: 'v2/top-headlines', query: {
      'country':'eg',
      'category':'business',
      'apiKey':'e85ecb510dab4d71a395e240f83a6732',
    }).then((value) {
      business =value.data['articles'];
      emit(NewsGetBusinessSuccessState());
    }).catchError((error){
      print(error.toString());
      emit(NewsGetBusinessErrorState(error.toString()));
      return Completer<Never>().future;
    });
  }
  void getSports() {
    emit(NewsGetSportsLoadingState());
    if(sports.length == 0 ){
    DioHelper.getData(url: 'v2/top-headlines', query: {
      'country': 'eg',
      'category': 'sports',
      'apiKey': 'e85ecb510dab4d71a395e240f83a6732',
    }).then((value) {
      sports = value.data['articles'];
      emit(NewsGetSportsSuccessState());
    }).catchError((error) {
      print(error.toString());
      emit(NewsGetSportsErrorState(error.toString()));
      return Completer<Never>().future;
    });
  }
  }
  void getScience(){

    emit(NewsGetScienceLoadingState());
    if(science.length == 0 ){
      DioHelper.getData(url: 'v2/top-headlines', query: {
        'country':'eg',
        'category':'science',
        'apiKey':'e85ecb510dab4d71a395e240f83a6732',
      }).then((value) {
        science =value.data['articles'];
        emit(NewsGetScienceSuccessState());
      }).catchError((error){
        print(error.toString());
        emit(NewsGetScienceErrorState(error.toString()));
        return Completer<Never>().future;
      });
    }
  }
  void getHealth(){

    emit(NewsGetHealthLoadingState());
    if(health.length == 0 ){
      DioHelper.getData(url: 'v2/top-headlines', query: {
        'country':'eg',
        'category':'health',
        'apiKey':'e85ecb510dab4d71a395e240f83a6732',
      }).then((value) {
        health =value.data['articles'];
        emit(NewsGetHealthSuccessState());
      }).catchError((error){
        print(error.toString());
        emit(NewsGetHealthErrorState(error.toString()));
        return Completer<Never>().future;
      });
    }
  }
  void getSearch(String value){
    if (value != null || value != '') {
      emit(NewsGetSearchLoadingState());
      DioHelper.getData(url: 'v2/everything', query: {
        'q': '$value',
        'apiKey': 'e85ecb510dab4d71a395e240f83a6732',
      }).then((value) {
        search = value.data['articles'];
        emit(NewsGetSearchSuccessState());
      }).catchError((error) {
        print(error.toString());
        emit(NewsGetSearchErrorState(error.toString()));
        return Completer<Never>().future;
      });
    }
    else {
      search = [] ;
    }
    }
  void onRefresh() async{
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 2000));
    // if failed,use refreshFailed()
    if(currentIndex == 0 ){
      business = [];
      business.length= 0;
      BusinessScreen.business_list = [];
      getBusiness();
      emit(NewsRefreshBusinessState());
      busiRefreshController.refreshCompleted();
    }

    else if(currentIndex == 1){
      sports = [];
      sports.length= 0;
      SportsScreen.sports_list = [];
      getSports();
      emit(NewsRefreshSportsState());
      sporRefreshController.refreshCompleted();
    }
    else if(currentIndex == 2){
      science = [];
      science.length= 0;
      ScienceScreen.science_list = [];
      getScience();
      emit(NewsRefreshScienceState());
      scieRefreshController.refreshCompleted();
    }
    else if(currentIndex == 3){
      health = [];
      health.length= 0;
      HealthScreen.health_list = [];
      getHealth();
      emit(NewsRefreshHealthState());
      healRefreshController.refreshCompleted();
    }

  }

  void onLoading() async{
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 2000));
    // if failed,use loadFailed(),if no data return,use LoadNodata()

    if(currentIndex == 0 ){
      busiRefreshController.loadComplete();
    }
    else if(currentIndex == 1){

      sporRefreshController.loadComplete();
    }
    else if (currentIndex == 2) {
      scieRefreshController.loadComplete();
    }
    else if (currentIndex == 3) {
      healRefreshController.loadComplete();
    }
  }
  }
