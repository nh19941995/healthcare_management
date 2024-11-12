import 'package:flutter/material.dart';
import 'package:healthcare_management_app/models/Qa.dart';
import 'package:healthcare_management_app/providers/Qa_provider.dart';
import 'package:provider/provider.dart';

class OnlineConsultation extends StatefulWidget {
  const OnlineConsultation({super.key});

  @override
  _OnlineConsultationState createState() => _OnlineConsultationState();
}

class _OnlineConsultationState extends State<OnlineConsultation> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<QaProvider>().getAllQa();
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    final questions = context.watch<QaProvider>().list;

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
            title: Text(questions[index].question!),
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
  final Qa question;

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
              question.question!,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              question.answer!,
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
