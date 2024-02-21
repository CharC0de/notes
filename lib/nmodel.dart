class Note{
  final int? id;
  final String title;
  final String subject;
  final String date;
  final String description;

  const Note({
    this.id,
    required this.title,
    required this.subject,
    required this.date,
    required this.description,
  });

  factory Note.fromJson(Map<String,dynamic> json) => Note(
    id: json['id'],
    title: json['title'],
    subject: json['subject'],
    date: json['date'],
    description: json['description'],
  );

  Map<String,dynamic> toJson() =>{
    'id' : id,
    'title' :title,
    'subject' : subject,
    'date' : date,
    'description' : description,
  };
}