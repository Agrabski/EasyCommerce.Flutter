import 'package:easy_commerce/data/reducers/action.dart';
import 'package:easy_commerce/data/state.dart';
import 'package:redux/redux.dart';
import 'package:redux_persist/redux_persist.dart';
import 'package:redux_persist_flutter/redux_persist_flutter.dart';

EasyCommerceState reducer(EasyCommerceState state, dynamic action) {
  if (action is ReducerAction) {
    return action.apply(state);
  }
  throw ArgumentError();
}

Future<Store<EasyCommerceState>> loadStore() async {
  final persistor = Persistor<EasyCommerceState>(
    storage: FlutterStorage(),
    serializer: JsonSerializer(EasyCommerceState.fromJson),
  );

  final store = Store<EasyCommerceState>(
    reducer,
    initialState: await persistor.load() ?? EasyCommerceState.empty(),
    distinct: true,
    middleware: [persistor.createMiddleware()],
  );
  return store;
}
