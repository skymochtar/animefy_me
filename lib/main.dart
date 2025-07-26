import 'package:flutter/material.dart';
import 'pages/upload_page.dart';
import 'pages/result_page.dart';

void main() => runApp(const AnimefyMe());

class AnimefyMe extends StatelessWidget {
  const AnimefyMe({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Animefy Me',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.purple),
        useMaterial3: true,
      ),
      initialRoute: '/',
      onGenerateRoute: (settings) {
        if (settings.name == '/') {
          return MaterialPageRoute(builder: (_) => const UploadPage());
        } else if (settings.name == '/result') {
          final imagePath = settings.arguments as String;

          return PageRouteBuilder(
            transitionDuration: const Duration(milliseconds: 600),
            pageBuilder:
                (context, animation, secondaryAnimation) =>
                    ResultPage(imagePath: imagePath),
            transitionsBuilder: (
              context,
              animation,
              secondaryAnimation,
              child,
            ) {
              const begin = Offset(1.0, 0.0);
              const end = Offset.zero;
              const curve = Curves.easeInOut;

              final tween = Tween(
                begin: begin,
                end: end,
              ).chain(CurveTween(curve: curve));

              return SlideTransition(
                position: animation.drive(tween),
                child: child,
              );
            },
          );
        }
        return null;
      },
    );
  }
}
