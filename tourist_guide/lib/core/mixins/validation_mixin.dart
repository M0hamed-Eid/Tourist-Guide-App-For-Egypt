mixin ValidationMixin {
  String? validateName(String? val) {
    if (val == null || val.isEmpty) {
      return "Full Name is required ";
    }
    if (val[0] != val[0].toUpperCase()) {
      return "The First letter must be capitalized";
    }
    return null;
  }

  String? validateEmail(String? val) {
    if (val == null || val.isEmpty) {
      return "Email is required ";
    }
    if (!val.contains("@")) {
      return "Email must contain '@'";
    }
    return null;
  }

  String? validatePassword(String? val) {
    if (val == null || val.isEmpty) {
      return "Password is required ";
    }
    if (val.length < 6) {
      return "Password must be at least 6 characters";
    }
    return null;
  }
}
