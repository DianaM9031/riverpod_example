import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  runApp(
    ProviderScope(
      child: MyApp(),
    ),
  );
}

class FakeHttpClient {
  Future<String> get(String url) async {
    await Future.delayed(const Duration(seconds: 1));
    return 'Response from $url';
  }
}

final fakeHttpClientProvider = Provider((ref) => FakeHttpClient());

// final responseProvider = FutureProvider<String>((ref) async {
//   final httpClient = ref.read(fakeHttpClientProvider);
//   return httpClient.get('https://resocoder.com');
// });
final responseProvider = FutureProvider.autoDispose.family<String, String>((ref, url) async {
  final httpClient = ref.read(fakeHttpClientProvider);
  return httpClient.get(url);
});

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Riverpod Tutorial',
      home: Scaffold(
        body: Center(
          child: Consumer(
            builder: (context, watch, child) {
              // final responseAsyncValue = watch(responseProvider);
              final responseAsyncValue = watch(responseProvider('https://flutter8.dev'));
              return responseAsyncValue.map(
                data: (_) => Text(_.value),
                loading: (_) => CircularProgressIndicator(),
                error: (_) => Text(
                  _.error.toString(),
                  style: TextStyle(color: Colors.red),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}


// Example 2
// class IncrementNotifier extends ChangeNotifier {
//   int _value = 0;
//   int get value => _value;
//
//   void increment() {
//     _value++;
//     notifyListeners();
//   }
// }
//
// final incrementProvider = ChangeNotifierProvider((ref) => IncrementNotifier());
//
// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Riverpod Tutorial',
//       home: Scaffold(
//         body: Center(
//           child: Consumer(
//             builder: (context, watch, child) {
//               final incrementNotifier = watch(incrementProvider);
//               return Text(incrementNotifier.value.toString());
//             },
//           ),
//         ),
//         floatingActionButton: FloatingActionButton(
//           onPressed: () {
//             context.read(incrementProvider).increment();
//           },
//           child: Icon(Icons.add),
//         ),
//       ),
//     );
//   }
// }

// Example 1
// class MyApp extends ConsumerWidget {
//   @override
//   Widget build(BuildContext context, ScopedReader watch) {
//     final greeting = watch(greetingProvider);
//     return MaterialApp(
//       title: 'Flutter Demo',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       home: Scaffold(
//         appBar: AppBar(
//           title: Text('Riverpod Example'),
//         ),
//         body: Center(
//           child: Text(greeting),
//         ),
//       ),
//     );
//   }
// }
