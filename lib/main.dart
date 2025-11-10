  import 'package:flutter/material.dart';
  import 'package:flutter/services.dart';

  import 'package:get_storage/get_storage.dart';
  import 'package:supabase_flutter/supabase_flutter.dart';


  import 'app/data/services/dependency_injection.dart';
  import 'app/my_app.dart';
  import 'app/ui/utils/logget.dart';

  Future<void> main() async {
    WidgetsFlutterBinding.ensureInitialized();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    await GetStorage.init();
    await Supabase.initialize(
    url: 'https://laskvifpjenhadgevrjx.supabase.co', 
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imxhc2t2aWZwamVuaGFkZ2V2cmp4Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjE1NTMyNzgsImV4cCI6MjA3NzEyOTI3OH0.n8PbZfZL8VU6Bbec_j_jq8kwYutouq_FswASDR7ST7U', 
  );
    DependencyInjection.init();
    Log.init();

    runApp(const MyApp());
  }
  final supabase = Supabase.instance.client;