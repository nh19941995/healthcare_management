import 'package:flutter/material.dart';
import 'package:healthcare_management_app/models/Medication.dart';
import 'package:healthcare_management_app/models/prescriptions.dart';
import 'package:healthcare_management_app/providers/Medications_provider.dart';
import 'package:provider/provider.dart';

import '../../dto/Appointment_dto.dart';
import '../comons/theme.dart';

class CreatePrescriptionScreen extends StatefulWidget {
  final AppointmentDTO booking;

  const CreatePrescriptionScreen({Key? key, required this.booking})
      : super(key: key);

  @override
  _CreatePrescriptionScreenState createState() =>
      _CreatePrescriptionScreenState();
}

class _CreatePrescriptionScreenState extends State<CreatePrescriptionScreen> {
  List<Medication> selectedMedications = []; // Danh sách thuốc đã chọn
  Map<int, TextEditingController> dosageControllers = {}; // Controller cho liều dùng
  Map<int, TextEditingController> totalDosageControllers = {}; // Controller cho tổng liều
  Map<int, TextEditingController> noteControllers = {}; // Controller cho cách uống thuốc
  TextEditingController searchController = TextEditingController(); // Bộ điều khiển tìm kiếm
  TextEditingController diseaseController = TextEditingController(); // Bộ điều khiển tên bệnh
  List<Medication> filteredMedications = []; // Danh sách thuốc lọc theo tìm kiếm

  @override
  void initState() {
    super.initState();
    filteredMedications = [];
  }

  @override
  void dispose() {
    dosageControllers.forEach((key, controller) {
      controller.dispose();
    });
    totalDosageControllers.forEach((key, controller) {
      controller.dispose();
    });
    noteControllers.forEach((key, controller) {
      controller.dispose();
    });
    searchController.dispose();
    diseaseController.dispose();
    super.dispose();
  }

  void _createPrescription() async {
    String medicalDiagnosis = diseaseController.text;

    // Kiểm tra nếu tên bệnh bị bỏ trống
    if (medicalDiagnosis.isEmpty) {
      _showErrorMessage('Please enter the disease name.');
      return;
    }

    // Kiểm tra nếu không có thuốc được chọn
    if (selectedMedications.isEmpty) {
      _showErrorMessage('Please select at least one medication.');
      return;
    }

    // Kiểm tra các liều dùng, tổng liều, và ghi chú
    for (var medication in selectedMedications) {
      if (dosageControllers[medication.id]?.text.isEmpty ?? true) {
        _showErrorMessage('Please enter dosage for ${medication.name}.');
        return;
      }
      if (totalDosageControllers[medication.id]?.text.isEmpty ?? true) {
        _showErrorMessage('Please enter total dosage for ${medication.name}.');
        return;
      }
      if (noteControllers[medication.id]?.text.isEmpty ?? true) {
        _showErrorMessage('Please enter note for ${medication.name}.');
        return;
      }
    }

    // Nếu tất cả các trường hợp đều hợp lệ, tiếp tục tạo đơn thuốc
    PrescriptionRequest prescriptionRequest = PrescriptionRequest(
      appointmentId: widget.booking.id,
      medicalDiagnosis: medicalDiagnosis,
      medications: selectedMedications.map((medication) {
        return SelectedMedicine(
          medicationId: medication.id,
          totalDosage: totalDosageControllers[medication.id]!.text,
          dosageInstructions: dosageControllers[medication.id]!.text,
          note: noteControllers[medication.id]!.text,
        );
      }).toList(),
    );

    try {
      await Provider.of<MedicationsProvider>(context, listen: false)
          .register(prescriptionRequest);

      _showSuccessDialog();
    } catch (e) {
      print("Error creating prescription: $e");
      _showErrorDialog('Failed to create the prescription. Please try again.');
    }
  }

  void _showErrorMessage(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Missing Information'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Đóng dialog
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Error'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Đóng dialog
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Success'),
          content: const Text('Prescription has been successfully created.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Đóng dialog
                Navigator.pop(context); // Quay về trang trước
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }


  void filterMedications(String query) {
    final medications = context.read<MedicationsProvider>().list;
    setState(() {
      filteredMedications = query.isEmpty
          ? []
          : medications
          .where((medication) => medication.name!
          .toLowerCase()
          .contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Prescription'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          const Text(
            'Enter Disease Name',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: diseaseController,
            decoration: const InputDecoration(
              labelText: 'Disease Name',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 20),

          const Text(
            'Search Medication',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: searchController,
            decoration: const InputDecoration(
              labelText: 'Search by name',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.search),
            ),
            onChanged: (value) {
              filterMedications(value);
            },
          ),
          const SizedBox(height: 20),

          if (filteredMedications.isNotEmpty) ...[
            const Text(
              'Select Medication(s)',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: filteredMedications.length,
              itemBuilder: (context, index) {
                final medication = filteredMedications[index];
                return ListTile(
                  title: Text(medication.name!),
                  trailing: IconButton(
                    icon: Icon(
                      selectedMedications.contains(medication)
                          ? Icons.check_circle
                          : Icons.add_circle,
                      color: selectedMedications.contains(medication)
                          ? Colors.green
                          : Colors.blue,
                    ),
                    onPressed: () {
                      setState(() {
                        if (selectedMedications.contains(medication)) {
                          selectedMedications.remove(medication);
                          dosageControllers.remove(medication.id);
                          totalDosageControllers.remove(medication.id);
                          noteControllers.remove(medication.id);
                        } else {
                          selectedMedications.add(medication);
                          dosageControllers[medication.id!] =
                              TextEditingController();
                          totalDosageControllers[medication.id!] =
                              TextEditingController();
                          noteControllers[medication.id!] =
                              TextEditingController();
                        }
                      });
                    },
                  ),
                );
              },
            ),
          ],

          if (selectedMedications.isNotEmpty) ...[
            const Text(
              'Selected Medications and Dosage',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Column(
              children: selectedMedications.map((medication) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Medication: ${medication.name}',
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: dosageControllers[medication.id],
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Enter dosage for ${medication.name}',
                        border: const OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: totalDosageControllers[medication.id],
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Enter total dosage for ${medication.name}',
                        border: const OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: noteControllers[medication.id],
                      decoration: InputDecoration(
                        labelText:
                        'Enter note for ${medication.name} (e.g., after meal)',
                        border: const OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                );
              }).toList(),
            ),
          ],

          SizedBox(
            width: double.infinity, // Chiếm toàn bộ chiều rộng
            child: ElevatedButton(
              style: AppTheme.elevatedButtonStyle, // Sử dụng style từ AppTheme
              onPressed: _createPrescription,
              child: Text('Create Prescription'),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
