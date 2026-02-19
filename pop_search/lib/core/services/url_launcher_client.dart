import 'package:pop_search/core/services/launch_client.dart';
import 'package:url_launcher/url_launcher.dart';

class UrlLauncherClient implements LaunchClient {
  const UrlLauncherClient();

  @override
  Future<bool> launchExternal(Uri uri) {
    return launchUrl(uri, mode: LaunchMode.externalApplication);
  }
}
