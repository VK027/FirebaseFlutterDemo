import 'package:ffd/firebase_service.dart';
import 'package:ffd/providers/app_theme.dart';
import 'package:ffd/routes.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

class MyApp extends StatefulWidget{
  final RemoteMessage? remoteMessage;
  const MyApp({Key? key, required this.remoteMessage}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return MyAppState();
  }
  
}
class MyAppState extends State<MyApp>{
  FirebaseService firebaseService = FirebaseService();

  final settings = ValueNotifier(ThemeSettings(
    sourceColor: Colors.pink,
    themeMode: ThemeMode.system,
  ));

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      // 6. used to inflate once app is terminated completely.
      print('widget.remoteMessage>> ${widget.remoteMessage}');
      if (widget.remoteMessage != null) {
        var message = await widget.remoteMessage;
        print('message>> $message');
        Future.delayed(const Duration(milliseconds: 1000), () async {
          //await Navigator.of(context).pushNamed(...);
        });
      }
    });
    fetchFirebaseToken();
  }

  void saveToken(String? token) {
    print('FCM Token: $token');
    // setState(() {
    //   _token = token;
    // });
  }

  Future fetchFirebaseToken() async {
    // 6. used to inflate once app is terminated completely.
    // await FirebaseService.onGetInitialMsg();
    String? token ;
    if (kIsWeb) {
      token = await firebaseService.getWebToken();
    }else{
      token = await firebaseService.getDeviceToken();
    }
    print('FirebaseService>>token>> $token');
    saveToken(token);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      // Providing a restorationScopeId allows the Navigator built by the
      // MaterialApp to restore the navigation stack when a user leaves and
      // returns to the app after it has been killed while running in the
      // background.
      restorationScopeId: 'app',

      // Provide the generated AppLocalizations to the MaterialApp. This
      // allows descendant Widgets to display the correct translations
      // depending on the user's locale.
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en', ''), // English, no country code
      ],
     // title:  appTitle,
      onGenerateTitle: (BuildContext context) => AppLocalizations.of(context)!.appTitle,

      // Define a light and dark color theme. Then, read the user's
      // preferred ThemeMode (light, dark, or system default) from the
      // SettingsController to display the correct theme.
      // theme: theme.light(settings.value.sourceColor),
      // darkTheme: theme.dark(settings.value.sourceColor),
      // themeMode: theme.themeMode(),
      routes: Routes.routes,
      initialRoute: splash,
     // home: splash,
      // Define a function to handle named routes in order to support
      // Flutter web url navigation and deep linking.
      // onGenerateRoute: (RouteSettings routeSettings) {
      //   return MaterialPageRoute<void>(
      //     settings: routeSettings,
      //     builder: (BuildContext context) {
      //       switch (routeSettings.name) {
      //         case SettingsView.routeName:
      //           return SettingsView(
      //               controller: widget.settingsController);
      //         case SampleItemDetailsView.routeName:
      //           return const SampleItemDetailsView();
      //         case SampleItemListView.routeName:
      //         default:
      //           return const SampleItemListView();
      //       }
      //     },
      //   );
      // },
    );
    // return AnimatedBuilder(
    //   animation: settings,
    //   builder: (BuildContext context, Widget? child) {

        // return ValueListenableBuilder<ThemeSettings>(
        //     valueListenable: settings,
        //     builder: (context, value, _) {
        //       final theme = ThemeProvider.of(context);
        //
        //     });
    //   },
    // );
  }
  
}