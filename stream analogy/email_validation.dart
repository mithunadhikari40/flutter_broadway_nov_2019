//<h4>Enter your email address </h4>

// </input>

//<div style ="color:red;"> Click me </div>

import 'dart:async';
import 'dart:html';

void main() {
  final InputElement input = querySelector('input');
  final DivElement div = querySelector('div');

  final validator =
      new StreamTransformer.fromHandlers(handleData: (inputValue, sink) {
    if (inputValue.contains("@")) {
      sink.add(inputValue);
    } else {
      sink.addError("Enter a valid email address");
    }
  });

  input.onInput
//listen((dynamic event)=>print(event.target.value));
      .map((dynamic event) => event.target.value)
      .transform(validator)
      .listen(
    (inputValue) {
      print("This email $inputValue is correct");
      div.innerHtml = '';
    },
    onError: (err) => div.innerHtml = err,
  );
}
