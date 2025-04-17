class Pet {
  final int? id;
  final String name;
  final String type;
  final String breed;
  final String gender;
  final String age;
  final String weight;
  final String location;
  final String about;
  final String imagePath;
  final String ownerName;
  final String ownerMessage;
  final String contactChat;
  final String contactPhone;

  Pet({
    this.id,
    required this.name,
    required this.type,
    required this.breed,
    required this.gender,
    required this.age,
    required this.weight,
    required this.location,
    required this.about,
    required this.imagePath,
    required this.ownerName,
    required this.ownerMessage,
    required this.contactChat,
    required this.contactPhone,
  });

  // Convert Pet object to Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'type': type,
      'breed': breed,
      'gender': gender,
      'age': age,
      'weight': weight,
      'location': location,
      'about': about,
      'imagePath': imagePath,
      'ownerName': ownerName,
      'ownerMessage': ownerMessage,
      'contactChat': contactChat,
      'contactPhone': contactPhone,
    };
  }

  
  factory Pet.fromMap(Map<String, dynamic> map) {
    return Pet(
      id: map['id'],
      name: map['name'],
      type: map['type'],
      breed: map['breed'],
      gender: map['gender'],
      age: map['age'],
      weight: map['weight'],
      location: map['location'],
      about: map['about'],
      imagePath: map['imagePath'],
      ownerName: map['ownerName'],
      ownerMessage: map['ownerMessage'],
      contactChat: map['contactChat'],
      contactPhone: map['contactPhone'],
    );
  }
}