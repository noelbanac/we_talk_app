import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:wetalk_application_2/styles/button.dart';
import 'package:wetalk_application_2/utils/appbar.dart';
import 'package:wetalk_application_2/utils/config.dart';

class BookingPage extends StatefulWidget {
  const BookingPage({super.key});

  @override
  State<BookingPage> createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  CalendarFormat _format = CalendarFormat.month;
  DateTime _focusDay = DateTime.now();
  DateTime? _selectedDay;
  final DateTime _currentDay = DateTime.now();
  int? _currentIndex;
  bool _isWeekend = false;
  bool _dateSelected = false;
  bool _timeSelected = false;

  @override
  Widget build(BuildContext context) {
    Config().init(context);
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(56.0), // Set the height of the AppBar
        child: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/intro_image.jpg'), // Set your background image here
              fit: BoxFit.cover,
            ),
          ),
          child: const CustomAppBar(
            appTitle: 'Appointment Form',
            icon: FaIcon(Icons.arrow_back_ios),
          ),
        ),
      ),
      body: Stack(
        children: [
          // Background Image for the body
          Positioned.fill(
            child: Image.asset(
              'assets/intro_image.jpg', // Path to your background image
              fit: BoxFit.cover,
            ),
          ),
          CustomScrollView(
            slivers: <Widget>[
              SliverToBoxAdapter(
                child: Column(
                  children: <Widget>[
                    _tableCalendar(),
                    const SizedBox(height: 25), // Space between calendar and time section
                    _selectTimeSection(), // Time selection section with box
                  ],
                ),
              ),
              _isWeekend
                  ? SliverToBoxAdapter(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 30),
                        alignment: Alignment.center,
                        child: const Text(
                          'Weekend is not available, please select another date',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    )
                  : SliverToBoxAdapter(
                      child: Container(), // Placeholder to avoid duplicating the grid
                    ),
              SliverToBoxAdapter(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 40), // Reduced vertical space
                  child: Button(
                    width: double.infinity,
                    title: 'Book Appointment',
                    onPressed: () async {
                      if (_dateSelected && _timeSelected) {
                        // Example appointment logic
                        print('Appointment booked on $_selectedDay at ${_currentIndex! + 9}:00');
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text(
                              'Appointment booked on $_selectedDay at ${_currentIndex! + 9}:00'),
                        ));
                      }
                    },
                    disable: !_timeSelected || !_dateSelected,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _tableCalendar() {
    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.only(bottom: 8.0), // Space between text and calendar
          child: Text(
            'PREFERRED DATE',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18, // Adjust font size as needed
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.all(10.0), // Optional: Add some padding inside the container
          margin: const EdgeInsets.symmetric(horizontal: 16.0), // Adjust this for space outside the box
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.7), // Add white color with opacity to the calendar box
            border: Border.all(color: Colors.black), // Optional: Add border to the calendar box
            borderRadius: BorderRadius.circular(10), // Optional: Rounded corners for the box
          ),
          child: TableCalendar(
            focusedDay: _focusDay,
            firstDay: DateTime.now(),
            lastDay: DateTime.now().add(const Duration(days: 365)), // Last day one year from now
            calendarFormat: _format,
            currentDay: _currentDay,
            selectedDayPredicate: (day) {
              return isSameDay(_selectedDay, day);
            },
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusDay = focusedDay;
                _isWeekend = selectedDay.weekday == DateTime.saturday || selectedDay.weekday == DateTime.sunday;
                _dateSelected = true;
              });
            },
            rowHeight: 48,
            calendarStyle: const CalendarStyle(
              todayDecoration: BoxDecoration(color: Config.primaryColor, shape: BoxShape.circle),
            ),
            availableCalendarFormats: const {
              CalendarFormat.month: 'Month',
            },
            onFormatChanged: (format) {
              setState(() {
                _format = format;
              });
            },
          ),
        ),
      ],
    );
  }

  Widget _selectTimeSection() {
    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.only(bottom: 8.0), // Space between text and time section
          child: Text(
            'SELECT TIME',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18, // Adjust font size as needed
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.all(10.0), // Optional: Add some padding inside the container
          margin: const EdgeInsets.symmetric(horizontal: 16.0), // Adjust this for space outside the box
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.7), // Add white color with opacity to the time selection box
            border: Border.all(color: Colors.black), // Optional: Add border to the time selection box
            borderRadius: BorderRadius.circular(10), // Optional: Rounded corners for the box
          ),
          child: GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              childAspectRatio: 1.5,
            ),
            itemCount: 8,
            itemBuilder: (context, index) {
              return InkWell(
                splashColor: Colors.transparent,
                onTap: () {
                  setState(() {
                    _currentIndex = index;
                    _timeSelected = true;
                  });
                },
                child: Container(
                  margin: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: _currentIndex == index
                          ? Colors.white
                          : Colors.black,
                    ),
                    borderRadius: BorderRadius.circular(15),
                    color: _currentIndex == index
                        ? Config.primaryColor
                        : null,
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    '${index + 9}:00 ${index + 9 > 11 ? "PM" : "AM"}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: _currentIndex == index ? Colors.white : null,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
