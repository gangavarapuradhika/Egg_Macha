/// Frontend-only demo store. This is intentionally in-memory until a backend
/// and secure persistent storage are added. It is NOT production security.
class AdminAccountStore {
  AdminAccountStore._();
  static final AdminAccountStore instance = AdminAccountStore._();

  String? name;
  String? email;
  String? password;

  bool get isCreated => email != null && password != null;

  bool create(
      {required String adminName,
      required String adminEmail,
      required String adminPassword}) {
    if (isCreated) return false;
    name = adminName.trim();
    email = adminEmail.trim().toLowerCase();
    password = adminPassword;
    return true;
  }

  bool verify(String inputEmail, String inputPassword) =>
      isCreated &&
      inputEmail.trim().toLowerCase() == email &&
      inputPassword == password;
}
