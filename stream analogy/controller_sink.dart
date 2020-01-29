import 'dart:async';

void main() {
  final contoller = new StreamController();
  final order = new Order('chocolate');
  contoller.sink.add(order);
  final baker =
      new StreamTransformer.fromHandlers(handleData: (cakeType, sink) {
    if (cakeType == 'chocolate') {
      sink.add(new Cake(120));
    } else {
      sink.addError("Sorry cannot bake $cakeType cake");
    }
  });
  contoller.stream
      .map((order) => order.type)
      .transform(baker)
      //right here
      .listen(
          (cake) => print("Here is your cake with total of Rs. ${cake.price}"),
          onError: (err) => print(err));
}

class Cake {
  int price;
  Cake(this.price);
}

class Order {
  String type;
  Order(this.type);
}
