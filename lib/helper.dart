import 'dart:async';

extension DateTimeHelper on DateTime {
  String customDataHeaderText() {
    var months = [
      'января',
      'февраля',
      'марта',
      'апреля',
      'мая',
      'июня',
      'июля',
      'августа',
      'сенятбря',
      'октября',
      'ноября',
      'декабря'
    ];
    if (year == DateTime.now().year) {
      return '${day.toString().padLeft(2, '0')} ${months[month - 1]} ${hour.toString().padLeft(2,'0')}:${minute.toString().padLeft(2,'0')}';
    } else {
      return '${day.toString().padLeft(2, '0')} ${months[month - 1]} ${year} ${hour.toString().padLeft(2,'0')}:${minute.toString().padLeft(2,'0')}';
    }
  }
}

extension streamHelper on Stream {
  Stream<Set<T>> combine<T>(Stream<T> anotherStream) {
    var controller = StreamController<Set<T>>();
    Set activeStreams = {};
    Map<Stream<T> , T> lastValues = {};

    activeStreams.add(this);
    activeStreams.add(anotherStream);

    void addStream(_stream) {
      _stream.listen(
              (val) {
            lastValues[_stream] = val;
            Set<T> out = {};
            for (T list in lastValues.values) {
              out.add(list);
            }
            controller.add(out);
          },
          onDone: () {
            activeStreams.remove(_stream);
            if (activeStreams.isEmpty) {
              controller.close();
            }
          }
      );
    }
    addStream(anotherStream);
    addStream(this);

    return controller.stream;
  }
}
