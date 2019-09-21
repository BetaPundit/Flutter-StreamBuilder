import 'dart:async';
import 'dart:convert';

import 'package:proj_1/widget.dart';


abstract class SimpleStorage {
  Future<String> readMessage ();
  Future<void> writeMessage (String message);

  Future<int> readCount ();
  Future<void> writeCount (int count);
}

abstract class OnlineAPI {
  Future<String> getAdviceJsonString ();
}

class CoreLogic implements FabButtonModel, FabButtonController, AdviceBarModel {

  final String _intialAdvice;
  final int _intialCount;
  final SimpleStorage _simpleStorage;
  final OnlineAPI _api;
  
  int _currentCount;

  CoreLogic._(this._intialAdvice, this._intialCount, this._simpleStorage, this._api):
    _currentCount = _intialCount;

  static Future<CoreLogic> getInstance (SimpleStorage storage, OnlineAPI api) async {
    String message = await storage.readMessage();
    int count = 0; 
    if (message == null) {
      message = "";
      count = 0;
    } else {
      count = await storage.readCount();
    }
    
    return CoreLogic._(message, count, storage, api);;
  }

  
  StreamController<int> _countStreamController = StreamController();
  StreamController<String> _messageStreamController = StreamController();
  StreamController<FabState> _fabStateStreamController = StreamController();

  @override
  Stream<int> get countStream => _countStreamController.stream;
  @override
  Stream<String> get messageStream => _messageStreamController.stream;
  @override
  Stream<FabState> get fabStateStream => _fabStateStreamController.stream;

  @override
  int get initialCount => _intialCount;

  @override
  FabState get initialFabState => FabState.ACTIVE ;

  @override
  String get initialMessage => _intialAdvice;

  

  @override
  Future fetchNewAdvice() async {
    _fabStateStreamController.sink.add(FabState.INACTIVE);

    String response = await _api.getAdviceJsonString();
		dynamic body = json.decode(response);

    var message = body["slip"]["advice"];
    _currentCount += 1;

    await _simpleStorage.writeMessage(message);
    await _simpleStorage.writeCount(_currentCount);

    _countStreamController.add(_currentCount);
    _messageStreamController.add(message);
    _fabStateStreamController.add(FabState.ACTIVE);
  }
}