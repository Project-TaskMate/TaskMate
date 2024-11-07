import 'package:flutter/material.dart';
import 'AddScheduleDialog.dart';

class WeeklySchedule extends StatefulWidget {
  final DateTime initialDate;

  WeeklySchedule({required this.initialDate});

  @override
  _WeeklyScheduleState createState() => _WeeklyScheduleState();
}

class _WeeklyScheduleState extends State<WeeklySchedule> {
  late DateTime _startOfWeek;
  late DateTime _selectedDate;

  // 날짜별 일정들을 저장하는 Map
  Map<String, List<Map<String, dynamic>>> _scheduleMap = {};

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.initialDate;
    _startOfWeek = _selectedDate.subtract(Duration(days: _selectedDate.weekday % 7));
  }

  // 일정 추가 함수
  void _addSchedule(String title, String details, String time) {
    setState(() {
      String dateKey = _selectedDate.toString().split(' ')[0]; // 날짜만 사용
      _scheduleMap[dateKey] ??= [];
      _scheduleMap[dateKey]!.add({
        "title": title,
        "time": time,
        "completed": false, // 일정 완료 상태 추가
      });
    });
    // Firebase에 추가 로직을 넣으세요
  }

  // 일정 완료 상태 토글 함수
  void _toggleCompletion(String dateKey, int index) {
    setState(() {
      _scheduleMap[dateKey]![index]["completed"] = !_scheduleMap[dateKey]![index]["completed"];
    });
    // Firebase에 상태 업데이트 로직을 넣으세요
  }

  @override
  Widget build(BuildContext context) {
    String dateKey = _selectedDate.toString().split(' ')[0];
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text("Weekly Schedule"),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.add, color: Colors.purple),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AddScheduleDialog(
                  selectedDate: _selectedDate,
                  onScheduleAdded: (title, details, time) {
                    _addSchedule(title, details, time);
                  },
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // 주간 날짜 표시 (스크롤 가능)
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(7, (index) {
                DateTime date = _startOfWeek.add(Duration(days: index));
                bool isSelected = date.day == _selectedDate.day;

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedDate = date;
                    });
                  },
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 8.0),
                    padding: EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      color: isSelected ? Colors.purple.shade100 : Colors.transparent,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      children: [
                        Text(
                          "${date.day}",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: isSelected ? Colors.purple : Colors.black,
                          ),
                        ),
                        Text(
                          ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"][date.weekday - 1],
                          style: TextStyle(
                            fontSize: 12,
                            color: isSelected ? Colors.purple : Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ),
          ),
          SizedBox(height: 16),
          // 일정 목록 표시
          Expanded(
            child: ListView(
              children: (_scheduleMap[dateKey] ?? []).asMap().entries.map((entry) {
                int index = entry.key;
                Map<String, dynamic> event = entry.value;
                bool isCompleted = event["completed"] ?? false;

                return ListTile(
                  title: Text(
                    event["title"],
                    style: TextStyle(
                      fontSize: 16,
                      decoration: isCompleted ? TextDecoration.lineThrough : null,
                    ),
                  ),
                  subtitle: event.containsKey("time") ? Text(event["time"]) : null,
                  trailing: IconButton(
                    icon: Icon(
                      isCompleted ? Icons.check_box : Icons.check_box_outline_blank,
                      color: Colors.purple.shade200,
                    ),
                    onPressed: () => _toggleCompletion(dateKey, index),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}