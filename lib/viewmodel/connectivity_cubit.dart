import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:meta/meta.dart';

part 'connectivity_state.dart';

class ConnectivityCubit extends Cubit<ConnectivityState> {
  final Connectivity _connectivity = Connectivity();
  late  StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;
  ConnectivityCubit() : super(ConnectivityState(true));

  Future<void>init()async{
    final result=await _connectivity.checkConnectivity();
    final isConnection=hasConnetcion(result);
    emit(ConnectivityState(isConnection));
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen((r){
      emit(ConnectivityState(hasConnetcion(result)));
    });
  }
  hasConnetcion(List<ConnectivityResult>res){
    return res.any((r)=>r!=ConnectivityResult.none);
  }
}
