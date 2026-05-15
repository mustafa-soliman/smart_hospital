class DoctorModel {
  final String name;
  final String specialty;
  final String image;
  final String fee;

  DoctorModel({
    required this.name,
    required this.specialty,
    required this.image,
    required this.fee,
  });
}

// تأكد إن القائمة مكتوبة كدة بالظبط وبره أي كلاس
List<DoctorModel> topDoctorsList = [
  DoctorModel(
    name: "Dr. Hamza Ahmed",
    specialty: "Senior Surgeon",
    image: "assets/images/doctor1.png",
    fee: "200 EGP",
  ),
];