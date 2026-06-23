import 'package:flutter/material.dart';

import 'src/app/jewellery_erp_app.dart';
import 'src/core/di/injection.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await configureDependencies();
  runApp(const JewelleryErpApp());
}
