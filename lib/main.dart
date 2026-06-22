import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:smart_hospital/screens/splash_screen.dart';
import 'package:smart_hospital/features/doctor_role/home_doctor/ui/main_layout.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://qzddnwbblnsfpmyomrso.supabase.co',
    publishableKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InF6ZGRud2JibG5zZnBteW9tcnNvIiwicm9sZSI6ImFub24iLCJpYXQiOjE3ODEzNDI3NzIsImV4cCI6MjA5NjkxODc3Mn0.vnjbMYInnyuLhJNDzB1m7jzlnqx5OHpcb2_KRCQyrPI',
  );

  runApp(const SmartHayatHospitalApp());
}

final supabase = Supabase.instance.client;

class SmartHayatHospitalApp extends StatelessWidget {
  const SmartHayatHospitalApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Smart Hayat Hospital',
          theme: ThemeData(
            primaryColor: const Color(0xFF1B3A4B),
            colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF1B3A4B)),
            useMaterial3: true,
            fontFamily: 'Roboto',
          ),
          home: const SplashScreen(),
          routes: {
            '/main_layout': (context) => const MainLayout(),
          },
        );
      },
    );
  }
}