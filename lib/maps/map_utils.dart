import 'package:url_launcher/url_launcher.dart';

class MapUtils {
  MapUtils._();
  static void launchMapFromSourceToDestination(
      sourceLat ,sourceLng, destinationLat, destinationLng )async{
    String mapOptions = [
      'saddr=$sourceLat,$sourceLng',
      'daddr=$destinationLat,$destinationLng',
      'dire_action=navigate',
    ].join('&');

    final mapUrl = 'https://www.google.com/maps?$mapOptions';
    if (await canLaunchUrl(Uri.parse(mapUrl))){
       await launchUrl(Uri.parse(mapUrl),mode: LaunchMode.externalApplication);
    }
    else{
      throw 'Couldn\'t launch $mapUrl';
    }
  }
}