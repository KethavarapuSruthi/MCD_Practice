  import 'package:flutter/material.dart';
import 'registration_widgets.dart';
import 'validators.dart';

class PersonalStep extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController nameController;
  final TextEditingController idController;
  final TextEditingController dobController;

  const PersonalStep({
    super.key,
    required this.formKey,
    required this.nameController,
    required this.idController,
    required this.dobController,
  });

  Future<void> _pickDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime(1996, 1, 25),
      firstDate: DateTime(1920),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      final d = picked.day.toString().padLeft(2, '0');
      final m = picked.month.toString().padLeft(2, '0');
      dobController.text = '$d/$m/${picked.year}';
    }
  }

  @override
  Widget build(BuildContext context) {
    return StepCard(
      formKey: formKey,
      title: 'Tell us about you',
      subtitle: 'Enter your details exactly as on your national ID or passport.',
      children: [
        const FormLabel('Full name'),
        AppTextField(
          controller: nameController,
          hint: 'As on your ID',
          icon: Icons.badge_outlined,
          validator: Validators.name,
        ),
        const SizedBox(height: 16),
        const FormLabel('National ID / Passport no.'),
        AppTextField(
          controller: idController,
          hint: 'Enter ID number',
          icon: Icons.credit_card,
          validator: Validators.id,
        ),
        const SizedBox(height: 16),
        const FormLabel('Date of birth'),
        AppTextField(
          controller: dobController,
          hint: 'DD/MM/YYYY',
          icon: Icons.cake_outlined,
          readOnly: true,
          onTap: () => _pickDate(context),
          validator: Validators.dob,
        ),
      ],
    );
  }
}