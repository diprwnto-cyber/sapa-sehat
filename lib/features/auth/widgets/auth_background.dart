import 'package:material_ui/material_ui.dart';

class AuthBackground extends StatelessWidget {
  final Widget child;

  const AuthBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Background Gradient Image covering 100% of full screen
          Image.asset(
            'assets/images/auth_bg.jpg',
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
            errorBuilder: (context, error, stackTrace) =>
                Container(color: const Color(0xFFF0FDF4)),
          ),
          SafeArea(child: child),
        ],
      ),
    );
  }
}
