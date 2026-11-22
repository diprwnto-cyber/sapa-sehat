import 'package:material_ui/material_ui.dart';

class AppLogoWidget extends StatelessWidget {
  final double size;

  const AppLogoWidget({
    super.key,
    this.size = 110,
  });

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/images/logo.png',
      width: size,
      height: size,
      fit: BoxFit.contain,
      errorBuilder: (context, error, stackTrace) => const Icon(
        Icons.local_hospital_rounded,
        size: 64,
        color: Color(0xFF0FB27E),
      ),
    );
  }
}
