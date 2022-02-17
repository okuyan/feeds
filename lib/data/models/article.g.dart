// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'article.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ArticleAdapter extends TypeAdapter<Article> {
  @override
  final int typeId = 2;

  @override
  Article read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Article(
      feedId: fields[0] as String,
      title: fields[1] as String,
      link: fields[2] as String,
      unread: fields[3] as bool,
      pubDate: fields[5] as DateTime?,
      content: fields[4] as String?,
      youTubeVideoId: fields[6] as String?,
      bookmarked: fields[7] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, Article obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.feedId)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.link)
      ..writeByte(3)
      ..write(obj.unread)
      ..writeByte(4)
      ..write(obj.content)
      ..writeByte(5)
      ..write(obj.pubDate)
      ..writeByte(6)
      ..write(obj.youTubeVideoId)
      ..writeByte(7)
      ..write(obj.bookmarked);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ArticleAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
