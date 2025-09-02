import 'package:hive_flutter/hive_flutter.dart';

part 'countdown_entity.g.dart';

@HiveType(typeId: 0)
class CountdownEntity extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final String? description;

  @HiveField(3)
  final DateTime targetDate;

  @HiveField(4)
  final DateTime createdAt;

  CountdownEntity({
    required this.id,
    required this.title,
    this.description,
    required this.targetDate,
  }) : createdAt = DateTime.now();

  CountdownEntity copyWith({
    String? id,
    String? title,
    String? description,
    DateTime? targetDate,
  }) {
    return CountdownEntity(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      targetDate: targetDate ?? this.targetDate,
    );
  }
}