import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../models/user.dart';

class Question {
  final int id;
  final String question;
  final String answer;

  Question({required this.id, required this.question, required this.answer});
}

// Fake data cho danh sách câu hỏi và trả lời
List<Question> questions = [
  Question(
    id: 1,
    question: "Cách ly F0 tại nhà?",
    answer: "Bạn nên cách ly trong phòng riêng, đeo khẩu trang, và theo dõi sức khỏe hàng ngày.",
  ),
  Question(
    id: 2,
    question: "Cách để ăn nhiều mà vẫn gầy?",
    answer: "Tập thể dục đều đặn, cân bằng dinh dưỡng, và đảm bảo lượng calo tiêu thụ cao hơn lượng nạp vào.",
  ),
  Question(
    id: 3,
    question: "Chữa bệnh lao phổi tại nhà?",
    answer: "Điều trị lao phổi cần được bác sĩ theo dõi, kết hợp dùng thuốc và nghỉ ngơi đầy đủ.",
  ),
  Question(
    id: 4,
    question: "Cách cấp cứu nhanh khi cano bị lật?",
    answer: "Mặc áo phao, giữ bình tĩnh, và tìm cách bơi vào bờ an toàn.",
  ),
  Question(
    id: 1,
    question: "Cách ly F0 tại nhà?",
    answer: "Bạn nên cách ly trong phòng riêng, đeo khẩu trang, và theo dõi sức khỏe hàng ngày.",
  ),
  Question(
    id: 2,
    question: "Cách để ăn nhiều mà vẫn gầy?",
    answer: "Tập thể dục đều đặn, cân bằng dinh dưỡng, và đảm bảo lượng calo tiêu thụ cao hơn lượng nạp vào.",
  ),
  Question(
    id: 3,
    question: "Chữa bệnh lao phổi tại nhà?",
    answer: "Điều trị lao phổi cần được bác sĩ theo dõi, kết hợp dùng thuốc và nghỉ ngơi đầy đủ.",
  ),
  Question(
    id: 4,
    question: "Cách cấp cứu nhanh khi cano bị lật?",
    answer: "Mặc áo phao, giữ bình tĩnh, và tìm cách bơi vào bờ an toàn.",
  ),
  Question(
    id: 1,
    question: "Cách ly F0 tại nhà?",
    answer: "Bạn nên cách ly trong phòng riêng, đeo khẩu trang, và theo dõi sức khỏe hàng ngày.",
  ),
  Question(
    id: 2,
    question: "Cách để ăn nhiều mà vẫn gầy?",
    answer: "Tập thể dục đều đặn, cân bằng dinh dưỡng, và đảm bảo lượng calo tiêu thụ cao hơn lượng nạp vào.",
  ),
  Question(
    id: 3,
    question: "Chữa bệnh lao phổi tại nhà?",
    answer: "Điều trị lao phổi cần được bác sĩ theo dõi, kết hợp dùng thuốc và nghỉ ngơi đầy đủ.",
  ),
  Question(
    id: 4,
    question: "Cách cấp cứu nhanh khi cano bị lật?",
    answer: "Mặc áo phao, giữ bình tĩnh, và tìm cách bơi vào bờ an toàn.",
  ),
  Question(
    id: 1,
    question: "Cách ly F0 tại nhà?",
    answer: "Bạn nên cách ly trong phòng riêng, đeo khẩu trang, và theo dõi sức khỏe hàng ngày.",
  ),
  Question(
    id: 2,
    question: "Cách để ăn nhiều mà vẫn gầy?",
    answer: "Tập thể dục đều đặn, cân bằng dinh dưỡng, và đảm bảo lượng calo tiêu thụ cao hơn lượng nạp vào.",
  ),
  Question(
    id: 3,
    question: "Chữa bệnh lao phổi tại nhà?",
    answer: "Điều trị lao phổi cần được bác sĩ theo dõi, kết hợp dùng thuốc và nghỉ ngơi đầy đủ.",
  ),
  Question(
    id: 4,
    question: "Cách cấp cứu nhanh khi cano bị lật?",
    answer: "Mặc áo phao, giữ bình tĩnh, và tìm cách bơi vào bờ an toàn.",
  ),
  Question(
    id: 1,
    question: "Cách ly F0 tại nhà?",
    answer: "Bạn nên cách ly trong phòng riêng, đeo khẩu trang, và theo dõi sức khỏe hàng ngày.",
  ),
  Question(
    id: 2,
    question: "Cách để ăn nhiều mà vẫn gầy?",
    answer: "Tập thể dục đều đặn, cân bằng dinh dưỡng, và đảm bảo lượng calo tiêu thụ cao hơn lượng nạp vào.",
  ),
  Question(
    id: 3,
    question: "Chữa bệnh lao phổi tại nhà?",
    answer: "Điều trị lao phổi cần được bác sĩ theo dõi, kết hợp dùng thuốc và nghỉ ngơi đầy đủ.",
  ),
  Question(
    id: 4,
    question: "Cách cấp cứu nhanh khi cano bị lật?",
    answer: "Mặc áo phao, giữ bình tĩnh, và tìm cách bơi vào bờ an toàn.",
  ),

  // Thêm các câu hỏi khác nếu cần...
];

class OnlineConsultation extends StatelessWidget {
  final User user;

  const OnlineConsultation({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Online Consultation'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context); // Quay lại màn hình trước
          },
        ),
      ),
      body: ListView.builder(
        itemCount: questions.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(questions[index].question),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              // Khi người dùng nhấn vào câu hỏi, chuyển sang màn hình chi tiết
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AnswerDetail(question: questions[index]),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

// Màn hình hiển thị câu trả lời chi tiết
class AnswerDetail extends StatelessWidget {
  final Question question;

  const AnswerDetail({super.key, required this.question});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Detailed answer"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context); // Quay lại danh sách câu hỏi
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              question.question,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              question.answer,
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
