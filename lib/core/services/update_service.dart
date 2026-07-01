import 'package:in_app_update/in_app_update.dart';

class UpdateService {
  Future<bool> checkForUpdate() async {
    try {
      final AppUpdateInfo updateInfo =
          await InAppUpdate.checkForUpdate();

      if (updateInfo.updateAvailability ==
          UpdateAvailability.updateAvailable) {

        await InAppUpdate.performImmediateUpdate();

        return true;
      }

      return false;
    } catch (e) {
      print("Update Error: $e");
      return false;
    }
  }
}