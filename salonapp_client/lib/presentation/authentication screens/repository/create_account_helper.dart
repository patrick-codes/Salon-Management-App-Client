import 'package:salonapp_client/presentation/authentication%20screens/repository/user_helper.dart';
import 'data model/user_model.dart';

class AccountHelper {
  static UserHelper userhelper = UserHelper();

  static Future<void> createUser(UserModel user) async {
    try {
      final existingUser = await userhelper.getUserDetails(user.email!);

      if (existingUser?.email == null) {
        print("No existing user found. Creating new user.");
        await userhelper.createUserDb(user);
        print("User created successfully in Firestore.");
      } else {
        print("User already exists with email: ${existingUser!.email}");
      }
    } catch (error) {
      print("Error creating user: $error");
    }
  }
}
