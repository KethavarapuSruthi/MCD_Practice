import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'app_colors.dart';
import 'contact_step.dart';
import 'personal_step.dart';
import 'registration_widgets.dart';
import 'security_step.dart';
import 'success_screen.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  int currentStep = 0;
  bool _submitted = false;
  bool _acceptTerms = false;

  // One form key per step
  final _personalKey = GlobalKey<FormState>();
  final _contactKey = GlobalKey<FormState>();
  final _securityKey = GlobalKey<FormState>();

  // Step 1
  final _nameController = TextEditingController();
  final _idController = TextEditingController();
  final _dobController = TextEditingController();

  // Step 2
  final _emailController = TextEditingController();
  final _mobileController = TextEditingController();
  final _depositoryController = TextEditingController();

  // Step 3
  final _passController = TextEditingController();
  final _confirmController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _idController.dispose();
    _dobController.dispose();
    _emailController.dispose();
    _mobileController.dispose();
    _depositoryController.dispose();
    _passController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  void _onContinue() {
    FocusScope.of(context).unfocus();
    final key = [_personalKey, _contactKey, _securityKey][currentStep];
    if (!(key.currentState?.validate() ?? false)) return;

    if (currentStep < 2) {
      setState(() => currentStep++);
    } else {
      _createAccount();
    }
  }

  void _createAccount() {
    // TODO: call your API here using the controllers' values
    setState(() => _submitted = true);
  }

  void _goBack() {
    if (currentStep > 0) {
      setState(() => currentStep--);
    } else if (context.canPop()) {
      context.pop();
    }
  }

  Widget _buildStep() {
    switch (currentStep) {
      case 0:
        return PersonalStep(
          formKey: _personalKey,
          nameController: _nameController,
          idController: _idController,
          dobController: _dobController,
        );
      case 1:
        return ContactStep(
          formKey: _contactKey,
          emailController: _emailController,
          mobileController: _mobileController,
          depositoryController: _depositoryController,
        );
      default:
        return SecurityStep(
          formKey: _securityKey,
          passController: _passController,
          confirmController: _confirmController,
          acceptTerms: _acceptTerms,
          onTermsChanged: (v) => _acceptTerms = v,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_submitted) return const SuccessScreen();

    final isLast = currentStep == 2;

    return PopScope(
      // On step 2 and 3, the phone's back gesture goes to the previous step
      canPop: currentStep == 0,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) _goBack();
      },
      child: Scaffold(
        backgroundColor: AppColors.bg,
        appBar: AppBar(
          backgroundColor: AppColors.bg,
          elevation: 0,
          scrolledUnderElevation: 0,
          leadingWidth: 64,
          leading: Padding(
            padding: const EdgeInsets.only(left: 16),
            child: CircleAvatar(
              backgroundColor: Colors.white,
              child: IconButton(
                icon: const Icon(Icons.arrow_back, color: AppColors.navy, size: 20),
                onPressed: _goBack,
              ),
            ),
          ),
          actions: const [McdLogo()],
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),
              const Text(
                'Create your investor account',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w600,
                  color: AppColors.navy,
                ),
              ),
              const SizedBox(height: 16),
              StepIndicator(currentStep: currentStep),
              const SizedBox(height: 24),
              _buildStep(),
              const SizedBox(height: 24),
            ],
          ),
        ),
        bottomNavigationBar: Container(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
          ),
          child: SafeArea(
            top: false,
            child: Row(
              children: [
                if (currentStep > 0) ...[
                  OutlineBackButton(onTap: _goBack),
                  const SizedBox(width: 16),
                ],
                Expanded(
                  child: GradientButton(
                    label: isLast ? 'Create account' : 'Continue',
                    icon: isLast ? Icons.check : Icons.arrow_forward,
                    onTap: _onContinue,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}