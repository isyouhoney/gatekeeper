import 'package:gatekeeper/model/visitor.dart';

class Visitor {
  late List<VisitorData> visitor;

  Visitor() {
    visitor = <VisitorData>[];
  }

  void addVisit(VisitorData u) {
    visitor.add(u);
  }

  int getRegisteredNum() {
    int cnt = 0;
    for (int i = 0; i < visitor.length; i++) {
      if (visitor[i].status == 'REGISTRANT') {
        cnt += 1;
      }
    }
    return cnt;
  }
}
