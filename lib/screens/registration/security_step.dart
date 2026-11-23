import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'registration_widgets.dart';
import 'validators.dart';

class SecurityStep extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController passController;
  final TextEditingController confirmController;
  final bool acceptTerms;
  final ValueChanged<bool> onTermsChanged;

  const SecurityStep({
    super.key,
    required this.formKey,
    required this.passController,
    required this.confirmController,
    required this.acceptTerms,
    required this.onTermsChanged,
  });

  @override
  State<SecurityStep> createState() => _SecurityStepState();
}

class _SecurityStepState extends State<SecurityStep> {
  bool _hidePass = true;
  bool _hideConfirm = true;

  @override
  void initState() {
    super.initState();
    // Rebuild while typing so the strength bars update
    widget.passController.addListener(_refresh);
  }

  @override
  void dispose() {
    widget.passController.removeListener(_refresh);
    super.dispose();
  }

  void _refresh() => setState(() {});

  // Password strength: 0 to 4
  int get _strength {
    final p = widget.passController.text;
    int score = 0;
    if (p.length >= 8) score++;
    if (RegExp(r'[A-Z]').hasMatch(p) && RegExp(r'[a-z]').hasMatch(p)) score++;
    if (RegExp(r'\d').hasMatch(p)) score++;
    if (RegExp(r'[^A-Za-z0-9]').hasMatch(p)) score++;
    return score;
  }

  Widget _eyeButton(bool hidden, VoidCallback onPressed) {
    return IconButton(
      icon: Icon(
        hidden ? Icons.visibility_off_outlined : Icons.visibility_outlined,
        color: AppColors.icon,
      ),
      onPressed: onPressed,
    );
  }

  Widget _strengthBars() {
    const colors = [
      AppColors.border,
      Color(0xFFD9534F),
      Color(0xFFF0A030),
      Color(0xFF8BC34A),
      Color(0xFF2E9E5B),
    ];
    final active = colors[_strength];
    return Row(
      children: List.generate(4, (i) {
        return Expanded(
          child: Container(
            height: 4,
            margin: EdgeInsets.only(right: i < 3 ? 8 : 0),
            decoration: BoxDecoration(
              color: i < _strength ? active : AppColors.border,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        );
      }),
    );
  }

  Widget _termsCheckbox() {
    return FormField<bool>(
      initialValue: widget.acceptTerms,
      validator: (v) => v == true ? null : 'Please accept to continue',
      builder: (state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 28,
                  height: 28,
                  child: Checkbox(
                    value: state.value,
                    activeColor: AppColors.blue,
                    side: BorderSide(
                      color: state.hasError ? AppColors.error : AppColors.navy,
                      width: 2,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                    onChanged: (v) {
                      state.didChange(v);
                      widget.onTermsChanged(v ?? false);
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text.rich(
                    TextSpan(
                      style: const TextStyle(fontSize: 14, color: AppColors.navy),
                      children: [
                        const TextSpan(text: 'I agree to the '),
                        TextSpan(
                          text: 'Terms of Service',
                          style: const TextStyle(color: AppColors.blue),
                          recognizer: TapGestureRecognizer()..onTap = () {},
                        ),
                        const TextSpan(text: ' and '),
                        TextSpan(
                          text: 'Privacy Policy',
                          style: const TextStyle(color: AppColors.blue),
                          recognizer: TapGestureRecognizer()..onTap = () {},
                        ),
                        const TextSpan(
                          text: ', and consent to identity verification.',
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            if (state.hasError)
              Padding(
                padding: const EdgeInsets.only(top: 6, left: 40),
                child: Text(
                  state.errorText!,
                  style: const TextStyle(color: AppColors.error, fontSize: 13),
                ),
              ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return StepCard(
      formKey: widget.formKey,
      title: 'Secure your access',
      subtitle: 'Choose a strong password to protect your portfolio.',
      children: [
        const FormLabel('Password'),
        AppTextField(
          controller: widget.passController,
          hint: 'At least 8 characters',
          icon: Icons.lock_outline,
          obscure: _hidePass,
          suffix: _eyeButton(_hidePass, () => setState(() => _hidePass = !_hidePass)),
          validator: Validators.password,
        ),
        const SizedBox(height: 12),
        _strengthBars(),
        const SizedBox(height: 16),
        const FormLabel('Confirm password'),
        AppTextField(
          controller: widget.confirmController,
          hint: 'Re-enter your password',
          icon: Icons.lock_reset,
          obscure: _hideConfirm,
          suffix: _eyeButton(
              _hideConfirm, () => setState(() => _hideConfirm = !_hideConfirm)),
          validator: (v) =>
              Validators.confirmPassword(v, widget.passController.text),
        ),
        const SizedBox(height: 16),
        _termsCheckbox(),
      ],
    );
  }
}