import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:istnagram/state/auth/backend/authenticator.dart';
import 'package:istnagram/state/auth/provider/is_logged_in_provider.dart';
import 'package:istnagram/state/providers/is_loading_provider.dart';
import 'package:istnagram/views/components/loading/loading_screen.dart';
import 'firebase_options.dart';

/// extension for log messages. Next time We will be using a Flutter package for log messages.
import 'dart:developer' as devTools show log;
// const String name = "Romaisa";

extension Log on Object {
  void log() => devTools.log(toString());
}

// ...
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MainView());
}

class MainView extends StatelessWidget {
  const MainView({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      darkTheme: ThemeData(
          brightness: Brightness.dark,
          primarySwatch: Colors.blueGrey,
          indicatorColor: Colors.blueGrey),
      themeMode: ThemeMode.dark,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        brightness: Brightness.dark,
      ),
      home: Consumer(
        builder: (BuildContext context, WidgetRef ref, Widget? child) {
          ref.listen<bool>(isLoadingProvider, (previous, next) {
            if (next) {
              LoadingScreen.instance().show(context: context);
            } else {
              LoadingScreen.instance().hide();
            }
          });
          // return const MyHomePage();
          final isLogedIn = ref.watch<bool>(isLoggedInProvider);
          if (isLogedIn) {
            return MyHomePage();
          } else {
            return Container(
              child: Text('this is a dummy login screen'),
            );
          }
        },
      ),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Isntagram"),
      ),
      body: Column(
        children: [
          TextButton(
            onPressed: () async {
              final result = await Authenticator().loginWithGoogle();
              result.log();
            },
            child: Text('login with Google'),
          ),
          TextButton(
            onPressed: () async {
              final result = await Authenticator().loginWithFacebook();
              result.log();
            },
            child: Text('login with Facebook'),
          ),
        ],
      ),
    );
  }
}
