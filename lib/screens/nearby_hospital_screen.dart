import 'package:flutter/material.dart';
// استيراد نافذة التأكيد لربطها بالأزرار
import 'package:smart_hospital/screens/confirm_transfer_popup.dart';

class NearbyHospitalScreen extends StatelessWidget {
  const NearbyHospitalScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // 1. استدعاء الخلفية الموحدة hospital_bg.png كما طلبت
          Image.asset(
            'assets/images/hospital_bg.png',
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) => Container(color: Colors.white),
          ),

          // طبقة شفافة (Overlay) لضمان وضوح النصوص فوق الخلفية
          Container(
            color: Colors.white.withOpacity(0.3),
          ),

          SafeArea(
            child: Column(
              children: [
                const SizedBox(height: 10),

                // شريط العنوان العلوي (Header)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: const CircleAvatar(
                          backgroundColor: Colors.white,
                          child: Icon(Icons.arrow_back_ios_new, size: 18, color: Colors.black),
                        ),
                      ),
                      const Expanded(
                        child: Text(
                          'Nearby Hospital',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1B3A4B), // اللون الأزرق الداكن الموحد
                          ),
                        ),
                      ),
                      const SizedBox(width: 40),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // أيقونة التوجيه والنجاح الدائرية الزرقاء في المنتصف
                const Center(
                  child: CircleAvatar(
                    radius: 45,
                    backgroundColor: Color(0xFF0D638F),
                    child: Icon(Icons.check_circle_outline, color: Colors.white, size: 50),
                  ),
                ),

                const SizedBox(height: 25),

                // قائمة المستشفيات (List of Hospitals)
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    children: [
                      // المستشفى الأول (Hospital A)
                      _buildHospitalCard(
                        context,
                        name: 'Hospital A',
                        distance: '1.5 km',
                        beds: '3',
                        eta: '5 min',
                      ),
                      // المستشفى الثاني (Hospital B)
                      _buildHospitalCard(
                        context,
                        name: 'Hospital B',
                        distance: '2.5 km',
                        beds: '1',
                        eta: '9 min',
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // دالة بناء بطاقة المستشفى (Hospital Card)
  Widget _buildHospitalCard(
      BuildContext context, {
        required String name,
        required String distance,
        required String beds,
        required String eta,
      }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.45), // شفافية البطاقة لإظهار الخلفية من خلفها
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.3)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // اسم المستشفى
          Text(
            name,
            style: const TextStyle(
              fontSize: 19,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1B3A4B),
            ),
          ),
          const SizedBox(height: 15),

          // عرض تفاصيل المسافة، الأسرة، والوقت
          _buildInfoRow('Distance', distance),
          _buildInfoRow('Beds', beds),
          _buildInfoRow('ETA', eta),

          const SizedBox(height: 10),

          // زر الاختيار (Select) الذي يفتح الـ Pop-up
          Align(
            alignment: Alignment.centerRight,
            child: ElevatedButton(
              onPressed: () {
                // الانتقال لنافذة تأكيد النقل المنبثقة
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ConfirmTransferPopup()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1B3A4B),
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                shape: const StadiumBorder(),
                elevation: 4,
              ),
              child: const Text(
                'Select',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.bold
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // دالة مساعدة لبناء أسطر المعلومات داخل البطاقة
  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 15, color: Colors.black87),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1B3A4B),
            ),
          ),
        ],
      ),
    );
  }
}