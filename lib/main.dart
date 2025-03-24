import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:logo_brief/Core/Constants/strings.dart';
import 'package:logo_brief/Core/ViewModel/application_form_provider.dart';
import 'package:provider/provider.dart';
import 'Core/ViewModel/SocialMediaFormProvider.dart';
import 'Core/ViewModel/LogoSelectionProvider.dart';
import 'View/Pages/Application.dart';
import 'View/Pages/logoBrief.dart';
import 'View/Pages/social-media.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FlutterLocalization.instance.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  static const TextStyle _textStyle = TextStyle(
    color: Colors.white,
    fontFamily: 'Cairo',
    fontSize: 20,
    fontWeight: FontWeight.bold,
    overflow: TextOverflow.ellipsis,
  );

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => LogoSelectionProvider()),
        ChangeNotifierProvider(create: (context) => SocialMediaFormProvider()),
        ChangeNotifierProvider(create: (context) => ApplicationFormProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Brief Pdf',

        // ✅ Fix: Proper locale definition
        locale: const Locale('ar'),
        supportedLocales: const [
          Locale('ar', ''),
          Locale('en', ''),
        ],
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],

        localeResolutionCallback: (locale, supportedLocales) {
          if (supportedLocales.contains(locale)) {
            return locale;
          }
          return const Locale('en');
        },

        // ✅ Fix: Define routes correctly
        initialRoute: '/',
        routes: {
          '/': (context) => const HomePage(),
          '/logoBrief': (context) =>   LogoSelectionPage(),
          '/socialMedia': (context) => const SocialMediaForm(),
          '/application': (context) => const ApplicationForm(),
        },
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double buttonWidth = width > 750 ? width * 0.3 : width * 0.8;
    double spacing = width > 750 ? 40 : 20;
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Stack(
        children: [

          Positioned.fill(
            child: Image.network(
              'https://brief.pockethost.io/api/files/m645vzz2enc190w/wqyy33oipgobiww/background_lByOuzs2H6.png?token=',
              fit: BoxFit.cover,
            ),
          ),
          Center(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: width * 0.1),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildTitle(width),
                  const SizedBox(height: 30),
                  Wrap(
                    spacing: spacing,
                    runSpacing: spacing,
                    alignment: WrapAlignment.center,
                    children: [
                      _buildServiceButton(context, 'تصميم لوجو', '/logoBrief', buttonWidth),
                      _buildServiceButton(context, 'تصميمات سوشيال ميديا', '/socialMedia', buttonWidth),
                      _buildServiceButton(context, 'تصميم مواقع وبرامج', '/application', buttonWidth),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTitle(double height) {
    return SizedBox(
      width: double.infinity,
      height: height * 0.2,
      child: Center(
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: DefaultTextStyle(
            style: const TextStyle(
              fontSize: 70,
              fontFamily: 'Cairo',
              color: Colors.white,
              shadows: [
                Shadow(
                  blurRadius: 7.0,
                  color: Colors.white,
                  offset: Offset(0, 0),
                ),
              ],
            ),
            child: AnimatedTextKit(
              repeatForever: true,
              animatedTexts: [
                FlickerAnimatedText('Welcome', speed: const Duration(seconds: 4)),
                FlickerAnimatedText('To', speed: const Duration(seconds: 4)),
                FlickerAnimatedText("Brief pdf", speed: const Duration(seconds: 4)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildServiceButton(BuildContext context, String title, String route, double width) {
    return SizedBox(
      width: width,
      child: InkWell(
        onTap: () => Navigator.of(context).pushNamed(route),
        child: customContainer(
           Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontFamily: 'Cairo',
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
