import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // Application name
      title: 'Advanced Counter App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      // A widget that will be started on the application startup
      home: CounterWidget(),
    );
  }
}

class CounterWidget extends StatefulWidget {
  @override
  _CounterWidgetState createState() => _CounterWidgetState();
}

class _CounterWidgetState extends State<CounterWidget> {
//initial couter value
  int _counter = 0;
  int _incrementValue = 1; //custom increment value
  List<int> _history = []; //list to store history of counter values

  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
  //get color based on value
  Color get counterColor {
    if (_counter == 0) return Colors.red;
    if (_counter > 50) return Colors.green;
    return Colors.black;
  }
  //add current counter value to history
  void _addToHistory() {
    setState(() {
      _history.insert(0, _counter); //adds to beginning of list
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Stateful Widget'),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Container(
                color: Colors.blue,
                child: Text(
                  //displays the current number
                  '$_counter',
                  style: TextStyle(
                    fontSize: 50.0,
                    color: counterColor, //dynamic color
                  ),
                ),
              ),
            ),
            Slider(
              min: 0,
              max: 100,
              value: _counter.toDouble(),
              onChanged: (double value) {
                setState(() {
                  _counter = value.toInt();
                });
              },
              onChangeEnd: (double value) {
                _addToHistory(); //add to history after slider interaction
              },
              activeColor: Colors.blue,
              inactiveColor: Colors.red,
            ),
            //custom increment value input
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Text(
                    'Custom Increment Value: ',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 150,
                        child: TextField(
                          controller: _controller,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: 'Enter value',
                            contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                          ),
                          onChanged: (String value) {
                            setState(() {
                              //validate input as integer
                              int? parsedValue = int.tryParse(value);
                              if (parsedValue != null && parsedValue > 0) {
                                _incrementValue = parsedValue;
                              }
                              else if (value.isEmpty) {
                                _incrementValue = 1; //reset to default if empty
                              }
                            });
                          },
                        ),
                      ),
                      SizedBox(width: 10),
                      //display current increment value
                      Container(
                        padding: EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                          color: Colors.blue.shade100,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Text(
                          'Current increment value +$_incrementValue',
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                  //validation error
                  if (_controller.text.isNotEmpty && int.tryParse(_controller.text) == null)
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text('Please enter a valid integer',
                        style: TextStyle(color: Colors.red, fontSize: 12),
                      ),
                    ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                //custom increment button
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      if (_counter + _incrementValue <= 100) {
                        _counter += _incrementValue;
                      }
                      else {
                        _counter = 100; //caps out at 100
                      }
                    });
                    _addToHistory(); //add to history after increment
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  ),
                  child: Text(
                    'Increment by $_incrementValue',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
                SizedBox(width: 10),
                //decrement button
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      if (_counter > 0) { //counter cannot go below 0
                        _counter--;
                      }
                    });
                    _addToHistory(); //add to history after decrement
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  ),
                  child: Text(
                    'Decrement',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
                SizedBox(width: 20),
                //reset button
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _counter = 0;
                      _addToHistory(); //add to history after reset
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey,
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  ),
                  child: Text(
                    'Reset',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ],
            ),
            //history
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Counter History:',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  //listview for history
                  Container(
                    height: 250,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: _history.isEmpty
                        ? Center(
                            child: Text(
                              'No history yet',
                              style: TextStyle(color: Colors.grey, fontSize: 16),
                            ),
                          )
                        : ListView.builder(
                            itemCount: _history.length,
                            itemBuilder: (context, index) {
                              return ListTile(
                                leading: CircleAvatar(
                                  backgroundColor: Colors.blue,
                                  child: Text(
                                    '${index + 1}',
                                    style: TextStyle(fontSize: 12, color: Colors.white),
                                  ),
                                ),
                                title: Text(
                                  'Value: ${_history[index]}',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              );
                            },
                          ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}