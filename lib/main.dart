import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:spacecraft/provider/auth_provider.dart';
import 'package:spacecraft/provider/kitchen_provider.dart';
import 'package:spacecraft/provider/search_provider.dart';
import 'package:spacecraft/provider/settings_provider.dart';
import 'package:spacecraft/provider/user_provider.dart';

import 'firebase_options.dart';
import 'provider/room_provider.dart';
import 'provider/theme_provider.dart';
import 'screens/auth/splash_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider(UserProvider())),
        ChangeNotifierProvider(create: (_) => RoomProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => SettingsProvider()),
        ChangeNotifierProvider(create: (_) => KitchenProvider()),
        ChangeNotifierProxyProvider2<RoomProvider, KitchenProvider,
            CombinedSearchProvider>(
          create: (context) => CombinedSearchProvider(
            Provider.of<RoomProvider>(context, listen: false),
            Provider.of<KitchenProvider>(context, listen: false),
          ),
          update: (context, roomProvider, kitchenProvider, previous) =>
              CombinedSearchProvider(roomProvider, kitchenProvider),
        ),
      ],
      child: const RoomDesignApp(),
    ),
  );
}

class RoomDesignApp extends StatelessWidget {
  const RoomDesignApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Room Design',
      theme: ThemeData(
        primaryColor: const Color.fromARGB(255, 17, 24, 31),
        scaffoldBackgroundColor: const Color.fromARGB(255, 64, 87, 82),
        appBarTheme: AppBarTheme(
          titleTextStyle: GoogleFonts.montserrat(
            color: Color.fromARGB(255, 17, 24, 31),
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
          color: Color.fromARGB(255, 64, 87, 82),
          elevation: 0,
          scrolledUnderElevation: 0,
        ),
        textSelectionTheme: const TextSelectionThemeData(
          cursorColor: Color.fromARGB(255, 17, 24, 31),
          selectionColor: Color.fromARGB(255, 17, 24, 31),
          selectionHandleColor: Color.fromARGB(255, 17, 24, 31),
        ),
      ),
      home: const SplashScreen(),
    );
  }
}
