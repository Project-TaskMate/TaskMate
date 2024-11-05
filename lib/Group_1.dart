import 'package:flutter/material.dart';

class GroupPage extends StatelessWidget {
  const GroupPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.person_add, color: Colors.black),
            onPressed: () {
              // Action for adding person
            },
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              '대화 목록',
              style: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: ListView(
              children: const [
                ChatItem(
                  groupName: '고모프 TaskMate',
                  message: '좋아요 6시반 부터 시작합시당^^',
                  time: '10 min',
                ),
                ChatItem(
                  groupName: '김○○, 박○○, 최○○',
                  message: '알겠습니다.',
                  time: '20 min',
                ),
                ChatItem(
                  groupName: '이○○, 강○○',
                  message: '다음주에 봐요',
                  time: '30 min',
                ),
                ChatItem(
                  groupName: '캡스톤',
                  message: '다음주에 만나요!!',
                  time: '35 min',
                ),
                ChatItem(
                  groupName: '웹프웤',
                  message: '과제 이번주 금요일까지 제출입니다',
                  time: '40 min',
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.check_box),
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
        selectedItemColor: Colors.purple,
        unselectedItemColor: Colors.grey,
        currentIndex: 2,
        onTap: (index) {
          // Handle navigation based on the selected index
        },
      ),
      backgroundColor: Colors.white, // 전체 배경을 흰색으로 설정
    );
  }
}

class ChatItem extends StatelessWidget {
  final String groupName;
  final String message;
  final String time;

  const ChatItem({
    Key? key,
    required this.groupName,
    required this.message,
    required this.time,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xFFFFF0F5), // 모든 ChatItem에 연한 핑크색 배경 적용
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.grey[300],
          child: Icon(Icons.group, color: Colors.grey[600]),
        ),
        title: Text(
          groupName,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(message),
        trailing: Text(
          time,
          style: const TextStyle(color: Colors.grey, fontSize: 12),
        ),
      ),
    );
  }
}
