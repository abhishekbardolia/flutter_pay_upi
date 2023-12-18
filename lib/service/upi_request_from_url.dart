// Converting URL and pushing value into single object.
///Coming soon
class UpiRequestFromUrl {
  String? pn;
  String? mc;
  String? tid;
  String? tr;
  String? am;
  String? pa;

  String? cu;

  UpiRequestFromUrl(String responseString) {
    List<String> _parts = responseString.split('&');

    for (int i = 0; i < _parts.length; ++i) {
      String key = _parts[i].split('=')[0];
      String value = _parts[i].split('=')[1];
      if (key == "pn") {
        pn = value;
      } else if (key == "mc") {
        mc = value;
      } else if (key == "tid") {
        tid = value;
      } else if (key.toLowerCase() == "tr") {
        tr = value;
      } else if (key == "am") {
        am = value;
      } else if (key == "cu") {
        cu = value;
      } else if (key == "intent://pay?pa") {
        pa = value;
      }
    }
  }
}
