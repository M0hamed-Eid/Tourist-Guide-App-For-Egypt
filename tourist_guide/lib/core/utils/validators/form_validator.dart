abstract class IFormValidator {
  String? validate(String? value);
}

class EmailValidator implements IFormValidator {
  @override
  String? validate(String? value) {
    if (value == null || value.isEmpty) {
      return "Email is required";
    }
    if (!value.contains("@")) {
      return "Email must contain '@'";
    }
    return null;
  }
}

class PasswordValidator implements IFormValidator {
  @override
  String? validate(String? value) {
    if (value == null || value.isEmpty) {
      return "Password is required";
    }
    if (value.length < 6) {
      return "Password must be at least 6 characters";
    }
    return null;
  }
}