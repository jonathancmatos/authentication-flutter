bool validateName(String value) {
  return RegExp(r'^\w+\s\w+').hasMatch(value);
}

bool validateEmail(String value) {
  return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value);
}

bool validatePasswd(String value) {
  return value.isNotEmpty && value.length >= 8;
}

bool validatePhone(String value) {
  return RegExp(r'^\([1-9]{2}\) [2-9][0-9]{3,4}\-[0-9]{4}$').hasMatch(value);
}
