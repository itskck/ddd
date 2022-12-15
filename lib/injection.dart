import 'package:firebase_flutter_ddd/injection.config.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

final getIt = GetIt.instance;

@InjectableInit()
void configureInjection(String prod) => $initGetIt(getIt);
