class Validators {

  String? validateName(String name) {
    RegExp regExp = RegExp(r'^(?=.*?[a-zA-Z]).{2,}$');
    if (name.isEmpty) {
      return "Please enter your name";
    } else if (name.length < 3) {
      return "Your name must be more than 3 characters";
    } else if (!regExp.hasMatch(name)) {
      return "Enter a valid name";
    }
    return null;
  }

  String? validatePassword(String password) {
    RegExp regExp =
    RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#/$&*~]).{8,}$');
    if (password.isEmpty) {
      return "Please enter your password";
    } else if (password.length < 8) {
      return "Your password must be more than 8 characters";
    } else if (!regExp.hasMatch(password)) {
      return "Your password should contain upper, lower, digit and special character";
    }
    return null;
  }

  String? validateEmail(String email, List<String> registeredEmails) {
    if (email.isEmpty) {
      return "Please input your email";
    } else if (!email.endsWith(".com")) {
      return "Email address must end with .com";
    } else if (!email.contains("@")) {
      return "Your email must have @";
    } else if (email.length <= 8) {
      return "Email address must be more than 8 characters";
    } else if (registeredEmails.contains(email)) {
      return "This email is already registered";
    }
    return null;
  }

  String? validatePhone(String phone, List<String> registeredPhones) {
    RegExp regExp = RegExp(r'^(?=.*?[0-9]).{8,}$');
    if (phone.isEmpty) {
      return "Please enter your phone number";
    } else if (phone.length != 10) {
      return "Your phone number must be 10 digits";
    } else if (!regExp.hasMatch(phone)) {
      return "Please enter a valid phone number";
    } else if (!phone.startsWith("05")) {
      return "Your phone number must start with 05";
    } else if (registeredPhones.contains(phone)) {
      return "This phone number is already in use";
    }
    return null;
  }

  String? validateConfirmPassword(String confirmPassword, String password) {
    if (confirmPassword.isEmpty) {
      return "Please confirm your password.";
    } else if (confirmPassword != password) {
      return "The passwords do not match.";
    }
    return null;
  }
}
