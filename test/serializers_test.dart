import 'dart:collection';

import 'package:gitjournal/storage/serializers.dart';
import 'package:gitjournal/datetime_utils.dart';
import 'package:test/test.dart';

DateTime nowWithoutMicro() {
  var dt = DateTime.now();
  return DateTime(dt.year, dt.month, dt.day, dt.hour, dt.minute, dt.second);
}

void main() {
  group('Serializers', () {
    var created = toIso8601WithTimezone(nowWithoutMicro());
    var note =
        NoteData("This is the body", LinkedHashMap.from({"created": created}));

    test('Markdown Serializer', () {
      var serializer = MarkdownYAMLSerializer();
      var str = serializer.encode(note);
      var note2 = serializer.decode(str);

      expect(note2, note);
    });

    test('Markdown Serializer with invalid YAML', () {
      var inputNoteStr = """---
type
---

Alright.""";

      var serializer = MarkdownYAMLSerializer();
      var note = serializer.decode(inputNoteStr);
      var actualStr = "Alright.";

      expect(actualStr, note.body);
    });

    test('Markdown Serializer with empty YAML', () {
      var inputNoteStr = """---
---

Alright.""";

      var serializer = MarkdownYAMLSerializer();
      var note = serializer.decode(inputNoteStr);
      var actualStr = "Alright.";

      expect(actualStr, note.body);
    });

    test('Markdown Serializer YAML Order', () {
      var str = """---
type: Journal
created: 2017-02-15T22:41:19+01:00
foo: bar
---

Alright.""";

      var serializer = MarkdownYAMLSerializer();
      var note = serializer.decode(str);
      var actualStr = serializer.encode(note);

      expect(actualStr, str);
    });
  });
}
