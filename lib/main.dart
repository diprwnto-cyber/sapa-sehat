import 'package:material_ui/material_ui.dart';
import 'core/constants/app_colors.dart';
import 'core/services/supabase_service.dart';
import 'features/auth/screens/splash_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SupabaseService.initialize();
  runApp(const SapaSehatApp());
}

class SapaSehatApp extends StatelessWidget {
  const SapaSehatApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SapaSehat',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primary,
          primary: AppColors.primary,
          surface: Colors.white,
        ),
        scaffoldBackgroundColor: Colors.white,
        fontFamily: null,
      ),
      home: const SplashScreen(),
    );
  }
}
