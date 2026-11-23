import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'app_colors.dart';
import 'registration_widgets.dart';
import 'validators.dart';

class ContactStep extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController emailController;
  final TextEditingController mobileController;
  final TextEditingController depositoryController;

  const ContactStep({
    super.key,
    required this.formKey,
    required this.emailController,
    required this.mobileController,
    required this.depositoryController,
  });

  @override
  Widget build(BuildContext context) {
    return StepCard(
      formKey: formKey,
      title: 'How can we reach you?',
      subtitle: 'Link an existing depository account if you already hold securities.',
      children: [
        const FormLabel('Email address'),
        AppTextField(
          controller: emailController,
          hint: 'you@example.com',
          icon: Icons.mail_outline,
          keyboardType: TextInputType.emailAddress,
          validator: Validators.email,
        ),
        const SizedBox(height: 16),
        const FormLabel('Mobile number'),
        AppTextField(
          controller: mobileController,
          hint: 'Enter mobile number',
          icon: Icons.smartphone,
          keyboardType: TextInputType.phone,
          formatters: [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(8),
          ],
          validator: Validators.mobile,
        ),
        const SizedBox(height: 16),
        const FormLabel('Depository account no. (optional)'),
        AppTextField(
          controller: depositoryController,
          hint: 'Link an existing account',
          icon: Icons.account_balance_wallet_outlined,
          validator: Validators.depository,
        ),
        const Padding(
          padding: EdgeInsets.only(top: 8, left: 12),
          child: Text(
            'Leave blank to open a new investor account.',
            style: TextStyle(fontSize: 13, color: AppColors.navy),
          ),
        ),
      ],
    );
  }
}