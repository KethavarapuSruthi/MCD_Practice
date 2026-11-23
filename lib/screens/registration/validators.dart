// Every validator returns null when the value is fine,
// or an error message when it is not.
class Validators {
  static String? name(String? v) {
    final value = v?.trim() ?? '';
    if (value.isEmpty) return 'Enter your full name';
    if (value.length < 3) return 'Name is too short';
    if (!RegExp(r'^[a-zA-Z ]+$').hasMatch(value)) {
      return 'Use letters and spaces only';
    }
    return null;
  }

  static String? id(String? v) {
    final value = v?.trim() ?? '';
    if (value.isEmpty) return 'Enter your ID number';
    if (!RegExp(r'^[a-zA-Z0-9]{6,12}$').hasMatch(value)) {
      return 'Enter a valid ID number';
    }
    return null;
  }

  static String? dob(String? v) {
    final text = v?.trim() ?? '';
    final parts = text.split('/');
    if (parts.length != 3) return 'Select your date of birth';

    final d = int.tryParse(parts[0]);
    final m = int.tryParse(parts[1]);
    final y = int.tryParse(parts[2]);
    if (d == null || m == null || y == null) {
      return 'Select your date of birth';
    }

    final birth = DateTime(y, m, d);
    final now = DateTime.now();
    int age = now.year - birth.year;
    if (now.month < birth.month ||
        (now.month == birth.month && now.day < birth.day)) {
      age--;
    }
    if (age < 18) return 'You must be at least 18 years old';
    return null;
  }

  static String? email(String? v) {
    final value = v?.trim() ?? '';
    if (value.isEmpty) return 'Enter your email address';
    if (!RegExp(r'^[\w.+-]+@[\w-]+(\.[\w-]+)+$').hasMatch(value)) {
      return 'Enter a valid email';
    }
    return null;
  }

  static String? mobile(String? v) {
    final value = v?.trim() ?? '';
    if (value.isEmpty) return 'Enter your mobile number';
    if (!RegExp(r'^\d{8}$').hasMatch(value)) {
      return 'Enter a valid mobile number';
    }
    return null;
  }

  static String? depository(String? v) {
    final value = v?.trim() ?? '';
    if (value.isEmpty) return null; 
    if (!RegExp(r'^[a-zA-Z0-9]{6,15}$').hasMatch(value)) {
      return 'Enter a valid account number';
    }
    return null;
  }

  static String? password(String? v) {
    final value = v ?? '';
    if (value.isEmpty) return 'Enter a password';
    if (value.length < 8) return 'Use at least 8 characters';
    if (!RegExp(r'[A-Z]').hasMatch(value)) return 'Add an uppercase letter';
    if (!RegExp(r'[a-z]').hasMatch(value)) return 'Add a lowercase letter';
    if (!RegExp(r'\d').hasMatch(value)) return 'Add a number';
    return null;
  }

  static String? confirmPassword(String? v, String password) {
    if (v == null || v.isEmpty) return 'Re-enter your password';
    if (v != password) return 'Passwords do not match';
    return null;
  }
}