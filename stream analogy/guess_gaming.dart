//<h4>Guess the word </h4>

//<button>Guess </button>
// </input>

//<button>Click me </button>

import 'dart:html';

void main() {
  final ButtonElement button = querySelector('button');
  final InputElement input = querySelector('input');

  button.onClick.take(4).where((event) => input.value == "banana").listen(
        (event) => print("You got it"),
        onDone: () => print("Sorry no more guesses!!"),
      );
}
