import 'dart:convert';

class DocumentModel {
  final int? id;
  final String? name;
  final String? category;
  final String? path;
  final DateTime? createdAt;

  DocumentModel({
    this.id,
    this.name,
    this.category,
    this.path,
    this.createdAt,
  });

  /// Converts DocumentModel instance to a Map (for JSON serialization)
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'category': category,
      'path': path,
      'createdAt': createdAt?.millisecondsSinceEpoch,
    };
  }

  /// Creates a DocumentModel instance from a Map (JSON deserialization)
  factory DocumentModel.fromMap(Map<String, dynamic> map) {
    return DocumentModel(
      id: map['id'],
      name: map['name'] as String?,
      category: map['category'] as String?,
      path: map['path'] as String?,
      createdAt: map['createdAt'] != null
          ? DateTime.fromMillisecondsSinceEpoch(
              map['createdAt']) // Convert to DateTime
          : null,
    );
  }

  String toJson() => json.encode(toMap());
  factory DocumentModel.fromJson(String source) => DocumentModel();

  DocumentModel copyWith({
    int? id,
    String? name,
    String? category,
    String? path,
    DateTime? createdAt,
  }) {
    return DocumentModel(
      id: id ?? this.id,
      name: name ?? this.name,
      category: category ?? this.category,
      path: path ?? this.path,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
