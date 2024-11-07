import 'package:flutter/material.dart';
import 'WeeklySchedule.dart'; // 주간 일정 위젯을 import

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: CalendarScreen(),
    );
  }
}

class CalendarScreen extends StatefulWidget {
  @override
  _CalendarScreenState createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  DateTime _currentDate = DateTime(2024, 10); // 초기 날짜를 2024년 10월로 설정

  // 달을 한 달 앞 또는 뒤로 이동
  void _changeMonth(int increment) {
    setState(() {
      _currentDate = DateTime(_currentDate.year, _currentDate.month + increment);
    });
  }

  void _openWeeklySchedule(DateTime selectedDate) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => WeeklySchedule(initialDate: selectedDate), // 변경된 부분
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '${_currentDate.year}.${_currentDate.month.toString().padLeft(2, '0')}',
          style: TextStyle(fontSize: 24, color: Colors.black),
        ),
        backgroundColor: Colors.white,
        centerTitle: true,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // 요일 표시
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: ['SUN', 'MON', 'TUE', 'WED', 'THU', 'FRI', 'SAT']
                  .map((day) => Text(
                day,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: day == 'SUN' ? Colors.red : Colors.purple,
                ),
              ))
                  .toList(),
            ),
            SizedBox(height: 16),
            // 달력 그리드
            Expanded(
              child: GridView.builder(
                itemCount: _daysInMonth(_currentDate) + _firstWeekdayOffset(_currentDate),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 7,
                  childAspectRatio: 0.8,
                  mainAxisSpacing: 8,
                  crossAxisSpacing: 8,
                ),
                itemBuilder: (context, index) {
                  final day = index >= _firstWeekdayOffset(_currentDate)
                      ? index - _firstWeekdayOffset(_currentDate) + 1
                      : null;
                  return GestureDetector(
                    onTap: day != null
                        ? () => _openWeeklySchedule(DateTime(_currentDate.year, _currentDate.month, day))
                        : null,
                    child: Container(
                      decoration: BoxDecoration(
                        color: day != null ? Colors.white : Colors.transparent,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: day != null
                            ? [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.2),
                            spreadRadius: 1,
                            blurRadius: 5,
                            offset: Offset(0, 3),
                          ),
                        ]
                            : [],
                      ),
                      child: Center(
                        child: day != null
                            ? Text(
                          '$day',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.purple,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                            : null,
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: Icon(Icons.arrow_left, color: Colors.grey),
                  onPressed: () {
                    _changeMonth(-1);
                  },
                ),
                IconButton(
                  icon: Icon(Icons.arrow_right, color: Colors.grey),
                  onPressed: () {
                    _changeMonth(1);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.purple,
        unselectedItemColor: Colors.grey,
        currentIndex: 1,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'To Do List',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.group),
            label: 'Group',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: 'Notice',
          ),
        ],
      ),
    );
  }

  int _daysInMonth(DateTime date) {
    final firstDayOfNextMonth = (date.month < 12)
        ? DateTime(date.year, date.month + 1, 1)
        : DateTime(date.year + 1, 1, 1);
    return firstDayOfNextMonth.subtract(Duration(days: 1)).day;
  }

  int _firstWeekdayOffset(DateTime date) {
    return DateTime(date.year, date.month, 1).weekday % 7;
  }
}
