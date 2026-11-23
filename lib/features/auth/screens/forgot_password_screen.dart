import 'dart:async';
import 'package:material_ui/material_ui.dart';
import '../../../core/constants/app_colors.dart';
import '../widgets/auth_background.dart';
import '../widgets/auth_dialogs.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_text_field.dart';
import 'login_screen.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  int _currentStep = 1;

  // Step 1 controllers
  final _phoneController = TextEditingController();

  // Step 2 controllers
  final List<TextEditingController> _otpControllers =
      List.generate(6, (_) => TextEditingController());
  final List<FocusNode> _otpFocusNodes = List.generate(6, (_) => FocusNode());
  int _timerSeconds = 44;
  Timer? _timer;

  // Step 3 controllers
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _obscurePass1 = true;
  bool _obscurePass2 = true;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer?.cancel();
    _timerSeconds = 44;
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (_timerSeconds > 0) {
        if (mounted) setState(() => _timerSeconds--);
      } else {
        t.cancel();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _phoneController.dispose();
    for (var c in _otpControllers) {
      c.dispose();
    }
    for (var f in _otpFocusNodes) {
      f.dispose();
    }
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: AuthBackground(
        child: Column(
          children: [
            // Top App Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios_new, size: 18, color: AppColors.textPrimary),
                    onPressed: () {
                      if (_currentStep > 1) {
                        setState(() => _currentStep--);
                      } else {
                        Navigator.pop(context);
                      }
                    },
                  ),
                  Text(
                    _currentStep == 1
                        ? 'Lupa Kata Sandi'
                        : _currentStep == 2
                            ? 'Verifikasi Kode OTP'
                            : 'Setel Ulang Kata Sandi',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
            ),

            // Step Progress Indicator matching Figma
            _buildStepIndicator(),

            // Step Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
                child: _currentStep == 1
                    ? _buildStep1()
                    : _currentStep == 2
                        ? _buildStep2()
                        : _buildStep3(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Step Indicator Widget
  Widget _buildStepIndicator() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 10.0),
      child: Row(
        children: [
          _buildStepItem(1, 'Nomor WA', _currentStep >= 1),
          Expanded(child: Container(height: 2, color: _currentStep >= 2 ? AppColors.primary : AppColors.border)),
          _buildStepItem(2, 'OTP', _currentStep >= 2),
          Expanded(child: Container(height: 2, color: _currentStep >= 3 ? AppColors.primary : AppColors.border)),
          _buildStepItem(3, 'Sandi Baru', _currentStep >= 3),
        ],
      ),
    );
  }

  Widget _buildStepItem(int step, String label, bool isDone) {
    final isActive = _currentStep == step;
    return Column(
      children: [
        Container(
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            color: isDone ? AppColors.primary : Colors.white,
            shape: BoxShape.circle,
            border: Border.all(
              color: isDone ? AppColors.primary : AppColors.border,
              width: 1.5,
            ),
          ),
          child: Center(
            child: isDone && !isActive
                ? const Icon(Icons.check, size: 14, color: Colors.white)
                : Text(
                    '$step',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: isDone ? Colors.white : AppColors.textMuted,
                    ),
                  ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
            color: isActive ? AppColors.primary : AppColors.textSecondary,
          ),
        ),
      ],
    );
  }

  // Step 1: Input Nomor WhatsApp
  Widget _buildStep1() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 12),
        const Text(
          'Masukkan Nomor WhatsApp',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
        ),
        const SizedBox(height: 8),
        const Text(
          'Kami akan mengirimkan 6-digit kode verifikasi (OTP) ke nomor WhatsApp yang terdaftar pada akun Anda.',
          style: TextStyle(fontSize: 13, color: AppColors.textSecondary, height: 1.4),
        ),
        const SizedBox(height: 28),

        CustomTextField(
          controller: _phoneController,
          labelText: 'Nomor WhatsApp Terdaftar',
          hintText: '0812-3456-7890',
          keyboardType: TextInputType.phone,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          prefixWidget: Container(
            margin: const EdgeInsets.only(left: 10, right: 10),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFFF1F5F9),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Text('+62', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.textPrimary)),
          ),
          validator: (val) {
            if (val == null || val.trim().isEmpty) {
              return 'Nomor WhatsApp wajib diisi';
            }
            final digits = val.replaceAll(RegExp(r'\D'), '');
            if (digits.length < 12) {
              return 'nomor tidak boleh kurang dari 12';
            }
            return null;
          },
        ),
        const SizedBox(height: 24),

        // Protection Info Card
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: AppColors.primaryLight,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.primary.withValues(alpha: 0.2)),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Icon(Icons.shield_outlined, color: AppColors.primary, size: 22),
              SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Perlindungan Data Keluarga & Anak',
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Kode OTP bersifat rahasia. Jangan berikan kepada siapapun demi keamanan data tumbuh kembang si Kecil.',
                      style: TextStyle(fontSize: 11, color: AppColors.textSecondary, height: 1.3),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 36),

        CustomButton(
          text: 'Kirim Kode Verifikasi (OTP)',
          icon: const Icon(Icons.arrow_forward_rounded, size: 18, color: Colors.white),
          isLoading: _isLoading,
          onPressed: () async {
            setState(() => _isLoading = true);
            await Future.delayed(const Duration(milliseconds: 500));
            if (!mounted) return;
            setState(() {
              _isLoading = false;
              _currentStep = 2;
              _startTimer();
            });
          },
        ),
      ],
    );
  }

  // Step 2: Verifikasi Kode OTP
  Widget _buildStep2() {
    final phoneDisplay = _phoneController.text.isNotEmpty
        ? '+62 ${_phoneController.text}'
        : '+62 812-3456-7890';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 12),
        const Text(
          'Masukkan 6-Digit Kode OTP',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Text(
              'Kode verifikasi telah dikirim ke $phoneDisplay',
              style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
            ),
            const SizedBox(width: 6),
            GestureDetector(
              onTap: () => setState(() => _currentStep = 1),
              child: const Text('Ubah', style: TextStyle(fontSize: 12, color: AppColors.primary, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
        const SizedBox(height: 32),

        // 6 OTP Box Inputs
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(6, (index) {
            return SizedBox(
              width: 44,
              height: 52,
              child: TextField(
                controller: _otpControllers[index],
                focusNode: _otpFocusNodes[index],
                textAlign: TextAlign.center,
                keyboardType: TextInputType.number,
                maxLength: 1,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                decoration: InputDecoration(
                  counterText: '',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: AppColors.border)),
                  focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: AppColors.primary, width: 2)),
                ),
                onChanged: (val) {
                  if (val.isNotEmpty && index < 5) {
                    _otpFocusNodes[index + 1].requestFocus();
                  } else if (val.isEmpty && index > 0) {
                    _otpFocusNodes[index - 1].requestFocus();
                  }
                },
              ),
            );
          }),
        ),
        const SizedBox(height: 24),

        // Resend Timer
        Center(
          child: Text(
            'Kirim ulang kode via WhatsApp dalam 00:${_timerSeconds.toString().padLeft(2, '0')}',
            style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
          ),
        ),
        const SizedBox(height: 36),

        CustomButton(
          text: 'Verifikasi & Lanjut Buat Sandi Baru',
          icon: const Icon(Icons.arrow_forward_rounded, size: 18, color: Colors.white),
          isLoading: _isLoading,
          onPressed: () {
            setState(() => _currentStep = 3);
          },
        ),
      ],
    );
  }

  // Step 3: Setel Ulang Kata Sandi
  Widget _buildStep3() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 12),
        const Text(
          'Buat Kata Sandi Baru',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
        ),
        const SizedBox(height: 8),
        const Text(
          'Kata sandi baru harus berbeda dari kata sandi yang pernah digunakan sebelumnya.',
          style: TextStyle(fontSize: 13, color: AppColors.textSecondary, height: 1.4),
        ),
        const SizedBox(height: 28),

        CustomTextField(
          controller: _newPasswordController,
          labelText: 'Kata Sandi Baru',
          hintText: 'Minimal 8 karakter',
          prefixIcon: Icons.lock_outline_rounded,
          obscureText: _obscurePass1,
          suffixIcon: IconButton(
            icon: Icon(_obscurePass1 ? Icons.visibility_off_outlined : Icons.visibility_outlined, size: 20, color: AppColors.textMuted),
            onPressed: () => setState(() => _obscurePass1 = !_obscurePass1),
          ),
        ),
        const SizedBox(height: 16),

        CustomTextField(
          controller: _confirmPasswordController,
          labelText: 'Konfirmasi Kata Sandi Baru',
          hintText: 'Ulangi kata sandi baru',
          prefixIcon: Icons.lock_outline_rounded,
          obscureText: _obscurePass2,
          suffixIcon: IconButton(
            icon: Icon(_obscurePass2 ? Icons.visibility_off_outlined : Icons.visibility_outlined, size: 20, color: AppColors.textMuted),
            onPressed: () => setState(() => _obscurePass2 = !_obscurePass2),
          ),
        ),
        const SizedBox(height: 20),

        // Syarat Kata Sandi
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: const Color(0xFFF8FAFC),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.border),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text('Syarat Kata Sandi Baru:', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
              SizedBox(height: 8),
              _ReqItem('Minimal 8 karakter'),
              _ReqItem('Mengandung huruf besar dan kecil'),
              _ReqItem('Mengandung angka dan tanda baca (!, @, #)'),
            ],
          ),
        ),
        const SizedBox(height: 32),

        CustomButton(
          text: 'Simpan Kata Sandi & Masuk',
          isLoading: _isLoading,
          onPressed: () {
            AuthDialogs.showSuccess(
              context: context,
              title: 'Kata Sandi Diperbarui',
              message: 'Kata sandi Anda berhasil diperbarui. Silakan masuk kembali dengan kata sandi baru Anda.',
              onContinue: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => const LoginScreen()),
                  (route) => false,
                );
              },
            );
          },
        ),
      ],
    );
  }
}

class _ReqItem extends StatelessWidget {
  final String text;
  const _ReqItem(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4.0),
      child: Row(
        children: [
          const Icon(Icons.check_circle_outline, size: 14, color: AppColors.primary),
          const SizedBox(width: 8),
          Text(text, style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
        ],
      ),
    );
  }
}
