import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:gatekeeper/controller/login_service.dart';
import 'package:gatekeeper/controller/visit_record.dart';
import 'package:gatekeeper/view/home/home_header.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:timeline_tile/timeline_tile.dart';
import '../../model/visitor.dart';
import "package:collection/collection.dart";
import 'package:intl/intl.dart';

class Timeline extends StatefulWidget {
  UserProvider user;
  Timeline({Key? key, required this.user}) : super(key: key);

  @override
  State<Timeline> createState() => _TimelineState(user: user);
}

class _TimelineState extends State<Timeline> {
  late VisitorRecord _visitor;
  List<VisitorData> _visitorRecord = [];
  UserProvider user;
  late Timer _timer;
  _TimelineState({required this.user});

  @override
  void initState() {
    super.initState();
    _visitor = VisitorRecord(user: user);
    _visitor.getRecord().then((value) {
      setState(() {
        _visitorRecord = value;
      });
    });
    _timer = Timer.periodic(Duration(seconds: 3), (timer) {
      setState(() {
        _visitor.getRecord().then((value) {
          setState(() {
            _visitorRecord = value;
          });
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SafeArea(
        child: Column(
          children: [
            // ElevatedButton(onPressed: () async {}, child: Text('Login')),
            Searchbar(),

            // Timeline(),

            Visitboard(
              data: _visitorRecord,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: CustomScrollView(
                  slivers: <Widget>[
                    _TimelineVisitor(
                      data: _visitorRecord,
                    ),
                    SliverList(
                      delegate: SliverChildListDelegate(<Widget>[
                        _MessageTimeline(
                          message: '이전 기록이 없습니다.',
                        ),
                      ]),
                    ),
                    // const SliverPadding(padding: EdgeInsets.only(top: 20)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TimelineVisitor extends StatelessWidget {
  _TimelineVisitor({Key? key, required this.data}) : super(key: key);

  final List<VisitorData> data;

  @override
  Widget build(BuildContext context) {
    DateFormat formatter = DateFormat('yyyy-MM-dd');
    Map<String, List> value = Map();
    int counter = 0;
    GlobalKey key;
    for (int i = data.length - 1; i >= 0; i--) {
      VisitorData item = data[i];
      String date = formatter.format(item.date);
      if (!value.containsKey(date)) {
        List<VisitorData> temp = <VisitorData>[];
        value[date] = temp; // 초기화
      }
      value[date]!.add(item);
    }
    List<Widget> result = <Widget>[];
    value.forEach((k, v) {
      if (k == formatter.format(DateTime.now())) {
        result.add(
          _MessageTimeline(
            message: '오늘',
          ),
        );
        if (value[Status] == Status.REGISTRANT) {
          counter += 1;
        }
      } else if (k ==
          formatter.format(DateTime.now().subtract(Duration(days: 1)))) {
        result.add(_MessageTimeline(
          message: '어제',
        ));
      } else {
        result.add(_MessageTimeline(
          message: k,
        ));
      }

      for (int j = 0; j < v.length; j++) {
        var event = v[j];
        final isLeftChild = event.status == Status.REGISTRANT;
        // print(isLeftChild);

        final child = _TimelineVisitorChild(
          name: event.name,
          status: event.status,
          date: event.date,
          img: event.img,
          isLeftChild: isLeftChild,
        );

        result.add(TimelineTile(
          alignment: TimelineAlign.center,
          endChild: isLeftChild ? null : child,
          startChild: isLeftChild ? child : null,
          indicatorStyle: IndicatorStyle(
            width: 70,
            height: 40,
            indicator: _TimelineVisitIndicator(date: event.date),
            drawGap: true,
          ),
          beforeLineStyle: LineStyle(
            color: Color.fromARGB(207, 212, 174, 178),
            thickness: 3,
          ),
        ));
      }
    });
    print(value);

    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (BuildContext context, int index) {
          return result[index];
        },
        childCount: result.length,
      ),
    );
  }
}

class _MessageTimeline extends StatelessWidget {
  const _MessageTimeline({Key? key, required this.message}) : super(key: key);

  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(8),
        margin: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: Color.fromARGB(207, 212, 174, 178),
          borderRadius: const BorderRadius.all(Radius.circular(8)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Flexible(
              child: Text(
                message,
                textAlign: TextAlign.center,
                style: GoogleFonts.dosis(
                    fontSize: 18,
                    color: Colors.black,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TimelineVisitorChild extends StatelessWidget {
  const _TimelineVisitorChild({
    Key? key,
    required this.status,
    required this.name,
    required this.date,
    required this.img,
    required this.isLeftChild,
  }) : super(key: key);

  final Status status;
  final String name;
  final DateTime date;
  final String img;
  final bool isLeftChild;

  @override
  Widget build(BuildContext context) {
    final rowChildren = [
      _buildImg(),
    ];

    return Padding(
      padding: const EdgeInsets.all(5),
      child: Container(
        decoration: const BoxDecoration(
          color: Color.fromARGB(100, 212, 174, 178),
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        child: Padding(
          padding: isLeftChild
              ? const EdgeInsets.only(left: 10, top: 10, bottom: 10, right: 5)
              : const EdgeInsets.only(right: 10, top: 10, bottom: 10, left: 10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Row(
                children:
                    isLeftChild ? rowChildren.reversed.toList() : rowChildren,
              ),
              Flexible(
                child: Text(
                  name,
                  textAlign: isLeftChild ? TextAlign.right : TextAlign.left,
                  style: GoogleFonts.dosis(
                    fontSize: 16,
                    color: Colors.black,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImg() {
    return Image.network(
      img,

      // height: 160,
      width: 99,
    );
  }
}

class _TimelineVisitIndicator extends StatelessWidget {
  const _TimelineVisitIndicator({Key? key, required this.date})
      : super(key: key);

  final DateTime date;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          border: Border.all(
            color: Color.fromARGB(207, 212, 174, 178),
            width: 3,
          ),
          borderRadius: BorderRadius.circular(10)),
      child: Center(
        child: Text(
          DateFormat.jm().format(date),
          textAlign: TextAlign.center,
          style: GoogleFonts.dosis(
              fontSize: 18, color: Colors.black, fontWeight: FontWeight.w500),
        ),
      ),
    );
  }
}

class Visitboard extends StatelessWidget {
  Visitboard({Key? key, required this.data}) : super(key: key);
  final List<VisitorData> data;

  @override
  Widget build(BuildContext context) {
    int rcnt = 0;
    int ncnt = 0;
    DateFormat formatter = DateFormat('yyyy-MM-dd');

    for (int i = 0; i < data.length; i++) {
      String date = formatter.format(data[i].date);
      String ndate = formatter.format(DateTime.now());
      if (date == ndate) {
        if (data[i].status == Status.REGISTRANT) {
          rcnt += 1;
        } else if (data[i].status == Status.NON_REGISTRANT) {
          ncnt += 1;
        }
      }
    }
    return Container(
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.only(top: 12, right: 12, left: 12),
      constraints: const BoxConstraints(maxHeight: 160),
      decoration: BoxDecoration(
        color: Color.fromARGB(80, 212, 174, 178),
        borderRadius: const BorderRadius.all(Radius.circular(8)),
      ),
      child: Column(
        children: [
          Text(
            "Today's Record",
            style: GoogleFonts.dosis(
                fontSize: 20, color: Colors.black, fontWeight: FontWeight.w700),
          ),
          Spacer(flex: 1),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const SizedBox(width: 16),
              _VisitCnt(cnt: rcnt.toString(), status: 'Registrant'),
              Spacer(),
              _VisitCnt(cnt: ncnt.toString(), status: 'Non-Registrant'),
              const SizedBox(width: 16),
            ],
          ),
        ],
      ),
    );
  }
}

class _VisitCnt extends StatelessWidget {
  const _VisitCnt({Key? key, required this.cnt, required this.status})
      : super(key: key);

  final String cnt;
  final String status;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          constraints: const BoxConstraints(minWidth: 100, minHeight: 70),
          decoration: const BoxDecoration(
            color: Color.fromARGB(70, 46, 148, 173),
            borderRadius: BorderRadius.all(Radius.circular(8)),
          ),
          child: Center(
            child: Text(
              cnt,
              style: GoogleFonts.dosis(
                fontSize: 28,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const SizedBox(height: 10),
        Text(
          status,
          style: GoogleFonts.dosis(
            fontSize: 15,
            color: Colors.black,
            fontWeight: FontWeight.w500,
          ),
        )
      ],
    );
  }
}
