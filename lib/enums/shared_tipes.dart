// TODO Implement this library.
enum SheredType {
  text("text"),
  image('image'),
  audio('audio'),
  video('video'),
  file('file'),
  pdf('file');

  final String value;
  const SheredType(this.value);
}