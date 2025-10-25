// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'note_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class NoteAdapter extends TypeAdapter<Note> {
  @override
  final int typeId = 0;

  @override
  Note read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Note(
      id: fields[0] as String,
      title: fields[1] as String,
      content: fields[2] as String,
      imagePath: fields[3] as String?,
      category: fields[4] as NoteCategory,
      colorValue: fields[5] as int,
      timestamp: fields[6] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, Note obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.content)
      ..writeByte(3)
      ..write(obj.imagePath)
      ..writeByte(4)
      ..write(obj.category)
      ..writeByte(5)
      ..write(obj.colorValue)
      ..writeByte(6)
      ..write(obj.timestamp);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NoteAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class NoteCategoryAdapter extends TypeAdapter<NoteCategory> {
  @override
  final int typeId = 1;

  @override
  NoteCategory read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return NoteCategory.all;
      case 1:
        return NoteCategory.important;
      case 2:
        return NoteCategory.todo;
      case 3:
        return NoteCategory.none;
      default:
        return NoteCategory.all;
    }
  }

  @override
  void write(BinaryWriter writer, NoteCategory obj) {
    switch (obj) {
      case NoteCategory.all:
        writer.writeByte(0);
        break;
      case NoteCategory.important:
        writer.writeByte(1);
        break;
      case NoteCategory.todo:
        writer.writeByte(2);
        break;
      case NoteCategory.none:
        writer.writeByte(3);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NoteCategoryAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
